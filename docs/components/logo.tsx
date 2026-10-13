import { cn } from '@/lib/cn';
import { basePath } from '@/lib/shared';

// Official EasyXray logo. Theme-aware via Tailwind's `dark:` variant. Pass a
// height class (e.g. `h-6`); width scales automatically (the artwork is 2:1).
// These are plain <img> tags, so the GitHub Pages base path has to be applied by
// hand — next/image and next/link would do it automatically, raw URLs don't.
export function Logo({ className }: { className?: string }) {
  return (
    <>
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img
        src={`${basePath}/logo-light.png`}
        alt="EasyXray"
        className={cn('w-auto dark:hidden', className)}
      />
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img
        src={`${basePath}/logo-dark.png`}
        alt="EasyXray"
        className={cn('hidden w-auto dark:block', className)}
      />
    </>
  );
}
