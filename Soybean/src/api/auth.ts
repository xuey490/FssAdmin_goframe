import { request } from '@/service/request';

/**
 * NOTE:
 * This file is a compatibility API layer migrated from `web/src/api/auth.ts`.
 * Keep function names stable because multiple `sai/*` components import from `@/api/auth`.
 */

export function fetchCaptcha() {
  return request<any>({
    url: '/api/core/captcha',
    method: 'get'
  });
}

export function fetchLogin(params: Record<string, any>) {
  return request<any>({
    url: '/api/core/login',
    method: 'post',
    data: params
  });
}

export function fetchRefreshToken() {
  return request<any>({
    url: '/api/core/refresh',
    method: 'post'
  });
}

export function fetchLogout() {
  return request<any>({
    url: '/api/core/logout',
    method: 'post'
  });
}

export function fetchGetUserInfo() {
  return request<any>({
    url: '/api/core/system/user',
    method: 'get'
  });
}

export function fetchTenantsByUsername(username: string) {
  return request<any>({
    url: '/api/core/tenants-by-username',
    method: 'get',
    params: { username }
  });
}

export function fetchSwitchTenant(tenantId: number) {
  return request<any>({
    url: '/api/core/switch-tenant',
    method: 'post',
    data: { tenant_id: tenantId }
  });
}

export function updateUserInfo(params: Record<string, any>) {
  return request<any>({
    url: '/api/core/user/updateInfo',
    method: 'post',
    data: params
  });
}

export function modifyPassword(params: Record<string, any>) {
  return request<any>({
    url: '/api/core/user/modifyPassword',
    method: 'post',
    data: params
  });
}

export function fetchGetLogin(params: Record<string, any>) {
  return request<any>({
    url: '/api/core/system/getLoginLogList',
    method: 'get',
    params
  });
}

export function fetchGetOperate(params: Record<string, any>) {
  return request<any>({
    url: '/api/core/system/getOperationLogList',
    method: 'get',
    params
  });
}

export function fetchClearCache() {
  return request<any>({
    url: '/api/core/system/clearAllCache',
    method: 'get'
  });
}

export function fetchGetDictList() {
  return request<any>({
    url: '/api/core/system/dictAll',
    method: 'get'
  });
}

export function fetchGetMenuList() {
  return request<any>({
    url: '/api/core/system/menu',
    method: 'get'
  });
}

export function uploadImage(data: FormData) {
  return request<any>({
    url: '/api/core/system/uploadImage',
    method: 'post',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data
  });
}

export function uploadFile(data: FormData) {
  return request<any>({
    url: '/api/core/system/uploadFile',
    method: 'post',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data
  });
}

export function chunkUpload(data: FormData) {
  return request<any>({
    url: '/api/core/system/chunkUpload',
    method: 'post',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data
  });
}

export function getResourceCategory(params: Record<string, any>) {
  return request<any>({
    url: '/api/core/system/getResourceCategory',
    method: 'get',
    params
  });
}

export function getResourceList(params: Record<string, any>) {
  return request<any>({
    url: '/api/core/system/getResourceList',
    method: 'get',
    params
  });
}

export function getUserList(params: Record<string, any>) {
  return request<any>({
    url: '/api/core/system/getUserList',
    method: 'get',
    params
  });
}

export function getUserSelectorList(params: Record<string, any>) {
  return request<any>({
    url: '/api/core/system/getUserSelectorList',
    method: 'get',
    params
  });
}

export function fetchStatistics() {
  return request<any>({
    url: '/api/core/system/statistics',
    method: 'get'
  });
}

export function fetchLoginChart() {
  return request<any>({
    url: '/api/core/system/loginChart',
    method: 'get'
  });
}

export function fetchLoginBarChart() {
  return request<any>({
    url: '/api/core/system/loginBarChart',
    method: 'get'
  });
}

