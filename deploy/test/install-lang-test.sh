#!/usr/bin/env bash
#
# install-lang-test.sh — unit-test install.sh's message catalog and language menu.
#
# install.sh prints every prompt, progress line and error through msg(). A key
# that is referenced but never defined reaches the user as its own literal name
# ("msg_ssl_title"), a locale the panel ships but the installer forgot falls back
# to English in silence, and an arm whose %s count differs from its call site
# either swallows a value or prints a stray placeholder.
#
# Needs only bash. Usage: bash deploy/test/install-lang-test.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INSTALL_SH="${REPO_ROOT}/install.sh"
PANEL_LOCALES_DIR="${REPO_ROOT}/internal/web/translation"
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT
export INSTALL_SH TMP

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

# set -e says where it gave up only by saying nothing, and a check that returns
# non-zero without a `|| fail` would look like a clean stop.
trap 'rc=$?; echo "FAIL: line ${LINENO} exited ${rc}" >&2; exit ${rc}' ERR

# Extract the shipped catalog, list and functions instead of reimplementing
# them, so the test cannot drift from what the installer ships.
extract_function() { # extract_function <name>
    sed -n "/^${1}() {$/,/^}$/p" "${INSTALL_SH}"
}

bash -n "${INSTALL_SH}" || fail "install.sh is not valid bash"
languages="$(grep -m1 '^INSTALL_LANGUAGES=' "${INSTALL_SH}")"
[[ -n "${languages}" ]] || fail "could not find INSTALL_LANGUAGES in install.sh"
eval "${languages}"
menu_rows_src="$(sed -n '/^INSTALL_MENU_ROWS=(/,/^)/p' "${INSTALL_SH}")"
[[ -n "${menu_rows_src}" ]] || fail "could not find INSTALL_MENU_ROWS in install.sh"
eval "${menu_rows_src}"
# The menu and the box colour their output with variables defined at the top of
# install.sh, which this test does not source.
yellow=''
plain=''
green=''
blue=''
# display_width finds its one-column character class in a top-level variable.
narrow3="$(grep -m1 '^__NARROW3=' "${INSTALL_SH}")"
[[ -n "${narrow3}" ]] || fail "could not find __NARROW3 in install.sh"
eval "${narrow3}"

# msg() is the function install.sh ships, wrapped only to bound a recursive arm
# by counting calls: a ulimit would depend on what the caller has already spent.
CALLS="${TMP}/calls"
BUDGET=0
export CALLS BUDGET
{
    extract_function msg | sed 's/^msg() {/__msg() {/'
    cat <<'GUARD'
msg() {
    printf 'x' >> "${CALLS}"
    if read -r -N "${BUDGET}" __ < "${CALLS}"; then return 1; fi
    __msg "$@"
}
GUARD
} > "${TMP}/catalog.sh"
source "${TMP}/catalog.sh"

budget() { # budget <calls> -- the ceiling for the section that follows
    BUDGET="$1"
    : > "${CALLS}"
}

budget_held() { # budget_held <what> -- reaching the ceiling means an arm recurses
    local calls
    calls="$(wc -c < "${CALLS}")"
    [[ ${calls} -lt ${BUDGET} ]] \
        || fail "${1} made ${calls} msg() calls (budget ${BUDGET}): an arm calls msg() back"
}

for fn in display_width print_usage_box install_locale_supported \
    resolve_install_language select_install_language; do
    body="$(extract_function "${fn}")"
    [[ -n "${body}" ]] || fail "could not extract ${fn}() from install.sh"
    eval "${body}"
done

declared_locales="$(IFS=';'; for entry in ${INSTALL_LANGUAGES}; do echo "${entry%%:*}"; done | sort)"
panel_locales="$(cd "${PANEL_LOCALES_DIR}" && ls ./*.json | xargs -n1 basename | sed 's/\.json$//' | sort)"
[[ -n "${panel_locales}" ]] || fail "no panel translations in ${PANEL_LOCALES_DIR}"

