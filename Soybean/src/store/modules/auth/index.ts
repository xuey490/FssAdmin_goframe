import { computed, reactive, ref } from 'vue';
import { useRoute } from 'vue-router';
import { defineStore } from 'pinia';
import { useLoading } from '@sa/hooks';
import { fetchGetUserInfo, fetchLogin } from '@/service/api';
import { useRouterPush } from '@/hooks/common/router';
import { localStg } from '@/utils/storage';
import { SetupStoreId } from '@/enum';
import { $t } from '@/locales';
import { useRouteStore } from '../route';
import { useTabStore } from '../tab';
import { clearAuthStorage, getToken } from './shared';

export const useAuthStore = defineStore(SetupStoreId.Auth, () => {
  const route = useRoute();
  const authStore = useAuthStore();
  const routeStore = useRouteStore();
  const tabStore = useTabStore();
  const { toLogin, redirectFromLogin } = useRouterPush(false);
  const { loading: loginLoading, startLoading, endLoading } = useLoading();

  const token = ref(getToken());

  const userInfo: Api.Auth.UserInfo = reactive({
    userId: '',
    userName: '',
    realName: '',
    roles: [],
    buttons: [],
    email: '',
    phone: '',
    avatar: '',
    gender: '',
    signed: '',
    remark: '',
    department: null,
    tenantId: undefined
  });

  function applyUserProfileSnapshot(profile: Api.Auth.UserProfileSnapshot) {
    Object.assign(userInfo, {
      userId: String(profile.id ?? ''),
      userName: profile.username ?? '',
      realName: profile.realname ?? profile.nickname ?? '',
      avatar: profile.avatar ?? ''
    });
  }

  function persistUserProfile(info: Api.Auth.UserProfileResponse) {
    const profile: Api.Auth.UserProfileSnapshot = {
      id: Number(info.id ?? 0),
      username: info.username ?? '',
      realname: info.realname ?? info.nickname ?? '',
      nickname: info.nickname ?? '',
      avatar: info.avatar ?? ''
    };

    localStg.set('userProfile', profile);
    return profile;
  }

  function hydrateUserInfoFromStorage() {
    const cached = localStg.get('userProfile');
    if (cached) {
      applyUserProfileSnapshot(cached);
    }
  }

  hydrateUserInfoFromStorage();

  /** is super role in static route */
  const isStaticSuper = computed(() => {
    const { VITE_AUTH_ROUTE_MODE, VITE_STATIC_SUPER_ROLE } = import.meta.env;

    return VITE_AUTH_ROUTE_MODE === 'static' && userInfo.roles.includes(VITE_STATIC_SUPER_ROLE);
  });

  /** Is login */
  const isLogin = computed(() => Boolean(token.value));

  /** Reset auth store */
  async function resetStore() {
    recordUserId();

    clearAuthStorage();

    authStore.$reset();

    if (!route.meta.constant) {
      await toLogin();
    }

    tabStore.cacheTabs();
    routeStore.resetStore();
  }

  /** Record the user ID of the previous login session Used to compare with the current user ID on next login */
  function recordUserId() {
    if (!userInfo.userId) {
      return;
    }

    // Store current user ID locally for next login comparison
    localStg.set('lastLoginUserId', String(userInfo.userId));
  }

  /**
   * Check if current login user is different from previous login user If different, clear all tabs
   *
   * @returns {boolean} Whether to clear all tabs
   */
  function checkTabClear(): boolean {
    if (!userInfo.userId) {
      return false;
    }

    const lastLoginUserId = localStg.get('lastLoginUserId');

    // Clear all tabs if current user is different from previous user
    if (lastLoginUserId !== userInfo.userId) {
      localStg.remove('globalTabs');
      tabStore.clearTabs();

      return true;
    }

    return false;
  }

  /**
   * Login
   *
   * @param payload Login params
   * @param [redirect=true] Whether to redirect after login. Default is `true`
   */
  async function login(payload: Api.Auth.LoginParams, redirect = true) {
    startLoading();
    let ok = false;

    try {
      const { data: loginToken, error } = await fetchLogin(payload);

      if (!error) {
        const pass = await loginByToken(loginToken);

        if (pass) {
          // Check if the tab needs to be cleared
          const isClear = checkTabClear();
          let needRedirect = redirect;

          if (isClear) {
            // If the tab needs to be cleared,it means we don't need to redirect.
            needRedirect = false;
          }
          await redirectFromLogin(needRedirect);

          window.$notification?.success({
            title: $t('page.login.common.loginSuccess'),
            message: $t('page.login.common.welcomeBack', { userName: userInfo.userName }),
            duration: 4500
          });
          ok = true;
        }
      } else {
        resetStore();
      }
    } finally {
      endLoading();
    }

    return ok;
  }

  async function loginByToken(loginToken: Api.Auth.LoginToken) {
    // 1. stored in the localStorage, the later requests need it in headers
    localStg.set('token', loginToken.access_token);
    localStg.set('refreshToken', loginToken.refresh_token);
    if (loginToken.menus) {
      localStg.set('loginMenus', loginToken.menus);
    }
    if (typeof loginToken.tenant_id === 'number') {
      localStg.set('tenantId', loginToken.tenant_id);
    }

    // 2. get user info
    const pass = await getUserInfo();

    if (pass) {
      token.value = loginToken.access_token;

      return true;
    }

    return false;
  }

  async function getUserInfo() {
    const { data: info, error } = await fetchGetUserInfo();

    if (!error) {
      persistUserProfile(info);

      Object.assign(userInfo, {
        userId: String(info.id ?? ''),
        userName: info.username ?? '',
        realName: info.realname ?? info.nickname ?? '',
        roles: info.roles ?? [],
        buttons: info.buttons && info.buttons.length ? info.buttons : ['*'],
        email: info.email ?? '',
        phone: info.phone ?? '',
        avatar: info.avatar ?? '',
        gender: info.gender ?? '',
        signed: info.signed ?? '',
        remark: info.remark ?? '',
        department: info.department ?? null,
        tenantId: info.tenant?.id
      });

      return true;
    }

    return false;
  }

  async function initUserInfo() {
    const hasToken = getToken();

    if (hasToken) {
      const pass = await getUserInfo();

      if (!pass) {
        resetStore();
      }
    }
  }

  return {
    token,
    userInfo,
    isStaticSuper,
    isLogin,
    loginLoading,
    resetStore,
    login,
    initUserInfo
  };
});
