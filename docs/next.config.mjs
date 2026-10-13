import { createMDX } from 'fumadocs-mdx/next';

const withMDX = createMDX();

// Set DEPLOY_TARGET=static to produce a fully static export (e.g. for GitHub
// Pages). Search already uses a static index, and OG images are prerendered, so
// the export is self-contained. Default (unset) builds for Vercel/Node hosting.
const isStaticExport = process.env.DEPLOY_TARGET === 'static';

// GitHub Pages serves this project site from a sub-path:
// https://easyxrayteam.github.io/EasyXray/ . Every route and every `_next/`
// asset must therefore be prefixed with `/EasyXray`, otherwise the published
// site 404s on its own CSS/JS/images. Local and Vercel/Node builds stay at the
// domain root, so the prefix is only applied for the static export.
const basePath = isStaticExport ? '/EasyXray' : '';

/** @type {import('next').NextConfig} */
const config = {
  reactStrictMode: true,
  basePath,
  assetPrefix: basePath || undefined,
  // Expose the prefix to components that build raw URLs (public assets, the
  // Storybook link) instead of going through next/link.
  env: { NEXT_PUBLIC_BASE_PATH: basePath },
  // On the static host (GitHub Pages) emit directory-style routes
  // (`en/index.html` rather than `en.html`) so URLs with a trailing slash —
  // including the root `/` → `/en/` redirect — resolve instead of 404ing.
  ...(isStaticExport
    ? { output: 'export', trailingSlash: true, images: { unoptimized: true } }
    : {}),
};

export default withMDX(config);
