import { request } from '../../../request';

const API_PATH = '/api/task/cronjob/job';

export interface SchedulerStatus {
  status: string;
  is_running: boolean;
  job_count: number;
  active_count?: number;
  run_seq?: number;
  last_run_at?: string;
}

export interface SchedulerJob {
  id: string;
  name: string;
  handler?: string;
  trigger: string;
  next_run_time?: string;
  status: number;
  status_text?: string;
  running?: boolean;
  fail_count?: number;
  last_run_time?: string;
  last_error?: string;
  unsupported_reason?: string;
}

export interface JobLogPageQuery {
  page_no?: number;
  page_size?: number;
  job_id?: string;
  job_name?: string;
  trigger_type?: string;
  status?: number;
  [key: string]: unknown;
}

export interface JobLogTable {
  id?: number;
  job_id: string;
  job_name?: string;
  trigger_type?: string;
  next_run_time?: string;
  job_state?: string;
  result?: string;
  error?: string;
  status?: number;
  description?: string;
  create_time?: string;
  update_time?: string;
  tenant_id?: number;
}

export interface JobLogPageResult {
  page_no?: number;
  page_size?: number;
  total: number;
  has_next?: boolean;
  items: JobLogTable[];
  list?: JobLogTable[];
}

async function unwrap<T>(p: ReturnType<typeof request<T>>): Promise<T> {
  const { data, error } = await p;
  if (error) throw error;
  return data as T;
}

const JobAPI = {
  getSchedulerStatus() {
    return unwrap(request<SchedulerStatus>({ url: `${API_PATH}/scheduler/status` }));
  },
  getSchedulerJobs() {
    return unwrap(request<SchedulerJob[]>({ url: `${API_PATH}/scheduler/jobs` }));
  },
  startScheduler() {
    return unwrap(request<void>({ url: `${API_PATH}/scheduler/start`, method: 'post' }));
  },
  pauseScheduler() {
    return unwrap(request<void>({ url: `${API_PATH}/scheduler/pause`, method: 'post' }));
  },
  resumeScheduler() {
    return unwrap(request<void>({ url: `${API_PATH}/scheduler/resume`, method: 'post' }));
  },
  shutdownScheduler() {
    return unwrap(request<void>({ url: `${API_PATH}/scheduler/shutdown`, method: 'post' }));
  },
  clearAllJobs() {
    return unwrap(request<void>({ url: `${API_PATH}/scheduler/jobs/clear`, method: 'delete' }));
  },
  getSchedulerConsole() {
    return unwrap(request<string>({ url: `${API_PATH}/scheduler/console` }));
  },
  syncJobsToDb() {
    return unwrap(request<number>({ url: `${API_PATH}/scheduler/sync`, method: 'post' }));
  },
  pauseJob(jobId: string) {
    return unwrap(request<void>({ url: `${API_PATH}/task/pause/${jobId}`, method: 'post' }));
  },
  resumeJob(jobId: string) {
    return unwrap(request<void>({ url: `${API_PATH}/task/resume/${jobId}`, method: 'post' }));
  },
  runJobNow(jobId: string) {
    return unwrap(request<void>({ url: `${API_PATH}/task/run/${jobId}`, method: 'post' }));
  },
  removeJob(jobId: string) {
    return unwrap(request<void>({ url: `${API_PATH}/task/remove/${jobId}`, method: 'delete' }));
  },
  getJobLogList(query: JobLogPageQuery) {
    return unwrap(request<JobLogPageResult>({ url: `${API_PATH}/log/list`, params: query }));
  },
  getJobLogDetail(id: number) {
    return unwrap(request<JobLogTable>({ url: `${API_PATH}/log/detail/${id}` }));
  },
  deleteJobLog(ids: number[]) {
    return unwrap(request<void>({ url: `${API_PATH}/log/delete`, method: 'delete', data: ids }));
  }
};

export default JobAPI;
export const {
  getSchedulerStatus,
  getSchedulerJobs,
  startScheduler,
  pauseScheduler,
  resumeScheduler,
  shutdownScheduler,
  clearAllJobs,
  getSchedulerConsole,
  syncJobsToDb,
  pauseJob,
  resumeJob,
  runJobNow,
  removeJob,
  getJobLogList,
  getJobLogDetail,
  deleteJobLog
} = JobAPI;
