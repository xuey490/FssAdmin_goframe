import { request } from '../request';

export function fetchGetConfigGroupList(params?: Api.Config.ConfigGroupSearchParams) {
  return request<Api.Config.ConfigGroupList>({
    url: '/api/core/configGroup/list',
    method: 'get',
    params
  });
}

export function fetchCreateConfigGroup(data: Partial<Api.Config.ConfigGroup>) {
  return request({
    url: '/api/core/configGroup/save',
    method: 'post',
    data
  });
}

export function fetchUpdateConfigGroup(id: number, data: Partial<Api.Config.ConfigGroup>) {
  return request({
    url: `/api/core/configGroup/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteConfigGroup(id: number) {
  return request({
    url: `/api/core/configGroup/delete/${id}`,
    method: 'delete'
  });
}

export function fetchGetConfigList(params?: Record<string, any>) {
  return request<any>({
    url: '/api/core/config/list',
    method: 'get',
    params
  });
}

export function fetchCreateConfig(data: Partial<Api.Config.ConfigItem>) {
  return request({
    url: '/api/core/config/save',
    method: 'post',
    data
  });
}

export function fetchUpdateConfig(id: number, data: Partial<Api.Config.ConfigItem>) {
  return request({
    url: `/api/core/config/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteConfig(data: { ids: number[] }) {
  return request({
    url: '/api/core/config/delete',
    method: 'delete',
    data
  });
}

export function fetchBatchUpdateConfig(data: { group_id: number; config: any[] }) {
  return request({
    url: '/api/core/config/batchUpdate',
    method: 'post',
    data
  });
}

export function fetchTestEmail(data: { email: string }) {
  return request({
    url: '/api/core/configGroup/testEmail',
    method: 'post',
    data
  });
}
