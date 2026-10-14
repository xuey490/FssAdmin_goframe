import { request } from '../../request';

/**
 * 字典数据 API
 */

// ==================== 字典类型 ====================

export function fetchGetDictTypeList(params?: Api.Safeguard.DictTypeSearchParams) {
  return request<Api.Safeguard.DictTypeList>({
    url: '/api/system/dict/type/list',
    method: 'get',
    params
  });
}

export function fetchCreateDictType(data: Record<string, any>) {
  return request<any>({
    url: '/api/system/dict/type/create',
    method: 'post',
    data
  });
}

export function fetchUpdateDictType(id: number, data: Record<string, any>) {
  return request<any>({
    url: `/api/system/dict/type/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteDictType(id: number) {
  return request<any>({
    url: `/api/system/dict/type/delete/${id}`,
    method: 'delete'
  });
}

export function fetchUpdateDictTypeStatus(id: number, status: number) {
  return request<any>({
    url: `/api/system/dict/type/status/${id}`,
    method: 'put',
    data: { status }
  });
}

// ==================== 字典数据 ====================

export function fetchGetDictDataList(params?: Api.Safeguard.DictDataSearchParams) {
  return request<Api.Safeguard.DictDataList>({
    url: '/api/system/dict/data/list',
    method: 'get',
    params
  });
}

export function fetchGetDictDataByCode(dictCode: string) {
  return request<Api.Safeguard.DictData[]>({
    url: `/api/system/dict/data/code/${dictCode}`
  });
}

export function fetchCreateDictData(data: Record<string, any>) {
  return request<any>({
    url: '/api/system/dict/data/create',
    method: 'post',
    data
  });
}

export function fetchUpdateDictData(id: number, data: Record<string, any>) {
  return request<any>({
    url: `/api/system/dict/data/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteDictData(id: number) {
  return request<any>({
    url: `/api/system/dict/data/delete/${id}`,
    method: 'delete'
  });
}

export function fetchBatchDeleteDictData(ids: (number | string)[]) {
  return request<any>({
    url: '/api/system/dict/data/batchDelete',
    method: 'delete',
    data: { ids }
  });
}

export function fetchUpdateDictDataStatus(id: number, status: number) {
  return request<any>({
    url: `/api/system/dict/data/status/${id}`,
    method: 'put',
    data: { status }
  });
}
