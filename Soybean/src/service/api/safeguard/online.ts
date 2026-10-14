import { request } from '../../request';

export function fetchGetOnlineList(params?: Record<string, any>) {
  return request<Api.Common.PaginatingQueryRecord<any>>({
    url: '/api/monitor/online/list',
    method: 'get',
    params
  });
}

export function fetchForceLogout(token: string) {
  return request<any>({
    url: `/api/monitor/online/${token}`,
    method: 'delete'
  });
}
