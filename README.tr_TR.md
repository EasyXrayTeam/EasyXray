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

**EasyXray**, [Xray-core](https://github.com/XTLS/Xray-core) sunucularını çalıştırmak ve yönetmek için geliştirilmiş açık kaynaklı bir web kontrol panelidir. Tek bir VPS'ten çok düğümlü kurulumlara kadar geniş bir proxy ve VPN protokolü yelpazesini kurmak, yapılandırmak ve izlemek için temiz, çok dilli bir arayüz sunar.

Panelin arayüzü ve özellik altyapısı, özgün X-UI projesinden ve onu sürdüren çalışmalardan gelir. EasyXray bu birikimi kendi adıyla ileri taşır: kendi ikili dosyası, servisi, kurulum yolları, ortam değişkeni öneki ve HTTP API ad alanı vardır. Hukuki durum ve projenin kökeni için [Atıf ve lisans](#atıf-ve-lisans) bölümüne bakın.

> [!IMPORTANT]
> Bu proje yalnızca kişisel kullanım için tasarlanmıştır. Lütfen yasa dışı amaçlarla veya üretim ortamlarında kullanmayın.

## Özellikler

- **Çok protokollü gelen bağlantılar** — VLESS, VMess, Trojan, Shadowsocks, WireGuard, AmneziaWG, TUIC v5, Hysteria2, MASQUE, MTProto, HTTP, SOCKS (Mixed), Dokodemo-door / Tunnel ve TUN.
- **Modern taşıma katmanları ve güvenlik** — TCP (Raw), mKCP, WebSocket, gRPC, HTTPUpgrade ve XHTTP; TLS, XTLS ve REALITY ile birlikte.
- **Yerleşik AmneziaWG** — DPI'a dayanıklı WireGuard, panel süreci içinde kullanıcı alanı ağ yığını üzerinde çalışır; çekirdek modülü, DKMS veya ek paket gerekmez.
- **Yerel TUIC v5 sunucusu** — Süreç içinde çalışan Go tabanlı QUIC sunucusu; Xray yönlendirmesi ve istemci bazlı trafik muhasebesi sunar, sunucu tarafında BBR ve New Reno kullanılabilir. CUBIC istemci profilinde korunur, ancak sunucuda şimdilik New Reno'ya düşer.
- **MTProto proxy'leri** — İstemci bazlı FakeTLS sırları, ad-tag'ler ve kotalar; mevcut bağlantılar düşürülmeden anında uygulanır.
- **Fallback** — Xray'in fallback desteğiyle tek portta birden fazla protokol sunma (örneğin 443 üzerinde VLESS ve Trojan).
- **İstemci bazlı yönetim** — Trafik kotaları, bitiş tarihleri, güvenilir adres muafiyetli IP limitleri, HWID cihaz limitleri, planlanmış yenileme döngüleri, canlı çevrimiçi durumu ve tek tıkla paylaşım bağlantıları, QR kodları ve abonelikler.
- **Trafik istatistikleri** — Gelen bağlantı, istemci ve giden bağlantı bazında; sıfırlama denetimleriyle birlikte.
- **Çok düğümlü destek** — Tek panelden birden fazla sunucuyu yönetip ölçeklendirin; gelen bağlantıları diğer düğümlere klonlayabilirsiniz.
- **Giden bağlantılar ve yönlendirme** — WARP, NordVPN, PIA, özel yönlendirme kuralları, yük dengeleyiciler arası devretmeli yük dengeleyiciler ve giden proxy zincirleme. Paketle gelen geosite ve geoip kategorileri doğrudan kural düzenleyicisinden göz atılabilir.
- **Yerleşik abonelik sunucusu** — raw, JSON ve Clash çıktısı; istemcinin User-Agent bilgisine göre otomatik seçilir, ayrıca [özel sayfa şablonları](docs/custom-subscription-templates.md) desteklenir.
- **Uzaktan izleme ve yönetim için Telegram ve Discord botları.**
- **RESTful API** — Kapsamı sınırlandırılabilen ve süresi dolabilen token'lar ile panel içi API başvurusu.
- **Kurulabilir panel (PWA)** — EasyXray'i masaüstüne veya telefon ana ekranına sabitleyin.
- **Esnek depolama** — SQLite (varsayılan) veya PostgreSQL.
- **Koyu ve açık temalı 13 arayüz dili.**
- **Fail2ban entegrasyonu** ile istemci bazlı IP limitlerinin uygulanması.

## Ekran Görüntüleri

Aşağıdaki ekran görüntüleri güncel EasyXray arayüzünü gösterir. Panelin yerleşimi ve tasarımı önceki projeden devralınmıştır; bu sürüm için yeniden tasarlanmamıştır.

<details>
<summary>Genişletmek için tıklayın</summary>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/01-overview-dark.png">
  <img alt="Genel bakış" src="./media/01-overview-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/02-add-inbound-dark.png">
  <img alt="Gelen bağlantılar" src="./media/02-add-inbound-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/03-add-client-dark.png">
  <img alt="İstemci ekle" src="./media/03-add-client-light.png">
</picture>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./media/05-add-nodes-dark.png">
  <img alt="Düğümler" src="./media/05-add-nodes-light.png">
</picture>

</details>

## Hızlı Başlangıç

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh)
```

Belirli bir sürümü kurmak için etiketini ekleyin (örneğin `v1.0.3`):

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) v1.0.3
```

Sürekli güncellenen **dev** derlemesini (kararlı bir sürüm değil, `main` dalındaki her commit için üretilen en son ön sürüm) kurmak için `dev-latest` parametresini verin:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh) dev-latest
```

Kurulum sırasında rastgele bir kullanıcı adı, parola ve erişim yolu oluşturulur. Kurulum bittiğinde `easyxray` komutunu çalıştırarak yönetim menüsünü açabilirsiniz; buradan servisi başlatıp durdurabilir, giriş bilgilerinizi görüntüleyip sıfırlayabilir, SSL sertifikalarını yönetebilir ve daha fazlasını yapabilirsiniz.

Yayımlanan her arşivin yanında bir `.sha256` dosyası bulunur. Hem `install.sh` hem de güncelleyici, arşivi bu özetle doğrular ve uyuşmazlık halinde işlemi durdurur.

Kurulum, yapılandırma, günlük işletim ve eksiksiz API başvurusu dahil tüm belgeler **[easyxrayteam.github.io/EasyXray](https://easyxrayteam.github.io/EasyXray/)** adresindedir.

### Etkileşimsiz kurulum

Kurulum betiği cloud-init için **etkileşimsiz** de çalışır.
`EASYXRAY_NONINTERACTIVE=1` ayarlayın (veya TTY olmayan bir boru üzerinden çalıştırın);
kurulum hiçbir soru sormadan baştan sona tamamlanır, rastgele kimlik bilgileri üretilir
ve bunlar `/etc/easyxray/install-result.env` dosyasına yazılır. Örnekler için [`deploy/`](deploy/) dizinine bakın:

- [Cloud-init user-data](deploy/cloud-init/) — herhangi bir bulut sağlayıcıda (Hetzner/AWS/DO/Vultr/GCP/Azure/Oracle) etkileşimsiz kurulum
- [Hetzner Cloud notları](deploy/marketplace/hetzner/) — Hetzner üzerinde cloud-init ile dağıtım

## Kurulum düzeni ve servis adları

EasyXray'in tüm bileşenleri projeyle aynı adı taşır; böylece aynı sunucudaki başka bir panelle çakışmazlar.

| Öğe | Değer |
| --- | --- |
| İkili dosya | `easyxray` |
| Yönetim menüsü | `easyxray` (`easyxray.sh` üzerinden `/usr/bin/easyxray` konumuna kurulur) |
| Kurulum dizini | `/usr/local/easyxray` |
| Yapılandırma ve veritabanı dizini | `/etc/easyxray` |
| SQLite veritabanı | `/etc/easyxray/EasyXray.db` |
| Günlük dizini / dosyası | `/var/log/easyxray` , `easyxray.log` |
| Ortam değişkenleri | `EASYXRAY_*` |
| systemd birimi | `easyxray.service` (varyantlar: `easyxray.service.debian`, `.arch`, `.rhel`) |
| OpenRC servisi | `easyxray` (`easyxray.rc` dosyasından) |
| Go modülü | `github.com/EasyXrayTeam/EasyXray/v3` |
| Panel sürümü | `1.0.0` |

## Panel arayüzü ve HTTP API

Web kök yolu varsayılan değeri olan `/` iken panel şu adreslerden sunulur:

| Yüzey | Yol |
| --- | --- |
| Panel arayüzü | `/easyxray/…` |
| REST API | `/easyxray/api/v1/…` — örneğin `/easyxray/api/v1/inbounds/list` |
| WebSocket | `/easyxray/ws` |
| OpenAPI tanımı | `/easyxray/api/v1/openapi.json` |

Bu adreslerin tümü yapılandırdığınız web kök yolunun **altında** yer alır; kök yolu `/panelim` olan bir panelde arayüz `/panelim/easyxray/…`, API ise `/panelim/easyxray/api/v1/…` olur.

> [!WARNING]
> Bu sürüm API ad alanının tamamını yeniden adlandırıyor. Eski `/panel/api/…` yolları geriye dönük uyumluluk için **takma ad olarak korunmuyor** — bu yollara yapılan istekler yanıtlanmaz. 3x-ui dönemine ait API'ye göre yazılmış her harici entegrasyonun, çalışmaya devam etmesi için `/easyxray/api/v1/…` yollarına güncellenmesi gerekir.

## 3x-ui'den geçiş

EasyXray **sıfırdan bir kurulumdur**. Var olan bir 3x-ui kurulumunu algılamaz, devralmaz veya taşımaz ve hiçbir şey otomatik olarak dönüştürülmez: servis adı, kurulum dizini, yapılandırma ve veritabanı dizini, ortam değişkeni öneki, veritabanı dosya adı ve API ad alanı farklıdır ve ikisi arasında bir geçiş yolu sunulmaz.

3x-ui'den geçiyorsanız eski paneli çalışır durumda bırakın, ihtiyacınız olanları oradan dışa aktarın (gelen bağlantı ve istemci listeleri, paylaşım bağlantıları, Xray yapılandırması, sertifikalar), ardından EasyXray'i kurup bu yapılandırmayı yeni panelde yeniden oluşturun. Herhangi bir şeyi silmeden veya değiştirmeden önce eski veritabanının yedeğini alın.

## Desteklenen Platformlar

**İşletim sistemleri:** Ubuntu, Debian, Armbian, Fedora, CentOS, RHEL, AlmaLinux, Rocky Linux, Oracle Linux, Amazon Linux, Virtuozzo, Arch, Manjaro, Parch, openSUSE (Tumbleweed / Leap), Alpine ve Windows.

**Mimari:** `amd64` · `386` · `arm64` (aarch64) · `armv7` · `armv6` · `armv5` · `s390x`.

## Veritabanı Seçenekleri

EasyXray, kurulum sırasında seçilen iki arka ucu destekler:

- **SQLite** (varsayılan) — `/etc/easyxray/EasyXray.db` konumunda tek bir dosya. Hiç kurulum gerektirmez; küçük ve orta ölçekli kurulumlar için idealdir.
- **PostgreSQL** — çok sayıda istemci veya çok düğümlü kurulumlar için önerilir. Kurulum betiği PostgreSQL'i sizin için yerel olarak kurabilir ya da mevcut bir sunucuya ait DSN kabul edebilir.

Çalışma anında arka uç ortam değişkenleriyle seçilir (kurulum betiği bunları sizin için `/etc/default/easyxray` dosyasına yazar):

```
EASYXRAY_DB_TYPE=postgres
EASYXRAY_DB_DSN=postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable
```

### Mevcut bir SQLite kurulumunu PostgreSQL'e taşıma

```bash
easyxray migrate-db --dsn "postgres://easyxray:password@127.0.0.1:5432/easyxray?sslmode=disable"
# ardından /etc/default/easyxray içindeki EASYXRAY_DB_TYPE ve EASYXRAY_DB_DSN değerlerini ayarlayıp yeniden başlatın:
systemctl restart easyxray
```

Kaynak SQLite dosyası olduğu gibi bırakılır; yeni arka ucu doğruladıktan sonra elle silin.

### Docker

Varsayılan `docker compose up -d` komutu SQLite kullanmaya devam eder. Paketle gelen PostgreSQL servisiyle çalıştırmak için `docker-compose.yml` dosyasındaki iki `EASYXRAY_DB_*` ortam satırının yorumunu kaldırın ve profile ile başlatın:

```bash
docker compose --profile postgres up -d
```

İmaj, istemci bazlı **IP limitlerini** uygulamak için Fail2ban'i (varsayılan olarak etkin) içerir. Fail2ban ihlal edenleri `iptables` ile engeller; bu da `NET_ADMIN` yeteneğini gerektirir. `docker-compose.yml` bunu `cap_add` ile zaten veriyor; kapsayıcıyı `docker run` ile başlatırsanız yetenekleri kendiniz ekleyin, aksi halde engellemeler yalnızca günlüğe yazılır ve hiçbir zaman uygulanmaz:

```bash
docker run -d --cap-add=NET_ADMIN --cap-add=NET_RAW ... ghcr.io/easyxrayteam/easyxray
```

## Ortam Değişkenleri

| Değişken | Açıklama | Varsayılan |
| --- | --- | --- |
| `EASYXRAY_DB_TYPE` | Veritabanı arka ucu: `sqlite` veya `postgres` | `sqlite` |
| `EASYXRAY_DB_DSN` | PostgreSQL bağlantı dizesi (`EASYXRAY_DB_TYPE=postgres` iken) | — |
| `EASYXRAY_DB_FOLDER` | SQLite veritabanı dosyasının dizini | `/etc/easyxray` |
| `EASYXRAY_DB_MAX_OPEN_CONNS` | En fazla açık bağlantı sayısı (PostgreSQL havuzu) | — |
| `EASYXRAY_DB_MAX_IDLE_CONNS` | En fazla boşta bağlantı sayısı (PostgreSQL havuzu) | — |
| `EASYXRAY_PORT` | Panel portunu geçersiz kılar (1–65535); kayıtlı ayardan önceliklidir | — |
| `EASYXRAY_INIT_WEB_BASE_PATH` | Web panelinin başlangıç URI yolu | `/` |
| `EASYXRAY_ENABLE_FAIL2BAN` | Fail2ban tabanlı IP limiti uygulamasını etkinleştirir | `true` |
| `EASYXRAY_SKIP_HSTS` | HSTS başlığını atlar; TLS'i ters proxy sonlandırıyorsa bunu açın | `false` |
| `EASYXRAY_LOG_LEVEL` | Günlük ayrıntı düzeyi (`debug`, `info`, `warning`, `error`) | `info` |
| `EASYXRAY_LOG_FOLDER` | Günlük çıktı dizini | `/var/log/easyxray` |
| `EASYXRAY_DEBUG` | Hata ayıklama modunu açar | `false` |
| `EASYXRAY_TUNNEL_HEALTH_MONITOR` | Tünel sağlık izleyicisini açar (bir URL'yi yoklar ve art arda başarısızlıkta Xray'i yeniden başlatır; yeniden başlatma tüm istemcileri düşürür) | `false` |
| `EASYXRAY_TUNNEL_HEALTH_PROXY` | Yoklamanın gönderileceği proxy; yerel bir Xray gelen bağlantısına yönlendirirseniz yoklama gerçekten tüneli test eder (örneğin `socks5://127.0.0.1:1080`). Boş bırakılırsa yalnızca sunucu bağlantısı kontrol edilir | — |
| `EASYXRAY_TUNNEL_HEALTH_URL` | Tünel sağlığı için yoklanan URL | `https://www.cloudflare.com/cdn-cgi/trace` |
| `EASYXRAY_TUNNEL_HEALTH_INTERVAL` | Yoklamalar arası süre | `30s` |
| `EASYXRAY_TUNNEL_HEALTH_TIMEOUT` | Yoklama başına zaman aşımı | `10s` |
| `EASYXRAY_TUNNEL_HEALTH_FAILURES` | Yeniden başlatmayı tetikleyen art arda başarısızlık sayısı | `3` |
| `EASYXRAY_TUNNEL_HEALTH_COOLDOWN` | Ardışık yeniden başlatmalar arasındaki en kısa süre | `5m` |
| `NODE_TOKEN_ENCRYPTION` | Düğüm API token'ları için diskte şifreleme: `off`, `migration` veya `required` (dikkat: `EASYXRAY_` öneki yok) | `off` |
| `EASYXRAY_NODE_TOKEN_KEY_FILE` | Etkin anahtar kimliğini ve base64 32 baytlık anahtarlarını tutan JSON anahtarlık dosyası (izin `0600`) | `/etc/easyxray/node_token_key.json` |
| `EASYXRAY_NODE_TOKEN_KEY` | Tek bir base64 32 baytlık anahtar; yalnızca anahtarlık dosyası okunamadığında kullanılır | — |

