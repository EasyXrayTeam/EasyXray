// The admin SPA is mounted under `<base>/easyxray` by the router in routes.tsx.
// The restart redirect has to land on a path that router actually serves.
export function panelSettingsPath(webBasePath: string): string {
  let base = webBasePath ? webBasePath.replace(/^\//, '') : '';
  if (base && !base.endsWith('/')) base += '/';
  return `/${base}easyxray/settings`;
}
