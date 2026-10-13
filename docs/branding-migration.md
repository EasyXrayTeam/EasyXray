# Branding migration ledger

This document records the complete `3x-ui` → `EasyXray` rebrand of this
codebase: every identifier that was renamed, every old-brand reference that was
**deliberately kept** and why, and every file that was deleted. It exists so a
reviewer can audit the change without diffing 1000+ files by hand.

It is a working document, not part of the published documentation site (the site
lives under `docs/content/`; this file sits beside `docs/architecture.md` and the
other repository-level notes).

---

## 1. Provenance

|                  |                                                                                                                                                             |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Upstream project | [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui)                                                                                                         |
| Base commit      | `74c3cc38821cabd66ad316ea562851422d0b0063` — _"fix(database): blank boolean-era verifyPeerCertByName values on hosts"_ (2026-10-12, upstream `3.10.0` line) |
| This repository  | [EasyXrayTeam/EasyXray](https://github.com/EasyXrayTeam/EasyXray)                                                                                           |
| License          | GNU GPL-3.0 — unchanged, see [`LICENSE`](../LICENSE)                                                                                                        |
| Relationship     | **Modified derivative work.** Not endorsed by, sponsored by, or affiliated with the upstream author. See [`NOTICE`](../NOTICE).                             |

Git history was **not** rewritten. The full upstream commit history is intact;
the rebrand is a short linear series of commits on top of it, merged into `main`
on 2026-10-13 with rebase-and-merge (so the commits on `main` carry new hashes;
the branch `branding/easyxray` was left behind, diverged).

---

## 2. The new identity

| Surface               | Old                            | New                                   |
| --------------------- | ------------------------------ | ------------------------------------- |
| Product name          | `3x-ui` / `X-UI`               | `EasyXray`                            |
| Binary                | `x-ui`                         | `easyxray`                            |
| Go module             | `github.com/mhsanaei/3x-ui/v3` | `github.com/EasyXrayTeam/EasyXray/v3` |
| Repository            | `MHSanaei/3x-ui`               | `EasyXrayTeam/EasyXray`               |
| Version               | `3.10.0`                       | `1.0.0`                               |
| systemd unit          | `x-ui.service`                 | `easyxray.service`                    |
| OpenRC unit           | `x-ui.rc`                      | `easyxray.rc`                         |
| Control script        | `x-ui.sh`                      | `easyxray.sh`                         |
| Install directory     | `/usr/local/x-ui`              | `/usr/local/easyxray`                 |
| Config / DB directory | `/etc/x-ui`                    | `/etc/easyxray`                       |
| Database file         | `x-ui.db`                      | `EasyXray.db`                         |
| Log file              | `x-ui.log`                     | `easyxray.log`                        |
| Env prefix            | `XUI_*`                        | `EASYXRAY_*`                          |
| Session cookie        | `3x-ui`                        | `easyxray`                            |
| API namespace         | `/panel/api/…`                 | `/easyxray/api/v1/…`                  |
| Panel (SPA) routes    | `/panel/…`                     | `/easyxray/…`                         |
| WebSocket             | `/ws`                          | `/easyxray/ws`                        |
| Service env file      | `/etc/default/x-ui`            | `/etc/default/easyxray`               |

---

## 3. Rename ledger

### 3.1 Build & module

- `go.mod`: module path → `github.com/EasyXrayTeam/EasyXray/v3`. Every internal
  import was rewritten to match (`internal/**`, `main.go`, `tools/openapigen`).
- `go.sum` is unchanged — no dependency was added, removed, or upgraded.
- Go toolchain stays at `go 1.27.2`.
- `internal/config/version` → `1.0.0` (embedded via `//go:embed version`).
- The `Makefile` gate (`make verify` = `gen-check lint format-check typecheck
  msw-worker-check test build build-storybook`) is unchanged in structure and
  operates on the new module path.

### 3.2 API namespace (no compatibility layer)

The user explicitly chose a full API rename with **no backward-compatible
aliases**. Consequences, all intentional:

- `internal/web/controller/api.go` — route group is `/easyxray/api/v1`; the
  prefix-stripping constant that `relAPIPath` relies on was moved with it.
- `internal/web/controller/spa.go` — SPA group is `/easyxray`, serving `/`,
  `/inbounds`, `/clients`, `/groups`, `/nodes`, `/settings`, `/xray`,
  `/outbound`, `/routing`, `/api-docs`, and `/csrf-token`.
- `internal/web/web.go` — `MaxBodyBytes` exemption path, and the WebSocket route
  `g.GET("/easyxray/ws", …)`.
- `internal/web/runtime/remote.go` — the master↔node client: ~40 request paths
  moved from `panel/api/…` to `easyxray/api/v1/…`. These are relative to each
  node's configured base path, so they keep working under any `webBasePath`.
- Frontend call sites: `frontend/src/api/*` (`HttpUtil` base), the WebSocket URL
  builder, the post-login redirect, the backup/migration download URLs, and the
  API-docs page's spec URL.
- OpenAPI source of truth `frontend/scripts/build-openapi.mjs` +
  `frontend/src/pages/api-docs/endpoints.ts` were updated, then the generated
  artifacts regenerated: `frontend/public/openapi.json` (184 paths, 195
  operations, 13 tags) and the `frontend/src/generated/` Zod/TS mirror
  (`npm run gen:zod`, backed by `go run ./tools/openapigen`).

A residue check on the regenerated spec finds **0** occurrences of `panel/api`
and **190** of `easyxray/api/v1`.

### 3.3 Runtime, install & service

- `install.sh`, `easyxray.sh`, `update.sh` — install paths, unit names, temp
  files, and the printed access URL.
- `easyxray.service.{debian,rhel,arch}` and `easyxray.rc` — `Description`,
  `ExecStart`, `WorkingDirectory`, `EnvironmentFile`.
- Self-update: `internal/web/service/panel/panel.go` resolves releases from
  `EasyXrayTeam/EasyXray` (same mechanism as upstream, different repository).
- `internal/config/config.go` — env-var names, default DB folder, and the
  database filename.

### 3.4 Frontend

- `frontend/src/routes.tsx` — router basename is `<basePath>/easyxray`.
- `frontend/vite.config.js` — the dev-server proxy anchors on the first path
  segment; `panel` → `easyxray` in the proxy matcher, in
  `PANEL_API_PREFIXES` (`easyxray/csrf-token`), and in the
  `bypassMigratedRoute` SPA fallback. Without this, `npm run dev` would proxy
  `/easyxray/…` nowhere.
- `frontend/public/manifest.webmanifest` — `name`/`short_name` `EasyXray`,
  theme colour `#22D3EE`, background `#0B1220`.
- `internal/web/controller/dist.go` — the server-side `<head>` injection emits
  the `easyxray-32.png`, `favicon.ico`, and `apple-touch-icon.png` links, and
  injects `window.EASYXRAY_BASE_PATH` / `EASYXRAY_CUR_VER` / `EASYXRAY_DB_TYPE`.
- Donate/sponsor surfaces point at `https://ko-fi.com/minimaxflora`
  (`frontend/src/layouts/AppSidebar.tsx`,
  `internal/web/service/panel/sponsor.go`, `.github/FUNDING.yml`).

### 3.4.1 The mark

The upstream icon set is replaced by a **vector trace of the artwork supplied
for this rebrand**, not a new design. Its geometry was measured off the source
raster rather than approximated: disc `r=224`, rim `r=221`, four elliptical
orbits `rx=174 ry=68` at 0/45/90/135°, a nested-triangle core, and eight orbit
particles, all in a 512×512 viewBox. The four-orbit reading was verified by
fitting ellipse sets to the artwork's stroke pixels — 94.6% coverage against
53.9% for the best three-orbit fit. The measurements and the full geometry table
live in [`tools/branding/README.md`](../tools/branding/README.md).

Everything raster is generated from those SVGs by
`tools/branding/generate-icons.mjs` (sharp for PNG, a hand-rolled container for
the ICO).

### 3.5 Documentation site (`docs/`)

- Rewritten as documentation for a **new project**: `en`, `fa`, `ru`, `zh`, with
  deployment targeting the GitHub Pages address (`DEPLOY_TARGET=static`,
  `basePath`/`assetPrefix` `/EasyXray`). `docs/public/CNAME` was deleted — there
  is no custom domain yet.
- `docs/public/openapi.json` re-synced from the regenerated frontend spec.
- The 13 generated per-tag API reference pages were **regenerated with the
  official generator** (`pnpm gen:api` → `node scripts/gen-openapi.ts`), not
  hand-edited; the generated files carry a `Do not edit this file directly`
  banner.
- The same 13 pages exist as translations under `fa`, `ru`, `zh`. The generator
  only writes `en`, so those copies were updated mechanically (the `operations`
  path arrays and the `/panel/api` → `/easyxray/api/v1` strings). Their
  per-page TOC anchors are derived from the English operation summaries and were
  left internally consistent; two operations whose English summary text changed
  (`getPanelUpdateInfo`, `restartPanel`) keep their previous anchor slugs in the
  non-English copies only. This is a cosmetic drift on jump links, not a
  rendering fault.

### 3.6 CI/CD

- The Claude Code pipelines (`.github/workflows/claude-issue-analyst.yml`,
  `claude-pr-review.yml`) were **kept and renamed**, not removed.
- Workflow names, job names, artifact names, and cache keys were rebranded
  across `ci.yml`, `release.yml`, `docker.yml`, `docs-ci.yml`,
  `docs-deploy.yml`, `codeql.yml`, `mutation.yml`, `cleanup_caches.yml`.
- `release.yml` now builds `easyxray-release` and packages
  `easyxray-linux-<platform>.tar.gz`, bundling `easyxray.sh` and the three
  `easyxray.service.*` units; the Go ldflags target the new module path.
- This is a **single repository** containing both the Go backend and the
  `frontend/` SPA — CI checks out nothing else and reads
  `frontend/package-lock.json` directly. No sibling-repository bridge, no
  `EASYXRAY_FRONTEND` / `EASYXRAY_BACKEND` variables.

### 3.7 Corrections found after the first verification pass

The first pass renamed the router basename and the API prefix but missed some
sites that _consume_ them, and it never ran the docs test suite. Five defects
were found and fixed on this branch; none of them was cosmetic.

- **The settings page redirected to a route that no longer exists.**
  `frontend/src/pages/settings/SettingsPage.tsx` still built
  `/<basePath>panel/settings` for the post-restart redirect. `routes.tsx` had
  moved the router basename to `<basePath>/easyxray`, so "Restart panel" landed
  on a 404: the rename reached the router but not its only hard-coded consumer.
  The path now comes from `frontend/src/lib/panel-url.ts`, and
  `frontend/src/test/panel-restart-redirect.test.tsx` resolves it against the
  real route table with `matchRoutes`, so the two cannot drift apart silently
  again.
- **The "old namespace" callout in all 7 READMEs named `/easyxray/api/v1/…` as
  the prefix that no longer answers** — the substitution had rewritten the very
  string it was describing, leaving a self-contradictory warning. It now reads
  `/panel/api/…`, matching `docs/content/docs/*/help/migration.mdx` and
  `docs/content/docs/*/reference/api/index.mdx`.
- **`CONTRIBUTING.md` documented the pre-rename SPA routing:** `/panel` as the
  router basename, `/panel/*` as the dev-proxy rule, and `/easyxray/api/v1-docs`
  as a route name. All three now match `routes.tsx` and `vite.config.js`;
  `docs/architecture.md`'s `spa.go` annotation carried the same stale label.
- **`docs/lib/xray/api-client.test.ts` kept `panel/api/inbounds/list` as a
  `joinUrl` input** while its expected value had been renamed, so the docs suite
  failed. The substitution was anchored on a leading `/` and skipped the
  unanchored form. The missed gate is as much the defect as the string: `pnpm
  test` was never run over `docs/` in the first pass; it is now recorded in §8.
- **Base-path examples still used the retired `/panel` default** in
  `.env.example`, all four `reference/env-vars.mdx` locales, the reverse-proxy
  generator default, the install-command placeholder, and the
  `ReverseProxyOptions` doc comment. They now use `/mypanel`, the example the
  READMEs already use. Test fixtures that merely need _a_ base path were left
  alone.

### 3.8 Correction found after the merge

The five above were caught by reading; this one needed a gate that only fires on
`main`.

- **The MTProto sidecar's dependency URL was renamed along with the project.**
  The rename included a catch-all `s#[Mm][Hh][Ss]anaei#MinimaxFlora#g`, which
  also rewrote `github.com/mhsanaei/mtg-multi` — a third-party project that is
  _not_ part of this rebrand — to `github.com/MinimaxFlora/mtg-multi`, a path
  that does not exist. `release.yml` (4 sites) and `DockerInit.sh` (2) resolve
  the sidecar's latest tag from that URL and abort on an empty result, so every
  Linux and Windows release build died with `could not resolve the latest
  mtg-multi release tag`; `internal/mtproto/process.go`, `docs/architecture.md`
  and `.github/claude/issue-analyst-context.md` documented the dead path. All
  nine now read `mhsanaei/mtg-multi` (latest `v1.15.0`, whose asset names match
  the matrix labels: `mtg-multi-1.15.0-linux-amd64.tar.gz`, …). The branding
  brief's rename list names `MHSanaei/3x-ui`, `mhsanaei/3x-ui` and
  `docs.sanaei.dev` and never the sidecar, so the substitution over-reached
  rather than missed a site. What let it through: the §8 residue scan was
  written as "0 old-brand hits", and a catch-all is the surest way to satisfy
  that — nothing checked that a renamed URL still _resolves_. `release.yml`
  triggers only on `main` pushes and tags, so no branch CI ever ran the step.

### 3.9 Two inherited CI defaults fixed while cutting the first release

Neither is rename damage — both come from `74c3cc38` unchanged — but both showed
up the first time the pipeline actually ran to completion.

- **Version tags were published as pre-releases.** Both
  `svenstaro/upload-release-action` steps carried `prerelease: true`
  (`release.yml:198,334`), so `v1.0.0` came out flagged _Pre-release_ with an
  empty title. `/releases/latest` skips pre-releases, so `install.sh`,
  `update.sh` and the panel's update check would 404 on a repository whose only
  releases were pre-releases — a state upstream never reaches, because its
  version releases are created by hand and the workflow only attaches assets
  (`v3.10.0 prerelease=false`). Both steps now read `prerelease: false`, and the
  existing `v1.0.0` was flipped to match. The rolling `dev-latest` job is
  untouched: it passes `--prerelease --latest=false` on purpose.
- **The Windows build ran on the deprecated MINGW64 MSYS2 environment**, which
  `msys2/setup-msys2` annotated on every run. Migrated to `UCRT64`, its drop-in
  successor, with the matching `mingw-w64-ucrt-x86_64-*` packages; the CGO build
  needs no other change because UCRT64 ships the same `x86_64-w64-mingw32-gcc`
  triplet, and nothing in the workflows hard-codes a `/mingw64` path. Checked by
  running `release.yml` on the branch through `workflow_dispatch` (which skips
  every publishing step): all eight build legs green, the Windows log records
  `msystem: UCRT64` and the string `deprecat` no longer appears anywhere in it.

### 3.10 Version floors inherited from the 3.x line

Found by installing the published release on a clean host, which is the only way
any of them can fire: each one compares a version _number_ this project inherited
from upstream against tags that only exist in the 3.x numbering. This
repository's tags are `v1.0.0` and `dev-latest`, so every floor either rejected
the only release there is or was never reached.

- **`install.sh` refused to install its own release.** The positional-argument
  path carried `min_version="2.3.5"` and compared the requested tag against it,
  so the documented `install.sh v1.0.0` — the command in the READMEs and the
  install docs — printed `Please use a newer version (at least v2.3.5). Exiting
  installation.` and exited 1 before downloading anything. Note the blast radius:
  `install.sh` is always fetched from `main`, so this broke the documented
  command for every release, not just that one. Removed rather than renumbered,
  because the floor was standing in for a check that already exists and is
  stronger: `require_repo_files` probes the requested tag for `easyxray.sh`, and
  the tarball's published `.sha256` is verified. The `dev` alias no longer needs
  a branch of its own.
- **`nodeProtocolFirstRelease` gated every sidecar protocol at 3.x.** MTProto,
  AmneziaWG, TUIC and MASQUE were pinned to `v3.5.0`, `v3.7.0`, `v3.8.0` and
  `v3.9.1`, and `checkNodeCanHostProtocol` refuses when the node's reported
  version compares lower — so a node reporting `1.0.0` was judged older than a
  floor of `v3.5.0` and **all four protocols were unassignable to every node**.
  The floors never protected a real population: `beb12633` repointed the
  master→node calls from `panel/api/…` to `easyxray/api/v1/…`, so a node must
  already be running this project's panel to be reachable at all, and no 3.x
  panel can be. All four now read `v1.0.0`, the first release of the line that
  ships them. `TestNodeProtocolFirstReleaseIsNotNewerThanThisPanel` compares the
  map against `config.GetBaseVersion()`, so a renumbering cannot quietly
  re-create this; the old tests could not catch it, because they asserted the
  floors against each other rather than against the panel.
- **Three user-facing statements repeated the old floors**: `config/amneziawg`
  (en) and `config/tuic` (en, ru) told users a node needs panel v3.7.0/v3.8.0.
  Corrected to v1.0.0.
- **Sweep for the same class** found three comment-level leftovers, all
  corrected: `install.sh` and `update.sh` described the fail2ban guard as
  "scripts older than v3.4.0" (it is upstream's v3.4.0 the guard is about; the
  check itself greps the installed binary and is unaffected), and
  `deploy/test/smoke-noninteractive.sh` used `v3.4.2` as its example tag.

The published `v1.0.0` binary carries the second defect, so multi-node protocol
assignment needs a `v1.0.1`.

### 3.11 Surfaces found after the `v1.0.1` release

- **The collapsed sidebar rail showed the upstream mark.** `AppSidebar` renders
  the wordmark `EasyXray` when open and fell back to the literal `3X` when
  collapsed — the one brand surface the rename pass missed, because `3X` is not a
  token any sweep looked for (`3x-ui`, `x-ui`, `XUI_`, …). The rail is 72px wide,
  so the wordmark does not fit; it now shows `EX`, the wordmark's two capitals,
  and `frontend/src/test/app-sidebar.test.tsx` pins that. The guard earns its
  place now that upstream is merged periodically: a sync is exactly how the old
  literal would come back.
- **The IP-limit surfaces still carry the upstream name.** `easyxray.sh` prints
  `3X-IPL ban log entries:`, and the fail2ban jail, filter and action are named
  `3x-ipl` (created by `setup_fail2ban`, duplicated in `DockerEntrypoint.sh`, and
  queried by the CLI's `fail2ban-client status 3x-ipl`). The heading is cosmetic;
  the jail name is not — renaming it rewrites fail2ban configuration that already
  exists on installed hosts, so it is left as §9 item 7 rather than changed here.

---

## 4. Deliberate non-renames

These old-brand strings remain on purpose. Each is either a legal requirement, a
third-party contract, or a generic word that was never the brand.

| Location                                                                                                                                                                                          | Why it stays                                                                                                                                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `README*.md` (all 7) — "Upgrading from 3x-ui", "modified derivative of MHSanaei/3x-ui"                                                                                                            | GPL-3.0 requires preserving attribution and stating that this is a modified derivative. The upgrade section tells users the truth: there is no migration path.                                                                       |
| `README*.md` — ecosystem links (`terraform-provider-3x-ui`, `3X-UI Manager`)                                                                                                                      | They are third-party projects that interoperate with the _upstream_ panel. Renaming them would be factually wrong.                                                                                                                   |
| `NOTICE`, `THIRD_PARTY_NOTICES.md`                                                                                                                                                                | Legal attribution for upstream and for every third-party dependency.                                                                                                                                                                 |
| `tools/branding/README.md` — "upstream 3x-ui icon set"                                                                                                                                            | Provenance: names which icon set the new mark replaces. Attribution, not a brand reference.                                                                                                                                          |
| `docs/content/docs/*/help/migration.mdx`, `help/faq.mdx`, `guide/installation.mdx`                                                                                                                | These pages _exist_ to explain that EasyXray does not adopt, detect, or migrate a `3x-ui` install. The comparison table needs the old name.                                                                                          |
| `docs/content/docs/*/reference/api/index.mdx`                                                                                                                                                     | The "no aliases" callout names `/panel/api/…` to tell integrators exactly which prefix no longer answers.                                                                                                                            |
| `internal/xray/*`, `internal/config/*` — Xray core configuration field names, protocol identifiers, share-link schemes (`vless://`, `vmess://`, `trojan://`, `ss://`), `reality`, `xhttp`, `xtls` | Third-party protocol contracts. Renaming these would break client compatibility.                                                                                                                                                     |
| `panelOutbound`, `panelVersion`, `panelGuid` (JSON fields, DB columns, settings keys)                                                                                                             | Generic domain concepts — "the panel's outbound route", "the version a node's panel reports". They never contained the old brand, and they are persisted/migrated data. Renaming them would require a data migration for no benefit. |
| `frontend/src/lib/panel-version.ts`, `formatPanelVersion`, `isPanelUpdateAvailable`                                                                                                               | Same as above: "panel" as a noun, not a brand.                                                                                                                                                                                       |
| `internal/web/service/client_update_rename_test.go` — the literal `"Sanaei"`                                                                                                                      | Test _data_, not branding: it is a client e-mail used to prove the email-rename path is case-insensitive.                                                                                                                            |
| Test hostnames like `panel.example.com`                                                                                                                                                           | RFC-2606-style reserved example hostnames in fixtures.                                                                                                                                                                               |
| "panel" throughout UI copy and translations (`internal/web/translation/*.json`)                                                                                                                   | The English word for the admin panel. Verified: no `/panel/…` _path_ survives in any locale file.                                                                                                                                    |

### 4.1 One retained behavior worth flagging

`internal/config/config.go` has a Windows-only `init()` that copies a database
from `/etc/easyxray/<name>.db` to the platform default folder. After the rename
both paths resolve to the same location on the code path that reaches the copy,
so the call is a no-op. It was **kept** rather than deleted because:

- it is genuinely unreachable-but-harmless, not misleading;
- `copyFile` is still exercised by `internal/config/config_mutation_test.go`, so
  removing it would not simplify anything;
- it carries no old-brand string.

---

## 5. Deletions

| Path                                                    | Reason                                                                                                                                                                                                                                                 |
| ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `docs/public/CNAME`                                     | Declared a custom documentation domain. The user chose the GitHub Pages address instead; a `CNAME` pointing at a domain we do not control would break the site. Add one back when a domain is registered.                                              |
| `frontend/public/icons/3x-ui-{16,24,32,64,192,512}.png` | Superseded by the new EasyXray icon set.                                                                                                                                                                                                               |
| All 131 git tags, local and on `origin`                 | Removed on the user's explicit instruction. `gh api repos/EasyXrayTeam/EasyXray/git/refs/tags` confirmed **0 releases** were attached to any of them before deletion; all 131 were then deleted through the API (`deleted=131 failed=0`, 0 remaining). |
| `.gitignore` entry `dist/`                              | Replaced with `**/dist/*` plus `!internal/web/dist/.gitkeep`. The bare `dist/` pattern excluded the directory itself, which made the negation ineffective and would also have excluded `docs/dist`.                                                    |

---

## 6. New files

| Path                                                                          | What                                                                                                                                                                                                                         |
| ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `NOTICE`                                                                      | Derivative-work statement, upstream base commit, GPL-3.0 terms, non-affiliation clause.                                                                                                                                      |
| `THIRD_PARTY_NOTICES.md`                                                      | Licenses for all 39 direct Go modules and 45 frontend packages, read from the actual installed module/package metadata rather than guessed; MPL-2.0 notice for `xtls/xray-core` and `pgregory.net/rapid`; trademark section. |
| `tools/branding/`                                                             | Vector source of truth for the mark (`easyxray-mark.svg`, `easyxray-mark-compact.svg`, lockups), the `generate-icons.mjs` script (sharp + a hand-rolled ICO container), and its README with the measured geometry table.     |
| `frontend/public/favicon.ico`, `apple-touch-icon.png`, `icons/easyxray-*.png` | Generated from the SVG sources — a trace of the supplied artwork (§3.4.1), not a redraw from description.                                                                                                                    |
| `SECURITY.md`                                                                 | Rewritten for this project: GitHub private advisories first, with `2519840456@qq.com` as the monitored fallback contact. The upstream maintainer's personal address is gone.                                                 |
| `media/easyxray-{light,dark}.png`                                             | README hero images (renamed from `media/3x-ui-*.png`).                                                                                                                                                                       |
| `sponsors/sponsors.json`, `sponsors/logos/`                                   | Sponsor data consumed by the panel's sponsor surface, served from this repository's `main` branch.                                                                                                                           |
| `docs/branding-migration.md`                                                  | This file.                                                                                                                                                                                                                   |

---

## 7. Compatibility stance

- **No API compatibility layer.** `/panel/api/…` is not routed, not redirected,
  and not aliased. Integrations written against the old namespace must be
  updated.
- **No install compatibility.** EasyXray does not detect, adopt, convert, or
  upgrade an existing `3x-ui` installation. Service name, install directory,
  config/database directory, env prefix, database filename, and API namespace all
  differ, and no migration path is provided. An upgrade in place is not
  supported; users are told to keep both panels running, export what they need,
  and recreate it.
- **No data-migration code was added**, because no persisted _brand_ field was
  renamed — the persisted names that contain "panel" (`panelOutbound`,
  `panelVersion`) are generic and were left alone (§4).
- GPL-3.0 obligations are met: the license is intact, upstream copyright and
  attribution are preserved, and the derivative relationship is stated in
  `NOTICE`, all 7 READMEs, and `THIRD_PARTY_NOTICES.md`.

---

## 8. Verification

Run against the working tree on branch `branding/easyxray`; the sidecar row below
was re-checked on `main` after the merge (§3.8).

| Check                                              | Result                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `gofmt -l` over every changed `.go` file           | **PASS** — clean (four files needed realignment after the renames and were formatted)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `go vet ./...`                                     | **PASS** — exit 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `go test ./...`                                    | **5 failures, all pre-existing** — see below                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `npm run typecheck` (frontend)                     | **PASS**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `npm run lint` (frontend)                          | **PASS**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `npm run test` (frontend)                          | **PASS** — 190 files, 1843 tests (162 unit/components + 28 Storybook browser stories)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `npm run build` (frontend)                         | **PASS** — dist repopulated with the new icons, `favicon.ico`, `apple-touch-icon.png`, regenerated `openapi.json`; re-run after §3.7 with no generated-file drift                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `pnpm run typecheck` (docs site)                   | **PASS**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| `pnpm test` (docs site)                            | **PASS** — 12 files, 107 tests. Added after §3.7: this suite was missing from the first pass and is what the `joinUrl` defect escaped through                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `pnpm run format:check` (docs site)                | **PASS** — `oxfmt --check .`, 117 files                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `pnpm run gen:api` (docs site)                     | **PASS** — 13 tag pages regenerated from the new spec                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `DEPLOY_TARGET=static pnpm run build` (docs site)  | **PASS** — static export prerenders every page in all four locales; spot-checking the built HTML confirms the API pages carry the `/easyxray/api/v1/…` namespace and that `/panel/api/…` survives only on the migration and "no aliases" pages, where it belongs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Old-brand residue scan                             | After §3.7, `panel/api` survives only where it names the retired prefix: all 7 READMEs, the four `help/migration.mdx`, the four `reference/api/index.mdx`, this ledger. No `/panel/…` UI route remains in `frontend/src`, in any locale file, or on any docs page; **0** old-brand hits in `.github/` or `install.sh`                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| `release.yml` + `DockerInit.sh` sidecar tag lookup | **FAILED on `main` after the merge (see §3.8); PASS after the fix** — the tag-lookup line, copied out of each file and run as-is, resolved to an empty tag (hence `could not resolve the latest mtg-multi release tag`) and now prints `v1.15.0`, with the matching asset URL answering 200. No test can reach a workflow's shell step, so running the file's own command is the demonstration                                                                                                                                                                                                                                                                                                                                                                                  |
| Shipped release artifacts                          | **PASS** — `easyxray-linux-amd64.tar.gz` and `easyxray-windows-amd64.zip` fetched from the published release match their published `.sha256`, and contain `easyxray/bin/mtg-linux-amd64` / `mtg-windows-amd64.exe` — the sidecar binaries that exist only because §3.8's URL resolves. Grepping the shipped `easyxray` binary finds **0** hits for `3x-ui`, `x-ui`, `sanaei` and `MHSanaei`, and 12715 for `EasyXray`; the sole `panel/api` hit is the Go build path `internal/web/service/panel/api_token.go`, not a URL                                                                                                                                                                                                                                                       |
| `npm run generate` (branding tools)                | **PASS** — 14 files regenerated from the four SVGs; the 512px icon, the 180px apple-touch-icon, the four-entry ICO and the two lockups were each rendered and inspected against the source artwork                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `install.sh v1.0.0` on a clean host (§3.10)        | **PASS** — after the fix, the script installed the published `v1.0.0` on a fresh Debian 13 host: exit 0, the tarball's published `.sha256` verified, a Let's Encrypt certificate issued for the bound domain over HTTP-01 on port 80 (issuer `CN=YE1`, four-cert chain), `easyxray` active and enabled, the `xray-linux-amd64` child running against its generated `config.json`, and a real login (the SPA's `X-CSRF-Token` flow, `POST /<base>/login`) returning `{"success":true}` with an authenticated `/easyxray/api/v1/server/status` answering 200. Before the fix the same command exited 1 with `Please use a newer version (at least v2.3.5)`. No test can reach a shell installer's tag handling, so running the script against a real release is the demonstration |
| `nodeProtocolFirstRelease` vs the panel version    | **PASS** — `TestNodeProtocolFirstReleaseIsNotNewerThanThisPanel` was RED before the fix (all four protocols reported "newer than this panel (1.0.0)") and GREEN after; the four affected test files were re-expressed in the current numbering, and PR #4's CI agrees — `go-test`, `golangci`, `race`, `node-e2e` (a real master and sub-node) and `postgres-durable-first` all pass                                                                                                                                                                                                                                                                                                                                                                                            |

| `v1.0.1` published (PR #3 + PR #4) | **PASS** — the tag sits on PR #4's merge commit `9ae4de1e`; `release.yml` built all 7 Linux platforms plus Windows (8 jobs green, `Publish rolling dev release` correctly skipped on a tag push) and attached **16** assets with their `.sha256` sidecars. `/releases/latest` resolves to `v1.0.1` with `prerelease=false`, which is what PR #3's `prerelease: false` fix made possible; before it, a tag release was published as a pre-release and `/releases/latest` skipped it. The version bump rode inside PR #4 rather than in a commit of its own, because `release.yml` filters on `paths` — a version-only tag matches none of them and would publish no artifacts at all |
| `update.sh` v1.0.0 → v1.0.1 on the live host | **PASS** — the documented update path (script from `main`, no argument, so `/releases/latest`) exited 0 and logged `easyxray v1.0.1 updating finished`: published `.sha256` verified, database migrated, and the panel's port, web base path and SSL settings plus the Let's Encrypt certificate (`CN=new.kejizero.xyz`, four-cert chain, valid to 2027-01-11) left exactly as configured — an update replaces the panel, not the TLS setup. Afterwards the binary reports `1.0.1`, `fail2ban` and `easyxray` are both active and enabled, a real login (the SPA's `X-CSRF-Token` flow) returns `{"success":true}`, and an authenticated `/easyxray/api/v1/server/status` answers 200 with the `xray-linux-amd64` child running. No test can reach a shell updater either, so running it is the demonstration |

### The 5 Go test failures

Four in `internal/amneziawgnet`, one in `internal/tuic`. All fail with
socket/network errors of the form:

```
bind: An attempt was made to access a socket in a way forbidden by its access permissions
Cannot find device "eth9"
```

These are **not** caused by the rebrand. They were reproduced on an untouched
checkout of upstream commit `74c3cc38` (in a scratch git worktree, under the
original module path `github.com/mhsanaei/3x-ui/v3`) with an identical 5
failures. They are a Windows networking-privilege limitation of this
development machine.

---

## 9. Outstanding items

1. **The rebrand is on `main`** and has been released. Merged 2026-10-13
   (rebase-and-merge, PR #1), §3.8 fixed the same day; `main` is `a4855bb7` and
   nothing was force-pushed. Three releases now exist: `dev-latest` (rolling
   pre-release, rebuilt on every push to `main`, carries the `commit=<sha>`
   marker the panel's Dev update channel reads), `v1.0.0`, and `v1.0.1` (§3.10's
   fixes, shipped by PR #4 — stable, 16 assets, and the current target of
   `/releases/latest`, so `install.sh`, `update.sh` and the panel's update check
   resolve to it). The first `main` push's release run was cancelled
   at the `Publish rolling dev release` step; it had already force-pushed
   `dev-latest`, which was deleted and re-created by the completed run.
2. **GitHub Pages is enabled** (`build_type: workflow`), publishing from
   `.github/workflows/docs-deploy.yml` to
   <https://easyxrayteam.github.io/EasyXray/>.
3. **Non-English API reference TOC anchors** drift on two operations — see
   §3.5.
4. **Dev-only:** `readPanelVersion()` in `frontend/vite.config.js` reads
   `../config/version`, a path that does not exist (the real file is
   `internal/config/version`). Pre-existing upstream behaviour, unrelated to the
   rebrand; noted because it was found while auditing. It only affects the
   version string injected by `npm run dev`.
5. **The `v1.0.0` release carries §3.10's node-gate defect**, so sub-node
   protocol assignment needs `v1.0.1` or newer. Worth remembering about that
   framework: the `install.sh` floor lived in `install.sh` itself, and the
   documented install command fetches that script from `main` rather than from
   the release — so a bad floor there breaks every release at once, and only a
   fix on `main` clears it. `v1.0.1` is now the release `/releases/latest`
   resolves to, so this is fixed for anyone installing or updating from here on;
   a host still on `v1.0.0` needs `update.sh` (or `easyxray update`) before it can
   be given a sidecar-protocol inbound as a node. The `v1.0.0` release stays up
   as published rather than being edited or withdrawn — it is a truthful record
   of what shipped that day.
6. **The IP-limit fail2ban names are still upstream's** (§3.11). Renaming
   `3x-ipl` touches `setup_fail2ban` in `install.sh` and `easyxray.sh`,
   `DockerEntrypoint.sh`, and the CLI's `fail2ban-client status` query, and needs
   a migration that rewrites an already-installed host's `jail.d`, `filter.d` and
   `action.d` files and reloads fail2ban. That is a deliberate, user-visible
   change on deployed panels, so it was left for a decision instead of being
   bundled with the rail fix.