Listenin tamamı [dokümantasyon sitesindeki](https://easyxrayteam.github.io/EasyXray/) ortam değişkenleri başvurusunda yer alır.

## Desteklenen Diller

Panel arayüzü 13 dilde sunulur:

English · فارسی · العربية · 中文（简体） · 中文（繁體） · Español · Русский · Українська · Türkçe · Tiếng Việt · 日本語 · Bahasa Indonesia · Português (Brasil)

## Katkıda Bulunma

Katkılara açığız. Bir issue veya pull request açmadan önce lütfen [Katkı Rehberi](/CONTRIBUTING.md) belgesini okuyun.

## Atıf ve lisans

EasyXray, [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui) projesinin **değiştirilmiş bir türevidir**. Bu kod tabanı, `74c3cc38` numaralı upstream commit'ini (3.10.0 serisi) temel alır ve EasyXrayTeam tarafından EasyXray adıyla geliştirilip dağıtılır.

EasyXray'in bu temele göre değiştirdikleri: proje baştan sona yeniden adlandırıldı. Ürün adı, ikili dosya ve systemd/OpenRC servisi, kurulum, yapılandırma, veritabanı ve günlük yolları, ortam değişkeni öneki (artık `EASYXRAY_*`), yönetim betiği, panel arayüzü ve REST API ad alanları, Go modül yolu ve paketlenen Docker imajı EasyXray adını taşır. Bu yeniden adlandırmanın dışında panelin davranışı — özellik kümesi, sunduğu protokoller ve Xray-core'u yönetme biçimi — upstream projeden devralınmıştır. Somut adlar ve yollar için [Kurulum düzeni ve servis adları](#kurulum-düzeni-ve-servis-adları) ile [Panel arayüzü ve HTTP API](#panel-arayüzü-ve-http-api) bölümlerine bakın.

EasyXray, **GNU Genel Kamu Lisansı sürüm 3.0** (GPL-3.0) ile lisanslanmıştır. Lisansın tam metni [`LICENSE`](LICENSE) dosyasındadır. Projeye dahil edilen veya projenin bağımlı olduğu üçüncü taraf bileşenler `NOTICE` ve `THIRD_PARTY_NOTICES.md` dosyalarında kayıtlıdır.

Burada dağıtılan ikili dosyalara karşılık gelen kaynak kod bu depodur: [EasyXrayTeam/EasyXray](https://github.com/EasyXrayTeam/EasyXray).

Bu proje, 3x-ui'nin upstream yazarı tarafından **onaylanmamış, desteklenmemiş ve onunla hiçbir şekilde ilişkili değildir**. GNU GPL koşulları altında yayımlanan bağımsız bir türev çalışmadır.

## Teşekkür & Atıf

EasyXray panelinin arayüz ve özellik altyapısı, özgün **X-UI** projesinden ve onu sürdüren çalışmalardan gelir; bu temel emeği için [alireza0](https://github.com/alireza0/)'a özellikle teşekkür ederiz.

Ayrıca panel şu projelere dayanır veya onlarla birlikte dağıtılır:

- [Iran v2ray rules](https://github.com/chocolate4u/Iran-v2ray-rules) (Lisans: **GPL-3.0**): _İran alan adları yerleşik, güvenlik ve reklam engelleme odaklı gelişmiş v2ray/xray ve v2ray/xray-clients yönlendirme kuralları._
- [Russia v2ray rules](https://github.com/runetfreedom/russia-v2ray-rules-dat) (Lisans: **GPL-3.0**): _Bu depo, Rusya'da engellenen alan adları ve adreslere ilişkin verilere dayanarak otomatik güncellenen V2Ray yönlendirme kurallarını içerir._

## Topluluk Araçları

Bu panelin geldiği proje etrafında topluluk tarafından geliştirilmiş araçlar ve entegrasyonlar. Bunların upstream API ad alanını hedeflediğini unutmayın; EasyXray'in yeniden adlandırılmış `/easyxray/api/v1/…` uç noktalarıyla çalışmadan önce güncellenmeleri gerekebilir.

- [terraform-provider-3x-ui](https://github.com/batonogov/terraform-provider-threexui) (Lisans: **MIT**): _Gelen bağlantıları, istemcileri, panel ayarlarını ve Xray yapılandırmasını Terraform / OpenTofu ile kod olarak yönetin._
- [3X-UI Manager](https://github.com/yukh975/3X-UI-Manager) (Lisans: **MIT**): _3x-ui için yerel Android istemcisi — kontrol paneli, gelen bağlantılar, QR ile paylaşımlı istemciler, düğümler ve çoklu panel yönetimi. F-Droid'de mevcut._

## Yıldız Geçmişi

<a href="https://www.star-history.com/?repos=EasyXrayTeam%2FEasyXray&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=easyxrayteam/easyxray&type=date&legend=top-left" />
 </picture>
</a>
