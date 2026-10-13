# Branding assets

The SVGs in this directory are the source of truth for the EasyXray mark. Every
PNG and ICO in the repository is generated from them — do not hand-edit the
raster files, they will be overwritten.

## Sources

| File | What it is |
|---|---|
| `easyxray-mark.svg` | The square mark: dark navy disc, glowing cyan rim, four elliptical orbits at 0/45/90/135°, a nested-triangle core and eight orbit particles. Transparent outside the disc. |
| `easyxray-mark-compact.svg` | Small-size cut of the same mark for 16/24/32px, where the glow passes, the particles and the core's inner triangle all collapse into a single row of pixels. |
| `easyxray-lockup-light.svg` | 400×200 horizontal lockup (mark + wordmark) for light backgrounds. |
| `easyxray-lockup-dark.svg` | The same lockup for dark backgrounds: lighter disc, stronger rim, light wordmark. |

Brand colours: disc `#12314C` → `#08111F` → `#03060C`, orbit cyan `#4FD8EE`,
highlight `#EAFEFF`, deep cyan `#12657E`. The PWA theme colour stays `#22D3EE`
(`frontend/public/manifest.webmanifest`).

Every variant is deliberately built from **stacked strokes rather than an SVG
glow filter** — `feGaussianBlur` renders differently across librsvg, resvg and
browsers, so the "glow" is a wide low-opacity stroke underneath the crisp one,
and the rim's halo is a radial-gradient annulus.

## Geometry

Measured off the master artwork (`341932637.jpg`, 96×96) and kept in one place so
a future edit does not have to re-derive it. All values are in the mark's
512×512 viewBox, centre (256, 256):

| Element | Geometry |
|---|---|
| Disc | `r=224`, radial gradient centred slightly up-left |
| Rim | `r=221`, 6px stroke, plus a bloom annulus out to `r=256` |
| Orbits | four ellipses `rx=174 ry=68`, rotated 0/45/90/135°, 8px stroke |
| Core | triangle apex (256,160), base y=320, half-width 75; inner triangle at 0.55 scale |
| Particles | two per orbit, `r=4`–`4.5` with a soft halo |

The four-orbit reading is not a guess: fitting ellipse sets to the artwork's
stroke pixels covers 94.6% of them at `rx=349 ry=137` (1024px source) versus
53.9% for the closest three-orbit fit.

## Regenerating

```bash
cd tools/branding
npm install
npm run generate
```

This writes:

| Output | Used by |
|---|---|
| `frontend/public/icons/easyxray-{16,24,32,64,192,512}.png` | PWA manifest, `ServePWAIcon` |
| `frontend/public/favicon.ico` | `<link rel="icon">` (16/24/32/48 in one file) |
| `frontend/public/apple-touch-icon.png` | `<link rel="apple-touch-icon">`, flattened onto the brand dark |
| `media/easyxray-{light,dark}.png` | README hero images |
| `docs/public/logo-{light,dark}.png`, `icon.png`, `favicon.png` | documentation site |

The `frontend/public/` copies reach the running panel only after a frontend
build: Vite copies `public/` into `internal/web/dist/`, which the Go binary
embeds with `go:embed all:dist`. The server-side `<head>` links that point at
them are added by `pwaHeadInjection` in `internal/web/controller/dist.go`, and
the routes that serve them are registered in `internal/web/web.go`.

## Provenance

The mark is a **vector trace of the master artwork supplied for the EasyXray
rebrand** — not a new design. Its geometry was measured off that raster (see
above), so the SVG reproduces the original's disc, rim, orbit set, core and
particle placement rather than approximating them by eye. It replaces the
upstream 3x-ui icon set, which was removed from `frontend/public/icons/`.

The raster master is not committed; these SVGs are the source of truth from here
on.
