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

**EasyXray** es un panel de control web de código abierto para ejecutar y administrar servidores [Xray-core](https://github.com/XTLS/Xray-core). Ofrece una interfaz limpia y multilingüe para desplegar, configurar y supervisar una amplia variedad de protocolos de proxy y VPN, tanto si ejecutas un único VPS como si gestionas toda una flota de nodos.

La interfaz y las bases funcionales del panel provienen del proyecto original X-UI y de sus continuadores. EasyXray retoma ese trabajo con nombre propio: su propio binario, servicio, rutas de instalación, prefijo de variables de entorno y espacio de nombres de la API HTTP. Para conocer el marco legal y el linaje del proyecto, consulta [Atribución y licencia](#atribución-y-licencia).

> [!IMPORTANT]
> Este proyecto está pensado únicamente para uso personal. No lo utilices con fines ilegales ni en entornos de producción.

## Características

- **Entradas multiprotocolo** — VLESS, VMess, Trojan, Shadowsocks, WireGuard, AmneziaWG, TUIC v5, Hysteria2, MASQUE, MTProto, HTTP, SOCKS (Mixed), Dokodemo-door / Tunnel y TUN.
- **Transportes y seguridad modernos** — TCP (Raw), mKCP, WebSocket, gRPC, HTTPUpgrade y XHTTP, con TLS, XTLS y REALITY.
- **AmneziaWG integrado** — el WireGuard resistente al DPI se ejecuta dentro del panel sobre una pila de red en espacio de usuario: sin módulo del kernel, sin DKMS y sin paquetes adicionales.
- **Servidor TUIC v5 nativo** — servidor QUIC en Go dentro del propio proceso, con enrutamiento de Xray y contabilidad de tráfico por cliente; en el servidor puedes elegir BBR o New Reno. CUBIC se conserva en el perfil del cliente, pero en el servidor sigue recurriendo a New Reno.
- **Proxies MTProto** — secretos FakeTLS, ad-tags y cuotas por cliente, aplicados en caliente sin cortar las conexiones existentes.
- **Fallbacks** — sirve varios protocolos en un mismo puerto (por ejemplo VLESS y Trojan en el 443) gracias al soporte de fallback de Xray.
- **Gestión por cliente** — cuotas de tráfico, fechas de caducidad, límites de IP con excepciones para direcciones de confianza, límites de dispositivos por HWID, ciclos de renovación programados, estado en línea en tiempo real y enlaces para compartir, códigos QR y suscripciones con un solo clic.
- **Estadísticas de tráfico** — por entrada, por cliente y por salida, con controles de reinicio.
- **Compatibilidad multinodo** — administra y escala varios servidores desde un único panel, incluida la clonación de entradas en otros nodos.
- **Salidas y enrutamiento** — WARP, NordVPN, PIA, reglas de enrutamiento personalizadas, balanceadores de carga con conmutación entre balanceadores y encadenamiento de proxies de salida. Las categorías incluidas de geosite y geoip se pueden explorar directamente desde el editor de reglas.
- **Servidor de suscripciones integrado** — salida raw, JSON y Clash, elegida automáticamente según el User-Agent del cliente, además de [plantillas de página personalizadas](docs/custom-subscription-templates.md).
- **Bots de Telegram y Discord** para supervisión y administración remotas.
- **API RESTful** con tokens de ámbito limitado y caducidad opcional, y una referencia de la API dentro del propio panel.
- **Panel instalable (PWA)** — ancla EasyXray al escritorio o a la pantalla de inicio del móvil.
- **Almacenamiento flexible** — SQLite (por defecto) o PostgreSQL.
- **13 idiomas de interfaz** con temas claro y oscuro.
- **Integración con Fail2ban** para aplicar los límites de IP por cliente.

## Capturas de pantalla

Las capturas siguientes muestran la interfaz actual de EasyXray. El diseño y la disposición del panel se heredan del proyecto original; en esta versión no se ha rediseñado nada.

<details>
<summary>Haz clic para desplegar</summary>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/01-overview-dark.png">
  <img alt="Resumen" src="./media/01-overview-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/02-add-inbound-dark.png">
  <img alt="Entradas" src="./media/02-add-inbound-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/03-add-client-dark.png">
  <img alt="Añadir cliente" src="./media/03-add-client-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/05-add-nodes-dark.png">
  <img alt="Nodos" src="./media/05-add-nodes-light.png">
</picture>

</details>

## Inicio Rápido

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh)
```

Para instalar una versión concreta, añade su etiqueta (por ejemplo `v1.0.3`):

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) v1.0.3
```

Para instalar la compilación **dev** continua (la prepublicación más reciente de cada commit en `main`, no una versión estable), pasa `dev-latest`:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) dev-latest
```

Durante la instalación se generan un nombre de usuario, una contraseña y una ruta de acceso aleatorios. Cuando termine, ejecuta `easyxray` para abrir el menú de gestión, desde el que puedes iniciar y detener el servicio, consultar o restablecer tus credenciales, gestionar certificados SSL y mucho más.

Cada paquete publicado incluye a su lado un archivo `.sha256`. Tanto `install.sh` como el actualizador comprueban el archivo comprimido contra esa suma y se detienen si no coincide.

Toda la documentación —instalación, configuración, operación diaria y la referencia completa de la API— está en **[easyxrayteam.github.io/EasyXray](https://easyxrayteam.github.io/EasyXray/)**.

### Instalación desatendida

El instalador también funciona **sin interacción** para cloud-init.
Define `EASYXRAY_NONINTERACTIVE=1` (o ejecútalo en una tubería sin TTY) y completará
la instalación de principio a fin sin ninguna pregunta, generando credenciales
aleatorias y escribiéndolas en `/etc/easyxray/install-result.env`. Consulta [`deploy/`](deploy/) para ver:

- [Cloud-init user-data](deploy/cloud-init/) — instalación desatendida en cualquier nube (Hetzner/AWS/DO/Vultr/GCP/Azure/Oracle)
- [Notas sobre Hetzner Cloud](deploy/marketplace/hetzner/) — despliegue con cloud-init en Hetzner

## Rutas de instalación y nombres de servicio

Todos los componentes de EasyXray llevan el nombre del proyecto, de modo que nunca entran en conflicto con otro panel instalado en el mismo host.

| Elemento | Valor |
| --- | --- |
| Binario | `easyxray` |
| Menú de gestión | `easyxray` (instalado en `/usr/bin/easyxray`, a partir de `easyxray.sh`) |
| Directorio de instalación | `/usr/local/easyxray` |
| Directorio de configuración y base de datos | `/etc/easyxray` |
| Base de datos SQLite | `/etc/easyxray/EasyXray.db` |
| Directorio / archivo de registro | `/var/log/easyxray` , `easyxray.log` |
| Variables de entorno | `EASYXRAY_*` |
| Unidad systemd | `easyxray.service` (variantes: `easyxray.service.debian`, `.arch`, `.rhel`) |
| Servicio OpenRC | `easyxray` (a partir de `easyxray.rc`) |
| Módulo Go | `github.com/EasyXrayTeam/EasyXray/v3` |
| Versión del panel | `1.0.0` |

## Interfaz del panel y API HTTP

Con la ruta base web configurada en `/` (su valor por defecto), el panel se sirve desde:

| Superficie | Ruta |
| --- | --- |
| Interfaz del panel | `/easyxray/…` |
| API REST | `/easyxray/api/v1/…`, por ejemplo `/easyxray/api/v1/inbounds/list` |
| WebSocket | `/easyxray/ws` |
| Especificación OpenAPI | `/easyxray/api/v1/openapi.json` |

Todas estas rutas quedan **debajo** de la ruta base web que configures: un panel con ruta base `/mipanel` sirve su interfaz en `/mipanel/easyxray/…` y su API en `/mipanel/easyxray/api/v1/…`.

> [!WARNING]
> Esta versión renombra por completo el espacio de nombres de la API. Las rutas antiguas `/panel/api/…` **no** se conservan como alias compatibles: las peticiones a esas rutas no recibirán respuesta. Cualquier integración externa escrita contra la API de la época de 3x-ui deberá actualizarse a las rutas `/easyxray/api/v1/…` antes de volver a funcionar.

## Actualizar desde 3x-ui

EasyXray es una **instalación desde cero**. No detecta, adopta ni migra una instalación de 3x-ui existente, y no convierte nada automáticamente: el nombre del servicio, el directorio de instalación, el directorio de configuración y base de datos, el prefijo de las variables de entorno, el nombre del archivo de base de datos y el espacio de nombres de la API son distintos, y no se ofrece ninguna vía de migración entre ambos.

Si vienes de 3x-ui, mantén el panel antiguo en funcionamiento, exporta lo que necesites (listas de entradas y clientes, enlaces para compartir, configuración de Xray, certificados), instala EasyXray y vuelve a crear esa configuración en el panel nuevo. Haz una copia de seguridad de la base de datos antigua antes de eliminar o reemplazar nada.

## Plataformas Compatibles

**Sistemas operativos:** Ubuntu, Debian, Armbian, Fedora, CentOS, RHEL, AlmaLinux, Rocky Linux, Oracle Linux, Amazon Linux, Virtuozzo, Arch, Manjaro, Parch, openSUSE (Tumbleweed / Leap), Alpine y Windows.

**Arquitecturas:** `amd64` · `386` · `arm64` (aarch64) · `armv7` · `armv6` · `armv5` · `s390x`.

## Opciones de Base de Datos

EasyXray admite dos backends, que se eligen durante la instalación:

- **SQLite** (por defecto) — un único archivo en `/etc/easyxray/EasyXray.db`. Cero configuración, ideal para despliegues pequeños y medianos.
- **PostgreSQL** — recomendado cuando hay muchos clientes o en montajes multinodo. El instalador puede instalar PostgreSQL localmente por ti, o aceptar un DSN hacia un servidor existente.

En tiempo de ejecución el backend se selecciona mediante variables de entorno (el instalador las escribe en `/etc/default/easyxray`):

```
EASYXRAY_DB_TYPE=postgres
EASYXRAY_DB_DSN=postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable
```

### Migrar una instalación de SQLite existente a PostgreSQL

```bash
easyxray migrate-db --dsn "postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable"
# luego define EASYXRAY_DB_TYPE y EASYXRAY_DB_DSN en /etc/default/easyxray y reinicia:
systemctl restart easyxray
```

El archivo SQLite de origen no se modifica; elimínalo manualmente cuando hayas verificado el nuevo backend.

### Docker

El `docker compose up -d` predeterminado sigue usando SQLite. Para ejecutar con el servicio PostgreSQL incluido, descomenta las dos líneas de entorno `EASYXRAY_DB_*` en `docker-compose.yml` y arranca con el perfil:

```bash
docker compose --profile postgres up -d
```

La imagen incluye Fail2ban (activado por defecto) para aplicar los **límites de IP** por cliente. Fail2ban bloquea a los infractores con `iptables`, lo que requiere la capacidad `NET_ADMIN`. `docker-compose.yml` ya la concede mediante `cap_add`; si arrancas el contenedor con `docker run`, añade tú las capacidades, o los bloqueos se registrarán pero nunca se aplicarán:

```bash
docker run -d --cap-add=NET_ADMIN --cap-add=NET_RAW ... ghcr.io/easyxrayteam/easyxray
```

## Variables de Entorno

| Variable | Descripción | Valor por defecto |
| --- | --- | --- |
| `EASYXRAY_DB_TYPE` | Backend de base de datos: `sqlite` o `postgres` | `sqlite` |
| `EASYXRAY_DB_DSN` | Cadena de conexión de PostgreSQL (con `EASYXRAY_DB_TYPE=postgres`) | — |
| `EASYXRAY_DB_FOLDER` | Directorio del archivo de base de datos SQLite | `/etc/easyxray` |
| `EASYXRAY_DB_MAX_OPEN_CONNS` | Conexiones abiertas máximas (pool de PostgreSQL) | — |
| `EASYXRAY_DB_MAX_IDLE_CONNS` | Conexiones inactivas máximas (pool de PostgreSQL) | — |
| `EASYXRAY_PORT` | Sobrescribe el puerto del panel (1–65535); tiene prioridad sobre el ajuste guardado | — |
| `EASYXRAY_INIT_WEB_BASE_PATH` | Ruta URI inicial del panel web | `/` |
| `EASYXRAY_ENABLE_FAIL2BAN` | Activa la aplicación de límites de IP con Fail2ban | `true` |
| `EASYXRAY_SKIP_HSTS` | Omite la cabecera HSTS; actívalo cuando un proxy inverso termina el TLS | `false` |
| `EASYXRAY_LOG_LEVEL` | Nivel de detalle del registro (`debug`, `info`, `warning`, `error`) | `info` |
| `EASYXRAY_LOG_FOLDER` | Directorio de salida de los registros | `/var/log/easyxray` |
| `EASYXRAY_DEBUG` | Activa el modo de depuración | `false` |
| `EASYXRAY_TUNNEL_HEALTH_MONITOR` | Activa el monitor de salud del túnel (sonda una URL y reinicia Xray tras fallos repetidos; un reinicio corta a todos los clientes) | `false` |
| `EASYXRAY_TUNNEL_HEALTH_PROXY` | Proxy por el que se envía la sonda; apúntalo a una entrada local de Xray para que la prueba ejercite el túnel (por ejemplo `socks5://127.0.0.1:1080`). Vacío significa que la sonda solo comprueba la conectividad del host | — |
| `EASYXRAY_TUNNEL_HEALTH_URL` | URL sondeada para la salud del túnel | `https://www.cloudflare.com/cdn-cgi/trace` |
| `EASYXRAY_TUNNEL_HEALTH_INTERVAL` | Intervalo entre sondas | `30s` |
| `EASYXRAY_TUNNEL_HEALTH_TIMEOUT` | Tiempo de espera por sonda | `10s` |
| `EASYXRAY_TUNNEL_HEALTH_FAILURES` | Fallos consecutivos antes de desencadenar un reinicio | `3` |
| `EASYXRAY_TUNNEL_HEALTH_COOLDOWN` | Retardo mínimo entre reinicios consecutivos | `5m` |
| `NODE_TOKEN_ENCRYPTION` | Cifrado en reposo de los tokens de la API de nodos: `off`, `migration` o `required` (atención: sin prefijo `EASYXRAY_`) | `off` |
| `EASYXRAY_NODE_TOKEN_KEY_FILE` | Anillo de claves JSON (modo `0600`) con el id de la clave activa y sus claves de 32 bytes en base64 | `/etc/easyxray/node_token_key.json` |
| `EASYXRAY_NODE_TOKEN_KEY` | Una única clave de 32 bytes en base64, usada solo si no se puede cargar el archivo de claves | — |

