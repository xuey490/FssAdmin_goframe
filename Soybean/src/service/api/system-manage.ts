import { request } from '../request';

/** get role list */
export function fetchGetRoleList(params?: Api.SystemManage.RoleSearchParams) {
  return request<Api.SystemManage.RoleList>({
    url: '/api/system/role/list',
    method: 'get',
    params
  });
}

/**
 * get all roles
 *
 * these roles are all enabled
 */
export function fetchGetAllRoles() {
  return request<Api.SystemManage.AllRole[]>({
    url: '/api/system/role/all',
    method: 'get'
  });
}

/** get user list */
export function fetchGetUserList(params?: Api.SystemManage.UserSearchParams) {
  return request<Api.SystemManage.UserList>({
    url: '/api/system/user/list',
    method: 'get',
    params
  });
}

export function fetchGetUserSelector(params?: {
  page?: number;
  limit?: number;
  keyword?: string;
  status?: Api.Common.EnableStatus;
}) {
  return request<Api.SystemManage.UserList>({
    url: '/api/system/user/list',
    method: 'get',
    params
  });
}

export function fetchGetUserDetail(id: number) {
  return request<Api.SystemManage.User>({
    url: `/api/system/user/detail/${id}`,
    method: 'get'
  });
}

/** get menu list (returns tree structure) */
export function fetchGetMenuList(params?: Record<string, any>) {
  return request<Api.SystemManage.Menu[]>({
    url: '/api/system/menu/list',
    method: 'get',
    params
  });
}

/** get all pages */
export function fetchGetAllPages() {
  return request<Api.SystemManage.Menu[]>({
    url: '/api/system/menu/list',
    method: 'get'
  });
}

/** get menu tree */
export function fetchGetMenuTree() {
  return request<Api.SystemManage.MenuTree[]>({
    url: '/api/system/menu/tree',
    method: 'get'
  });
}

/** get assignable menu tree (all types including buttons) */
export function fetchGetAssignableMenuTree() {
  return request<Api.SystemManage.MenuTree[]>({
    url: '/api/system/menu/assignable-tree',
    method: 'get'
  });
}

/** get menu detail */
export function fetchGetMenuDetail(id: number) {
  return request<Api.SystemManage.Menu>({
    url: `/api/system/menu/detail/${id}`,
    method: 'get'
  });
}

/** update menu status */
export function fetchUpdateMenuStatus(id: number, status: number) {
  return request({
    url: `/api/system/menu/status/${id}`,
    method: 'put',
    data: { status }
  });
}

/** save role menu permission (all types) */
export function fetchSaveRoleMenuPermission(roleId: number, menu_ids: number[]) {
  return request({
    url: `/api/system/role/menu-permission/${roleId}`,
    method: 'put',
    data: { menu_ids }
  });
}

export function fetchCreateUser(data: Partial<Api.SystemManage.User>) {
  return request({
    url: '/api/system/user/create',
    method: 'post',
    data
  });
}

export function fetchUpdateUser(id: number, data: Partial<Api.SystemManage.User>) {
  return request({
    url: `/api/system/user/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteUser(id: number) {
  return request({
    url: `/api/system/user/delete/${id}`,
    method: 'delete'
  });
}

export async function fetchBatchDeleteUser(ids: number[]) {
  for (const id of ids) {
    const { error } = await fetchDeleteUser(id);
    if (error) return { data: null, error };
  }
  return { data: null, error: null };
}

export function fetchChangeUserPassword(id: number, password: string) {
  return request({
    url: `/api/system/user/change-password/${id}`,
    method: 'put',
    data: { password }
  });
}

export function fetchClearUserCache(id: number) {
  return request({
    url: `/api/system/user/clear-cache/${id}`,
    method: 'put'
  });
}

export function fetchSetUserHomePage(id: number, dashboard: string) {
  return request({
    url: `/api/system/user/set-home-page/${id}`,
    method: 'put',
    data: { id, dashboard }
  });
}

export function fetchGetUserMenus(id: number) {
  return request<number[]>({
    url: `/api/system/user/menus/${id}`,
    method: 'get'
  });
}

export function fetchSaveUserMenus(id: number, menu_ids: number[]) {
  return request({
    url: `/api/system/user/menus/${id}`,
    method: 'put',
    data: { menu_ids }
  });
}

export function fetchCreateRole(data: Partial<Api.SystemManage.Role>) {
  return request({
    url: '/api/system/role/create',
    method: 'post',
    data
  });
}

export function fetchUpdateRole(id: number, data: Partial<Api.SystemManage.Role>) {
  return request({
    url: `/api/system/role/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteRole(id: number) {
  return request({
    url: `/api/system/role/delete/${id}`,
    method: 'delete'
  });
}

export async function fetchBatchDeleteRole(ids: number[]) {
  for (const id of ids) {
    const { error } = await fetchDeleteRole(id);
    if (error) return { data: null, error };
  }
  return { data: null, error: null };
}

export function fetchGetRoleMenuByRole(roleId: number) {
  return request<Api.SystemManage.MenuPermissionResp>({
    url: `/api/system/role/menu-by-role/${roleId}`,
    method: 'get'
  });
}

export function fetchGetRoleDetail(id: number) {
  return request<Api.SystemManage.Role>({
    url: `/api/system/role/detail/${id}`,
    method: 'get'
  });
}

export function fetchAssignRoleMenus(roleId: number, menu_ids: number[]) {
  return request({
    url: `/api/system/role/assign-menus/${roleId}`,
    method: 'put',
    data: { menu_ids }
  });
}

export function fetchCreateMenu(data: Partial<Api.SystemManage.Menu>) {
  return request({
    url: '/api/system/menu/create',
    method: 'post',
    data
  });
}

export function fetchUpdateMenu(id: number, data: Partial<Api.SystemManage.Menu>) {
  return request({
    url: `/api/system/menu/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteMenu(id: number) {
  return request({
    url: `/api/system/menu/delete/${id}`,
    method: 'delete'
  });
}

export async function fetchBatchDeleteMenu(ids: number[]) {
  for (const id of ids) {
    const { error } = await fetchDeleteMenu(id);
    if (error) return { data: null, error };
  }
  return { data: null, error: null };
}
