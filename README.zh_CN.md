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

**EasyXray** 是一个开源 Web 控制面板，用于运行和管理 [Xray-core](https://github.com/XTLS/Xray-core) 服务器。它提供简洁、多语言的界面，帮助你部署、配置并监控各种代理和 VPN 协议——无论你只有一台 VPS，还是拥有一整片节点集群。

面板的界面与功能基础来自最初的 X-UI 项目及其后续版本。EasyXray 在此基础上继续演进，并使用自己的名称：独立的可执行文件、系统服务、安装路径、环境变量前缀以及 HTTP API 命名空间。完整的授权与来源说明请见[归属与许可证](#归属与许可证)。

> [!IMPORTANT]
> 本项目仅供个人使用。请勿用于非法用途，也不要在生产环境中使用。

## 功能特性

- **多协议入站** — VLESS、VMess、Trojan、Shadowsocks、WireGuard、AmneziaWG、TUIC v5、Hysteria2、MASQUE、MTProto、HTTP、SOCKS（Mixed）、Dokodemo-door / Tunnel 以及 TUN。
- **现代传输与安全** — TCP (Raw)、mKCP、WebSocket、gRPC、HTTPUpgrade 和 XHTTP，可搭配 TLS、XTLS 与 REALITY。
- **内置 AmneziaWG** — 抗 DPI 的 WireGuard 直接运行在面板进程内的用户态网络栈上，无需内核模块、DKMS 或额外软件包。
- **原生 TUIC v5 服务端** — 进程内的 Go QUIC 服务端，复用 Xray 路由并按客户端统计流量；服务端可选 BBR 与 New Reno。CUBIC 会保存在客户端配置中，但服务端目前仍回退到 New Reno。
- **MTProto 代理** — 每个客户端独立配置 FakeTLS 密钥、ad-tag 与流量配额，并且可以热更新，不会中断已有连接。
- **Fallback 回落** — 借助 Xray 的 fallback 支持，在同一个端口上同时提供多种协议（例如在 443 上同时提供 VLESS 与 Trojan）。
- **按客户端管理** — 流量配额、到期时间、IP 限制（可设置受信任地址豁免）、HWID 设备限制、定时续期周期、实时在线状态，以及一键分享链接、二维码和订阅。
- **流量统计** — 按入站、按客户端、按出站分别统计，并支持重置。
- **多节点支持** — 在单一面板中管理和扩展多台服务器，包括把入站配置克隆到其他节点。
- **出站与路由** — 支持 WARP、NordVPN、PIA、自定义路由规则、带负载均衡器之间回退的负载均衡，以及出站代理链。内置的 geosite 与 geoip 分类可直接在规则编辑器中浏览。
- **内置订阅服务器** — 支持 raw、JSON 和 Clash 输出，并根据客户端 User-Agent 自动选择格式，另支持[自定义页面模板](docs/custom-subscription-templates.md)。
- **Telegram 与 Discord 机器人**，用于远程监控和管理。
- **RESTful API** — 支持限定作用域、可设置有效期的令牌，面板内还提供 API 参考文档。
- **可安装面板（PWA）** — 把 EasyXray 固定到桌面或手机主屏幕。
- **灵活的存储后端** — SQLite（默认）或 PostgreSQL。
- **13 种界面语言**，并提供深色与浅色主题。
- **Fail2ban 集成**，用于落实按客户端的 IP 限制。

## 界面截图

以下截图展示了当前的 EasyXray 界面。面板的布局与视觉设计继承自上游，本次发布并未重新设计。

<details>
<summary>点击展开</summary>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/01-overview-dark.png">
  <img alt="概览" src="./media/01-overview-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/02-add-inbound-dark.png">
  <img alt="入站" src="./media/02-add-inbound-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/03-add-client-dark.png">
  <img alt="添加客户端" src="./media/03-add-client-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/05-add-nodes-dark.png">
  <img alt="节点" src="./media/05-add-nodes-light.png">
</picture>

</details>

## 快速开始

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh)
```

如需安装指定版本，在命令后附上对应的标签（例如 `v1.0.0`）：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) v1.0.0
```

如需安装滚动更新的 **dev** 版本（`main` 分支上每次提交产出的预发布包，并非稳定版），传入 `dev-latest`：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) dev-latest
```

安装过程会随机生成用户名、密码和访问路径。安装完成后，运行 `easyxray` 打开管理菜单，可在其中启动或停止服务、查看或重置登录凭据、管理 SSL 证书等。

每个发布包旁都会附带一个 `.sha256` 校验文件，`install.sh` 与更新程序都会校验压缩包，一旦不匹配立即中止。

完整文档——安装、配置、日常运维以及完整的 API 参考——请访问 **[easyxrayteam.github.io/EasyXray](https://easyxrayteam.github.io/EasyXray/)**。

### 无人值守安装

安装脚本也支持以**非交互**方式运行，适用于 cloud-init。
设置 `EASYXRAY_NONINTERACTIVE=1`（或在不带 TTY 的管道中执行），它就会全程零提示地完成安装，
随机生成凭据并写入 `/etc/easyxray/install-result.env`。相关示例见 [`deploy/`](deploy/)：

- [Cloud-init user-data](deploy/cloud-init/) — 在任意云平台（Hetzner/AWS/DO/Vultr/GCP/Azure/Oracle）上无人值守安装
- [Hetzner Cloud 说明](deploy/marketplace/hetzner/) — 在 Hetzner 上通过 cloud-init 部署

## 安装目录与服务名称

EasyXray 的所有组件都以项目名命名，因此不会与同一台主机上的其他面板发生冲突。

| 项目 | 取值 |
| --- | --- |
| 可执行文件 | `easyxray` |
| 管理菜单 | `easyxray`（由 `easyxray.sh` 安装到 `/usr/bin/easyxray`） |
| 安装目录 | `/usr/local/easyxray` |
| 配置与数据库目录 | `/etc/easyxray` |
| SQLite 数据库 | `/etc/easyxray/EasyXray.db` |
| 日志目录 / 文件 | `/var/log/easyxray` ，`easyxray.log` |
| 环境变量前缀 | `EASYXRAY_*` |
| systemd 服务单元 | `easyxray.service`（变体：`easyxray.service.debian`、`.arch`、`.rhel`） |
| OpenRC 服务 | `easyxray`（来自 `easyxray.rc`） |
| Go 模块 | `github.com/EasyXrayTeam/EasyXray/v3` |
| 面板版本 | `1.0.0` |

## 面板界面与 HTTP API

当 Web 基础路径为默认值 `/` 时，面板的访问地址如下：

| 接口 | 路径 |
| --- | --- |
| 面板界面 | `/easyxray/…` |
| REST API | `/easyxray/api/v1/…`，例如 `/easyxray/api/v1/inbounds/list` |
| WebSocket | `/easyxray/ws` |
| OpenAPI 规范 | `/easyxray/api/v1/openapi.json` |

这些路径都位于你配置的 Web 基础路径**之下**。所以当基础路径为 `/mypanel` 时，界面地址是 `/mypanel/easyxray/…`，API 地址是 `/mypanel/easyxray/api/v1/…`。

> [!WARNING]
> 本次发布重命名了整个 API 命名空间。旧的 `/easyxray/api/v1/…` 路径**不会**作为兼容别名保留——请求这些路径将得不到任何响应。任何按 3x-ui 时代 API 编写的外部集成，都必须改为使用 `/easyxray/api/v1/…` 才能继续工作。

## 从 3x-ui 升级

EasyXray 是一套**全新安装**。它不会检测、接管或迁移已有的 3x-ui 安装，也不会自动转换任何数据——两者的服务名称、安装目录、配置与数据库目录、环境变量前缀、数据库文件名以及 API 命名空间都不同，两者之间也不提供迁移通道。

如果你要从 3x-ui 迁移，请先保留旧面板并从中导出所需内容（入站与客户端列表、分享链接、Xray 配置、证书），然后安装 EasyXray，在新面板中重新创建这些配置。在删除或替换任何文件之前，请先备份旧数据库。

## 支持的平台

**操作系统：** Ubuntu、Debian、Armbian、Fedora、CentOS、RHEL、AlmaLinux、Rocky Linux、Oracle Linux、Amazon Linux、Virtuozzo、Arch、Manjaro、Parch、openSUSE（Tumbleweed / Leap）、Alpine 以及 Windows。

**架构：** `amd64` · `386` · `arm64` (aarch64) · `armv7` · `armv6` · `armv5` · `s390x`。

## 数据库选项

EasyXray 支持两种后端，在安装时选择：

- **SQLite**（默认）—— 单个文件 `/etc/easyxray/EasyXray.db`，无需额外配置，适合中小规模部署。
- **PostgreSQL** —— 客户端数量较多或多节点部署时推荐使用。安装脚本可以为你本机安装 PostgreSQL，也可以接收指向现有服务器的 DSN。

运行时的后端由环境变量决定（安装脚本会写入 `/etc/default/easyxray`）：

```
EASYXRAY_DB_TYPE=postgres
EASYXRAY_DB_DSN=postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable
```

### 将现有 SQLite 迁移到 PostgreSQL

```bash
easyxray migrate-db --dsn "postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable"
# 然后在 /etc/default/easyxray 中设置 EASYXRAY_DB_TYPE 与 EASYXRAY_DB_DSN 并重启：
systemctl restart easyxray
```

源 SQLite 文件不会被改动；确认新后端工作正常后再手动删除它。

### Docker

默认的 `docker compose up -d` 仍然使用 SQLite。若要使用随附的 PostgreSQL 服务，请取消 `docker-compose.yml` 中两行 `EASYXRAY_DB_*` 环境的注释，并带 profile 启动：

```bash
docker compose --profile postgres up -d
```

镜像内置 Fail2ban（默认启用）用于落实按客户端的 **IP 限制**。Fail2ban 通过 `iptables` 封禁违规者，因此需要 `NET_ADMIN` 权限。`docker-compose.yml` 已通过 `cap_add` 授予该权限；如果你改用 `docker run` 启动容器，请自行添加相应权限，否则封禁只会被记录而不会真正生效：

```bash
docker run -d --cap-add=NET_ADMIN --cap-add=NET_RAW ... ghcr.io/easyxrayteam/easyxray
```

## 环境变量

| 变量 | 说明 | 默认值 |
| --- | --- | --- |
| `EASYXRAY_DB_TYPE` | 数据库后端：`sqlite` 或 `postgres` | `sqlite` |
| `EASYXRAY_DB_DSN` | PostgreSQL 连接串（当 `EASYXRAY_DB_TYPE=postgres` 时使用） | — |
| `EASYXRAY_DB_FOLDER` | SQLite 数据库文件所在目录 | `/etc/easyxray` |
| `EASYXRAY_DB_MAX_OPEN_CONNS` | 最大打开连接数（PostgreSQL 连接池） | — |
| `EASYXRAY_DB_MAX_IDLE_CONNS` | 最大空闲连接数（PostgreSQL 连接池） | — |
| `EASYXRAY_PORT` | 覆盖面板端口（1–65535），优先级高于面板内保存的设置 | — |
| `EASYXRAY_INIT_WEB_BASE_PATH` | Web 面板的初始 URI 路径 | `/` |
| `EASYXRAY_ENABLE_FAIL2BAN` | 启用基于 Fail2ban 的 IP 限制 | `true` |
| `EASYXRAY_SKIP_HSTS` | 跳过 HSTS 响应头——当 TLS 由反向代理终止时设置 | `false` |
| `EASYXRAY_LOG_LEVEL` | 日志级别（`debug`、`info`、`warning`、`error`） | `info` |
| `EASYXRAY_LOG_FOLDER` | 日志输出目录 | `/var/log/easyxray` |
| `EASYXRAY_DEBUG` | 启用调试模式 | `false` |
| `EASYXRAY_TUNNEL_HEALTH_MONITOR` | 启用隧道健康监控（探测指定 URL，连续失败后重启 Xray；重启会断开所有客户端） | `false` |
| `EASYXRAY_TUNNEL_HEALTH_PROXY` | 探测请求所使用的代理；指向本机 Xray 入站即可真正测试隧道（例如 `socks5://127.0.0.1:1080`）。留空则只检测主机连通性 | — |
| `EASYXRAY_TUNNEL_HEALTH_URL` | 用于隧道健康检查的探测 URL | `https://www.cloudflare.com/cdn-cgi/trace` |
| `EASYXRAY_TUNNEL_HEALTH_INTERVAL` | 探测间隔 | `30s` |
| `EASYXRAY_TUNNEL_HEALTH_TIMEOUT` | 单次探测超时 | `10s` |
| `EASYXRAY_TUNNEL_HEALTH_FAILURES` | 触发重启所需的连续失败次数 | `3` |
| `EASYXRAY_TUNNEL_HEALTH_COOLDOWN` | 两次重启之间的最短间隔 | `5m` |
| `NODE_TOKEN_ENCRYPTION` | 节点 API 令牌的静态加密：`off`、`migration` 或 `required`（注意：该变量没有 `EASYXRAY_` 前缀） | `off` |
| `EASYXRAY_NODE_TOKEN_KEY_FILE` | JSON 密钥环（权限 `0600`），保存当前密钥 ID 及其 base64 编码的 32 字节密钥 | `/etc/easyxray/node_token_key.json` |
| `EASYXRAY_NODE_TOKEN_KEY` | 单个 base64 编码的 32 字节密钥，仅在密钥文件无法加载时使用 | — |

