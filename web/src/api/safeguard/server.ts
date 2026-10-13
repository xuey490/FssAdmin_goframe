import request from '@/utils/http'

export type ServerUsage = {
  percent: number
  text: string
  detail: string
  cores?: number
  model?: string
}

export type ServerPartition = {
  device: string
  mountpoint: string
  fstype: string
  total: string
  used: string
  free: string
  usedPercent: string
}

export type ServerMonitorData = {
  cpu: ServerUsage
  memory: ServerUsage
  disk: ServerUsage
  goroutines: number
  processes: number
  partitions: ServerPartition[]
  system: {
    hostname: string
    os: string
    arch: string
    cpuModel: string
    uptime: string
    appUptime: string
    processes: number
  }
  runtime: {
    version: string
    goroutines: number
    heapAlloc: string
    heapSys: string
    stackInUse: string
    numGC: number
    lastGC: string
  }
}

/**
 * 服务器信息 API
 */
export default {
  /** 服务监控：CPU / 内存 / 磁盘 / 进程 / Go 运行时 */
  monitor(params: Record<string, any> = {}) {
    return request.get<ServerMonitorData>({
      url: '/api/core/server/monitor',
      params
    })
  },

  /** 缓存列表（复用 Redis 监控） */
  cache(params: Record<string, any> = {}) {
    return request.get<any>({
      url: '/api/core/server/cache',
      params
    })
  },

  /** 清理缓存 */
  clear(params: Record<string, any> = {}) {
    return request.post<any>({
      url: '/api/core/server/clear',
      data: params
    })
  },

  redisInfo() {
    return request.get<any>({
      url: '/api/core/redis/info'
    })
  },

  redisOperations() {
    return request.get<any>({
      url: '/api/core/redis/operations'
    })
  },

  redisKeys(params: Record<string, any> = {}) {
    return request.get<any>({
      url: '/api/core/redis/keys',
      params
    })
  },

  deleteRedisKeys(params: Record<string, any>) {
    return request.del<any>({
      url: '/api/core/redis/deleteKeys',
      data: params
    })
  }
}