# Keys reach the catalog two ways: a literal call site, and the usage box, which
# looks its rows up through INSTALL_MENU_ROWS instead of naming msg_ keys inline.
call_keys="$(grep -oE '\$\(msg [a-z0-9_]+' "${INSTALL_SH}" | sed -E 's/^\$\(msg //' | sort -u)"
menu_keys="$(printf '%s\n' "${menu_rows_src}" | grep -oE '\|msg_[a-z0-9_]+' | sed 's/^|//' | sort -u)"
[[ -n "${call_keys}" ]] || fail "no \$(msg ...) call sites found in install.sh"
[[ -n "${menu_keys}" ]] || fail "INSTALL_MENU_ROWS names no catalog keys"
keys="$(printf '%s\n%s\n' "${call_keys}" "${menu_keys}" | sed '/^$/d' | sort -u)"

# An arm is one line and uses one of exactly two shapes, so a hand-edited arm
# that no longer parses fails here instead of printing a raw format string.
#
# The whole catalogue is indexed in one pass: the caller matches every (locale,
# key) pair, and a grep per pair costs a full grep per key, which alone made this
# suite a twenty-minute wait.
declare -A ARM=()
while IFS=$'\t' read -r _locale _key _text; do
    ARM["${_locale}:${_key}"]="${_text}"
done < <(sed -n -E \
    -e 's/^[[:space:]]+(\*|[a-z]{2}-[A-Z]{2}):(msg_[a-z0-9_]+)\)[[:space:]]+echo "(.*)"[[:space:]]*;;[[:space:]]*$/\1\t\2\t\3/p' \
    -e 's/^[[:space:]]+(\*|[a-z]{2}-[A-Z]{2}):(msg_[a-z0-9_]+)\)[[:space:]]+printf "(.*)\\n" "\$@"[[:space:]]*;;[[:space:]]*$/\1\t\2\t\3/p' \
    "${INSTALL_SH}")

# Those expressions drop anything that does not parse, so the index is
# reconciled against every line that looks like an arm.
arm_shaped="$(grep -cE '^[[:space:]]+(\*|[a-z]{2}-[A-Z]{2}):msg_[a-z0-9_]+\)' "${INSTALL_SH}")"
[[ "${#ARM[@]}" -eq "${arm_shaped}" ]] \
    || fail "${arm_shaped} arm line(s) but ${#ARM[@]} distinct entries: one is malformed or duplicated"

arm_text() { # arm_text <locale|*> <key>
    [[ -n "${ARM[${1}:${2}]:-}" ]] || return 1
    printf '%s\n' "${ARM[${1}:${2}]}"
}

# English is the `*` arm: it answers for en-US and for any locale we do not
# ship, so it is the only language without a prefixed arm of its own.
arms_for() { # arms_for <locale|*> -- every key that locale defines an arm for
    local entry
    for entry in "${!ARM[@]}"; do
        # An `if`, not `[[ ]] &&`: a trailing false test would fail the pipeline
        # this prints into, and `set -o pipefail` turns that into a silent exit.
        if [[ "${entry%%:*}" == "$1" ]]; then printf '%s\n' "${entry#*:}"; fi
    done | sort -u
}

arm_locales="$(for entry in "${!ARM[@]}"; do echo "${entry%%:*}"; done |
    grep -vx '\*' | sort -u)"
expected_arms="$(echo "${panel_locales}" | grep -vx en-US || true)"
english_keys="$(arms_for '*')"
[[ -n "${english_keys}" ]] || fail "the catalogue has no English (*) arms"

# Sets PLACEHOLDERS rather than printing: the caller runs this once per arm per
# locale, and a command substitution there is a fork each time.
count_in() { # count_in <text>
    local text="$1"
    PLACEHOLDERS=0
    while [[ "${text}" == *%s* ]]; do
        text="${text#*%s}"
        PLACEHOLDERS=$((PLACEHOLDERS + 1))
    done
}

budget 20000

echo "== the installer offers every language the panel ships =="
if [[ "${declared_locales}" != "${panel_locales}" ]]; then
    fail "INSTALL_LANGUAGES is [$(echo "${declared_locales}" | tr '\n' ' ')] but the panel ships [$(echo "${panel_locales}" | tr '\n' ' ')]"
fi
if [[ "${arm_locales}" != "${expected_arms}" ]]; then
    fail "the catalogue translates [$(echo "${arm_locales}" | tr '\n' ' ')] but the panel ships, English aside, [$(echo "${expected_arms}" | tr '\n' ' ')]"
fi

