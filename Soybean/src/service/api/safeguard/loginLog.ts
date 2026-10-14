import { request } from '../../request';

/**
 * 登录日志 API
 */
export function fetchGetLoginLogList(params?: Api.Safeguard.LoginLogSearchParams) {
  return request<Api.Safeguard.LoginLogList>({
    url: '/api/core/logs/getLoginLogPageList',
    method: 'get',
    params
  });
}

export function fetchDeleteLoginLog(data: { ids: number[] }) {
  return request<any>({
    url: '/api/core/logs/deleteLoginLog',
    method: 'delete',
    data
  });
}
