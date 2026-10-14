[English](/README.md) | [فارسی](/README.fa_IR.md) | [العربية](/README.ar_EG.md) | [中文](/README.zh_CN.md) | [Español](/README.es_ES.md) | [Русский](/README.ru_RU.md) | [Türkçe](/README.tr_TR.md)

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./media/easyxray-dark.png">
    <img alt="EasyXray" src="./media/easyxray-light.png">
  </picture>
</p>

<p align="center">
  <a href="https://github.com/EasyXrayTeam/EasyXray/actions"><img src="https://img.shields.io/github/actions/workflow/status/easyxrayteam/easyxray/release.yml.svg" alt="Build"></a>
  <a href="#"><img src="https://img.shields.io/github/go-mod/go-version/easyxrayteam/easyxray.svg" alt="Go Version"></a>
  <a href="https://www.gnu.org/licenses/gpl-3.0.en.html"><img src="https://img.shields.io/badge/license-GPL%20V3-blue.svg?longCache=true" alt="License"></a>
  <a href="https://easyxrayteam.github.io/EasyXray/"><img src="https://img.shields.io/badge/docs-easyxrayteam.github.io%2FEasyXray-22d3ee" alt="Documentation"></a>
</p>

**EasyXray** is an open-source web control panel for running and managing [Xray-core](https://github.com/XTLS/Xray-core) servers. It gives you a clean, multi-language interface for deploying, configuring and monitoring a wide range of proxy and VPN protocols — whether you are running a single VPS or a fleet of nodes.

The panel's interface and feature foundation come from the original X-UI project and its successors. EasyXray carries that work forward under its own name: its own binary, service, install paths, environment-variable prefix and HTTP API namespace. For the full legal and lineage picture, read [Attribution and license](#attribution-and-license).

> [!IMPORTANT]
> This project is intended for personal use only. Please do not use it for illegal purposes or in a production environment.

## Features

- **Multi-protocol inbounds** — VLESS, VMess, Trojan, Shadowsocks, WireGuard, AmneziaWG, TUIC v5, Hysteria2, MASQUE, MTProto, HTTP, SOCKS (Mixed), Dokodemo-door / Tunnel, and TUN.
- **Modern transports & security** — TCP (Raw), mKCP, WebSocket, gRPC, HTTPUpgrade, and XHTTP, secured with TLS, XTLS, and REALITY.
- **AmneziaWG built in** — DPI-resistant WireGuard runs inside the panel on a userspace network stack, with no kernel module, DKMS, or extra packages to install.
- **Native TUIC v5 server** — In-process Go QUIC server with Xray routing and per-client traffic accounting; BBR and New Reno are available server-side. CUBIC is preserved in the client profile but currently falls back to New Reno on the server.
- **MTProto proxies** — per-client FakeTLS secrets, ad-tags, and quotas, applied live without dropping existing connections.
- **Fallbacks** — serve multiple protocols on a single port (e.g. VLESS and Trojan on 443) using Xray's fallback support.
- **Per-client management** — traffic quotas, expiry dates, IP limits with trusted-address exemptions, HWID device limits, scheduled renewal cycles, live online status, and one-click share links, QR codes, and subscriptions.
- **Traffic statistics** — per inbound, per client, and per outbound, with reset controls.
- **Multi-node support** — manage and scale across multiple servers from a single panel, including cloning inbounds onto other nodes.
- **Outbound & routing** — WARP, NordVPN, PIA, custom routing rules, load balancers with balancer-to-balancer fallback, and outbound proxy chaining. Bundled geosite and geoip categories are browsable straight from the rule editor.
- **Built-in subscription server** — raw, JSON, and Clash output, auto-selected from the client's User-Agent, plus [custom page templates](docs/custom-subscription-templates.md).
- **Telegram and Discord bots** for remote monitoring and management.
- **RESTful API** with scoped, optionally expiring tokens and an in-panel API reference.
- **Installable panel (PWA)** — pin EasyXray to a desktop or phone home screen.
- **Flexible storage** — SQLite (default) or PostgreSQL.
- **13 UI languages** with dark and light themes.
- **Fail2ban integration** for enforcing per-client IP limits.

## Screenshots

The screenshots below show the current EasyXray interface. The panel's layout and design are inherited from upstream — nothing here is a redesign for this release.

<details>
<summary>Click to expand</summary>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/01-overview-dark.png">
  <img alt="Overview" src="./media/01-overview-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/02-add-inbound-dark.png">
  <img alt="Inbounds" src="./media/02-add-inbound-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/03-add-client-dark.png">
  <img alt="Add client" src="./media/03-add-client-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/05-add-nodes-dark.png">
  <img alt="Nodes" src="./media/05-add-nodes-light.png">
</picture>

</details>

## Quick Start

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh)
```

To install a specific version, append its tag (e.g. `v1.0.3`):

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) v1.0.3
```

