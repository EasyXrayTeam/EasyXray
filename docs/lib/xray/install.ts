// Pure builders for EasyXray install commands (script + Docker). No React/DOM.

export type InstallMethod = 'script' | 'docker';

export interface InstallOptions {
  method: InstallMethod;
  /** A release tag like `v1.0.1`, or empty/`latest` for the latest release. */
  version: string;
  enableFail2ban: boolean;
  panelPort: string;
  webBasePath: string;
}

const REPO_RAW = 'https://raw.githubusercontent.com/EasyXrayTeam/EasyXray/main/install.sh';
const IMAGE = 'ghcr.io/easyxrayteam/easyxray:latest';

function isLatest(version: string): boolean {
  const v = version.trim().toLowerCase();
  return v === '' || v === 'latest';
}

/**
 * The one-line script install command. The master install script reads the
 * version as its first argument: empty = latest stable release, a tag like
 * `v1.0.0` = that release, and `dev-latest` = the rolling per-commit dev build.
 */
export function buildScriptCommand(options: InstallOptions): string {
  if (isLatest(options.version)) {
    return `bash <(curl -Ls ${REPO_RAW})`;
  }
  return `bash <(curl -Ls ${REPO_RAW}) ${options.version.trim()}`;
}

/** A `docker run` command reflecting the chosen options. */
export function buildDockerRun(options: InstallOptions): string {
  const lines = ['docker run -itd'];
  lines.push(`  -e XRAY_VMESS_AEAD_FORCED=false`);
  lines.push(`  -e EASYXRAY_ENABLE_FAIL2BAN=${options.enableFail2ban ? 'true' : 'false'}`);
  if (options.panelPort.trim()) lines.push(`  -e EASYXRAY_PORT=${options.panelPort.trim()}`);
  if (options.webBasePath.trim())
    lines.push(`  -e EASYXRAY_INIT_WEB_BASE_PATH=${options.webBasePath.trim()}`);
  lines.push(`  -v $PWD/db/:/etc/easyxray/`);
  lines.push(`  -v $PWD/cert/:/root/cert/`);
  lines.push(`  --network=host`);
  lines.push(`  --restart=unless-stopped`);
  lines.push(`  --name EasyXray`);
  lines.push(`  ${IMAGE}`);
  return lines.join(' \\\n');
}

/** A `docker-compose.yml` reflecting the chosen options. */
export function buildDockerCompose(options: InstallOptions): string {
  const env: string[] = [
    `      XRAY_VMESS_AEAD_FORCED: 'false'`,
    `      EASYXRAY_ENABLE_FAIL2BAN: '${options.enableFail2ban ? 'true' : 'false'}'`,
  ];
  if (options.panelPort.trim()) env.push(`      EASYXRAY_PORT: '${options.panelPort.trim()}'`);
  if (options.webBasePath.trim())
    env.push(`      EASYXRAY_INIT_WEB_BASE_PATH: '${options.webBasePath.trim()}'`);

  return [
    `services:`,
    `  EasyXray:`,
    `    image: ${IMAGE}`,
    `    container_name: EasyXray`,
    `    volumes:`,
    `      - ./db/:/etc/easyxray/`,
    `      - ./cert/:/root/cert/`,
    `    environment:`,
    ...env,
    `    network_mode: host`,
    `    restart: unless-stopped`,
  ].join('\n');
}