La lista completa está en la referencia de variables de entorno del [sitio de documentación](https://easyxrayteam.github.io/EasyXray/).

## Idiomas Compatibles

La interfaz del panel está disponible en 13 idiomas:

English · فارسی · العربية · 中文（简体） · 中文（繁體） · Español · Русский · Українська · Türkçe · Tiếng Việt · 日本語 · Bahasa Indonesia · Português (Brasil)

## Contribuir

Las contribuciones son bienvenidas. Antes de abrir una incidencia o una pull request, lee la [Guía de contribución](/CONTRIBUTING.md).

## Atribución y licencia

EasyXray es una **obra derivada modificada** de [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui). Este código parte del commit `74c3cc38` upstream (la línea 3.10.0) y lo desarrolla y distribuye EasyXrayTeam bajo el nombre EasyXray.

Qué cambió EasyXray respecto a esa base: el proyecto se rebautizó por completo. El nombre del producto, el binario y su servicio systemd/OpenRC, las rutas de instalación, configuración, base de datos y registros, el prefijo de las variables de entorno (ahora `EASYXRAY_*`), el script de gestión, los espacios de nombres de la interfaz y de la API REST, la ruta del módulo Go y la imagen Docker publicada llevan todos el nombre EasyXray. Al margen de ese cambio de marca, el comportamiento del panel —su conjunto de funciones, los protocolos que sirve y la forma en que controla Xray-core— se hereda del proyecto original. Los nombres y rutas concretos están en [Rutas de instalación y nombres de servicio](#rutas-de-instalación-y-nombres-de-servicio) y [Interfaz del panel y API HTTP](#interfaz-del-panel-y-api-http).

EasyXray se distribuye bajo la **Licencia Pública General de GNU v3.0** (GPL-3.0). El texto completo de la licencia está en [`LICENSE`](LICENSE). Los componentes de terceros incluidos o de los que depende el proyecto están documentados en `NOTICE` y `THIRD_PARTY_NOTICES.md`.

El código fuente correspondiente a los binarios aquí distribuidos es este repositorio: [EasyXrayTeam/EasyXray](https://github.com/EasyXrayTeam/EasyXray).

Este proyecto **no cuenta con el respaldo del autor original de 3x-ui, ni está patrocinado por él ni afiliado a él** de ninguna manera. Es una obra derivada independiente publicada bajo los términos de la GNU GPL.

## Reconocimientos

La interfaz y las bases funcionales del panel de EasyXray proceden del proyecto original **X-UI** a través de sus continuadores, y agradecemos especialmente a [alireza0](https://github.com/alireza0/) ese trabajo fundacional.

Además, este panel se apoya en los siguientes proyectos o los distribuye junto a él:

- [Iran v2ray rules](https://github.com/chocolate4u/Iran-v2ray-rules) (Licencia: **GPL-3.0**): _Reglas de enrutamiento mejoradas para v2ray/xray y v2ray/xray-clients, con dominios iraníes integrados y enfoque en la seguridad y el bloqueo de publicidad._
- [Russia v2ray rules](https://github.com/runetfreedom/russia-v2ray-rules-dat) (Licencia: **GPL-3.0**): _Este repositorio contiene reglas de enrutamiento de V2Ray actualizadas automáticamente a partir de datos sobre dominios y direcciones bloqueados en Rusia._

## Herramientas de la Comunidad

Herramientas e integraciones creadas por la comunidad en torno al proyecto del que desciende este panel. Ten en cuenta que apuntan al espacio de nombres de la API original, por lo que puede que necesiten adaptarse antes de funcionar con los endpoints renombrados `/easyxray/api/v1/…` de EasyXray.

- [terraform-provider-3x-ui](https://github.com/batonogov/terraform-provider-threexui) (Licencia: **MIT**): _Gestiona inbounds, clientes, ajustes del panel y configuración de Xray como código con Terraform / OpenTofu._
- [3X-UI Manager](https://github.com/yukh975/3X-UI-Manager) (Licencia: **MIT**): _Cliente nativo de Android para 3x-ui: panel de control, inbounds, clientes con compartición por QR, nodos y gestión de múltiples paneles. Disponible en F-Droid._

## Historial de estrellas

<a href="https://www.star-history.com/?repos=EasyXrayTeam%2FEasyXray&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
 </picture>
</a>
