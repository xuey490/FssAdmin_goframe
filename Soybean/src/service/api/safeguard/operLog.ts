import { request } from '../../request';

/**
 * 操作日志 API
 */
export function fetchGetOperLogList(params?: Api.Safeguard.OperLogSearchParams) {
  return request<Api.Safeguard.OperLogList>({
    url: '/api/core/logs/getOperLogPageList',
    method: 'get',
    params
  });
}

export function fetchDeleteOperLog(data: { ids: number[] }) {
  return request<any>({
    url: '/api/core/logs/deleteOperLog',
    method: 'delete',
    data
  });
}
