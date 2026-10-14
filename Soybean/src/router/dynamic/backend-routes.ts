import type { RouteRecordRaw } from 'vue-router';
import { router } from '@/router';
import BaseLayout from '@/layouts/base-layout/index.vue';
import {
  isButtonMenu,
  isExternalLinkMenu,
  isHiddenMenu,
  resolveMenuRoute
} from './menu-route-resolver';
import { createMissingViewComponent, loadBackendView } from './view-loader';

interface BuildContext {
  /** Route names already produced in this build. Prevents duplicate `addRoute`. */
  emitted: Set<string>;
}

/* ---------- helpers ---------- */

function isLeafMenuType(rawType: unknown): boolean {
  // 2 = menu (a leaf with a real view)
  const n = String(rawType || '').trim().toUpperCase();
  return n === '2' || n === 'C' || n === 'MENU';
}

function pickComponent(item: Api.SystemManage.Menu, routePath: string) {
  const componentPath = String(item.component || '').trim();

  if (componentPath) {
    const loaded = loadBackendView(componentPath);
    if (loaded) return loaded;

    if (import.meta.env.DEV) {
      console.warn('[backend-routes] component file not found', {
        menu: item.menuName || item.name,
        component: componentPath
      });
    }
    return createMissingViewComponent(componentPath);
  }

  // Fallback - try using the route path itself as a view location.
  const loaded = loadBackendView(routePath);
  if (loaded) return loaded;

  return createMissingViewComponent(routePath || '(no component)');
}

function buildLeafRoute(item: Api.SystemManage.Menu, ctx: BuildContext): RouteRecordRaw | null {
  const resolved = resolveMenuRoute(item);
  if (!resolved) return null;
  // Already covered by a registered static route - nothing to do.
  if (resolved.isStatic) return null;
  // External links navigate via `window.open`, no vue-router record needed.
  if (resolved.isExternal) return null;
  if (ctx.emitted.has(resolved.routeKey)) return null;

  ctx.emitted.add(resolved.routeKey);

  // Backend leaf menus mount under the base layout. We wrap them in a
  // synthetic single-level route so the layout shell (sidebar, tabs, etc.)
  // is reused without coupling to the elegant-router static tree.
  return {
    path: resolved.routePath,
    component: BaseLayout,
    meta: {
      title: item.menuName || item.name || resolved.routeKey
    },
    children: [
      {
        name: resolved.routeKey,
        path: '',
        component: pickComponent(item, resolved.routePath),
        meta: {
          title: item.menuName || item.name || resolved.routeKey,
          i18nKey: item.i18nKey,
          icon: item.icon || import.meta.env.VITE_MENU_ICON,
          localIcon: String(item.iconType || '') === '2' ? item.icon : undefined,
          keepAlive: Number(item.is_keep_alive) === 1,
          fixedIndexInTab:
            Number(item.is_fixed_tab) === 1 ? (item.id as unknown as number) : undefined,
          hideInMenu: isHiddenMenu(item) ? true : undefined
        }
      } as RouteRecordRaw
    ]
  };
}

/* ---------- main ---------- */

/**
 * Translate a backend menu tree into vue-router routes that can be fed to
 * `router.addRoute`. Only menus that are NOT already covered by an existing
 * static route are emitted; static routes (e.g. `/manage/user`) stay
 * authoritative.
 */
export function buildBackendDynamicRoutes(menus: Api.SystemManage.Menu[]): RouteRecordRaw[] {
  const ctx: BuildContext = { emitted: new Set() };
  const routes: RouteRecordRaw[] = [];

  function walk(items: Api.SystemManage.Menu[] | null | undefined) {
    if (!Array.isArray(items)) return;

    for (const item of items) {
      const type = item.type || item.menuType;

      // skip pure permission buttons
      if (isButtonMenu(type)) continue;
      // external links are opened via window.open by the router push helper
      if (isExternalLinkMenu(type)) continue;

      if (isLeafMenuType(type)) {
        const route = buildLeafRoute(item, ctx);
        if (route) routes.push(route);
        // Even for isStatic routes (returned null), patch the existing route meta
        // so that tab icons from backend menus are preserved.
        else {
          patchStaticRouteMeta(item);
        }
      }

      if (item.children?.length) {
        walk(item.children);
      }
    }
  }

  walk(menus);
  return routes;
}

/**
 * For backend menus that resolve to an existing **static** route,
 * patch the vue-router record's `.meta` with icon / localIcon from the menu.
 * Without this, all static-route tabs fall back to VITE_MENU_ICON.
 */
function patchStaticRouteMeta(item: Api.SystemManage.Menu): void {
  const resolved = resolveMenuRoute(item);
  if (!resolved || !resolved.isStatic) return;

  const existing = router.getRoutes().find(r => r.name === resolved.routeKey);
  if (!existing) return;

  // Only patch if the current meta has no icon (static routes typically don't)
  if (!existing.meta.icon && item.icon) {
    existing.meta.icon = item.icon;
  }
  if (item.iconType === '2' && item.icon) {
    existing.meta.localIcon = item.icon;
  }

  // Also patch i18nKey and fixedIndexInTab if not already set
  if (!existing.meta.i18nKey && item.i18nKey) {
    existing.meta.i18nKey = item.i18nKey;
  }
  if (existing.meta.fixedIndexInTab === undefined && Number(item.is_fixed_tab) === 1) {
    existing.meta.fixedIndexInTab = item.id as unknown as number;
  }
}
