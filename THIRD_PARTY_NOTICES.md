# Third-Party Notices

EasyXray is a GPL-3.0 derivative of [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui);
see [`NOTICE`](NOTICE) for the upstream attribution that this section does not replace.

Everything below was read from the license file or the `license` field shipped
inside each dependency as resolved by `go.mod` and `frontend/package.json` at
the time of writing. Versions are pinned in those two files; the versions shown
here are the ones actually resolved. This file lists **direct** dependencies
only — transitive dependencies carry their own licenses, and their notices are
in the corresponding module or package as distributed.

## Upstream project

| Component | License | Copyright |
|---|---|---|
| [MHSanaei/3x-ui](https://github.com/MHSanaei/3x-ui) (base: `74c3cc38`) | GPL-3.0 | MHSanaei and the 3x-ui contributors |
| [alireza0/x-ui](https://github.com/alireza0/x-ui) (via 3x-ui) | GPL-3.0 | alireza0 |

## Go modules

| Module | Version | License |
|---|---|---|
| github.com/amnezia-vpn/amneziawg-go/v3 | v3.1.20260828 | MIT |
| github.com/apernet/quic-go | v0.61.1-0.20260806010916-184d081eef3e | MIT |
| github.com/gin-contrib/gzip | v1.2.8 | MIT |
| github.com/gin-contrib/sessions | v1.1.2 | MIT |
| github.com/gin-gonic/gin | v1.12.0 | MIT |
| github.com/go-ldap/ldap/v3 | v3.4.15 | MIT |
| github.com/go-playground/validator/v10 | v10.30.5 | MIT |
| github.com/goccy/go-json | v0.11.2 | MIT |
| github.com/goccy/go-yaml | v1.19.2 | MIT |
| github.com/google/uuid | v1.6.0 | BSD-3-Clause |
| github.com/gorilla/websocket | v1.5.3 | BSD-2-Clause |
| github.com/jackc/pgx/v5 | v5.11.0 | MIT |
| github.com/joho/godotenv | v1.5.1 | MIT |
| github.com/klauspost/compress | v1.20.1 | BSD-3-Clause (and Apache-2.0 for some files) |
| github.com/mattn/go-sqlite3 | v1.14.52 | MIT |
| github.com/mymmrac/telego | v1.12.1 | MIT |
| github.com/nicksnyder/go-i18n/v2 | v2.6.1 | MIT |
| github.com/op/go-logging | v0.0.0-20160315200505-970db520ece7 | BSD-3-Clause |
| github.com/quic-go/quic-go | v0.63.0 | MIT |
| github.com/refraction-networking/utls | v1.8.3-0.20260301010127-aa6edf4b11af | BSD-3-Clause |
| github.com/robfig/cron/v3 | v3.0.1 | MIT |
| github.com/shirou/gopsutil/v4 | v4.26.9 | BSD-3-Clause |
| github.com/skip2/go-qrcode | v0.0.0-20200617195104-da1b6568686e | MIT |
| github.com/valyala/fasthttp | v1.75.0 | MIT |
| github.com/xlzd/gotp | v0.1.0 | MIT |
| github.com/xtls/xray-core | v1.260327.1-0.20261010092107-701af60772cd | MPL-2.0 |
| go.uber.org/atomic | v1.12.0 | MIT |
| golang.org/x/crypto | v0.58.0 | BSD-3-Clause |
| golang.org/x/net | v0.61.0 | BSD-3-Clause |
| golang.org/x/sys | v0.49.0 | BSD-3-Clause |
| golang.org/x/text | v0.43.0 | BSD-3-Clause |
| google.golang.org/grpc | v1.86.0-dev | Apache-2.0 |
| google.golang.org/protobuf | v1.36.12 | BSD-3-Clause |
| gopkg.in/natefinch/lumberjack.v2 | v2.2.1 | MIT |
| gorm.io/driver/postgres | v1.6.3 | MIT |
| gorm.io/driver/sqlite | v1.6.0 | MIT |
| gorm.io/gorm | v1.31.2 | MIT |
| gvisor.dev/gvisor | v0.0.0-20260122175437-89a5d21be8f0 | Apache-2.0 |
| pgregory.net/rapid | v1.3.0 | MPL-2.0 |

### Note on MPL-2.0 dependencies

`github.com/xtls/xray-core` and `pgregory.net/rapid` are MPL-2.0. They are used
as unmodified library dependencies and are not combined into a larger MPL-covered
work; their source remains available from the module paths above. `xray-core` is
the upstream engine EasyXray drives — EasyXray does not vendor a modified copy of it.

## Frontend packages

| Package | License |
|---|---|
| @ant-design/icons | MIT |
| @codemirror/lang-json | MIT |
| @codemirror/theme-one-dark | MIT |
| @hookform/resolvers | MIT |
| @noble/hashes | MIT |
| @storybook/addon-a11y | MIT |
| @storybook/addon-docs | MIT |
| @storybook/addon-vitest | MIT |
| @storybook/react-vite | MIT |
| @tanstack/react-query | MIT |
| @tanstack/react-query-devtools | MIT |
| @testing-library/dom | MIT |
| @testing-library/react | MIT |
| @types/react | MIT |
| @types/react-dom | MIT |
| @types/swagger-ui-react | MIT |
| @vitejs/plugin-react | MIT |
| @vitest/browser-playwright | MIT |
| @vitest/coverage-v8 | MIT |
| antd | MIT |
| codemirror | MIT |
| dayjs | MIT |
| husky | MIT |
| i18next | MIT |
| jsdom | MIT |
| lint-staged | MIT |
| msw | MIT |
| otpauth | MIT |
| oxfmt | MIT |
| oxlint | MIT |
| oxlint-tsgolint | MIT |
| persian-calendar-suite | MIT |
| playwright | Apache-2.0 |
| react | MIT |
| react-dom | MIT |
| react-hook-form | MIT |
| react-i18next | MIT |
| react-router | MIT |
| storybook | MIT |
| swagger-ui-react | Apache-2.0 |
| typescript | Apache-2.0 |
| uplot | MIT |
| vite | MIT |
| vitest | MIT |
| zod | MIT |

## Documentation site

The `docs/` site is a separate Next.js application with its own dependency tree
(`docs/package.json`) and its own copy of the GPL-3.0 text at `docs/LICENSE`.
Its direct dependencies are MIT/Apache-2.0 licensed.

## Trademarks and third-party projects referenced by name

The following projects are referenced in EasyXray's documentation and UI but are
**not** part of EasyXray, are not covered by its license, and remain the property
of their authors. Their names are used descriptively and are deliberately **not**
rebranded:

- **Xray-core** — https://github.com/XTLS/Xray-core (MPL-2.0)
- **3X-UI Manager** — https://github.com/yukh975/3X-UI-Manager (MIT) — a third-party Android client
- **terraform-provider-3x-ui** — https://github.com/batonogov/terraform-provider-threexui (MIT) — a third-party Terraform provider
- **X-UI** — https://github.com/alireza0/x-ui — the original project EasyXray descends from

## Reporting a missing notice

If you believe a dependency of EasyXray is not covered here, open an issue at
https://github.com/EasyXrayTeam/EasyXray/issues. Do not send security reports
there — see [`SECURITY.md`](SECURITY.md).
