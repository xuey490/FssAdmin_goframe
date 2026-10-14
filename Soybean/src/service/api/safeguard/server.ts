import { request } from '../../request';

/**
 * 服务器监控与 Redis API（对齐 go-project / web）
 */
export function fetchGetServerMonitor(params?: Record<string, any>) {
  return request<Api.Safeguard.ServerInfo>({
    url: '/api/core/server/monitor',
    method: 'get',
    params
  });
}

export function fetchGetServerCache(params?: Record<string, any>) {
  return request<any>({
    url: '/api/core/server/cache',
    method: 'get',
    params
  });
}

export function fetchClearServerCache(data?: Record<string, any>) {
  return request<any>({
    url: '/api/core/server/clear',
    method: 'post',
    data
  });
}

export function fetchGetRedisMonitor() {
  return request<Api.Safeguard.RedisInfo>({
    url: '/api/core/server/redis',
    method: 'get'
  });
}

export function fetchGetRedisInfo() {
  return request<Api.Safeguard.RedisInfo>({
    url: '/api/core/redis/info',
    method: 'get'
  });
}

export function fetchGetRedisOperations() {
  return request<any>({
    url: '/api/core/redis/operations',
    method: 'get'
  });
}

export function fetchGetRedisKeys(params?: Record<string, any>) {
  return request<{ keys: string[]; total: number }>({
    url: '/api/core/redis/keys',
    method: 'get',
    params
  });
}

export function fetchDeleteRedisKeys(data: Record<string, any>) {
  return request<any>({
    url: '/api/core/redis/deleteKeys',
    method: 'delete',
    data
  });
}

// ==================== Redis 浏览器 ====================

export function fetchGetRedisLevel1(pattern?: string) {
  return request<any[]>({
    url: '/api/core/server/redis/browser/level1',
    method: 'get',
    params: { pattern }
  });
}

export function fetchGetRedisLevel2(prefix: string) {
  return request<any[]>({
    url: '/api/core/server/redis/browser/level2',
    method: 'get',
    params: { prefix }
  });
}

export function fetchGetRedisLevel3(prefix: string) {
  return request<any[]>({
    url: '/api/core/server/redis/browser/level3',
    method: 'get',
    params: { prefix }
  });
}

export function fetchGetRedisKeyInfo(key: string) {
  return request<any>({
    url: '/api/core/server/redis/browser/key-info',
    method: 'get',
    params: { key }
  });
}

export function fetchDeleteRedisKey(key: string) {
  return request<any>({
    url: '/api/core/server/redis/browser/delete',
    method: 'delete',
    data: { key }
  });
}

export function fetchDeleteRedisByPattern(pattern: string) {
  return request<any>({
    url: '/api/core/server/redis/browser/delete',
    method: 'delete',
    data: { pattern }
  });
}
