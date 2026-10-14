import { useRouter } from 'vue-router';
import type { RouteLocationRaw } from 'vue-router';
import type { RouteKey } from '@elegant-router/types';
import { router as globalRouter } from '@/router';
import { useRouteStore } from '@/store/modules/route';

/**
 * Router push
 *
 * Jump to the specified route, it can replace function router.push
 *
 * @param inSetup Whether is in vue script setup
 */
export function useRouterPush(inSetup = true) {
  const router = inSetup ? useRouter() : globalRouter;
  const route = globalRouter.currentRoute;

  const routerPush = router.push;

  const routerBack = router.back;

  interface RouterPushOptions {
    query?: Record<string, string>;
    params?: Record<string, string>;
  }

  function findMenuRoutePathByKey(menus: App.Global.Menu[], key: string): string | null {
    for (const menu of menus) {
      if (menu.routeKey === key || menu.key === key) {
        return menu.routePath as unknown as string;
      }
      if (menu.children?.length) {
        const childPath = findMenuRoutePathByKey(menu.children, key);
        if (childPath) return childPath;
      }
    }
    return null;
  }

  async function routerPushByKey(key: RouteKey, options?: RouterPushOptions) {
    const { query, params } = options || {};

    // If the route name is registered, prefer name-based navigation
    const hasRegisteredRoute = router.hasRoute(key);
    if (hasRegisteredRoute) {
      const routeLocation: RouteLocationRaw = {
        name: key
      };

      if (Object.keys(query || {}).length) {
        routeLocation.query = query;
      }

      if (Object.keys(params || {}).length) {
        routeLocation.params = params;
      }

      return routerPush(routeLocation);
    }

    // Fallback: look up the menu by key and navigate by path so backend menus
    // without a matching static route key still navigate (will hit 404 if path is unknown).
    const routeStore = useRouteStore();
    const fallbackPath = findMenuRoutePathByKey(routeStore.menus, key);

    if (fallbackPath) {
      if (/^https?:\/\//i.test(fallbackPath)) {
        window.open(fallbackPath, '_blank', 'noopener,noreferrer');
        return undefined as unknown as ReturnType<typeof routerPush>;
      }
      const routeLocation: RouteLocationRaw = { path: fallbackPath };
      if (Object.keys(query || {}).length) {
        routeLocation.query = query;
      }
      return routerPush(routeLocation);
    }

    if (import.meta.env.DEV) {
      console.warn('[router] route key not found and no fallback path:', key);
    }
    return undefined as unknown as ReturnType<typeof routerPush>;
  }

  function routerPushByKeyWithMetaQuery(key: RouteKey) {
    const allRoutes = router.getRoutes();
    const meta = allRoutes.find(item => item.name === key)?.meta || null;

    const query: Record<string, string> = {};

    meta?.query?.forEach(item => {
      query[item.key] = item.value;
    });

    return routerPushByKey(key, { query });
  }

  async function toHome() {
    return routerPushByKey('root');
  }

  /**
   * Navigate to login page
   *
   * @param loginModule The login module
   * @param redirectUrl The redirect url, if not specified, it will be the current route fullPath
   */
  async function toLogin(loginModule?: UnionKey.LoginModule, redirectUrl?: string) {
    const module = loginModule || 'pwd-login';

    const options: RouterPushOptions = {
      params: {
        module
      }
    };

    const redirect = redirectUrl || route.value.fullPath;

    options.query = {
      redirect
    };

    return routerPushByKey('login', options);
  }

  /**
   * Toggle login module
   *
   * @param module
   */
  async function toggleLoginModule(module: UnionKey.LoginModule) {
    const query = route.value.query as Record<string, string>;

    return routerPushByKey('login', { query, params: { module } });
  }

  /**
   * Redirect from login
   *
   * @param [needRedirect=true] Whether to redirect after login. Default is `true`
   */
  async function redirectFromLogin(needRedirect = true) {
    const redirect = route.value.query?.redirect as string;

    if (needRedirect && redirect) {
      await routerPush(redirect);
    } else {
      await toHome();
    }
  }

  return {
    routerPush,
    routerBack,
    routerPushByKey,
    routerPushByKeyWithMetaQuery,
    toLogin,
    toggleLoginModule,
    redirectFromLogin
  };
}
