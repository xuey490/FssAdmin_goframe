import { request } from '../../request';

/**
 * 数据表维护 API
 */
export function fetchGetDatabaseTableList(params?: Api.Safeguard.DatabaseTableSearchParams) {
  return request<Api.Safeguard.DatabaseTableList>({
    url: '/api/core/database/table/list',
    method: 'get',
    params
  });
}

export function fetchGetDatabaseDataSource(params?: Record<string, any>) {
  return request<any>({
    url: '/api/core/database/table/dataSource',
    method: 'get',
    params
  });
}

export function fetchGetDatabaseTableDetailed(params?: Record<string, any>) {
  return request<Api.Safeguard.DatabaseColumn[]>({
    url: '/api/core/database/table/detailed',
    method: 'get',
    params
  });
}

export function fetchGetDatabaseRecycleList(params?: Record<string, any>) {
  return request<Api.Safeguard.DatabaseRecycleList>({
    url: '/api/core/database/recycle/list',
    method: 'get',
    params
  });
}

export function fetchDestroyDatabaseRecycle(data: Record<string, any>) {
  return request<any>({
    url: '/api/core/database/recycle/destroy',
    method: 'post',
    data
  });
}

export function fetchRecoveryDatabaseRecycle(data: Record<string, any>) {
  return request<any>({
    url: '/api/core/database/recycle/recovery',
    method: 'post',
    data
  });
}

export function fetchOptimizeDatabaseTable(data: Record<string, any>) {
  return request<any>({
    url: '/api/core/database/table/optimize',
    method: 'post',
    data
  });
}

export function fetchFragmentDatabaseTable(data: Record<string, any>) {
  return request<any>({
    url: '/api/core/database/table/fragment',
    method: 'post',
    data
  });
}

export function fetchGetDatabaseTableDdl(params?: Record<string, any>) {
  return request<any>({
    url: '/api/core/database/table/createSql',
    method: 'get',
    params
  });
}