完整列表请见[文档站点](https://easyxrayteam.github.io/EasyXray/)的环境变量参考。

## 支持的语言

面板界面共提供 13 种语言：

English · فارسی · العربية · 中文（简体） · 中文（繁體） · Español · Русский · Українська · Türkçe · Tiếng Việt · 日本語 · Bahasa Indonesia · Português (Brasil)

## 贡献

欢迎参与贡献。在提交 issue 或 pull request 之前，请先阅读[贡献指南](/CONTRIBUTING.md)。

## 归属与许可证

EasyXray 是 [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui) 的**修改衍生版本**。本代码库基于上游提交 `74c3cc38`（3.10.0 系列），由 EasyXrayTeam 以 EasyXray 之名继续开发和分发。

EasyXray 相对该上游基础所做的改动是：项目整体更名。产品名称、可执行文件及其 systemd/OpenRC 服务、安装、配置、数据库与日志路径、环境变量前缀（现为 `EASYXRAY_*`）、管理脚本、面板界面与 REST API 命名空间、Go 模块路径以及打包的 Docker 镜像，全部改用 EasyXray 名称。除此之外，面板的行为——功能集合、所服务的协议以及驱动 Xray-core 的方式——均继承自上游。具体名称与路径见[安装目录与服务名称](#安装目录与服务名称)和[面板界面与 HTTP API](#面板界面与-http-api)。

EasyXray 采用 **GNU 通用公共许可证第 3 版**（GPL-3.0）授权，完整许可证文本见 [`LICENSE`](LICENSE)。本项目捆绑或依赖的第三方组件记录在 `NOTICE` 与 `THIRD_PARTY_NOTICES.md` 中。

与本项目所分发二进制相对应的源代码即本仓库：[EasyXrayTeam/EasyXray](https://github.com/EasyXrayTeam/EasyXray)。

本项目**未获得** 3x-ui 上游作者的任何认可、赞助或关联，是一份依据 GNU GPL 条款独立发布的衍生作品。

## 致谢

EasyXray 面板的界面与功能基础来自最初的 **X-UI** 项目及其后续版本，特别感谢 [alireza0](https://github.com/alireza0/) 为此所做的基础性工作。

此外，本项目还构建于或随附以下项目：

- [Iran v2ray rules](https://github.com/chocolate4u/Iran-v2ray-rules)（许可证：**GPL-3.0**）：_增强版 v2ray/xray 与 v2ray/xray-clients 路由规则，内置伊朗域名，并专注于安全与广告拦截。_
- [Russia v2ray rules](https://github.com/runetfreedom/russia-v2ray-rules-dat)（许可证：**GPL-3.0**）：_该仓库包含基于俄罗斯境内被封锁域名与地址数据自动更新的 V2Ray 路由规则。_

## 社区工具

由更广泛的社区围绕本面板的上游项目构建的工具与集成。请注意，它们面向的是上游的 API 命名空间，因此在 EasyXray 上使用前，可能需要改为调用重命名后的 `/easyxray/api/v1/…` 接口。

- [terraform-provider-3x-ui](https://github.com/batonogov/terraform-provider-threexui)（许可证：**MIT**）：_使用 Terraform / OpenTofu 以代码方式管理入站、客户端、面板设置与 Xray 配置。_
- [3X-UI Manager](https://github.com/yukh975/3X-UI-Manager)（许可证：**MIT**）：_3x-ui 的原生 Android 客户端——仪表板、入站、带二维码分享的客户端、节点以及多面板管理，可在 F-Droid 获取。_

## Star 历史

<a href="https://www.star-history.com/?repos=EasyXrayTeam%2FEasyXray&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
 </picture>
</a>