To install the rolling **dev** build (the latest per-commit pre-release from `main`, not a stable release), pass `dev-latest`:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) dev-latest
```

During installation a random username, password, and access path are generated. Once it finishes, run `easyxray` to open the management menu, where you can start and stop the service, view or reset your login credentials, manage SSL certificates, and more.

Every release asset is published with a `.sha256` sum next to it. Both `install.sh` and the updater verify the archive against that sum and abort on a mismatch.

For the full documentation — installation, configuration, day-to-day operations, and the complete API reference — see **[easyxrayteam.github.io/EasyXray](https://easyxrayteam.github.io/EasyXray/)**.

### Unattended install

The installer also runs **non-interactively** for cloud-init.
Set `EASYXRAY_NONINTERACTIVE=1` (or pipe with no TTY) and it installs end-to-end with
zero prompts, generating random credentials and writing them to
`/etc/easyxray/install-result.env`. See [`deploy/`](deploy/) for:

- [Cloud-init user-data](deploy/cloud-init/) — unattended install on any cloud (Hetzner/AWS/DO/Vultr/GCP/Azure/Oracle)
- [Hetzner Cloud notes](deploy/marketplace/hetzner/) — cloud-init deployment on Hetzner

## Install layout

Everything EasyXray ships is named after the project, so it never collides with another panel on the same host.

| Item | Value |
| --- | --- |
| Binary | `easyxray` |
| Management menu | `easyxray` (installed to `/usr/bin/easyxray`, from `easyxray.sh`) |
| Install directory | `/usr/local/easyxray` |
| Config and database directory | `/etc/easyxray` |
| SQLite database | `/etc/easyxray/EasyXray.db` |
| Log directory / file | `/var/log/easyxray` , `easyxray.log` |
| Environment variables | `EASYXRAY_*` |
| systemd unit | `easyxray.service` (variants: `easyxray.service.debian`, `.arch`, `.rhel`) |
| OpenRC service | `easyxray` (from `easyxray.rc`) |
| Go module | `github.com/EasyXrayTeam/EasyXray/v3` |
| Panel version | `1.0.0` |

## Panel UI and HTTP API

With the web base path configured to `/` (its default), the panel is served from:

| Surface | Path |
| --- | --- |
| Panel UI | `/easyxray/…` |
| REST API | `/easyxray/api/v1/…` — for example `/easyxray/api/v1/inbounds/list` |
| WebSocket | `/easyxray/ws` |
| OpenAPI spec | `/easyxray/api/v1/openapi.json` |

All of these sit *under* whatever web base path you configure, so a panel with a base path of `/mypanel` serves its UI at `/mypanel/easyxray/…` and its API at `/mypanel/easyxray/api/v1/…`.

> [!WARNING]
> This release renames the whole API namespace. The old `/panel/api/…` paths are **not** kept as backward-compatible aliases — requests to them will not be answered. Any external integration written against the 3x-ui-era API has to be updated to the `/easyxray/api/v1/…` paths before it will work again.

## Upgrading from 3x-ui

EasyXray is a **fresh installation**. It does not detect, adopt, or migrate an existing 3x-ui installation, and nothing is converted automatically — the service name, install directory, config and database directory, environment-variable prefix, database filename, and API namespace are all different, and no migration path between the two is provided.

If you are moving from 3x-ui, keep the old panel running, export what you need from it (inbound and client lists, share links, Xray configuration, certificates), then install EasyXray and recreate that configuration in the new panel. Back up the old database before you remove or replace anything.

## Supported Platforms

**Operating systems:** Ubuntu, Debian, Armbian, Fedora, CentOS, RHEL, AlmaLinux, Rocky Linux, Oracle Linux, Amazon Linux, Virtuozzo, Arch, Manjaro, Parch, openSUSE (Tumbleweed / Leap), Alpine, and Windows.

**Architectures:** `amd64` · `386` · `arm64` (aarch64) · `armv7` · `armv6` · `armv5` · `s390x`.

## Database Options

EasyXray supports two backends, chosen during the install:

- **SQLite** (default) — a single file at `/etc/easyxray/EasyXray.db`. Zero setup, ideal for small and medium deployments.
- **PostgreSQL** — recommended for high client counts or multi-node setups. The installer can install PostgreSQL locally for you, or accept a DSN to an existing server.

At runtime the backend is selected via environment variables (the installer writes these to `/etc/default/easyxray` for you):

```
EASYXRAY_DB_TYPE=postgres
EASYXRAY_DB_DSN=postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable
```

### Migrating an existing SQLite install to PostgreSQL

```bash
easyxray migrate-db --dsn "postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable"
# then set EASYXRAY_DB_TYPE and EASYXRAY_DB_DSN in /etc/default/easyxray and restart:
systemctl restart easyxray
```

The source SQLite file is left untouched; remove it manually once you have verified the new backend.

### Docker

The default `docker compose up -d` keeps using SQLite. To run with the bundled PostgreSQL service, uncomment the two `EASYXRAY_DB_*` env lines in `docker-compose.yml` and start with the profile:

```bash
docker compose --profile postgres up -d
```

The image bundles Fail2ban (enabled by default) to enforce per-client **IP limits**. Fail2ban bans offenders with `iptables`, which requires the `NET_ADMIN` capability. `docker-compose.yml` already grants it via `cap_add`; if you start the container with `docker run` instead, add the capabilities yourself, otherwise bans are logged but never applied:

```bash
docker run -d --cap-add=NET_ADMIN --cap-add=NET_RAW ... ghcr.io/easyxrayteam/easyxray
```

## Environment Variables

| Variable | Description | Default |
| --- | --- | --- |
| `EASYXRAY_DB_TYPE` | Database backend: `sqlite` or `postgres` | `sqlite` |
| `EASYXRAY_DB_DSN` | PostgreSQL connection string (when `EASYXRAY_DB_TYPE=postgres`) | — |
| `EASYXRAY_DB_FOLDER` | Directory for the SQLite database file | `/etc/easyxray` |
| `EASYXRAY_DB_MAX_OPEN_CONNS` | Maximum open connections (PostgreSQL pool) | — |
| `EASYXRAY_DB_MAX_IDLE_CONNS` | Maximum idle connections (PostgreSQL pool) | — |
| `EASYXRAY_PORT` | Override the panel port (1–65535); takes precedence over the stored setting | — |
| `EASYXRAY_INIT_WEB_BASE_PATH` | The initial URI path for the web panel | `/` |
| `EASYXRAY_ENABLE_FAIL2BAN` | Enable Fail2ban-based IP-limit enforcement | `true` |
| `EASYXRAY_SKIP_HSTS` | Skip the HSTS header — set when TLS is terminated by a reverse proxy | `false` |
| `EASYXRAY_LOG_LEVEL` | Log verbosity (`debug`, `info`, `warning`, `error`) | `info` |
| `EASYXRAY_LOG_FOLDER` | Log output directory | `/var/log/easyxray` |
| `EASYXRAY_DEBUG` | Enable debug mode | `false` |
| `EASYXRAY_TUNNEL_HEALTH_MONITOR` | Enable the tunnel health monitor (probes a URL and restarts Xray after repeated failures; a restart drops all clients) | `false` |
| `EASYXRAY_TUNNEL_HEALTH_PROXY` | Proxy the probe is sent through; point it at a local Xray inbound so the probe tests the tunnel (e.g. `socks5://127.0.0.1:1080`). Empty means the probe only checks host connectivity | — |
| `EASYXRAY_TUNNEL_HEALTH_URL` | URL probed for tunnel health | `https://www.cloudflare.com/cdn-cgi/trace` |
| `EASYXRAY_TUNNEL_HEALTH_INTERVAL` | Interval between probes | `30s` |
| `EASYXRAY_TUNNEL_HEALTH_TIMEOUT` | Per-probe timeout | `10s` |
| `EASYXRAY_TUNNEL_HEALTH_FAILURES` | Consecutive failures before a restart is triggered | `3` |
| `EASYXRAY_TUNNEL_HEALTH_COOLDOWN` | Minimum delay between consecutive restarts | `5m` |
| `NODE_TOKEN_ENCRYPTION` | Encryption at rest for node API tokens: `off`, `migration`, or `required` (note: no `EASYXRAY_` prefix) | `off` |
| `EASYXRAY_NODE_TOKEN_KEY_FILE` | JSON keyring (mode `0600`) holding the active key id and its base64 32-byte keys | `/etc/easyxray/node_token_key.json` |
| `EASYXRAY_NODE_TOKEN_KEY` | A single base64 32-byte key, used only when the key file cannot be loaded | — |

