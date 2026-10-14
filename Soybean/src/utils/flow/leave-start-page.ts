import type { RouteLocationNormalizedLoaded } from 'vue-router';
import { router } from '@/router';
import { useTabStore } from '@/store/modules/tab';

/** Close the current start-flow tab and navigate away after submit/cancel. */
export async function leaveStartPage(
  route: RouteLocationNormalizedLoaded,
  targetPath = '/flow/instance/my-started'
) {
  const tabStore = useTabStore();
  const tabId = tabStore.getTabIdByRoute(route);

  try {
    await router.push(targetPath);
  } catch {
    // Ignore duplicated navigation; tab cleanup should still run.
  }

  if (tabStore.tabs.some(tab => tab.id === tabId)) {
    await tabStore.removeTab(tabId);
  }
}
