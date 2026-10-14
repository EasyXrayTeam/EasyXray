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

**EasyXray** لوحة تحكم ويب مفتوحة المصدر لتشغيل خوادم [Xray-core](https://github.com/XTLS/Xray-core) وإدارتها. توفّر واجهة نظيفة ومتعددة اللغات لنشر مجموعة واسعة من بروتوكولات البروكسي والـ VPN وضبطها ومراقبتها، سواء كنت تدير خادم VPS واحدًا أو أسطولًا كاملًا من العُقد.

تعود أصول واجهة اللوحة وقاعدتها الوظيفية إلى مشروع X-UI الأصلي وخلفائه. ويواصل EasyXray هذا العمل باسمه الخاص: فله ملفه التنفيذي وخدمته ومسارات تثبيته وبادئة متغيّرات بيئته ونطاق أسماء واجهة HTTP API الخاصة به. للاطّلاع على الإسناد الكامل والشروط القانونية راجع قسم [الإسناد والترخيص](#الإسناد-والترخيص).

> [!IMPORTANT]
> هذا المشروع مخصّص للاستخدام الشخصي فقط. يُرجى عدم استخدامه لأغراض غير قانونية أو في بيئات الإنتاج.

## الميزات

- **اتصالات واردة متعددة البروتوكولات** — ‏VLESS وVMess وTrojan وShadowsocks وWireGuard وAmneziaWG وTUIC v5 وHysteria2 وMASQUE وMTProto وHTTP وSOCKS (Mixed) وDokodemo-door / Tunnel وTUN.
- **بنية نقل وحماية حديثة** — ‏TCP (Raw) وmKCP وWebSocket وgRPC وHTTPUpgrade وXHTTP، مدعومة بـ TLS وXTLS وREALITY.
- **‏AmneziaWG مدمج** — يعمل WireGuard المقاوم لفحص الحزم (DPI) داخل اللوحة نفسها على مكدّس شبكي في فضاء المستخدم، دون وحدة نواة أو DKMS أو حزم إضافية.
- **خادم TUIC v5 أصلي** — خادم QUIC مكتوب بلغة Go ويعمل داخل العملية نفسها، مع توجيه Xray ومحاسبة ترافيك لكل عميل؛ ويتوفّر على الخادم BBR وNew Reno. يبقى CUBIC محفوظًا في ملف تعريف العميل، لكنه يتراجع حاليًا على الخادم إلى New Reno.
- **بروكسيات MTProto** — أسرار FakeTLS ووسوم إعلانية (ad-tags) وحصص لكل عميل، تُطبَّق فورًا دون قطع الاتصالات القائمة.
- **‏Fallback** — تقديم عدة بروتوكولات على منفذ واحد (مثلًا VLESS وTrojan على المنفذ 443) بالاعتماد على دعم fallback في Xray.
- **إدارة لكل عميل** — حصص ترافيك، وتواريخ انتهاء، وحدود عناوين IP مع استثناءات للعناوين الموثوقة، وحدود أجهزة HWID، ودورات تجديد مجدولة، وحالة الاتصال المباشر، ورابط مشاركة ونقاط QR واشتراكات بضغطة واحدة.
- **إحصاءات الترافيك** — لكل اتصال وارد ولكل عميل ولكل اتصال صادر، مع إمكانية التصفير.
- **دعم تعدد العُقد** — إدارة عدة خوادم والتوسّع عبرها من لوحة واحدة، بما في ذلك استنساخ الاتصالات الواردة إلى عُقد أخرى.
- **الاتصالات الصادرة والتوجيه** — ‏WARP وNordVPN وPIA وقواعد توجيه مخصّصة وموازنات حمل مع تبديل بين موازن وآخر وسلاسل بروكسي صادر. كما يمكن استعراض تصنيفات geosite وgeoip المرفقة مباشرة من محرّر القواعد.
- **خادم اشتراكات مدمج** — مخرجات raw وJSON وClash، تُختار تلقائيًا حسب User-Agent الخاص بالعميل، إضافة إلى [قوالب صفحات مخصّصة](docs/custom-subscription-templates.md).
- **بوتات Telegram وDiscord** للمراقبة والإدارة عن بُعد.
- **واجهة RESTful API** برموز وصول محدودة النطاق وقابلة للانتهاء، مع مرجع للـ API داخل اللوحة.
- **لوحة قابلة للتثبيت (PWA)** — ثبّت EasyXray على سطح المكتب أو الشاشة الرئيسية لهاتفك.
- **تخزين مرن** — ‏SQLite (افتراضيًا) أو PostgreSQL.
- **13 لغة لواجهة المستخدم** مع سمات فاتحة وداكنة.
- **تكامل مع Fail2ban** لتطبيق حدود IP لكل عميل.

## لقطات الشاشة

تُظهر اللقطات التالية واجهة EasyXray الحالية. تخطيط اللوحة وتصميمها موروثان من المشروع الأصلي، ولم يُعَد تصميمهما في هذا الإصدار.

<details>
<summary>اضغط للتوسيع</summary>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/01-overview-dark.png">
  <img alt="نظرة عامة" src="./media/01-overview-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/02-add-inbound-dark.png">
  <img alt="الاتصالات الواردة" src="./media/02-add-inbound-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/03-add-client-dark.png">
  <img alt="إضافة عميل" src="./media/03-add-client-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/05-add-nodes-dark.png">
  <img alt="العُقد" src="./media/05-add-nodes-light.png">
</picture>

</details>

## البدء السريع

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh)
```

لتثبيت إصدار محدّد، أضف وسمه (مثل `v1.0.3`):

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) v1.0.3
```

ولتثبيت بناء **dev** المتجدّد (أحدث إصدار تجريبي يُنتَج مع كل commit على فرع `main`، وليس إصدارًا مستقرًا) مرّر `dev-latest`:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) dev-latest
```

أثناء التثبيت يُولَّد اسم مستخدم وكلمة مرور ومسار وصول عشوائية. وبعد انتهائه شغّل الأمر `easyxray` لفتح قائمة الإدارة، حيث يمكنك تشغيل الخدمة وإيقافها، وعرض بيانات الدخول أو إعادة تعيينها، وإدارة شهادات SSL وغير ذلك.

يُرفَق مع كل حزمة إصدار ملف `.sha256`، ويتحقّق كلٌّ من `install.sh` وبرنامج التحديث من الحزمة مقابل هذا المجموع ويتوقّف عند عدم تطابقه.

تجد الوثائق الكاملة — التثبيت والضبط والتشغيل اليومي ومرجع الـ API الكامل — على **[easyxrayteam.github.io/EasyXray](https://easyxrayteam.github.io/EasyXray/)**.

### التثبيت غير التفاعلي

يعمل سكربت التثبيت أيضًا **دون أي تفاعل**، وهو مناسب لـ cloud-init.
اضبط `EASYXRAY_NONINTERACTIVE=1` (أو شغّله عبر أنبوب بلا طرفية TTY) فيُكمل التثبيت
من البداية إلى النهاية دون أي سؤال، ويولّد بيانات اعتماد عشوائية
ويكتبها في `/etc/easyxray/install-result.env`. راجع [`deploy/`](deploy/) للأمثلة:

- [‏Cloud-init user-data](deploy/cloud-init/) — تثبيت غير تفاعلي على أي سحابة (Hetzner/AWS/DO/Vultr/GCP/Azure/Oracle)
- [ملاحظات Hetzner Cloud](deploy/marketplace/hetzner/) — النشر عبر cloud-init على Hetzner

## مسارات التثبيت وأسماء الخدمات

تحمل جميع مكوّنات EasyXray اسم المشروع، لذلك لا تتعارض مع أي لوحة أخرى على الخادم نفسه.

| العنصر | القيمة |
| --- | --- |
| الملف التنفيذي | `easyxray` |
| قائمة الإدارة | `easyxray` (تُثبَّت في `/usr/bin/easyxray` انطلاقًا من `easyxray.sh`) |
| مجلد التثبيت | `/usr/local/easyxray` |
| مجلد الضبط وقاعدة البيانات | `/etc/easyxray` |
| قاعدة بيانات SQLite | `/etc/easyxray/EasyXray.db` |
| مجلد / ملف السجلات | `/var/log/easyxray` ، `easyxray.log` |
| متغيّرات البيئة | `EASYXRAY_*` |
| وحدة systemd | `easyxray.service` (وبدائل: `easyxray.service.debian` و`.arch` و`.rhel`) |
| خدمة OpenRC | `easyxray` (من `easyxray.rc`) |
| وحدة Go | `github.com/EasyXrayTeam/EasyXray/v3` |
| إصدار اللوحة | `1.0.0` |

## واجهة اللوحة وواجهة HTTP API

عندما يكون مسار الويب الأساسي على قيمته الافتراضية `/`، تُقدَّم اللوحة من العناوين التالية:

| السطح | المسار |
| --- | --- |
| واجهة اللوحة | `/easyxray/…` |
| ‏REST API | `/easyxray/api/v1/…` — مثلًا `/easyxray/api/v1/inbounds/list` |
| ‏WebSocket | `/easyxray/ws` |
| مواصفة OpenAPI | `/easyxray/api/v1/openapi.json` |

تقع هذه المسارات كلها **تحت** مسار الويب الأساسي الذي تضبطه؛ فلوحة مسارها الأساسي `/mypanel` تُقدَّم واجهتها على `/mypanel/easyxray/…` وواجهة الـ API على `/mypanel/easyxray/api/v1/…`.

> [!WARNING]
> يعيد هذا الإصدار تسمية نطاق أسماء الـ API بالكامل. ولا تُحفَظ المسارات القديمة `/panel/api/…` كأسماء بديلة متوافقة مع الإصدارات السابقة؛ فالطلبات الموجّهة إليها لن تُخدَم. وعلى كل تكامل خارجي كُتب وفق واجهة عصر 3x-ui أن يحدَّث إلى المسارات `/easyxray/api/v1/…` ليعود إلى العمل.

## الانتقال من 3x-ui

‏EasyXray **تثبيت جديد من الصفر**. فهو لا يكتشف تثبيت 3x-ui قائمًا ولا يتبنّاه ولا ينقل بياناته، ولا يُحوَّل أي شيء تلقائيًا؛ إذ يختلف اسم الخدمة ومجلد التثبيت ومجلد الضبط وقاعدة البيانات وبادئة متغيّرات البيئة واسم ملف قاعدة البيانات ونطاق أسماء الـ API، ولا يوفّر المشروع أي مسار ترحيل بين الاثنين.

إذا كنت قادمًا من 3x-ui، فأبقِ اللوحة القديمة تعمل، وصدّر منها ما تحتاجه (قوائم الاتصالات الواردة والعملاء، وروابط المشاركة، وضبط Xray، والشهادات)، ثم ثبّت EasyXray وأعِد إنشاء هذا الضبط في اللوحة الجديدة. واحتفظ بنسخة احتياطية من قاعدة البيانات القديمة قبل حذف أي شيء أو استبداله.

## المنصات المدعومة

**أنظمة التشغيل:** ‏Ubuntu وDebian وArmbian وFedora وCentOS وRHEL وAlmaLinux وRocky Linux وOracle Linux وAmazon Linux وVirtuozzo وArch وManjaro وParch وopenSUSE (Tumbleweed / Leap) وAlpine وWindows.

**المعماريات:** `amd64` · `386` · `arm64` (aarch64) · `armv7` · `armv6` · `armv5` · `s390x`.

## خيارات قاعدة البيانات

يدعم EasyXray خلفيتين، تُختاران أثناء التثبيت:

- **‏SQLite** (الافتراضي) — ملف واحد في `/etc/easyxray/EasyXray.db`. بلا أي إعداد، وهو مناسب للنشر الصغير والمتوسط.
- **‏PostgreSQL** — موصى به عند كثرة العملاء أو في إعدادات تعدد العُقد. يمكن لسكربت التثبيت أن يثبّت PostgreSQL محليًا نيابةً عنك، أو أن يقبل DSN يشير إلى خادم قائم.

يُختار الخادم وقت التشغيل عبر متغيّرات البيئة (يكتبها المثبّت لك في `/etc/default/easyxray`):

```
EASYXRAY_DB_TYPE=postgres
EASYXRAY_DB_DSN=postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable
```

### ترحيل تثبيت SQLite قائم إلى PostgreSQL

```bash
easyxray migrate-db --dsn "postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable"
# ثم عيّن EASYXRAY_DB_TYPE و EASYXRAY_DB_DSN في /etc/default/easyxray وأعد التشغيل:
systemctl restart easyxray
```

يبقى ملف SQLite المصدر دون مساس؛ احذفه يدويًا بعد التأكد من عمل الخلفية الجديدة.

### Docker

يبقى الأمر الافتراضي `docker compose up -d` مستخدمًا لـ SQLite. وللتشغيل مع خدمة PostgreSQL المرفقة، أزل التعليق عن سطري المتغيّرين `EASYXRAY_DB_*` في `docker-compose.yml` ثم شغّل باستخدام الوضع (profile):

```bash
docker compose --profile postgres up -d
```

تضمّن الصورة Fail2ban (مفعّلًا افتراضيًا) لتطبيق **حدود IP** لكل عميل. ويحجب Fail2ban المخالفين عبر `iptables`، وهو ما يتطلّب قدرة `NET_ADMIN`. ويمنحها `docker-compose.yml` عبر `cap_add`؛ أما إذا شغّلت الحاوية بالأمر `docker run` فأضف القدرات بنفسك، وإلا سُجّلت عمليات الحجب دون أن تُطبَّق فعليًا:

```bash
docker run -d --cap-add=NET_ADMIN --cap-add=NET_RAW ... ghcr.io/easyxrayteam/easyxray
```

## متغيرات البيئة

| المتغيّر | الوصف | القيمة الافتراضية |
| --- | --- | --- |
| `EASYXRAY_DB_TYPE` | خلفية قاعدة البيانات: `sqlite` أو `postgres` | `sqlite` |
| `EASYXRAY_DB_DSN` | سلسلة اتصال PostgreSQL (عند `EASYXRAY_DB_TYPE=postgres`) | — |
| `EASYXRAY_DB_FOLDER` | مجلد ملف قاعدة بيانات SQLite | `/etc/easyxray` |
| `EASYXRAY_DB_MAX_OPEN_CONNS` | الحد الأقصى للاتصالات المفتوحة (تجمع PostgreSQL) | — |
| `EASYXRAY_DB_MAX_IDLE_CONNS` | الحد الأقصى للاتصالات الخاملة (تجمع PostgreSQL) | — |
| `EASYXRAY_PORT` | تجاوز منفذ اللوحة (1–65535)؛ وله أولوية على الإعداد المحفوظ | — |
| `EASYXRAY_INIT_WEB_BASE_PATH` | مسار URI الأولي للوحة الويب | `/` |
| `EASYXRAY_ENABLE_FAIL2BAN` | تفعيل تطبيق حدود IP عبر Fail2ban | `true` |
| `EASYXRAY_SKIP_HSTS` | تخطّي ترويسة HSTS — فعّله عندما ينتهي TLS عند بروكسي عكسي | `false` |
| `EASYXRAY_LOG_LEVEL` | مستوى تفصيل السجلات (`debug` أو `info` أو `warning` أو `error`) | `info` |
| `EASYXRAY_LOG_FOLDER` | مجلد إخراج السجلات | `/var/log/easyxray` |
| `EASYXRAY_DEBUG` | تفعيل وضع التنقيح | `false` |
| `EASYXRAY_TUNNEL_HEALTH_MONITOR` | تفعيل مراقب سلامة النفق (يستعلم عن رابط ويعيد تشغيل Xray بعد تكرار الفشل؛ وإعادة التشغيل تقطع جميع العملاء) | `false` |
| `EASYXRAY_TUNNEL_HEALTH_PROXY` | البروكسي الذي يُرسَل عبره الاستعلام؛ وجّهه إلى اتصال Xray وارد محلي لتختبر العملية النفق فعليًا (مثل `socks5://127.0.0.1:1080`). وتركه فارغًا يعني فحص اتصال المضيف فقط | — |
| `EASYXRAY_TUNNEL_HEALTH_URL` | الرابط الذي يُستعلَم عنه لفحص سلامة النفق | `https://www.cloudflare.com/cdn-cgi/trace` |
| `EASYXRAY_TUNNEL_HEALTH_INTERVAL` | الفاصل الزمني بين الاستعلامات | `30s` |
| `EASYXRAY_TUNNEL_HEALTH_TIMEOUT` | مهلة كل استعلام | `10s` |
| `EASYXRAY_TUNNEL_HEALTH_FAILURES` | عدد مرات الفشل المتتالية قبل تفعيل إعادة التشغيل | `3` |
| `EASYXRAY_TUNNEL_HEALTH_COOLDOWN` | أقل تأخير بين عمليات إعادة التشغيل المتتالية | `5m` |
| `NODE_TOKEN_ENCRYPTION` | تشفير رموز API الخاصة بالعُقد أثناء التخزين: `off` أو `migration` أو `required` (ملاحظة: دون بادئة `EASYXRAY_`) | `off` |
| `EASYXRAY_NODE_TOKEN_KEY_FILE` | ملف مفاتيح JSON (بصلاحيات `0600`) يحمل معرّف المفتاح النشط ومفاتيحه بحجم 32 بايت بترميز base64 | `/etc/easyxray/node_token_key.json` |
| `EASYXRAY_NODE_TOKEN_KEY` | مفتاح واحد بحجم 32 بايت بترميز base64، يُستخدم فقط عند تعذّر تحميل ملف المفاتيح | — |

