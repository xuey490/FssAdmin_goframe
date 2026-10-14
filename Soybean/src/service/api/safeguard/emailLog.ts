import { request } from '../../request';

/**
 * 邮件日志 API
 */
export function fetchGetEmailLogList(params?: Api.Safeguard.EmailLogSearchParams) {
  return request<Api.Safeguard.EmailLogList>({
    url: '/api/core/email/index',
    method: 'get',
    params
  });
}

export function fetchDeleteEmailLog(data: Record<string, any>) {
  return request<any>({
    url: '/api/core/email/destroy',
    method: 'delete',
    data
  });
}
