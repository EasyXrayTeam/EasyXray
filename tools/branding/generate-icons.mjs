// Rasterizes the EasyXray mark into every PNG/ICO the panel ships.
//
// The SVGs next to this file are the source of truth; the PNGs are build
// artifacts. Re-run `npm run generate` in tools/branding after editing an SVG,
// then rebuild the frontend so the copies under frontend/public/ reach
// internal/web/dist/ (they are embedded with go:embed all:dist).
//
// Writes:
//   frontend/public/icons/easyxray-{16,24,32,64,192,512}.png  PWA + manifest
//   frontend/public/favicon.ico                               16/24/32/48
//   frontend/public/apple-touch-icon.png                      180, opaque
//   media/easyxray-{light,dark}.png                           README hero lockup
//   docs/public/{logo-light,logo-dark,favicon,icon}.png       docs site

import { readFile, writeFile, mkdir } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

import sharp from 'sharp';

const here = dirname(fileURLToPath(import.meta.url));
const repo = resolve(here, '..', '..');

const MARK = join(here, 'easyxray-mark.svg');
const MARK_COMPACT = join(here, 'easyxray-mark-compact.svg');
const LOCKUP_LIGHT = join(here, 'easyxray-lockup-light.svg');
const LOCKUP_DARK = join(here, 'easyxray-lockup-dark.svg');

// The disc's outermost gradient stop, used as the opaque matte behind icons
// whose alpha would otherwise be flattened onto black (iOS, Windows shell).
const BRAND = { r: 0x03, g: 0x06, b: 0x0c, alpha: 1 };

async function render(svgPath, size, outPath) {
  await mkdir(dirname(outPath), { recursive: true });
  const png = await sharp(await readFile(svgPath), { density: 384 })
    .resize(size, size, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png({ compressionLevel: 9 })
    .toBuffer();
  await writeFile(outPath, png);
  return outPath;
}

async function renderOpaque(svgPath, size, outPath) {
  await mkdir(dirname(outPath), { recursive: true });
  const png = await sharp(await readFile(svgPath), { density: 384 })
    .resize(size, size, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .flatten({ background: BRAND })
    .png({ compressionLevel: 9 })
    .toBuffer();
  await writeFile(outPath, png);
  return outPath;
}

// ICO is a 6-byte header, one 16-byte directory entry per image, then the raw
// PNG payloads back to back. Vista+ accepts PNG-compressed entries, which is
// what every current browser and Windows shell reads.
function buildIco(pngs) {
  const header = Buffer.alloc(6);
  header.writeUInt16LE(0, 0); // reserved
  header.writeUInt16LE(1, 2); // type: icon
  header.writeUInt16LE(pngs.length, 4);

  const dir = Buffer.alloc(16 * pngs.length);
  let offset = header.length + dir.length;
  pngs.forEach(({ size, data }, i) => {
    const e = i * 16;
    dir.writeUInt8(size >= 256 ? 0 : size, e + 0); // 0 means 256
    dir.writeUInt8(size >= 256 ? 0 : size, e + 1);
    dir.writeUInt8(0, e + 2); // palette
    dir.writeUInt8(0, e + 3); // reserved
    dir.writeUInt16LE(1, e + 4); // colour planes
    dir.writeUInt16LE(32, e + 6); // bits per pixel
    dir.writeUInt32LE(data.length, e + 8);
    dir.writeUInt32LE(offset, e + 12);
    offset += data.length;
  });

  return Buffer.concat([header, dir, ...pngs.map((p) => p.data)]);
}

const PWA_SIZES = [16, 24, 32, 64, 192, 512];
const ICO_SIZES = [16, 24, 32, 48];

const written = [];

// PWA / manifest icons. The two smallest come from the compact variant: at
// 16-24px the full mark's two orbit strokes land inside the same pixel row.
for (const size of PWA_SIZES) {
  const src = size <= 32 ? MARK_COMPACT : MARK;
  written.push(await render(src, size, join(repo, 'frontend/public/icons', `easyxray-${size}.png`)));
}

// favicon.ico — one file, four sizes, built from the compact variant so the
// 16px entry stays legible in a browser tab.
const icoPngs = [];
for (const size of ICO_SIZES) {
  const data = await sharp(await readFile(MARK_COMPACT), { density: 384 })
    .resize(size, size, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png({ compressionLevel: 9, palette: true })
    .toBuffer();
  icoPngs.push({ size, data });
}
const icoPath = join(repo, 'frontend/public/favicon.ico');
await writeFile(icoPath, buildIco(icoPngs));
written.push(icoPath);

// iOS ignores transparency and composites onto black, so flatten this one.
written.push(await renderOpaque(MARK, 180, join(repo, 'frontend/public/apple-touch-icon.png')));

// README hero lockups.
await mkdir(join(repo, 'media'), { recursive: true });
for (const [src, name] of [
  [LOCKUP_LIGHT, 'easyxray-light.png'],
  [LOCKUP_DARK, 'easyxray-dark.png'],
]) {
  const out = join(repo, 'media', name);
  await sharp(await readFile(src), { density: 384 })
    .resize(400, 200, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png({ compressionLevel: 9 })
    .toFile(out);
  written.push(out);
}

// Docs site assets.
await mkdir(join(repo, 'docs/public'), { recursive: true });
for (const [src, size, name, opaque] of [
  [LOCKUP_LIGHT, null, 'logo-light.png', false],
  [LOCKUP_DARK, null, 'logo-dark.png', false],
  [MARK, 256, 'favicon.png', false],
  [MARK, 512, 'icon.png', false],
]) {
  const out = join(repo, 'docs/public', name);
  const input = await readFile(src);
  let pipeline = sharp(input, { density: 384 });
  pipeline = size
    ? pipeline.resize(size, size, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    : pipeline.resize(400, 200, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } });
  if (opaque) pipeline = pipeline.flatten({ background: BRAND });
  await pipeline.png({ compressionLevel: 9 }).toFile(out);
  written.push(out);
}

for (const p of written) console.log('wrote', p.replace(repo + '\\', '').replace(repo + '/', ''));
console.log(`${written.length} files`);