القائمة الكاملة في مرجع متغيّرات البيئة على [موقع الوثائق](https://easyxrayteam.github.io/EasyXray/).

## اللغات المدعومة

تتوفّر واجهة اللوحة بـ 13 لغة:

English · فارسی · العربية · 中文（简体） · 中文（繁體） · Español · Русский · Українська · Türkçe · Tiếng Việt · 日本語 · Bahasa Indonesia · Português (Brasil)

## المساهمة

نرحّب بمساهماتكم. يُرجى قراءة [دليل المساهمة](/CONTRIBUTING.md) قبل فتح issue أو pull request.

## الإسناد والترخيص

‏EasyXray **عمل مشتق معدّل** من [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui). تستند هذه الشيفرة إلى الـ commit `74c3cc38` من المشروع الأصلي (سلسلة 3.10.0)، ويتولّى فريق EasyXrayTeam تطويرها وتوزيعها باسم EasyXray.

وما غيّره EasyXray عن هذا الأصل هو إعادة تسمية المشروع بالكامل: اسم المنتج، والملف التنفيذي وخدمته في systemd/OpenRC، ومسارات التثبيت والضبط وقاعدة البيانات والسجلات، وبادئة متغيّرات البيئة (أصبحت `EASYXRAY_*`)، وسكربت الإدارة، ونطاقا أسماء واجهة اللوحة وواجهة REST API، ومسار وحدة Go، وصورة Docker الموزّعة — كلها تحمل اسم EasyXray. وإلى جانب إعادة التسمية هذه، يبقى سلوك اللوحة — مجموعة ميزاتها، والبروتوكولات التي تخدمها، وطريقة إدارتها لـ Xray-core — موروثًا من المشروع الأصلي. وللاطّلاع على الأسماء والمسارات الفعلية راجع [مسارات التثبيت وأسماء الخدمات](#مسارات-التثبيت-وأسماء-الخدمات) و[واجهة اللوحة وواجهة HTTP API](#واجهة-اللوحة-وواجهة-http-api).

يُراخَص EasyXray تحت **رخصة GNU العامة العمومية الإصدار الثالث** (GPL-3.0)، ونص الرخصة الكامل في الملف [`LICENSE`](LICENSE). أما المكوّنات الخارجية المضمّنة في المشروع أو التي يعتمد عليها فمسجّلة في `NOTICE` و`THIRD_PARTY_NOTICES.md`.

والشيفرة المصدرية المقابلة للملفات التنفيذية الموزّعة هنا هي هذا المستودع: [EasyXrayTeam/EasyXray](https://github.com/EasyXrayTeam/EasyXray).

هذا المشروع **غير معتمد من مؤلف 3x-ui الأصلي ولا مدعوم منه ولا مرتبط به** بأي شكل. وهو عمل مشتق مستقل يُنشر وفق شروط رخصة GNU العامة.

## شكر وتقدير

تعود أصول واجهة لوحة EasyXray وقاعدتها الوظيفية إلى مشروع **X-UI** الأصلي وخلفائه، ونشكر بشكل خاص [alireza0](https://github.com/alireza0/) على هذا العمل التأسيسي.

كما تعتمد اللوحة على المشاريع التالية أو توزّعها معها:

- [Iran v2ray rules](https://github.com/chocolate4u/Iran-v2ray-rules) (الترخيص: **GPL-3.0**): _قواعد توجيه محسّنة لـ v2ray/xray وv2ray/xray-clients مع نطاقات إيرانية مدمجة وتركيز على الأمان وحجب الإعلانات._
- [Russia v2ray rules](https://github.com/runetfreedom/russia-v2ray-rules-dat) (الترخيص: **GPL-3.0**): _يحتوي هذا المستودع على قواعد توجيه V2Ray محدَّثة تلقائيًا بناءً على بيانات النطاقات والعناوين المحجوبة في روسيا._

## أدوات المجتمع

أدوات وتكاملات بناها المجتمع الأوسع حول المشروع الذي انبثقت منه هذه اللوحة. لاحظ أنها تستهدف نطاق أسماء الـ API الأصلي، لذا قد تحتاج إلى تحديث قبل أن تعمل مع نقاط نهاية EasyXray المعاد تسميتها `/easyxray/api/v1/…`.

- [terraform-provider-3x-ui](https://github.com/batonogov/terraform-provider-threexui) (الترخيص: **MIT**): _إدارة الاتصالات الواردة والعملاء وإعدادات اللوحة وضبط Xray كشيفرة برمجية باستخدام Terraform / OpenTofu._
- [3X-UI Manager](https://github.com/yukh975/3X-UI-Manager) (الترخيص: **MIT**): _عميل أندرويد أصلي لـ 3x-ui — لوحة تحكم واتصالات واردة وعملاء مع مشاركة رمز QR وعُقد وإدارة عدة لوحات. متاح على F-Droid._

## سجل النجوم

<a href="https://www.star-history.com/?repos=EasyXrayTeam%2FEasyXray&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
 </picture>
</a>
