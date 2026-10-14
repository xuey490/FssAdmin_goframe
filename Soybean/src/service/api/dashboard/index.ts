import { request } from '../../request';

/**
 * Dashboard 控制台 API
 */
export function fetchStatistics() {
  return request<Api.Dashboard.StatisticsData>({
    url: '/api/core/system/statistics',
    method: 'get'
  });
}

export function fetchLoginChart() {
  return request<Api.Dashboard.LoginChartData>({
    url: '/api/core/system/loginChart',
    method: 'get'
  });
}

export function fetchLoginBarChart() {
  return request<Api.Dashboard.LoginBarChartData>({
    url: '/api/core/system/loginBarChart',
    method: 'get'
  });
}

export function fetchGetLoginLogs(params?: Api.Dashboard.LogSearchParams) {
  return request<Api.Dashboard.LogList>({
    url: '/api/core/system/getLoginLogList',
    method: 'get',
    params
  });
}

export function fetchGetOperateLogs(params?: Api.Dashboard.LogSearchParams) {
  return request<Api.Dashboard.LogList>({
    url: '/api/core/system/getOperationLogList',
    method: 'get',
    params
  });
}

export function updateUserInfo(data: Api.Dashboard.UpdateUserInfoParams) {
  return request<any>({
    url: '/api/core/user/updateInfo',
    method: 'post',
    data
  });
}

export function modifyPassword(data: Api.Dashboard.ModifyPasswordParams) {
  return request<any>({
    url: '/api/core/user/modifyPassword',
    method: 'post',
    data
  });
}
