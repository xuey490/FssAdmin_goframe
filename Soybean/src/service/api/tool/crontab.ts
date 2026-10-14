import { request } from '../../request';

/**
 * 定时任务 API
 */
export function fetchGetCrontabList(params?: Record<string, any>) {
  return request<Api.Common.PaginatingQueryRecord<any>>({
    url: '/api/tool/crontab/list',
    method: 'get',
    params
  });
}

export function fetchGetCrontabTasks() {
  return request<string[]>({
    url: '/api/tool/crontab/tasks',
    method: 'get'
  });
}

export function fetchGetCrontabDetail(id: number | string) {
  return request<any>({
    url: `/api/tool/crontab/detail/${id}`,
    method: 'get'
  });
}

export function fetchCreateCrontab(data: Record<string, any>) {
  return request<any>({
    url: '/api/tool/crontab/create',
    method: 'post',
    data
  });
}

export function fetchUpdateCrontab(id: number | string, data: Record<string, any>) {
  return request<any>({
    url: `/api/tool/crontab/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteCrontab(data: Record<string, any>) {
  return request<any>({
    url: '/api/tool/crontab/delete',
    method: 'delete',
    data
  });
}

export function fetchRunCrontab(id: number | string) {
  return request<any>({
    url: `/api/tool/crontab/run/${id}`,
    method: 'post'
  });
}

export function fetchGetCrontabLogList(params?: Record<string, any>) {
  return request<Api.Common.PaginatingQueryRecord<any>>({
    url: '/api/tool/crontab/log/list',
    method: 'get',
    params
  });
}

export function fetchDeleteCrontabLog(data: Record<string, any>) {
  return request<any>({
    url: '/api/tool/crontab/log/delete',
    method: 'delete',
    data
  });
}

export function fetchCleanCrontabLog() {
  return request<any>({
    url: '/api/tool/crontab/log/clean',
    method: 'delete'
  });
}