The complete list lives in the environment-variables reference on the [documentation site](https://easyxrayteam.github.io/EasyXray/).

## Supported Languages

The panel UI is available in 13 languages:

English · فارسی · العربية · 中文（简体） · 中文（繁體） · Español · Русский · Українська · Türkçe · Tiếng Việt · 日本語 · Bahasa Indonesia · Português (Brasil)

## Contributing

Contributions are welcome. Please read the [Contributing Guide](/CONTRIBUTING.md) before opening an issue or pull request.

## Attribution and license

EasyXray is a **modified derivative** of [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui). This codebase is based on upstream commit `74c3cc38` (the 3.10.0 line), and it is developed and distributed under the name EasyXray by the EasyXrayTeam.

What EasyXray changed relative to that upstream basis: the project was rebranded throughout. The product name, the binary and its systemd/OpenRC service, the install, config, database and log paths, the environment-variable prefix (now `EASYXRAY_*`), the management script, the panel UI and REST API namespaces, the Go module path, and the packaged Docker image all carry the EasyXray name. Apart from that rebranding, the panel's behaviour — its feature set, the protocols it serves, and the way it drives Xray-core — is inherited from upstream. See [Install layout](#install-layout) and [Panel UI and HTTP API](#panel-ui-and-http-api) for the concrete names and paths.

EasyXray is licensed under the **GNU General Public License v3.0** (GPL-3.0). The full license text is in [`LICENSE`](LICENSE). Third-party components bundled with or depended on by this project are recorded in `NOTICE` and `THIRD_PARTY_NOTICES.md`.

The corresponding source for the binaries distributed here is this repository, [EasyXrayTeam/EasyXray](https://github.com/EasyXrayTeam/EasyXray).

This project is **not endorsed by, sponsored by, or affiliated with** the upstream author of 3x-ui in any way. It is an independent derivative work published under the terms of the GNU GPL.

## Acknowledgements

The EasyXray panel's interface and feature foundation come from the original **X-UI** project through its successors, and a special thanks goes to [alireza0](https://github.com/alireza0/) for that original work.

Additional projects this panel builds on or ships alongside:

- [Iran v2ray rules](https://github.com/chocolate4u/Iran-v2ray-rules) (License: **GPL-3.0**): _Enhanced v2ray/xray and v2ray/xray-clients routing rules with built-in Iranian domains and a focus on security and adblocking._
- [Russia v2ray rules](https://github.com/runetfreedom/russia-v2ray-rules-dat) (License: **GPL-3.0**): _This repository contains automatically updated V2Ray routing rules based on data on blocked domains and addresses in Russia._

## Community Tools

Tools and integrations built by the wider community around this panel's upstream. Note that these target the upstream API namespace, so they may need updating before they work against EasyXray's renamed `/easyxray/api/v1/…` endpoints.

- [terraform-provider-3x-ui](https://github.com/batonogov/terraform-provider-threexui) (License: **MIT**): _Manage inbounds, clients, panel settings, and Xray configuration as code with Terraform / OpenTofu._
- [3X-UI Manager](https://github.com/yukh975/3X-UI-Manager) (License: **MIT**): _Native Android client for 3x-ui — dashboard, inbounds, clients with QR sharing, nodes and multi-panel management. Available on F-Droid._

## Star History

<a href="https://www.star-history.com/?repos=EasyXrayTeam%2FEasyXray&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
 </picture>
</a>
