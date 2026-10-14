import { computed, nextTick, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import { useContext } from '@sa/hooks';
import type { RouteKey } from '@elegant-router/types';
import { useRouteStore } from '@/store/modules/route';
import { useRouterPush } from '@/hooks/common/router';

export const { setupStore: setupMixMenuContext, useStore: useMixMenuContext } = useContext('mix-menu', useMixMenu);

function useMixMenu() {
  const route = useRoute();
  const routeStore = useRouteStore();
  const { selectedKey } = useMenu();

  const activeFirstLevelMenuKey = ref('');

  function setActiveFirstLevelMenuKey(key: string) {
    activeFirstLevelMenuKey.value = key;
  }

  /**
   * Find the first-level menu whose subtree contains a node matching `target`
   * (compared against both `key` and `routeKey`). This replaces the legacy
   * `selectedKey.split('_')[0]` heuristic which only worked for
   * elegant-router's `parent_child` naming convention and broke when the
   * sidebar was driven by backend menus with arbitrary codes.
   */
  function findFirstLevelKey(menus: App.Global.Menu[], target: string): string | null {
    function subtreeMatches(menu: App.Global.Menu): boolean {
      if (menu.key === target || menu.routeKey === target) return true;
      if (menu.children?.length) {
        return menu.children.some(subtreeMatches);
      }
      return false;
    }

    for (const menu of menus) {
      if (subtreeMatches(menu)) return menu.key;
    }
    return null;
  }

  function getActiveFirstLevelMenuKey() {
    const selected = selectedKey.value;
    if (!selected) return;

    // Walk the menu tree first - this works for any menu naming scheme.
    const matched = findFirstLevelKey(routeStore.menus, selected);
    if (matched) {
      setActiveFirstLevelMenuKey(matched);
      return;
    }

    // Fallback to the legacy parent_child split for hidden / detail routes
    // that are not present in the visible menu tree (e.g. `manage_user-detail`).
    const [firstLevelRouteName] = selected.split('_');
    if (firstLevelRouteName) {
      setActiveFirstLevelMenuKey(firstLevelRouteName);
    }
  }

  const allMenus = computed<App.Global.Menu[]>(() => routeStore.menus);

  const firstLevelMenus = computed<App.Global.Menu[]>(() =>
    routeStore.menus.map(menu => {
      const { children: _, ...rest } = menu;

      return rest;
    })
  );

  const childLevelMenus = computed<App.Global.Menu[]>(
    () => routeStore.menus.find(menu => menu.key === activeFirstLevelMenuKey.value)?.children || []
  );

  const isActiveFirstLevelMenuHasChildren = computed(() => {
    if (!activeFirstLevelMenuKey.value) {
      return false;
    }

    const findItem = allMenus.value.find(item => item.key === activeFirstLevelMenuKey.value);

    return Boolean(findItem?.children?.length);
  });

  watch(
    () => route.name,
    () => {
      getActiveFirstLevelMenuKey();
    },
    { immediate: true }
  );

  // Re-evaluate when the backend menu tree finishes loading after the initial
  // route is in place (e.g. menus arrive after a hard refresh on a deep link).
  watch(
    () => routeStore.menus,
    () => {
      getActiveFirstLevelMenuKey();
    }
  );

  return {
    allMenus,
    firstLevelMenus,
    childLevelMenus,
    isActiveFirstLevelMenuHasChildren,
    activeFirstLevelMenuKey,
    setActiveFirstLevelMenuKey,
    getActiveFirstLevelMenuKey
  };
}

export function useMenu() {
  const route = useRoute();
  const { routerPushByKeyWithMetaQuery } = useRouterPush();

  const selectedKey = computed(() => {
    const { hideInMenu, activeMenu } = route.meta;
    const name = route.name as string;

    const routeName = (hideInMenu ? activeMenu : name) || name;

    return routeName;
  });

  const selectedKeyDummy = ref(selectedKey.value);

  watch(
    () => selectedKey.value,
    val => {
      selectedKeyDummy.value = val;
    }
  );

  function handleSelect(key: RouteKey) {
    selectedKeyDummy.value = key;

    routerPushByKeyWithMetaQuery(key);

    if (key.endsWith('-link')) {
      nextTick(() => {
        selectedKeyDummy.value = selectedKey.value;
      });
    }
  }

  return {
    selectedKey,
    selectedKeyDummy,
    handleSelect
  };
}
