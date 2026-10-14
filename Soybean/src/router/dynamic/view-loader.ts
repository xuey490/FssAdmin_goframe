import { h } from 'vue';
import type { Component } from 'vue';

/**
 * Vite glob of every `.vue` view under `src/views`.
 *
 * Keys look like `../../views/manage/user/index.vue`. We use them as a lookup
 * table so backend `component` paths (e.g. `/manage/user`) can be mapped to a
 * real Vue file at runtime - mirroring the `web/` project's ComponentLoader.
 */
const viewModules = import.meta.glob('../../views/**/*.vue');

function normalizeViewKey(componentPath: string): string {
  let cleaned = String(componentPath || '').trim();
  if (!cleaned) return '';
  cleaned = cleaned.replace(/^\/+/, '');
  cleaned = cleaned.replace(/\.vue$/i, '');
  cleaned = cleaned.replace(/\/+$/, '');
  return cleaned;
}

/**
 * Try to resolve a backend menu `component` path (e.g. `/manage/user`) to a
 * lazy view loader.
 *
 * Strategy:
 *   /manage/user  -> ../../views/manage/user.vue
 *                 -> ../../views/manage/user/index.vue
 */
export function loadBackendView(componentPath: string): (() => Promise<Component>) | null {
  const key = normalizeViewKey(componentPath);
  if (!key) return null;

  const candidates = [`../../views/${key}.vue`, `../../views/${key}/index.vue`];

  for (const candidate of candidates) {
    if (viewModules[candidate]) {
      return viewModules[candidate] as () => Promise<Component>;
    }
  }

  return null;
}

/**
 * Placeholder rendered when a backend menu references a view file that
 * does not exist in `src/views/`. Keeps navigation safe and surfaces the
 * mistake to the developer instead of crashing the router.
 */
export function createMissingViewComponent(componentPath: string) {
  return () =>
    Promise.resolve({
      name: 'BackendViewMissing',
      render() {
        return h(
          'div',
          {
            style:
              'padding: 24px; color: #f56c6c; font-size: 14px; line-height: 1.6;'
          },
          [
            h(
              'div',
              { style: 'font-weight: 600; margin-bottom: 8px;' },
              '视图未找到'
            ),
            h(
              'div',
              `component: ${componentPath || '(empty)'}`
            ),
            h(
              'div',
              { style: 'margin-top: 12px; color: #909399; font-size: 12px;' },
              '请在 src/views/ 下创建对应文件，或修改菜单的"组件路径"字段。'
            )
          ]
        );
      }
    });
}

/**
 * Iframe wrapper used by external-link (type=4) menus configured as embedded.
 * Currently delegates to the @builtin iframe page if available.
 */
export function loadIframeView(): (() => Promise<Component>) | null {
  const iframePath = '../../views/_builtin/iframe-page/[url].vue';
  if (viewModules[iframePath]) {
    return viewModules[iframePath] as () => Promise<Component>;
  }
  return null;
}
