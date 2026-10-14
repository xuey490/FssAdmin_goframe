import type { RouteKey, RouteMap } from '@elegant-router/types';
import { getRouteName, getRoutePath } from '@/router/elegant/transform';

/** 后端菜单 code（PascalCase）到 elegant-router routeKey 的映射 */
const BACKEND_MENU_CODE_ALIASES: Partial<Record<string, RouteKey>> = {
  FlowMyStarted: 'flow_instance_my-started',
  FlowTaskPending: 'flow_task_pending',
  FlowTaskCompleted: 'flow_task_completed',
  FlowTaskCopyMe: 'flow_task_copy-me',
  FlowTaskRevertedCanceled: 'flow_task_reverted-canceled',
  FlowMessage: 'flow_message',
  FlowTemplateDesign: 'flow_template_design',
  FlowFormDesign: 'flow_template_form-design',
  FlowInstanceStart: 'flow_instance_start-entry',
  FlowInstanceResubmit: 'flow_instance_resubmit',
  FlowInstanceDetail: 'flow_instance_detail',
  FlowFormLeaveRequest: 'flow_form_leave-request',
  FlowFormExpenseClaim: 'flow_form_expense-claim',
  FlowFormPurchaseRequest: 'flow_form_purchase-request'
};

/**
 * Unified backend menu -> route resolver.
 *
 * It is the single source of truth that translates a backend menu node
 * into the `routeKey` / `routePath` pair used by:
 *   - the sidebar (`App.Global.Menu.routeKey`)
 *   - the dynamic vue-router registration (`router.addRoute({ name, ... })`)
 *
 * It removes all hard-coded `/system -> manage`, `/dashboard -> home` rules
 * that used to live in `store/modules/route/shared.ts`.
 */

export interface ResolvedMenuRoute {
  /** Final route key used as vue-router `name` and sidebar menu `key`. */
  routeKey: string;
  /** Final route path used for navigation. For external links this is the URL. */
  routePath: string;
  /** Whether this menu reuses an existing static route (no dynamic registration needed). */
  isStatic: boolean;
  /** Whether this menu is an external link (open via `window.open`). */
  isExternal: boolean;
}

/* ---------- type / visibility helpers ---------- */

export function isButtonMenu(rawType: unknown): boolean {
  if (rawType == null) return false;
  const n = String(rawType).trim().toUpperCase();
  return n === '3' || n === 'B' || n === 'BUTTON';
}

export function isExternalLinkMenu(rawType: unknown): boolean {
  if (rawType == null) return false;
  const n = String(rawType).trim().toUpperCase();
  return n === '4' || n === 'L' || n === 'LINK';
}

export function isHiddenMenu(item: Api.SystemManage.Menu): boolean {
  return item.hideInMenu === true || Number(item.is_hidden) === 1;
}

/* ---------- path / key helpers ---------- */

export function normalizePath(rawPath: string): string {
  const trimmed = String(rawPath || '').trim();
  if (!trimmed) return '';
  if (/^https?:\/\//i.test(trimmed)) return trimmed;
  return trimmed.startsWith('/') ? trimmed : `/${trimmed}`;
}

/**
 * Build a deterministic route key from a backend menu node.
 *
 * Priority: `code` / `routeName` -> `path` -> `id` based fallback.
 */
export function synthesizeRouteKey(item: Api.SystemManage.Menu): string {
  const rawCode = String(item.routeName || item.code || '').trim();
  if (rawCode) return rawCode.replace(/[^\w-]/g, '_');

  const rawPath = String(item.path || item.routePath || '').trim();
  if (rawPath) {
    const cleaned = rawPath.replace(/^\/+/, '').replace(/\/+$/, '');
    if (cleaned) return cleaned.replace(/[^\w-]+/g, '_');
  }

  return `menu_${item.id ?? Date.now()}`;
}

/* ---------- resolver ---------- */

/**
 * Resolve a backend menu to its final route descriptor.
 *
 * - External link menus (type=4) point to their `link_url`.
 * - Menus whose `code` or `path` matches a registered static route reuse it (so
 *   existing `/manage/user`, `/home`, etc. keep working without any extra work).
 * - Everything else is treated as a dynamic menu; the caller is expected to
 *   register a real vue-router route for it via `buildBackendDynamicRoutes`.
 */
export function resolveMenuRoute(item: Api.SystemManage.Menu): ResolvedMenuRoute | null {
  const type = item.type || item.menuType;

  // External link
  if (isExternalLinkMenu(type)) {
    const linkUrl = String((item as any).link_url || (item as any).href || '').trim();
    if (!linkUrl) return null;
    return {
      routeKey: synthesizeRouteKey(item),
      routePath: linkUrl,
      isStatic: false,
      isExternal: true
    };
  }

  // 1. Try matching an existing static route by code/routeName
  const code = String(item.code || item.routeName || '').trim();
  if (code) {
    const aliasedKey = BACKEND_MENU_CODE_ALIASES[code];
    if (aliasedKey) {
      const aliasedPath = getRoutePath(aliasedKey);
      if (aliasedPath) {
        return { routeKey: aliasedKey, routePath: aliasedPath, isStatic: true, isExternal: false };
      }
    }

    const staticPath = getRoutePath(code as RouteKey);
    if (staticPath) {
      return { routeKey: code, routePath: staticPath, isStatic: true, isExternal: false };
    }
  }

  // 2. Try matching an existing static route by path
  const rawPath = String(item.path || item.routePath || '').trim();
  if (rawPath) {
    const normalized = normalizePath(rawPath);
    const directName = getRouteName(normalized as RouteMap[RouteKey]);
    if (directName) {
      return { routeKey: directName, routePath: normalized, isStatic: true, isExternal: false };
    }

    // tolerate trailing /index or /list segments
    const simplified = normalized.replace(/\/(index|list)$/i, '').replace(/\/+$/, '');
    if (simplified && simplified !== normalized) {
      const simpleName = getRouteName(simplified as RouteMap[RouteKey]);
      if (simpleName) {
        return { routeKey: simpleName, routePath: simplified, isStatic: true, isExternal: false };
      }
    }
  }

  // 3. Pure dynamic - synthesize a stable key and use the backend path as-is
  const routeKey = synthesizeRouteKey(item);
  if (!routeKey) return null;
  const routePath = rawPath ? normalizePath(rawPath) : `/${routeKey}`;
  return { routeKey, routePath, isStatic: false, isExternal: false };
}
