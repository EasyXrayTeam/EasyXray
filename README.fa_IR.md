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

**EasyXray** یک پنل کنترل وب متن‌باز برای اجرا و مدیریت سرورهای [Xray-core](https://github.com/XTLS/Xray-core) است. این پنل رابطی تمیز و چندزبانه برای استقرار، پیکربندی و پایش طیف گسترده‌ای از پروتکل‌های پراکسی و VPN در اختیار شما می‌گذارد؛ چه یک VPS تکی داشته باشید و چه ناوگانی از نودها.

ریشه‌ی رابط کاربری و توانمندی‌های این پنل به پروژه‌ی اصلی X-UI و ادامه‌دهندگان آن بازمی‌گردد. EasyXray همین مسیر را با نام خودش پیش می‌برد: فایل اجرایی، سرویس، مسیرهای نصب، پیشوند متغیرهای محیطی و فضای نام HTTP API همه اختصاصی خودش هستند. برای آگاهی از نسبت حقوقی و پیشینه‌ی پروژه، بخش [انتساب و مجوز](#انتساب-و-مجوز) را ببینید.

> [!IMPORTANT]
> این پروژه تنها برای استفاده‌ی شخصی در نظر گرفته شده است. لطفاً از آن برای مقاصد غیرقانونی یا در محیط تولید استفاده نکنید.

## ویژگی‌ها

- **ورودی‌های چندپروتکلی** — VLESS، VMess، Trojan، Shadowsocks، WireGuard، AmneziaWG، TUIC v5، Hysteria2، MASQUE، MTProto، HTTP، SOCKS (Mixed)، Dokodemo-door / Tunnel و TUN.
- **ترابری و امنیت مدرن** — TCP (Raw)، mKCP، WebSocket، gRPC، HTTPUpgrade و XHTTP، همراه با TLS، XTLS و REALITY.
- **AmneziaWG درون‌ساخت** — WireGuard مقاوم در برابر DPI، داخل خود پنل و روی پشته‌ی شبکه‌ی فضای کاربر اجرا می‌شود؛ بدون ماژول کرنل، DKMS یا بسته‌ی اضافی.
- **سرور بومی TUIC v5** — سرور QUIC نوشته‌شده با Go که درون همان فرایند اجرا می‌شود، با مسیریابی Xray و محاسبه‌ی ترافیک به‌ازای هر کلاینت؛ در سمت سرور BBR و New Reno در دسترس‌اند. الگوریتم CUBIC در پروفایل کلاینت حفظ می‌شود، اما فعلاً روی سرور به New Reno برمی‌گردد.
- **پراکسی‌های MTProto** — رمزهای FakeTLS، ad-tag و سهمیه‌ی اختصاصی هر کلاینت، که بی‌درنگ و بدون قطع اتصال‌های موجود اعمال می‌شوند.
- **Fallback** — ارائه‌ی چند پروتکل روی یک درگاه (مثلاً VLESS و Trojan روی درگاه 443) با پشتیبانی fallback در Xray.
- **مدیریت تک‌تک کلاینت‌ها** — سهمیه‌ی ترافیک، تاریخ انقضا، محدودیت IP با امکان استثنا کردن نشانی‌های مورد اعتماد، محدودیت دستگاه بر پایه‌ی HWID، دوره‌های تمدید زمان‌بندی‌شده، وضعیت آنلاین به‌صورت زنده، و لینک‌های اشتراک‌گذاری، کدهای QR و اشتراک‌ها با یک کلیک.
- **آمار ترافیک** — به‌ازای هر ورودی، هر کلاینت و هر خروجی، همراه با امکان بازنشانی.
- **پشتیبانی از چند نود** — مدیریت و گسترش چند سرور از یک پنل، از جمله کلون کردن ورودی‌ها روی نودهای دیگر.
- **خروجی‌ها و مسیریابی** — WARP، NordVPN، PIA، قواعد مسیریابی سفارشی، توزیع‌کننده‌های بار با جابه‌جایی میان توزیع‌کننده‌ها، و زنجیره‌سازی پراکسی خروجی. دسته‌های geosite و geoip همراه پنل را می‌توانید مستقیم از ویرایشگر قواعد مرور کنید.
- **سرور اشتراک درون‌ساخت** — خروجی raw، JSON و Clash که بر پایه‌ی User-Agent کلاینت به‌طور خودکار انتخاب می‌شود، به‌همراه [قالب‌های صفحه‌ی سفارشی](docs/custom-subscription-templates.md).
- **ربات‌های Telegram و Discord** برای پایش و مدیریت از راه دور.
- **RESTful API** با توکن‌های دامنه‌محدود و دارای تاریخ انقضای اختیاری، به‌همراه مرجع API درون خود پنل.
- **پنل قابل نصب (PWA)** — EasyXray را به میزکار یا صفحه‌ی اصلی گوشی خود سنجاق کنید.
- **ذخیره‌سازی انعطاف‌پذیر** — SQLite (پیش‌فرض) یا PostgreSQL.
- **۱۳ زبان رابط کاربری** با پوسته‌های تیره و روشن.
- **یکپارچگی با Fail2ban** برای اجرای محدودیت‌های IP هر کلاینت.

## اسکرین‌شات‌ها

تصاویر زیر رابط کاربری کنونی EasyXray را نشان می‌دهند. چیدمان و طراحی پنل از پروژه‌ی پیشین به ارث رسیده و در این انتشار بازطراحی نشده است.

<details>
<summary>برای باز کردن کلیک کنید</summary>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/01-overview-dark.png">
  <img alt="نمای کلی" src="./media/01-overview-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/02-add-inbound-dark.png">
  <img alt="ورودی‌ها" src="./media/02-add-inbound-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/03-add-client-dark.png">
  <img alt="افزودن کلاینت" src="./media/03-add-client-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/05-add-nodes-dark.png">
  <img alt="نودها" src="./media/05-add-nodes-light.png">
</picture>

</details>

## شروع سریع

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh)
```

برای نصب نسخه‌ی مشخص، برچسب آن را اضافه کنید (مثلاً `v1.0.3`):

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) v1.0.3
```

برای نصب ساخت **dev** جاری (آخرین پیش‌انتشار تولیدشده از هر commit روی شاخه‌ی `main`، نه یک نسخه‌ی پایدار) مقدار `dev-latest` را بدهید:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) dev-latest
```

در جریان نصب، نام کاربری، رمز عبور و مسیر دسترسی به‌صورت تصادفی ساخته می‌شوند. پس از پایان نصب، دستور `easyxray` را اجرا کنید تا منوی مدیریت باز شود؛ از آنجا می‌توانید سرویس را راه‌اندازی و متوقف کنید، اطلاعات ورود را ببینید یا بازنشانی کنید، گواهی‌های SSL را مدیریت کنید و کارهای دیگر را انجام دهید.

کنار هر بسته‌ی انتشار یک فایل `.sha256` قرار می‌گیرد. هم `install.sh` و هم برنامه‌ی به‌روزرسانی، بسته را با آن مجموع بررسی می‌کنند و در صورت عدم تطابق کار را متوقف می‌کنند.

مستندات کامل — نصب، پیکربندی، بهره‌برداری روزمره و مرجع کامل API — در **[easyxrayteam.github.io/EasyXray](https://easyxrayteam.github.io/EasyXray/)** در دسترس است.

### نصب بدون نظارت

نصب‌کننده به‌صورت **بدون تعامل** هم کار می‌کند و برای cloud-init مناسب است.
مقدار `EASYXRAY_NONINTERACTIVE=1` را تنظیم کنید (یا آن را در یک خط لوله بدون TTY اجرا کنید)
تا نصب بدون هیچ پرسشی از ابتدا تا انتها انجام شود، اطلاعات ورود تصادفی ساخته
و در `/etc/easyxray/install-result.env` نوشته شود. نمونه‌ها را در [`deploy/`](deploy/) ببینید:

- [‏Cloud-init user-data](deploy/cloud-init/) — نصب بدون نظارت روی هر ابری (Hetzner/AWS/DO/Vultr/GCP/Azure/Oracle)
- [یادداشت‌های Hetzner Cloud](deploy/marketplace/hetzner/) — استقرار با cloud-init روی Hetzner

## ساختار نصب و نام سرویس‌ها

همه‌ی اجزای EasyXray نام پروژه را دارند، بنابراین با هیچ پنل دیگری روی همان میزبان تعارض پیدا نمی‌کنند.

| مورد | مقدار |
| --- | --- |
| فایل اجرایی | `easyxray` |
| منوی مدیریت | `easyxray` (از `easyxray.sh` در `/usr/bin/easyxray` نصب می‌شود) |
| پوشه‌ی نصب | `/usr/local/easyxray` |
| پوشه‌ی پیکربندی و پایگاه‌داده | `/etc/easyxray` |
| پایگاه‌داده‌ی SQLite | `/etc/easyxray/EasyXray.db` |
| پوشه / فایل گزارش‌ها | `/var/log/easyxray` ، `easyxray.log` |
| متغیرهای محیطی | `EASYXRAY_*` |
| یونیت systemd | `easyxray.service` (گونه‌ها: `easyxray.service.debian`، `.arch`، `.rhel`) |
| سرویس OpenRC | `easyxray` (از `easyxray.rc`) |
| ماژول Go | `github.com/EasyXrayTeam/EasyXray/v3` |
| نسخه‌ی پنل | `1.0.0` |

## رابط کاربری پنل و HTTP API

وقتی مسیر پایه‌ی وب روی مقدار پیش‌فرض `/` باشد، پنل از این نشانی‌ها سرو می‌شود:

| سطح | مسیر |
| --- | --- |
| رابط کاربری پنل | `/easyxray/…` |
| ‏REST API | `/easyxray/api/v1/…` — برای نمونه `/easyxray/api/v1/inbounds/list` |
| ‏WebSocket | `/easyxray/ws` |
| مشخصات OpenAPI | `/easyxray/api/v1/openapi.json` |

همه‌ی این مسیرها **زیر** مسیر پایه‌ی وبی قرار می‌گیرند که خودتان تنظیم می‌کنید؛ پنلی با مسیر پایه‌ی `/mypanel` رابطش را در `/mypanel/easyxray/…` و API را در `/mypanel/easyxray/api/v1/…` ارائه می‌کند.

> [!WARNING]
> این انتشار تمام فضای نام API را تغییر نام می‌دهد. مسیرهای قدیمی `/panel/api/…` به‌عنوان نام‌های جایگزین سازگار **حفظ نمی‌شوند** — درخواست‌هایی که به آن‌ها فرستاده شوند پاسخ داده نمی‌شوند. هر یکپارچه‌سازی بیرونی که بر پایه‌ی API دوران 3x-ui نوشته شده باشد، باید به مسیرهای `/easyxray/api/v1/…` به‌روزرسانی شود تا دوباره کار کند.

## مهاجرت از 3x-ui

‏EasyXray یک **نصب کاملاً تازه** است. نصب موجود 3x-ui را شناسایی نمی‌کند، آن را در دست نمی‌گیرد و داده‌ای منتقل نمی‌کند؛ هیچ چیز هم به‌طور خودکار تبدیل نمی‌شود — نام سرویس، پوشه‌ی نصب، پوشه‌ی پیکربندی و پایگاه‌داده، پیشوند متغیرهای محیطی، نام فایل پایگاه‌داده و فضای نام API همه متفاوت‌اند و هیچ مسیر مهاجرتی میان این دو ارائه نمی‌شود.

اگر از 3x-ui می‌آیید، پنل قدیمی را روشن بگذارید، هر چه لازم دارید از آن خارج کنید (فهرست ورودی‌ها و کلاینت‌ها، لینک‌های اشتراک‌گذاری، پیکربندی Xray، گواهی‌ها)، سپس EasyXray را نصب کنید و همان پیکربندی را در پنل تازه بازسازی کنید. پیش از حذف یا جایگزینی هر چیزی، از پایگاه‌داده‌ی قدیمی نسخه‌ی پشتیبان بگیرید.

## پلتفرم‌های پشتیبانی‌شده

**سیستم‌عامل‌ها:** ‏Ubuntu، Debian، Armbian، Fedora، CentOS، RHEL، AlmaLinux، Rocky Linux، Oracle Linux، Amazon Linux، Virtuozzo، Arch، Manjaro، Parch، openSUSE (Tumbleweed / Leap)، Alpine و Windows.

**معماری‌ها:** `amd64` · `386` · `arm64` (aarch64) · `armv7` · `armv6` · `armv5` · `s390x`.

## گزینه‌های پایگاه‌داده

‏EasyXray از دو بک‌اند پشتیبانی می‌کند که هنگام نصب انتخاب می‌شوند:

- **‏SQLite** (پیش‌فرض) — یک فایل در `/etc/easyxray/EasyXray.db`. بدون هیچ تنظیمی، مناسب استقرارهای کوچک و متوسط.
- **‏PostgreSQL** — برای شمار بالای کلاینت‌ها یا ساختارهای چندنودی توصیه می‌شود. نصب‌کننده می‌تواند PostgreSQL را به‌جای شما به‌صورت محلی نصب کند یا یک DSN به سرور موجود را بپذیرد.

هنگام اجرا، بک‌اند با متغیرهای محیطی انتخاب می‌شود (نصب‌کننده آن‌ها را در `/etc/default/easyxray` می‌نویسد):

```
EASYXRAY_DB_TYPE=postgres
EASYXRAY_DB_DSN=postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable
```

### انتقال یک نصب موجود SQLite به PostgreSQL

```bash
easyxray migrate-db --dsn "postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable"
# سپس EASYXRAY_DB_TYPE و EASYXRAY_DB_DSN را در /etc/default/easyxray تنظیم کرده و ری‌استارت کنید:
systemctl restart easyxray
```

فایل SQLite مبدأ دست‌نخورده باقی می‌ماند؛ پس از اطمینان از درستی بک‌اند تازه، خودتان آن را حذف کنید.

### Docker

دستور پیش‌فرض `docker compose up -d` همچنان از SQLite استفاده می‌کند. برای اجرا با سرویس PostgreSQL همراه، دو خط متغیر `EASYXRAY_DB_*` در `docker-compose.yml` را از حالت توضیح خارج کنید و با profile بالا بیاورید:

```bash
docker compose --profile postgres up -d
```

این ایمج Fail2ban را در خود دارد (به‌طور پیش‌فرض فعال) تا **محدودیت‌های IP** هر کلاینت اجرا شود. Fail2ban متخلفان را با `iptables` مسدود می‌کند و این کار به توانمندی `NET_ADMIN` نیاز دارد. فایل `docker-compose.yml` این توانمندی را از راه `cap_add` می‌دهد؛ اگر کانتینر را با `docker run` بالا می‌آورید، خودتان توانمندی‌ها را اضافه کنید، وگرنه مسدودسازی‌ها فقط ثبت می‌شوند و هرگز اعمال نمی‌شوند:

```bash
docker run -d --cap-add=NET_ADMIN --cap-add=NET_RAW ... ghcr.io/easyxrayteam/easyxray
```

## متغیرهای محیطی

| متغیر | توضیح | پیش‌فرض |
| --- | --- | --- |
| `EASYXRAY_DB_TYPE` | بک‌اند پایگاه‌داده: `sqlite` یا `postgres` | `sqlite` |
| `EASYXRAY_DB_DSN` | رشته‌ی اتصال PostgreSQL (وقتی `EASYXRAY_DB_TYPE=postgres`) | — |
| `EASYXRAY_DB_FOLDER` | پوشه‌ی فایل پایگاه‌داده‌ی SQLite | `/etc/easyxray` |
| `EASYXRAY_DB_MAX_OPEN_CONNS` | بیشترین اتصال‌های باز (استخر PostgreSQL) | — |
| `EASYXRAY_DB_MAX_IDLE_CONNS` | بیشترین اتصال‌های بی‌کار (استخر PostgreSQL) | — |
| `EASYXRAY_PORT` | بازنویسی درگاه پنل (۱ تا ۶۵۵۳۵)؛ بر تنظیم ذخیره‌شده اولویت دارد | — |
| `EASYXRAY_INIT_WEB_BASE_PATH` | مسیر URI آغازین پنل وب | `/` |
| `EASYXRAY_ENABLE_FAIL2BAN` | فعال‌سازی اجرای محدودیت IP با Fail2ban | `true` |
| `EASYXRAY_SKIP_HSTS` | نادیده گرفتن سرایند HSTS — وقتی TLS در پراکسی معکوس پایان می‌یابد فعال کنید | `false` |
| `EASYXRAY_LOG_LEVEL` | سطح جزئیات گزارش‌ها (`debug`، `info`، `warning`، `error`) | `info` |
| `EASYXRAY_LOG_FOLDER` | پوشه‌ی خروجی گزارش‌ها | `/var/log/easyxray` |
| `EASYXRAY_DEBUG` | فعال‌سازی حالت اشکال‌زدایی | `false` |
| `EASYXRAY_TUNNEL_HEALTH_MONITOR` | فعال‌سازی پایشگر سلامت تونل (نشانی‌ای را بررسی می‌کند و پس از شکست‌های پی‌درپی Xray را ری‌استارت می‌کند؛ ری‌استارت همه‌ی کلاینت‌ها را قطع می‌کند) | `false` |
| `EASYXRAY_TUNNEL_HEALTH_PROXY` | پراکسی‌ای که بررسی از آن ارسال می‌شود؛ آن را به یک ورودی محلی Xray بدهید تا بررسی واقعاً تونل را بسنجد (مثلاً `socks5://127.0.0.1:1080`). خالی بودن یعنی فقط اتصال میزبان بررسی می‌شود | — |
| `EASYXRAY_TUNNEL_HEALTH_URL` | نشانی بررسی‌شده برای سلامت تونل | `https://www.cloudflare.com/cdn-cgi/trace` |
| `EASYXRAY_TUNNEL_HEALTH_INTERVAL` | فاصله‌ی میان بررسی‌ها | `30s` |
| `EASYXRAY_TUNNEL_HEALTH_TIMEOUT` | مهلت هر بررسی | `10s` |
| `EASYXRAY_TUNNEL_HEALTH_FAILURES` | شمار شکست‌های پی‌درپی پیش از راه‌افتادن ری‌استارت | `3` |
| `EASYXRAY_TUNNEL_HEALTH_COOLDOWN` | کمترین فاصله میان ری‌استارت‌های پی‌درپی | `5m` |
| `NODE_TOKEN_ENCRYPTION` | رمزگذاری در حالت سکون برای توکن‌های API نودها: `off`، `migration` یا `required` (توجه: بدون پیشوند `EASYXRAY_`) | `off` |
| `EASYXRAY_NODE_TOKEN_KEY_FILE` | حلقه‌ی کلید JSON (با دسترسی `0600`) شامل شناسه‌ی کلید فعال و کلیدهای ۳۲ بایتی base64 آن | `/etc/easyxray/node_token_key.json` |
| `EASYXRAY_NODE_TOKEN_KEY` | یک کلید ۳۲ بایتی base64، تنها زمانی استفاده می‌شود که فایل کلیدها خوانده نشود | — |

