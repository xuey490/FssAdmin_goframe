import JobAPI, { type SchedulerStatus } from '@/api/module_task/cronjob/job'
import { onBeforeUnmount, ref, type Ref } from 'vue'

export interface SchedulerWatchOptions {
  /** 检测到调度器状态变化（含任务执行）时回调，一般用于刷新列表 */
  onSync: () => void | Promise<void>
  /** 状态探测间隔（毫秒），默认 3000 */
  pollMs?: number
  /** 兜底全量刷新间隔（毫秒），默认 30000 */
  idleMs?: number
}

export interface SchedulerWatch {
  /** 调度器实时状态（页面直接展示，避免各处重复拉取） */
  schedulerStatus: Ref<SchedulerStatus>
  /** 自动刷新开关，可在页面上关闭 */
  autoRefresh: Ref<boolean>
  /** 最后一次刷新时间（HH:mm:ss） */
  lastSyncAt: Ref<string>
  /** 监控异常提示，空串表示正常 */
  syncError: Ref<string>
  /** 立即取一次调度器状态 */
  refreshStatus: () => Promise<SchedulerStatus | undefined>
  /** 立即执行一次刷新回调 */
  syncNow: () => Promise<void>
  /** 启动监控 */
  start: () => void
  /** 停止监控 */
  stop: () => void
}

const timeText = () =>
  new Date().toLocaleTimeString('zh-CN', { hour12: false, hour: '2-digit', minute: '2-digit', second: '2-digit' })

/**
 * 调度器进程监控：
 * - 周期性拉取轻量的调度器状态，用「状态指纹」判断是否有任务执行过（run_seq 变化）或调度器被启停；
 * - 一旦指纹变化就调用 onSync 刷新当前页面的数据；
 * - 另有兜底全量刷新，覆盖「别的页面改了节点/任务」这类不影响指纹的情况；
 * - 页面隐藏时暂停，组件卸载时自动清理定时器。
 */
export function useSchedulerWatch(options: SchedulerWatchOptions): SchedulerWatch {
  const pollMs = options.pollMs ?? 3000
  const idleMs = options.idleMs ?? 30000

  const schedulerStatus = ref<SchedulerStatus>({ status: '未知', is_running: false, job_count: 0 })
  const autoRefresh = ref(true)
  const lastSyncAt = ref('')
  const syncError = ref('')

  let fingerprint = ''
  let pollTimer: ReturnType<typeof setInterval> | undefined
  let idleTimer: ReturnType<typeof setInterval> | undefined
  let syncing = false

  const statusFingerprint = (s: SchedulerStatus) =>
    [s.status, s.is_running, s.job_count, s.active_count ?? 0, s.run_seq ?? 0].join('|')

  async function refreshStatus() {
    try {
      const status = await JobAPI.getSchedulerStatus()
      schedulerStatus.value = status
      syncError.value = ''
      return status
    } catch (error) {
      console.error(error)
      syncError.value = '调度器状态获取失败'
      return undefined
    }
  }

  async function syncNow() {
    if (syncing) return
    syncing = true
    try {
      await options.onSync()
      lastSyncAt.value = timeText()
    } catch (error) {
      console.error(error)
    } finally {
      syncing = false
    }
  }

  async function tick() {
    if (!autoRefresh.value || document.hidden) return
    const status = await refreshStatus()
    if (!status) return
    const next = statusFingerprint(status)
    // 首次只记录基线；之后指纹变化（任务执行、启停、任务数变化）即刷新列表
    if (fingerprint && next !== fingerprint) {
      await syncNow()
    }
    fingerprint = next
  }

  function stop() {
    if (pollTimer) {
      clearInterval(pollTimer)
      pollTimer = undefined
    }
    if (idleTimer) {
      clearInterval(idleTimer)
      idleTimer = undefined
    }
  }

  function start() {
    stop()
    void tick()
    pollTimer = setInterval(() => {
      void tick()
    }, pollMs)
    idleTimer = setInterval(() => {
      if (!autoRefresh.value || document.hidden) return
      void syncNow()
    }, idleMs)
  }

  onBeforeUnmount(stop)

  return {
    schedulerStatus,
    autoRefresh,
    lastSyncAt,
    syncError,
    refreshStatus,
    syncNow,
    start,
    stop
  }
}
