export const appName = 'EasyXray';
export const appTagline = 'Advanced web panel for managing Xray-core servers';

export const docsRoute = '/docs';
export const docsImageRoute = '/og/docs';
export const docsContentRoute = '/llms.mdx/docs';

// The EasyXray product repository — used for the navbar GitHub link,
// build-time star/release stats, and install commands.
export const productRepo = {
  user: 'EasyXrayTeam',
  repo: 'EasyXray',
  branch: 'main',
};

// Where these docs live in the EasyXray monorepo — used for "Edit on GitHub" links.
export const gitConfig = {
  user: 'EasyXrayTeam',
  repo: 'EasyXray',
  branch: 'main',
  docsDir: 'docs/content/docs',
};

// URL prefix the site is served under. Empty for the domain root (local dev,
// Vercel/Node); `/EasyXray` for the GitHub Pages project site. Keep in sync with
// `basePath` in next.config.mjs — used by components that emit raw asset URLs.
export const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? '';

export const productRepoUrl = `https://github.com/${productRepo.user}/${productRepo.repo}`;

// AI-generated interactive wiki of the EasyXray codebase.
export const deepWikiUrl = `https://deepwiki.com/${productRepo.user}/${productRepo.repo}`;

// Community channel of the upstream X-UI project. EasyXray is a fork and has no
// channel of its own, so the link is presented as an upstream resource rather
// than as an official EasyXray channel.
export const telegramChannel = 'XrayUI';
export const telegramChannelUrl = `https://t.me/${telegramChannel}`;

// Public site origin, used for metadataBase / canonical URLs / OG images.
// Defaults to the production domain, so the env var is optional. Use `||` (not
// `??`) so an empty string — e.g. an unset `${{ vars.NEXT_PUBLIC_SITE_URL }}`
// in CI — also falls back instead of shipping a blank origin.
export const siteUrl =
  process.env.NEXT_PUBLIC_SITE_URL || 'https://easyxrayteam.github.io/EasyXray';
