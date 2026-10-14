import { request } from '../request';

/**
 * Login
 *
 * @param payload login payload
 */
export function fetchLogin(payload: Api.Auth.LoginParams) {
  return request<Api.Auth.LoginToken>({
    url: '/api/core/login',
    method: 'post',
    data: payload
  });
}

/** Get user info */
export function fetchGetUserInfo() {
  return request<Api.Auth.UserProfileResponse>({ url: '/api/core/system/user' });
}

/** Get current user menus (backend-driven) */
export function fetchGetCurrentUserMenus() {
  return request<Api.SystemManage.Menu[]>({
    url: '/api/core/system/menu',
    method: 'get'
  });
}

/** Refresh token */
export function fetchRefreshToken() {
  return request<Api.Auth.LoginToken>({
    url: '/api/core/refresh',
    method: 'post'
  });
}

/** Get captcha */
export function fetchGetCaptcha() {
  return request<Api.Auth.CaptchaData>({
    url: '/api/core/captcha',
    method: 'get'
  });
}

/** Get tenant list by username */
export function fetchGetTenantsByUsername(username: string) {
  return request<Api.Auth.TenantItem[]>({
    url: '/api/core/tenants-by-username',
    method: 'get',
    params: { username }
  });
}

/**
 * Keep compatibility with function demo page
 */
export function fetchCustomBackendError(code: string, msg: string) {
  return request({
    url: '/auth/error',
    params: { code, msg }
  });
}
