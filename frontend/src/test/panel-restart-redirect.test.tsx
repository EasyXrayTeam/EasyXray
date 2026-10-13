import { afterEach, describe, expect, it, vi } from 'vitest';
import { matchRoutes } from 'react-router';

import { panelSettingsPath } from '@/lib/panel-url';

// A redirect target only works if the router can serve it, so resolve the built
// path against the real route table instead of restating the path string.
async function resolveSettingsRoute(basePathEnv: string | undefined, webBasePath: string) {
  vi.resetModules();
  if (basePathEnv === undefined) {
    delete (window as { EASYXRAY_BASE_PATH?: string }).EASYXRAY_BASE_PATH;
  } else {
    (window as { EASYXRAY_BASE_PATH?: string }).EASYXRAY_BASE_PATH = basePathEnv;
  }
  const { router } = await import('@/routes');
  const matches = matchRoutes(router.routes, panelSettingsPath(webBasePath), router.basename);
  return matches?.at(-1)?.route.path;
}

afterEach(() => {
  delete (window as { EASYXRAY_BASE_PATH?: string }).EASYXRAY_BASE_PATH;
});

describe('panel restart redirect', () => {
  it('lands on the settings route the router serves at the default base path', async () => {
    await expect(resolveSettingsRoute(undefined, '/')).resolves.toBe('settings');
  });

  it('lands on the settings route when a web base path is configured', async () => {
    await expect(resolveSettingsRoute('/mypanel/', '/mypanel')).resolves.toBe('settings');
  });
});
