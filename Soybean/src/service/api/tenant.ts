import { request } from '../request';

export function fetchGetTenantList(params?: Api.Tenant.TenantSearchParams) {
  return request<Api.Tenant.TenantList>({
    url: '/api/system/tenant/list',
    method: 'get',
    params
  });
}

/** 获取租户详情 */
export function fetchGetTenantDetail(id: number) {
  return request<Api.Tenant.Tenant>({
    url: `/api/system/tenant/detail/${id}`,
    method: 'get'
  });
}

export function fetchCreateTenant(data: Partial<Api.Tenant.Tenant>) {
  return request({
    url: '/api/system/tenant/create',
    method: 'post',
    data
  });
}

export function fetchUpdateTenant(id: number, data: Partial<Api.Tenant.Tenant>) {
  return request({
    url: `/api/system/tenant/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteTenant(id: number) {
  return request({
    url: `/api/system/tenant/delete/${id}`,
    method: 'delete'
  });
}

export function fetchUpdateTenantStatus(id: number, status: Api.Common.EnableStatus) {
  return request({
    url: `/api/system/tenant/status/${id}`,
    method: 'put',
    data: { status }
  });
}

// ── 租户用户管理 ───────────────────────────────────────────────

/** 获取租户关联用户列表 */
export function fetchGetTenantUsers(tenantId: number | string, params?: Record<string, any>) {
  return request({
    url: `/api/system/tenant/users/${tenantId}`,
    method: 'get',
    params
  });
}

/** 获取可添加到该租户的用户 */
export function fetchGetTenantAvailableUsers(
  tenantId: number | string,
  params?: Record<string, any>
) {
  return request({
    url: `/api/system/tenant/available-users/${tenantId}`,
    method: 'get',
    params
  });
}

/** 批量添加用户到租户 */
export function fetchAddUsersToTenant(tenantId: number | string, userIds: number[]) {
  return request({
    url: `/api/system/tenant/add-users/${tenantId}`,
    method: 'post',
    data: { user_ids: userIds }
  });
}

/** 从租户移除用户 */
export function fetchRemoveUserFromTenant(tenantId: number | string, userId: number | string) {
  return request({
    url: `/api/system/tenant/remove-user/${tenantId}/${userId}`,
    method: 'delete'
  });
}

/** 设置租户管理员 */
export function fetchSetTenantAdmin(
  tenantId: number | string,
  userId: number | string,
  isSuper: number
) {
  return request({
    url: `/api/system/tenant/set-admin/${tenantId}/${userId}`,
    method: 'put',
    data: { is_super: isSuper }
  });
}

/** 设置默认租户 */
export function fetchSetDefaultTenant(
  tenantId: number | string,
  userId: number | string,
  isDefault: number
) {
  return request({
    url: `/api/system/tenant/set-default/${tenantId}/${userId}`,
    method: 'put',
    data: { is_default: isDefault }
  });
}
