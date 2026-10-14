import { request } from '../request';

export function fetchGetDeptList(params?: Api.Dept.DeptSearchParams) {
  return request<Api.Dept.Dept[]>({
    url: '/api/system/dept/list',
    method: 'get',
    params
  });
}

export function fetchGetDeptTree() {
  return request<Api.SystemManage.MenuTree[]>({
    url: '/api/system/dept/tree',
    method: 'get'
  });
}

export function fetchGetAccessDeptTree() {
  return request<Api.SystemManage.MenuTree[]>({
    url: '/api/system/dept/access-dept',
    method: 'get'
  });
}

export function fetchCreateDept(data: Partial<Api.Dept.Dept>) {
  return request({
    url: '/api/system/dept/create',
    method: 'post',
    data
  });
}

export function fetchUpdateDept(id: number, data: Partial<Api.Dept.Dept>) {
  return request({
    url: `/api/system/dept/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteDept(id: number) {
  return request({
    url: `/api/system/dept/delete/${id}`,
    method: 'delete'
  });
}

export function fetchUpdateDeptStatus(id: number, status: number) {
  return request({
    url: `/api/system/dept/status/${id}`,
    method: 'put',
    data: { status }
  });
}

export function fetchGetDeptDetail(id: number) {
  return request<Api.Dept.Dept>({
    url: `/api/system/dept/detail/${id}`,
    method: 'get'
  });
}
