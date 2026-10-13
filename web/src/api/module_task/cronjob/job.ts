import request from '@/utils/http'

const API_PATH = '/api/task/cronjob/job'

export interface SchedulerStatus {
  status: string
  is_running: boolean
  job_count: number
  /** 实际参与调度的任务数（不含未支持/暂停） */
  active_count?: number
  /** 进程启动以来完成的执行次数：前端据此判断「有新执行」并自动刷新 */
  run_seq?: number
  /** 最近一次执行完成时间 */
  last_run_at?: string
}

export interface SchedulerJob {
  id: string
  name: string
  /** 任务类型（task_node.func） */
  handler?: string
  /** cron[表达式] / interval[@every 5m0s] / date[时间] / 未配置触发器 */
  trigger: string
  next_run_time?: string
  /** 0=运行中 1=暂停中 2=已停止 */
  status: number
  status_text?: string
  running?: boolean
  fail_count?: number
  last_run_time?: string
  last_error?: string
  unsupported_reason?: string
}

export interface JobLogPageQuery {
  page_no?: number
  page_size?: number
  job_id?: string
  job_name?: string
  trigger_type?: string
  status?: number
  [key: string]: unknown
}

export interface JobLogTable {
  id?: number
  job_id: string
  job_name?: string
  trigger_type?: string
  next_run_time?: string
  job_state?: string
  result?: string
  error?: string
  status?: number
  description?: string
  /** 后端返回的数据库列名 */
  create_time?: string
  update_time?: string
  tenant_id?: number
}

/** 与后端 PageResultSchema 对齐 */
export interface JobLogPageResult {
  page_no?: number
  page_size?: number
  total: number
  has_next?: boolean
  items: JobLogTable[]
}

const JobAPI = {
  getSchedulerStatus() {
    return request.get<SchedulerStatus>({ url: `${API_PATH}/scheduler/status` })
  },

  getSchedulerJobs() {
    return request.get<SchedulerJob[]>({ url: `${API_PATH}/scheduler/jobs` })
  },

  startScheduler() {
    return request.post<void>({ url: `${API_PATH}/scheduler/start` })
  },

  pauseScheduler() {
    return request.post<void>({ url: `${API_PATH}/scheduler/pause` })
  },

  resumeScheduler() {
    return request.post<void>({ url: `${API_PATH}/scheduler/resume` })
  },

  shutdownScheduler() {
    return request.post<void>({ url: `${API_PATH}/scheduler/shutdown` })
  },

  clearAllJobs() {
    return request.del<void>({ url: `${API_PATH}/scheduler/jobs/clear` })
  },

  getSchedulerConsole() {
    return request.get<string>({ url: `${API_PATH}/scheduler/console` })
  },

  syncJobsToDb() {
    return request.post<number>({ url: `${API_PATH}/scheduler/sync` })
  },

  pauseJob(jobId: string) {
    return request.post<void>({ url: `${API_PATH}/task/pause/${jobId}` })
  },

  resumeJob(jobId: string) {
    return request.post<void>({ url: `${API_PATH}/task/resume/${jobId}` })
  },

  runJobNow(jobId: string) {
    return request.post<void>({ url: `${API_PATH}/task/run/${jobId}` })
  },

  removeJob(jobId: string) {
    return request.del<void>({ url: `${API_PATH}/task/remove/${jobId}` })
  },

  getJobLogList(query: JobLogPageQuery) {
    return request.get<JobLogPageResult>({ url: `${API_PATH}/log/list`, params: query })
  },

  getJobLogDetail(id: number) {
    return request.get<JobLogTable>({ url: `${API_PATH}/log/detail/${id}` })
  },

  deleteJobLog(ids: number[]) {
    return request.del<void>({ url: `${API_PATH}/log/delete`, data: ids })
  }
}

export default JobAPI
