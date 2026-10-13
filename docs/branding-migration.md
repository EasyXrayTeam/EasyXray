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

| | |
|---|---|
| Upstream project | [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui) |
| Base commit | `74c3cc38821cabd66ad316ea562851422d0b0063` — *"fix(database): blank boolean-era verifyPeerCertByName values on hosts"* (2026-10-12, upstream `3.10.0` line) |
| This repository | [EasyXrayTeam/EasyXray](https://github.com/EasyXrayTeam/EasyXray) |
| License | GNU GPL-3.0 — unchanged, see [`LICENSE`](../LICENSE) |
| Relationship | **Modified derivative work.** Not endorsed by, sponsored by, or affiliated with the upstream author. See [`NOTICE`](../NOTICE). |

Git history was **not** rewritten. The full upstream commit history is intact;
the rebrand is a single commit on top of it, on the branch `branding/easyxray`.

---

## 2. The new identity

| Surface | Old | New |
|---|---|---|
| Product name | `3x-ui` / `X-UI` | `EasyXray` |
| Binary | `x-ui` | `easyxray` |
| Go module | `github.com/mhsanaei/3x-ui/v3` | `github.com/EasyXrayTeam/EasyXray/v3` |
| Repository | `MHSanaei/3x-ui` | `EasyXrayTeam/EasyXray` |
| Version | `3.10.0` | `1.0.0` |
| systemd unit | `x-ui.service` | `easyxray.service` |
| OpenRC unit | `x-ui.rc` | `easyxray.rc` |
| Control script | `x-ui.sh` | `easyxray.sh` |
| Install directory | `/usr/local/x-ui` | `/usr/local/easyxray` |
| Config / DB directory | `/etc/x-ui` | `/etc/easyxray` |
| Database file | `x-ui.db` | `EasyXray.db` |
| Log file | `x-ui.log` | `easyxray.log` |
| Env prefix | `XUI_*` | `EASYXRAY_*` |
| Session cookie | `3x-ui` | `easyxray` |
| API namespace | `/panel/api/…` | `/easyxray/api/v1/…` |
| Panel (SPA) routes | `/panel/…` | `/easyxray/…` |
| WebSocket | `/ws` | `/easyxray/ws` |
| Service env file | `/etc/default/x-ui` | `/etc/default/easyxray` |

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

---

## 4. Deliberate non-renames

These old-brand strings remain on purpose. Each is either a legal requirement, a
third-party contract, or a generic word that was never the brand.

| Location | Why it stays |
|---|---|
| `README*.md` (all 7) — "Upgrading from 3x-ui", "modified derivative of MHSanaei/3x-ui" | GPL-3.0 requires preserving attribution and stating that this is a modified derivative. The upgrade section tells users the truth: there is no migration path. |
| `README*.md` — ecosystem links (`terraform-provider-3x-ui`, `3X-UI Manager`) | They are third-party projects that interoperate with the *upstream* panel. Renaming them would be factually wrong. |
| `NOTICE`, `THIRD_PARTY_NOTICES.md` | Legal attribution for upstream and for every third-party dependency. |
| `tools/branding/README.md` — "upstream 3x-ui icon set" | Provenance: names which icon set the new mark replaces. Attribution, not a brand reference. |
| `docs/content/docs/*/help/migration.mdx`, `help/faq.mdx`, `guide/installation.mdx` | These pages *exist* to explain that EasyXray does not adopt, detect, or migrate a `3x-ui` install. The comparison table needs the old name. |
| `docs/content/docs/*/reference/api/index.mdx` | The "no aliases" callout names `/panel/api/…` to tell integrators exactly which prefix no longer answers. |
| `internal/xray/*`, `internal/config/*` — Xray core configuration field names, protocol identifiers, share-link schemes (`vless://`, `vmess://`, `trojan://`, `ss://`), `reality`, `xhttp`, `xtls` | Third-party protocol contracts. Renaming these would break client compatibility. |
| `panelOutbound`, `panelVersion`, `panelGuid` (JSON fields, DB columns, settings keys) | Generic domain concepts — "the panel's outbound route", "the version a node's panel reports". They never contained the old brand, and they are persisted/migrated data. Renaming them would require a data migration for no benefit. |
| `frontend/src/lib/panel-version.ts`, `formatPanelVersion`, `isPanelUpdateAvailable` | Same as above: "panel" as a noun, not a brand. |
| `internal/web/service/client_update_rename_test.go` — the literal `"Sanaei"` | Test *data*, not branding: it is a client e-mail used to prove the email-rename path is case-insensitive. |
| Test hostnames like `panel.example.com` | RFC-2606-style reserved example hostnames in fixtures. |
| "panel" throughout UI copy and translations (`internal/web/translation/*.json`) | The English word for the admin panel. Verified: no `/panel/…` *path* survives in any locale file. |

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

| Path | Reason |
|---|---|
| `docs/public/CNAME` | Declared a custom documentation domain. The user chose the GitHub Pages address instead; a `CNAME` pointing at a domain we do not control would break the site. Add one back when a domain is registered. |
| `frontend/public/icons/3x-ui-{16,24,32,64,192,512}.png` | Superseded by the new EasyXray icon set. |
| All 131 git tags, local and on `origin` | Removed on the user's explicit instruction. `gh api repos/EasyXrayTeam/EasyXray/git/refs/tags` confirmed **0 releases** were attached to any of them before deletion; all 131 were then deleted through the API (`deleted=131 failed=0`, 0 remaining). |
| `.gitignore` entry `dist/` | Replaced with `**/dist/*` plus `!internal/web/dist/.gitkeep`. The bare `dist/` pattern excluded the directory itself, which made the negation ineffective and would also have excluded `docs/dist`. |

---

## 6. New files

| Path | What |
|---|---|
| `NOTICE` | Derivative-work statement, upstream base commit, GPL-3.0 terms, non-affiliation clause. |
| `THIRD_PARTY_NOTICES.md` | Licenses for all 39 direct Go modules and 45 frontend packages, read from the actual installed module/package metadata rather than guessed; MPL-2.0 notice for `xtls/xray-core` and `pgregory.net/rapid`; trademark section. |
| `tools/branding/` | Vector source of truth for the mark (`easyxray-mark.svg`, `easyxray-mark-compact.svg`, lockups), the `generate-icons.mjs` script (sharp + a hand-rolled ICO container), and its README with the measured geometry table. |
| `frontend/public/favicon.ico`, `apple-touch-icon.png`, `icons/easyxray-*.png` | Generated from the SVG sources — a trace of the supplied artwork (§3.4.1), not a redraw from description. |
| `SECURITY.md` | Rewritten for this project: GitHub private advisories first, with `2519840456@qq.com` as the monitored fallback contact. The upstream maintainer's personal address is gone. |
| `media/easyxray-{light,dark}.png` | README hero images (renamed from `media/3x-ui-*.png`). |
| `sponsors/sponsors.json`, `sponsors/logos/` | Sponsor data consumed by the panel's sponsor surface, served from this repository's `main` branch. |
| `docs/branding-migration.md` | This file. |

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
- **No data-migration code was added**, because no persisted *brand* field was
  renamed — the persisted names that contain "panel" (`panelOutbound`,
  `panelVersion`) are generic and were left alone (§4).
- GPL-3.0 obligations are met: the license is intact, upstream copyright and
  attribution are preserved, and the derivative relationship is stated in
  `NOTICE`, all 7 READMEs, and `THIRD_PARTY_NOTICES.md`.

---

## 8. Verification

Run against the working tree on branch `branding/easyxray`.

| Check | Result |
|---|---|
| `gofmt -l` over every changed `.go` file | **PASS** — clean (four files needed realignment after the renames and were formatted) |
| `go vet ./...` | **PASS** — exit 0 |
| `go test ./...` | **5 failures, all pre-existing** — see below |
| `npm run typecheck` (frontend) | **PASS** |
| `npm run lint` (frontend) | **PASS** |
| `npm run test` (frontend) | **PASS** — 189 files, 1841 tests |
| `npm run build` (frontend) | **PASS** — dist repopulated with the new icons, `favicon.ico`, `apple-touch-icon.png`, regenerated `openapi.json` |
| `pnpm run typecheck` (docs site) | **PASS** |
| `pnpm run gen:api` (docs site) | **PASS** — 13 tag pages regenerated from the new spec |
| `DEPLOY_TARGET=static pnpm run build` (docs site) | **PASS** — static export prerenders every page in all four locales; spot-checking the built HTML confirms the API pages carry the `/easyxray/api/v1/…` namespace and that `/panel/api/…` survives only on the migration and "no aliases" pages, where it belongs |
| Old-brand residue scan | Only the intentional references in §4 — **0** remaining `panel/api` hits anywhere, **0** old-brand hits in `.github/` or `install.sh` |
| `npm run generate` (branding tools) | **PASS** — 14 files regenerated from the four SVGs; the 512px icon, the 180px apple-touch-icon, the four-entry ICO and the two lockups were each rendered and inspected against the source artwork |

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

1. **The rebrand is committed but not pushed.** It is the single commit at the
   tip of the branch `branding/easyxray`, directly on top of upstream
   `74c3cc38`. Nothing has been pushed, force-pushed, or released — see §1. The
   commit hash is deliberately not written down here: naming it would need a
   re-amend to correct, and that changes the hash.
2. **GitHub Pages must be enabled manually** in the repository settings for the
   docs workflow to publish.
3. **Non-English API reference TOC anchors** drift on two operations — see
   §3.5.
4. **Dev-only:** `readPanelVersion()` in `frontend/vite.config.js` reads
   `../config/version`, a path that does not exist (the real file is
   `internal/config/version`). Pre-existing upstream behaviour, unrelated to the
   rebrand; noted because it was found while auditing. It only affects the
   version string injected by `npm run dev`.
