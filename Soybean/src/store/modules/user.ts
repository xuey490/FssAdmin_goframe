import { computed } from 'vue';
import { defineStore } from 'pinia';
import { useAuthStore } from './auth';
import { fetchClearCache } from '@/api/auth';
import { localStg } from '@/utils/storage';

export const useUserStore = defineStore('legacy-user', () => {
  const authStore = useAuthStore();

  const accessToken = computed(() => authStore.token || '');
  const info = computed(() => {
    const cached = localStg.get('userProfile');

    return {
      id: authStore.userInfo.userId
        ? Number(authStore.userInfo.userId)
        : (cached?.id ?? 0),
      username: authStore.userInfo.userName || cached?.username || '',
      realname:
        authStore.userInfo.realName ||
        cached?.realname ||
        cached?.nickname ||
        '',
      avatar: authStore.userInfo.avatar || cached?.avatar || ''
    };
  });

  function clearCache() {
    return fetchClearCache();
  }

  return {
    accessToken,
    info,
    clearCache
  };
});