echo "== nothing is printed before the language menu =="
# The menu is the first thing the user reads, so a line printed ahead of it is in
# a language not yet chosen; install.sh cannot run here, so the call order stands in.
menu_call_line="$(awk '/^select_install_language$/{print NR; exit}' "${INSTALL_SH}")"
[[ -n "${menu_call_line}" ]] || fail "install.sh never calls select_install_language"
early_print="$(awk -v end="${menu_call_line}" 'NR < end && /^(echo|printf)/ && /\$\(msg /' "${INSTALL_SH}")"
[[ -z "${early_print}" ]] || fail "the installer prints \`${early_print}\` before it asks for a language"

echo "== every key is defined, used, and English =="
for key in ${keys}; do
    english="$(arm_text '*' "${key}")" || fail "no English message for ${key}"
    [[ "${english}" != "${key}" ]] || fail "no English message for ${key}"
    [[ -n "${english}" ]] || fail "the English arm of ${key} does not parse as echo or printf"
done
dead="$(comm -13 <(echo "${keys}") <(echo "${english_keys}") | tr '\n' ' ')"
[[ -z "${dead// /}" ]] || fail "defined but never used:${dead}"

for locale in ${arm_locales}; do
    arm_keys="$(arms_for "${locale}")"
    [[ "${arm_keys}" == "${english_keys}" ]] \
        || fail "${locale} and English define different keys: $(comm -3 <(echo "${english_keys}") <(echo "${arm_keys}") | tr '\n' ' ')"
done

echo "== call sites and arms agree on their placeholders =="
# An echo arm prints its own text and drops any argument, so a value silently
# disappears; a printf arm needs exactly the arguments its text declares.
call_sites_with_arg="$(grep -oE '\$\(msg [a-z0-9_]+ ' "${INSTALL_SH}" |
    sed -e 's/^\$(msg //' -e 's/ $//' | sort -u | tr '\n' ' ')"
for key in ${keys}; do
    count_in "${ARM[*:${key}]:-}"
    count="${PLACEHOLDERS}"
    called_with_arg=false
    case " ${call_sites_with_arg} " in
        *" ${key} "*) called_with_arg=true ;;
    esac
    if [[ ${count} -eq 0 ]] && [[ "${called_with_arg}" == true ]]; then
        fail "${key} has no placeholder but a call site passes an argument, so the value is dropped"
    fi
    if [[ ${count} -ge 1 ]] && [[ "${called_with_arg}" == false ]]; then
        fail "${key} declares ${count} placeholder(s) but no call site passes an argument"
    fi
done

echo "== no arm may call msg() back (the acme.sh fork storm) =="
# The English arm of msg_acme_installing once read `$(msg msg_acme_installing)`,
# so any install that had to fetch acme.sh forked subshells until the machine
# ran out of processes. Both checks below must stay: the grep names the mistake,
# the probe catches any recursion the grep cannot see.
if grep -nE '^[[:space:]]+[^:]+:msg_[a-z0-9_]+\)[[:space:]]*(echo|printf) "\$\(msg ' "${INSTALL_SH}" >&2; then
    fail "a catalog arm calls msg() itself -- that recurses until the machine runs out of processes"
fi
budget 40
rc=0
timeout 15 bash -c ". '${TMP}/catalog.sh'; INSTALL_LANG=en-US msg msg_acme_installing" \
    > "${TMP}/recursion.out" 2>&1 || rc=$?
[[ ${rc} -eq 0 ]] || fail "msg msg_acme_installing did not return promptly (exit ${rc}); it recurses"
budget_held "msg msg_acme_installing"