فهرست کامل در مرجع متغیرهای محیطی روی [سایت مستندات](https://easyxrayteam.github.io/EasyXray/) آمده است.

## زبان‌های پشتیبانی‌شده

رابط کاربری پنل در ۱۳ زبان در دسترس است:

English · فارسی · العربية · 中文（简体） · 中文（繁體） · Español · Русский · Українська · Türkçe · Tiếng Việt · 日本語 · Bahasa Indonesia · Português (Brasil)

## مشارکت

از مشارکت شما استقبال می‌کنیم. پیش از ثبت issue یا pull request، لطفاً [راهنمای مشارکت](/CONTRIBUTING.md) را بخوانید.

## انتساب و مجوز

‏EasyXray یک **اثر مشتق تغییر‌یافته** از [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui) است. این کدپایه بر پایه‌ی commit شماره‌ی `74c3cc38` بالادست (شاخه‌ی نسخه‌ی 3.10.0) ساخته شده و تیم EasyXrayTeam آن را با نام EasyXray توسعه می‌دهد و منتشر می‌کند.

آنچه EasyXray نسبت به این پایه تغییر داده، تغییر نام سراسری پروژه است: نام محصول، فایل اجرایی و سرویس systemd/OpenRC آن، مسیرهای نصب، پیکربندی، پایگاه‌داده و گزارش‌ها، پیشوند متغیرهای محیطی (اکنون `EASYXRAY_*`)، سکریپت مدیریت، فضای نام رابط کاربری و REST API، مسیر ماژول Go و ایمج Docker منتشرشده، همگی نام EasyXray را دارند. جز این تغییر نام، رفتار پنل — مجموعه‌ی قابلیت‌ها، پروتکل‌هایی که ارائه می‌دهد و شیوه‌ی مدیریت Xray-core — از پروژه‌ی بالادست به ارث رسیده است. نام‌ها و مسیرهای مشخص را در [ساختار نصب و نام سرویس‌ها](#ساختار-نصب-و-نام-سرویسها) و [رابط کاربری پنل و HTTP API](#رابط-کاربری-پنل-و-http-api) ببینید.

‏EasyXray با **مجوز عمومی همگانی گنو نسخه‌ی ۳** (GPL-3.0) منتشر می‌شود. متن کامل مجوز در فایل [`LICENSE`](LICENSE) است. اجزای شخص ثالثی که در این پروژه گنجانده شده‌اند یا پروژه به آن‌ها وابسته است، در `NOTICE` و `THIRD_PARTY_NOTICES.md` ثبت شده‌اند.

کد منبع متناظر با فایل‌های اجرایی توزیع‌شده در همین‌جا، همین مخزن است: [EasyXrayTeam/EasyXray](https://github.com/EasyXrayTeam/EasyXray).

این پروژه **نه مورد تأیید نویسنده‌ی بالادست 3x-ui است، نه با حمایت مالی او، و نه به هیچ شکلی وابسته به او**. این یک اثر مشتق مستقل است که بر پایه‌ی شرایط مجوز GNU GPL منتشر می‌شود.

## تقدیر و تشکر

ریشه‌ی رابط کاربری و توانمندی‌های پنل EasyXray به پروژه‌ی اصلی **X-UI** و ادامه‌دهندگان آن بازمی‌گردد؛ سپاس ویژه از [alireza0](https://github.com/alireza0/) برای این کار بنیادین.

افزون بر این، پنل بر این پروژه‌ها تکیه دارد یا همراه با آن‌ها توزیع می‌شود:

- [Iran v2ray rules](https://github.com/chocolate4u/Iran-v2ray-rules) (مجوز: **GPL-3.0**): _قواعد مسیریابی بهبودیافته‌ی v2ray/xray و v2ray/xray-clients با دامنه‌های ایرانی درون‌ساخت و تمرکز بر امنیت و حذف تبلیغات._
- [Russia v2ray rules](https://github.com/runetfreedom/russia-v2ray-rules-dat) (مجوز: **GPL-3.0**): _این مخزن شامل قواعد مسیریابی V2Ray است که به‌طور خودکار بر پایه‌ی داده‌های دامنه‌ها و نشانی‌های مسدودشده در روسیه به‌روزرسانی می‌شود._

## ابزارهای جامعه

ابزارها و یکپارچه‌سازی‌هایی که جامعه‌ی گسترده‌تر پیرامون پروژه‌ی بالادست این پنل ساخته‌اند. توجه داشته باشید که این‌ها فضای نام API بالادست را هدف می‌گیرند، بنابراین ممکن است پیش از کار با نقاط پایانی تغییرنام‌یافته‌ی EasyXray یعنی `/easyxray/api/v1/…` نیاز به به‌روزرسانی داشته باشند.

- [terraform-provider-3x-ui](https://github.com/batonogov/terraform-provider-threexui) (مجوز: **MIT**): _مدیریت ورودی‌ها، کلاینت‌ها، تنظیمات پنل و پیکربندی Xray به‌صورت کد با Terraform / OpenTofu._
- [3X-UI Manager](https://github.com/yukh975/3X-UI-Manager) (مجوز: **MIT**): _کلاینت بومی اندروید برای 3x-ui — داشبورد، ورودی‌ها، کلاینت‌ها با اشتراک‌گذاری QR، نودها و مدیریت چند پنل. در دسترس روی F-Droid._

## تاریخچه ستاره‌ها

<a href="https://www.star-history.com/?repos=EasyXrayTeam%2FEasyXray&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
 </picture>
</a>
