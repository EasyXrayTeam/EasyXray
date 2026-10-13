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

**EasyXray** — веб-панель управления с открытым исходным кодом для запуска серверов [Xray-core](https://github.com/XTLS/Xray-core) и работы с ними. Она даёт аккуратный многоязычный интерфейс для развёртывания, настройки и мониторинга множества прокси- и VPN-протоколов — и когда у вас один VPS, и когда под управлением целый парк узлов.

Основу интерфейса и возможностей панели заложил исходный проект X-UI и его преемники. EasyXray продолжает эту работу под собственным именем: у него свой исполняемый файл, служба, пути установки, префикс переменных окружения и пространство имён HTTP API. Полные сведения о происхождении и лицензии — в разделе [Атрибуция и лицензия](#атрибуция-и-лицензия).

> [!IMPORTANT]
> Проект предназначен только для личного использования. Пожалуйста, не применяйте его в противоправных целях и не используйте в продакшене.

## Возможности

- **Многопротокольные входящие подключения** — VLESS, VMess, Trojan, Shadowsocks, WireGuard, AmneziaWG, TUIC v5, Hysteria2, MASQUE, MTProto, HTTP, SOCKS (Mixed), Dokodemo-door / Tunnel и TUN.
- **Современные транспорты и защита** — TCP (Raw), mKCP, WebSocket, gRPC, HTTPUpgrade и XHTTP в сочетании с TLS, XTLS и REALITY.
- **Встроенный AmneziaWG** — устойчивый к DPI WireGuard работает прямо внутри панели на сетевом стеке в пользовательском пространстве: ни модуля ядра, ни DKMS, ни дополнительных пакетов.
- **Собственный сервер TUIC v5** — QUIC-сервер на Go внутри процесса панели, с маршрутизацией Xray и учётом трафика по клиентам; на стороне сервера доступны BBR и New Reno. CUBIC сохраняется в профиле клиента, но на сервере пока используется New Reno.
- **Прокси MTProto** — персональные секреты FakeTLS, ad-tag и квоты для каждого клиента, которые применяются на лету и не обрывают активные соединения.
- **Fallback** — несколько протоколов на одном порту (например, VLESS и Trojan на 443) за счёт поддержки fallback в Xray.
- **Управление по каждому клиенту** — квоты трафика, сроки действия, ограничения по IP с исключениями для доверенных адресов, лимиты устройств по HWID, плановые циклы продления, статус «онлайн» в реальном времени, а также ссылки для обмена, QR-коды и подписки в один клик.
- **Статистика трафика** — по каждому входящему, по каждому клиенту и по каждому исходящему, со сбросом счётчиков.
- **Несколько узлов** — управление несколькими серверами и масштабирование из одной панели, включая клонирование входящих на другие узлы.
- **Исходящие и маршрутизация** — WARP, NordVPN, PIA, собственные правила маршрутизации, балансировщики с переключением между балансировщиками и цепочки исходящих прокси. Встроенные категории geosite и geoip можно просматривать прямо из редактора правил.
- **Встроенный сервер подписок** — вывод в форматах raw, JSON и Clash, который выбирается автоматически по User-Agent клиента, плюс [пользовательские шаблоны страниц](docs/custom-subscription-templates.md).
- **Боты Telegram и Discord** для удалённого мониторинга и управления.
- **RESTful API** с токенами ограниченной области действия и необязательным сроком жизни, а также справка по API прямо в панели.
- **Устанавливаемая панель (PWA)** — закрепите EasyXray на рабочем столе или главном экране телефона.
- **Гибкое хранилище** — SQLite (по умолчанию) или PostgreSQL.
- **13 языков интерфейса** со светлой и тёмной темами.
- **Интеграция с Fail2ban** для соблюдения лимитов IP по клиентам.

## Скриншоты

Ниже — актуальный интерфейс EasyXray. Компоновка и оформление панели унаследованы от исходного проекта: ничего специально не перерисовывалось к этому выпуску.

<details>
<summary>Нажмите, чтобы развернуть</summary>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/01-overview-dark.png">
  <img alt="Обзор" src="./media/01-overview-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/02-add-inbound-dark.png">
  <img alt="Входящие" src="./media/02-add-inbound-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/03-add-client-dark.png">
  <img alt="Добавление клиента" src="./media/03-add-client-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/05-add-nodes-dark.png">
  <img alt="Узлы" src="./media/05-add-nodes-light.png">
</picture>

</details>

## Быстрый старт

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh)
```

Чтобы поставить конкретную версию, допишите её тег (например, `v1.0.0`):

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) v1.0.0
```

Чтобы поставить «плавающую» сборку **dev** (последний предварительный выпуск из ветки `main`, а не стабильный релиз), передайте `dev-latest`:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) dev-latest
```

Во время установки генерируются случайные имя пользователя, пароль и путь доступа. Когда установка завершится, выполните `easyxray`, чтобы открыть меню управления: там можно запускать и останавливать службу, смотреть или сбрасывать учётные данные, управлять SSL-сертификатами и не только.

К каждому опубликованному архиву прилагается файл `.sha256`. И `install.sh`, и программа обновления сверяют архив с этой суммой и прерывают работу при несовпадении.

Полная документация — установка, настройка, повседневная эксплуатация и справочник по API — на **[easyxrayteam.github.io/EasyXray](https://easyxrayteam.github.io/EasyXray/)**.

### Автоматическая установка

Установщик умеет работать **без диалога**, что удобно для cloud-init.
Задайте `EASYXRAY_NONINTERACTIVE=1` (либо запустите его в канале без TTY) — и он
пройдёт установку до конца без единого вопроса, сгенерировав случайные учётные данные
и записав их в `/etc/easyxray/install-result.env`. Примеры — в каталоге [`deploy/`](deploy/):

- [Cloud-init user-data](deploy/cloud-init/) — автоматическая установка в любом облаке (Hetzner/AWS/DO/Vultr/GCP/Azure/Oracle)
- [Заметки о Hetzner Cloud](deploy/marketplace/hetzner/) — развёртывание через cloud-init в Hetzner

## Пути установки и имена служб

Все компоненты EasyXray носят имя проекта, поэтому они не конфликтуют с другой панелью на том же хосте.

| Элемент | Значение |
| --- | --- |
| Исполняемый файл | `easyxray` |
| Меню управления | `easyxray` (устанавливается в `/usr/bin/easyxray` из `easyxray.sh`) |
| Каталог установки | `/usr/local/easyxray` |
| Каталог конфигурации и базы данных | `/etc/easyxray` |
| База данных SQLite | `/etc/easyxray/EasyXray.db` |
| Каталог / файл журналов | `/var/log/easyxray` , `easyxray.log` |
| Переменные окружения | `EASYXRAY_*` |
| Юнит systemd | `easyxray.service` (варианты: `easyxray.service.debian`, `.arch`, `.rhel`) |
| Служба OpenRC | `easyxray` (из `easyxray.rc`) |
| Go-модуль | `github.com/EasyXrayTeam/EasyXray/v3` |
| Версия панели | `1.0.0` |

## Интерфейс панели и HTTP API

Если базовый веб-путь оставлен по умолчанию (`/`), панель доступна по адресам:

| Интерфейс | Путь |
| --- | --- |
| Веб-интерфейс панели | `/easyxray/…` |
| REST API | `/easyxray/api/v1/…`, например `/easyxray/api/v1/inbounds/list` |
| WebSocket | `/easyxray/ws` |
| Спецификация OpenAPI | `/easyxray/api/v1/openapi.json` |

Все эти адреса располагаются **после** настроенного вами базового веб-пути: для панели с базовым путём `/mypanel` интерфейс будет в `/mypanel/easyxray/…`, а API — в `/mypanel/easyxray/api/v1/…`.

> [!WARNING]
> В этом выпуске пространство имён API переименовано целиком. Старые пути `/panel/api/…` **не** сохранены в качестве совместимых псевдонимов: запросы по ним не будут обработаны. Любым внешним интеграциям, написанным под API эпохи 3x-ui, нужно перейти на пути `/easyxray/api/v1/…`, иначе они перестанут работать.

## Переход с 3x-ui

EasyXray — это **установка с нуля**. Она не находит существующую установку 3x-ui, не перенимает её и не переносит данные: имя службы, каталог установки, каталог конфигурации и базы данных, префикс переменных окружения, имя файла базы данных и пространство имён API различаются, а путь миграции между ними не предусмотрен.

Если вы переходите с 3x-ui, оставьте старую панель работать, выгрузите из неё всё нужное (списки входящих и клиентов, ссылки для обмена, конфигурацию Xray, сертификаты), затем установите EasyXray и воссоздайте эту конфигурацию в новой панели. Перед удалением или заменой чего-либо сделайте резервную копию старой базы данных.

## Поддерживаемые платформы

**Операционные системы:** Ubuntu, Debian, Armbian, Fedora, CentOS, RHEL, AlmaLinux, Rocky Linux, Oracle Linux, Amazon Linux, Virtuozzo, Arch, Manjaro, Parch, openSUSE (Tumbleweed / Leap), Alpine и Windows.

**Архитектуры:** `amd64` · `386` · `arm64` (aarch64) · `armv7` · `armv6` · `armv5` · `s390x`.

## Варианты базы данных

EasyXray поддерживает два бэкенда, выбираемых при установке:

- **SQLite** (по умолчанию) — один файл `/etc/easyxray/EasyXray.db`. Никакой настройки, идеально для небольших и средних развёртываний.
- **PostgreSQL** — рекомендуется при большом числе клиентов и в многоузловых конфигурациях. Установщик может сам поставить PostgreSQL локально либо принять DSN к уже существующему серверу.

В работе бэкенд выбирается переменными окружения (установщик записывает их в `/etc/default/easyxray`):

```
EASYXRAY_DB_TYPE=postgres
EASYXRAY_DB_DSN=postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable
```

### Перенос существующей установки SQLite в PostgreSQL

```bash
easyxray migrate-db --dsn "postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable"
# затем задайте EASYXRAY_DB_TYPE и EASYXRAY_DB_DSN в /etc/default/easyxray и перезапустите:
systemctl restart easyxray
```

Исходный файл SQLite остаётся нетронутым; удалите его вручную, убедившись, что новый бэкенд работает.

### Docker

Команда `docker compose up -d` по умолчанию по-прежнему использует SQLite. Чтобы запустить встроенный сервис PostgreSQL, раскомментируйте две строки с `EASYXRAY_DB_*` в `docker-compose.yml` и запустите с профилем:

```bash
docker compose --profile postgres up -d
```

В образ встроен Fail2ban (включён по умолчанию) — он обеспечивает соблюдение **лимитов IP** по клиентам. Fail2ban блокирует нарушителей через `iptables`, а для этого нужна возможность `NET_ADMIN`. В `docker-compose.yml` она уже выдана через `cap_add`; если запускаете контейнер командой `docker run`, добавьте возможности сами, иначе блокировки будут только записываться в журнал и не применятся:

```bash
docker run -d --cap-add=NET_ADMIN --cap-add=NET_RAW ... ghcr.io/easyxrayteam/easyxray
```

## Переменные окружения

| Переменная | Описание | По умолчанию |
| --- | --- | --- |
| `EASYXRAY_DB_TYPE` | Бэкенд базы данных: `sqlite` или `postgres` | `sqlite` |
| `EASYXRAY_DB_DSN` | Строка подключения к PostgreSQL (при `EASYXRAY_DB_TYPE=postgres`) | — |
| `EASYXRAY_DB_FOLDER` | Каталог файла базы данных SQLite | `/etc/easyxray` |
| `EASYXRAY_DB_MAX_OPEN_CONNS` | Максимум открытых соединений (пул PostgreSQL) | — |
| `EASYXRAY_DB_MAX_IDLE_CONNS` | Максимум простаивающих соединений (пул PostgreSQL) | — |
| `EASYXRAY_PORT` | Переопределяет порт панели (1–65535); приоритетнее сохранённой настройки | — |
| `EASYXRAY_INIT_WEB_BASE_PATH` | Начальный URI-путь веб-панели | `/` |
| `EASYXRAY_ENABLE_FAIL2BAN` | Включает соблюдение лимитов IP через Fail2ban | `true` |
| `EASYXRAY_SKIP_HSTS` | Не отправлять заголовок HSTS — включайте, когда TLS терминируется обратным прокси | `false` |
| `EASYXRAY_LOG_LEVEL` | Подробность журнала (`debug`, `info`, `warning`, `error`) | `info` |
| `EASYXRAY_LOG_FOLDER` | Каталог журналов | `/var/log/easyxray` |
| `EASYXRAY_DEBUG` | Режим отладки | `false` |
| `EASYXRAY_TUNNEL_HEALTH_MONITOR` | Включает монитор работоспособности туннеля (опрашивает URL и перезапускает Xray после серии сбоев; перезапуск обрывает всех клиентов) | `false` |
| `EASYXRAY_TUNNEL_HEALTH_PROXY` | Прокси, через который отправляется проба; укажите локальное входящее Xray, чтобы проба проверяла именно туннель (например, `socks5://127.0.0.1:1080`). Пусто — проверяется только связность хоста | — |
| `EASYXRAY_TUNNEL_HEALTH_URL` | URL, опрашиваемый для проверки туннеля | `https://www.cloudflare.com/cdn-cgi/trace` |
| `EASYXRAY_TUNNEL_HEALTH_INTERVAL` | Интервал между пробами | `30s` |
| `EASYXRAY_TUNNEL_HEALTH_TIMEOUT` | Тайм-аут одной пробы | `10s` |
| `EASYXRAY_TUNNEL_HEALTH_FAILURES` | Сколько подряд неудач запускают перезапуск | `3` |
| `EASYXRAY_TUNNEL_HEALTH_COOLDOWN` | Минимальная пауза между перезапусками | `5m` |
| `NODE_TOKEN_ENCRYPTION` | Шифрование токенов API узлов на диске: `off`, `migration` или `required` (обратите внимание: без префикса `EASYXRAY_`) | `off` |
| `EASYXRAY_NODE_TOKEN_KEY_FILE` | JSON-связка ключей (права `0600`) с идентификатором активного ключа и его 32-байтовыми ключами в base64 | `/etc/easyxray/node_token_key.json` |
| `EASYXRAY_NODE_TOKEN_KEY` | Один 32-байтовый ключ в base64, используется только если файл связки ключей не читается | — |

