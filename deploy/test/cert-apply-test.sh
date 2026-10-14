#!/usr/bin/env bash
#
# cert-apply-test.sh — unit-test install.sh's certificate application helpers.
#
# The panel only serves HTTPS when webCertFile/webKeyFile are stored in its DB;
# otherwise it logs an error and silently falls back to HTTP. install.sh used to
# call `easyxray cert` and report success without checking, so a refused
# certificate still printed an https:// access URL. apply_panel_cert must turn
# that into a hard failure.
#
# Needs only bash + openssl. Usage: bash deploy/test/cert-apply-test.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INSTALL_SH="${REPO_ROOT}/install.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

# Pull the real helpers out of install.sh rather than reimplementing them, so
# the test cannot drift away from what the installer ships.
helpers="$(sed -n '/^# verify_panel_cert <cert> <key>/,/^}$/p' "${INSTALL_SH}")"
helpers+=$'\n'"$(sed -n '/^# apply_panel_cert <cert> <key>/,/^}$/p' "${INSTALL_SH}")"
[[ -n "${helpers}" ]] || fail "could not extract the cert helpers from install.sh"
# The helpers report through msg(); without the catalog their messages come out
# empty and the assertions below could not tell a message from silence.
helpers+=$'\n'"$(sed -n '/^msg() {$/,/^}$/p' "${INSTALL_SH}")"
eval "${helpers}"
INSTALL_LANG="en-US"

# MSYS rewrites a leading /CN=... into a Windows path, and OpenSSL rejects a
# subject without that slash, so the common name comes from a config file.
gen_cert() { # gen_cert <cn> <key-out> <cert-out>
    printf '[req]\ndistinguished_name=dn\nprompt=no\n[dn]\nCN=%s\n' "$1" > "${TMP}/subj.cnf"
    openssl req -x509 -newkey rsa:2048 -nodes -config "${TMP}/subj.cnf" \
        -keyout "$2" -out "$3" -days 30 2> /dev/null
}

gen_cert cert-apply-test "${TMP}/key.pem" "${TMP}/cert.pem"
gen_cert cert-apply-test-other "${TMP}/other.pem" "${TMP}/other.crt"
printf 'not a pem\n' > "${TMP}/junk.pem"

# A stand-in for the easyxray CLI. STUB_MODE decides whether `cert` records the
# paths, exits non-zero, or exits 0 while storing nothing.
write_stub() {
    STUB_MODE="$1"
    rm -f "${TMP}/stored"
    mkdir -p "${TMP}/bin/easyxray"
    cat > "${TMP}/bin/easyxray/easyxray" <<STUB
#!/bin/sh
case "\$1" in
    cert)
        case "${STUB_MODE}" in
            ok) printf '%s|%s\n' "\$3" "\$5" > "${TMP}/stored"; exit 0 ;;
            fail) echo "set certificate public key failed: database is locked"; exit 1 ;;
            silent) echo "set certificate public key success"; exit 0 ;;
        esac
        ;;
    setting)
        if [ -f "${TMP}/stored" ]; then
            IFS='|' read -r c k < "${TMP}/stored"
        else
            c=""; k=""
        fi
        printf 'cert: %s\nkey: %s\n' "\$c" "\$k"
        exit 0
        ;;
esac
exit 0
STUB
    chmod +x "${TMP}/bin/easyxray/easyxray"
    easyxray_folder="${TMP}/bin/easyxray"
}

echo "== verify_panel_cert =="
verify_panel_cert "${TMP}/cert.pem" "${TMP}/key.pem" 2> /dev/null || fail "a matching pair was rejected"
if verify_panel_cert "${TMP}/cert.pem" "${TMP}/other.pem" 2> /dev/null; then
    fail "a mismatched key pair was accepted"
fi
if verify_panel_cert "${TMP}/junk.pem" "${TMP}/key.pem" 2> /dev/null; then
    fail "a non-PEM certificate was accepted"
fi
if verify_panel_cert "${TMP}/missing.pem" "${TMP}/key.pem" 2> /dev/null; then
    fail "a missing certificate was accepted"
fi

echo "== apply_panel_cert: the CLI stores the paths =="
write_stub ok
apply_panel_cert "${TMP}/cert.pem" "${TMP}/key.pem" || fail "a certificate the CLI stored was reported as failed"

echo "== apply_panel_cert: the CLI exits 0 but stores nothing (the reported bug) =="
write_stub silent
out="$(apply_panel_cert "${TMP}/cert.pem" "${TMP}/key.pem" 2>&1)" &&
    fail "a no-op CLI run was reported as success -- this is the bug that produced a dead https:// URL"
[[ "${out}" == *"the panel did not save the certificate"* ]] ||
    fail "a refused certificate was reported with no message: ${out}"

echo "== apply_panel_cert: the CLI reports a failure =="
write_stub fail
out="$(apply_panel_cert "${TMP}/cert.pem" "${TMP}/key.pem" 2>&1)" &&
    fail "a failing CLI run was reported as success"
# The exit code and the CLI's own output both have to reach the user, or the
# install fails with no way to tell why.
[[ "${out}" == *"easyxray cert exited 1: set certificate public key failed: database is locked"* ]] ||
    fail "the CLI failure was reported without its exit code or output: ${out}"

echo "== apply_panel_cert: missing files are rejected before the CLI runs =="
write_stub ok
out="$(apply_panel_cert "${TMP}/missing.pem" "${TMP}/key.pem" 2>&1)" &&
    fail "a missing certificate file was accepted"
[[ "${out}" == *"certificate file is missing, empty or unreadable: ${TMP}/missing.pem"* ]] ||
    fail "a missing certificate was reported without naming the file: ${out}"

echo "== install.sh no longer calls the CLI without verifying =="
# Only apply_panel_cert may invoke `easyxray cert`; any other call site would
# report success on a refused certificate (install.sh calls in command
# substitution or with redirection, the helper assigns the output).
if grep -nE '(^|[^-])easyxray cert -webCert' "${INSTALL_SH}" | grep -vE '\$\(' | grep -vE '^\s*[0-9]+:\s*out='; then
    fail "install.sh still calls \`easyxray cert\` without verifying the result"
fi

echo "CERT_APPLY_PASS"