echo "== every arm is safe to interpolate =="
# Arms are echoed or printf-ed, so a quote, a backslash, a backtick or an
# unescaped $ would break out of the string; a stray % would corrupt printf.
for locale in '*' ${arm_locales}; do
    label="${locale}"
    [[ "${label}" == '*' ]] && label="en-US"
    for key in ${keys}; do
        text="${ARM[${locale}:${key}]:-}"
        [[ -n "${text}" ]] || continue
        case "${text}" in
            *'"'* | *'\'* | *'$'* | *'`'*) fail "${label}:${key} contains a character that would break the arm: ${text}" ;;
        esac
        if [[ "${text}" =~ %([^s]|$) ]]; then
            fail "${label}:${key} has a stray % (printf would mangle it): ${text}"
        fi
        count_in "${text}"
        count="${PLACEHOLDERS}"
        count_in "${ARM[*:${key}]}"
        if [[ "${count}" != "${PLACEHOLDERS}" ]]; then
            fail "${label}:${key} has ${count} placeholder(s), English has ${PLACEHOLDERS}"
        fi
    done
done

echo "== every locale prints its own text =="
# Each key is called with as many arguments as its own arm declares, so a
# translation that lost a %s, or a printf arm with a mismatched argument list,
# shows up as a leftover placeholder or an extra line.
: > "${TMP}/argc.tsv"
for key in ${keys}; do
    count_in "${ARM[*:${key}]:-}"
    printf '%s\t%s\n' "${key}" "${PLACEHOLDERS}" >> "${TMP}/argc.tsv"
done

sweep() { # sweep <locale> <out-file, one <key> <TAB> <text> line per key>
    local locale="$1" out="$2" key count args
    while IFS=$'\t' read -r key count; do
        args=()
        if [[ ${count} -ge 1 ]]; then args+=(A); fi
        if [[ ${count} -ge 2 ]]; then args+=(B); fi
        if [[ ${count} -ge 3 ]]; then args+=(C); fi
        printf '%s\t' "${key}"
        # msg() refuses once the budget is spent; budget_held() reports that,
        # so a refusal here must not abort the sweep on the spot.
        INSTALL_LANG="${locale}" msg "${key}" ${args[@]+"${args[@]}"} || true
    done < "${TMP}/argc.tsv" > "${out}"
}
key_count="$(echo "${keys}" | wc -l)"
for locale in en-US ${arm_locales}; do
    budget $((key_count * 3))
    sweep "${locale}" "${TMP}/${locale}.txt"
    budget_held "the ${locale} catalog"
    [[ "$(wc -l < "${TMP}/${locale}.txt")" -eq "${key_count}" ]] \
        || fail "${locale} printed $(wc -l < "${TMP}/${locale}.txt") lines for ${key_count} keys (a printf arm repeated or split its text)"
    if grep -q '%s' "${TMP}/${locale}.txt"; then
        fail "${locale} left a placeholder unfilled: $(grep -m1 '%s' "${TMP}/${locale}.txt")"
    fi
    # English is the reference itself: only another locale can fall back to it.
    if [[ "${locale}" == "en-US" ]]; then continue; fi
    unchanged="$(join -t$'\t' -j1 <(sort "${TMP}/en-US.txt") <(sort "${TMP}/${locale}.txt") |
        awk -F'\t' '$2 == $3 { printf " %s", $1 }')"
    # A handful of candidates are technical labels with nothing to translate
    # ("DSN:", a bare filename plus %s); a locale that was copied from English
    # wholesale leaves every key identical and fails here.
    if [[ -n "${unchanged// /}" ]]; then
        count="$(echo ${unchanged} | wc -w)"
        [[ ${count} -le 6 ]] || fail "${locale} prints the English text for ${count} keys:${unchanged}"
        echo "   ${locale}: ${count} label(s) match English:${unchanged}"
    fi
done

echo "== the usage box lines up in every locale =="
budget 20000
# Display columns per row, by a different method than install.sh's: the frame and
# arrows are three bytes but one column, so bytes would agree with a crooked box.
#
# One od per locale, one byte per line: a fork per row costs minutes on MSYS.
widths() { # widths <file> -- display columns, one per line
    od -An -v -tu1 -w1 "$1" | awk '
        { b = $1
          if (b == 10) { print c + 0; c = 0; lead = 0; next }
          if (b < 128) { c += 1; lead = 0 }
          else if (b < 192) {
              # first continuation of a three-byte character: U+2000-U+2BFF
              # is narrow, the CJK blocks after it are wide.
              if (lead == 226) { if (b < 176) c -= 1 }
              lead = 0
          }
          else if (b < 224) { c += 1; lead = 0 }
          else if (b < 240) { c += 2; lead = b }
          else { c += 2; lead = 0 } }
        END { if (c > 0) print c + 0 }'
}
expected_rows=$(( ${#INSTALL_MENU_ROWS[@]} + 4 ))
for locale in ${declared_locales}; do
    INSTALL_LANG="${locale}" print_usage_box > "${TMP}/box-${locale}.txt"
    rows="$(wc -l < "${TMP}/box-${locale}.txt")"
    [[ "${rows}" -eq "${expected_rows}" ]] \
        || fail "the ${locale} usage box has ${rows} lines, want ${expected_rows}"
    box_widths="$(widths "${TMP}/box-${locale}.txt" | sort -u | tr '\n' ' ')"
    [[ "$(echo ${box_widths} | wc -w)" -eq 1 ]] \
        || fail "the ${locale} usage box rows are not equally wide: ${box_widths}"
    for entry in "${INSTALL_MENU_ROWS[@]}"; do
        label="$(INSTALL_LANG="${locale}" msg "${entry#*|}")"
        grep -qF "${label}" "${TMP}/box-${locale}.txt" \
            || fail "the ${locale} usage box is missing the row for ${entry#*|}"
    done
done

echo "== the menu offers every locale, numbered =="
budget 20000
NONINTERACTIVE=0
unset EASYXRAY_LANG
resolve_install_language
menu_codes="$(IFS=';'; for entry in ${INSTALL_LANGUAGES}; do echo "${entry%%:*}"; done)"
menu_output="$(select_install_language < /dev/null 2> /dev/null || true)"
for code in ${menu_codes}; do
    [[ "${menu_output}" == *"(${code})"* ]] || fail "the menu does not list ${code}"
done

# The header is user-facing text like every other line the installer prints, so
# it follows the resolved language instead of being hardcoded.
for code in en-US ja-JP ar-EG; do
    EASYXRAY_LANG="${code}"
    resolve_install_language
    header="$(msg msg_lang_menu_title)"
    [[ -n "${header}" && "${header}" != "msg_lang_menu_title" ]] \
        || fail "the ${code} menu header has no catalogue text"
    # read() returns non-zero at EOF, which off a TTY is the only way here; the
    # check below reads the menu the installer printed before it prompted.
    select_install_language < /dev/null > "${TMP}/header-${code}.out" || true
    grep -qF "${header}" "${TMP}/header-${code}.out" \
        || fail "the ${code} menu header is not [${header}]"
done

index=0
for code in ${menu_codes}; do
    index=$((index + 1))
    select_install_language < <(printf '%s\n' "${index}") > /dev/null
    [[ "${INSTALL_LANG}" == "${code}" ]] || fail "menu choice ${index} selected ${INSTALL_LANG}, want ${code}"
done

# A typo at the prompt must not throw away an explicit EASYXRAY_LANG: the menu
# falls through to the language it advertised in brackets.
EASYXRAY_LANG=ru-RU
resolve_install_language
select_install_language < <(printf '99\n') > "${TMP}/invalid.out"
[[ "${INSTALL_LANG}" == "ru-RU" ]] \
    || fail "an invalid choice replaced the requested ru-RU with ${INSTALL_LANG}"
grep -qF "$(INSTALL_LANG=ru-RU msg msg_lang_invalid)" "${TMP}/invalid.out" \
    || fail "an invalid choice did not warn the user"

echo "== the menu must not run unattended =="
# `curl ... | bash` has no TTY; a read here would consume stdin or hang.
NONINTERACTIVE=1
for code in ${menu_codes}; do
    EASYXRAY_LANG="${code}"
    resolve_install_language
    select_install_language < /dev/null > /dev/null
    [[ "${INSTALL_LANG}" == "${code}" ]] || fail "EASYXRAY_LANG=${code} was ignored: ${INSTALL_LANG}"
done

INSTALL_LANG="pt-BR"
EASYXRAY_LANG=de-DE
resolve_install_language 2> "${TMP}/unknown.out"
[[ "${INSTALL_LANG}" == "en-US" ]] || fail "an unknown EASYXRAY_LANG left ${INSTALL_LANG}, want en-US"
grep -qF "$(INSTALL_LANG=en-US msg msg_lang_invalid)" "${TMP}/unknown.out" \
    || fail "an unknown EASYXRAY_LANG was ignored without a word"

echo "== an explicit language survives the menu's default =="
budget 20000
NONINTERACTIVE=0
EASYXRAY_LANG=ru-RU
resolve_install_language
select_install_language < <(printf '\n') > /dev/null
[[ "${INSTALL_LANG}" == "ru-RU" ]] || fail "the default choice dropped EASYXRAY_LANG=ru-RU for ${INSTALL_LANG}"

echo "INSTALL_LANG_PASS"