Полный список — в справочнике переменных окружения на [сайте документации](https://easyxrayteam.github.io/EasyXray/).

## Поддерживаемые языки

Интерфейс панели доступен на 13 языках:

English · فارسی · العربية · 中文（简体） · 中文（繁體） · Español · Русский · Українська · Türkçe · Tiếng Việt · 日本語 · Bahasa Indonesia · Português (Brasil)

## Участие в разработке

Мы рады вкладу сообщества. Перед созданием issue или pull request прочитайте [руководство для участников](/CONTRIBUTING.md).

## Атрибуция и лицензия

EasyXray — **модифицированная производная** проекта [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui). Эта кодовая база основана на коммите `74c3cc38` (линейка 3.10.0) и развивается и распространяется командой EasyXrayTeam под именем EasyXray.

Что EasyXray изменил по сравнению с этой основой: проект полностью переименован. Имя продукта, исполняемый файл и его служба systemd/OpenRC, пути установки, конфигурации, базы данных и журналов, префикс переменных окружения (теперь `EASYXRAY_*`), скрипт управления, пространства имён веб-интерфейса и REST API, путь Go-модуля и публикуемый образ Docker — всё носит имя EasyXray. Помимо этого переименования поведение панели — набор возможностей, обслуживаемые протоколы и способ управления Xray-core — унаследовано от исходного проекта. Конкретные имена и пути приведены в разделах [Пути установки и имена служб](#пути-установки-и-имена-служб) и [Интерфейс панели и HTTP API](#интерфейс-панели-и-http-api).

EasyXray распространяется по **Стандартной общественной лицензии GNU версии 3** (GPL-3.0). Полный текст лицензии — в файле [`LICENSE`](LICENSE). Сторонние компоненты, включённые в проект или используемые им, перечислены в `NOTICE` и `THIRD_PARTY_NOTICES.md`.

Исходный код, соответствующий распространяемым здесь бинарникам, — этот репозиторий: [EasyXrayTeam/EasyXray](https://github.com/EasyXrayTeam/EasyXray).

Этот проект **не одобрен, не спонсируется и никак не связан** с автором оригинального 3x-ui. Это независимая производная работа, публикуемая на условиях GNU GPL.

## Благодарности

Основу интерфейса и возможностей панели EasyXray заложил исходный проект **X-UI** и его преемники; отдельная благодарность [alireza0](https://github.com/alireza0/) за эту основополагающую работу.

Кроме того, панель опирается на следующие проекты или поставляется вместе с ними:

- [Iran v2ray rules](https://github.com/chocolate4u/Iran-v2ray-rules) (Лицензия: **GPL-3.0**): _Улучшенные правила маршрутизации для v2ray/xray и v2ray/xray-clients со встроенными иранскими доменами и упором на безопасность и блокировку рекламы._
- [Russia v2ray rules](https://github.com/runetfreedom/russia-v2ray-rules-dat) (Лицензия: **GPL-3.0**): _Репозиторий содержит автоматически обновляемые правила маршрутизации V2Ray на основе данных о заблокированных доменах и адресах в России._

## Инструменты сообщества

Инструменты и интеграции, созданные сообществом вокруг проекта, от которого происходит эта панель. Учтите, что они рассчитаны на исходное пространство имён API, поэтому для работы с переименованными конечными точками EasyXray `/easyxray/api/v1/…` их, возможно, придётся доработать.

- [terraform-provider-3x-ui](https://github.com/batonogov/terraform-provider-threexui) (Лицензия: **MIT**): _Управление входящими, клиентами, настройками панели и конфигурацией Xray как кодом с помощью Terraform / OpenTofu._
- [3X-UI Manager](https://github.com/yukh975/3X-UI-Manager) (Лицензия: **MIT**): _Нативный Android-клиент для 3x-ui — дашборд, входящие, клиенты с QR-кодами, узлы и управление несколькими панелями. Доступен в F-Droid._

## История звёзд

<a href="https://www.star-history.com/?repos=EasyXrayTeam%2FEasyXray&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
 </picture>
</a>
