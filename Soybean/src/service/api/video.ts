import { request } from '../request';

export interface VideoProgressItem {
  video_id: number;
  status?: number | null;
  title?: string | null;
  uploader?: string | null;
  source?: string | null;
  best_resolution?: string | null;
  thumbnail?: string | null;
  duration?: number | null;
  error_msg?: string | null;
  active_job_id?: number | null;
  active_job_status?: number | null;
  job_status?: number | null;
  job_progress?: number | null;
  job_speed?: string | null;
  job_mode?: string | null;
  job_error_msg?: string | null;
  job_local_dir?: string | null;
  local_dir?: string | null;
}

export function fetchGetVideoList(params?: Record<string, any>) {
  return request<Api.Common.PaginatingQueryRecord<any>>({
    url: '/api/platform/video/list',
    method: 'get',
    params
  });
}

export function fetchGetVideoProgress(ids: Array<number | string>) {
  return request<VideoProgressItem[]>({
    url: '/api/platform/video/progress',
    method: 'get',
    params: { ids: ids.join(',') }
  });
}

export function fetchCreateVideo(data: { urls: string[]; enqueue?: boolean }) {
  return request<any>({
    url: '/api/platform/video/create',
    method: 'post',
    data
  });
}

export function fetchUpdateVideo(id: number | string, data: { url: string }) {
  return request<any>({
    url: `/api/platform/video/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchRefreshVideo(id: number | string) {
  return request<any>({
    url: `/api/platform/video/refresh/${id}`,
    method: 'post'
  });
}

export function fetchDeleteVideo(id: number | string) {
  return request<any>({
    url: `/api/platform/video/delete/${id}`,
    method: 'delete'
  });
}

export function fetchPreviewVideo(id: number | string) {
  return request<{
    stream_url: string;
    page_url: string;
    thumbnail?: string;
    title?: string;
    qualities?: Array<{
      label: string;
      height?: number | null;
      url: string;
      format_id?: string | null;
    }>;
  }>({
    url: `/api/platform/video/preview/${id}`,
    method: 'get'
  });
}

export function fetchGetVideoFormats(id: number | string) {
  return request<Array<Record<string, any>>>({
    url: `/api/platform/video/formats/${id}`,
    method: 'get'
  });
}

export function fetchGetVideoFiles(id: number | string) {
  return request<{
    local_dir?: string | null;
    title?: string | null;
    files: Array<{
      name: string;
      size: number;
      mtime?: string | null;
      ext?: string | null;
      url?: string | null;
    }>;
  }>({
    url: `/api/platform/video/files/${id}`,
    method: 'get'
  });
}

export function fetchDownloadVideo(id: number | string, data: Record<string, any>) {
  return request<any>({
    url: `/api/platform/video/download/${id}`,
    method: 'post',
    data
  });
}

export function fetchGetVideoQueue(params?: Record<string, any>) {
  return request<Api.Common.PaginatingQueryRecord<any>>({
    url: '/api/platform/video/download/queue',
    method: 'get',
    params
  });
}

export function fetchPauseVideoJob(jobId: number | string) {
  return request<any>({
    url: `/api/platform/video/download/job/${jobId}/pause`,
    method: 'post'
  });
}

export function fetchResumeVideoJob(jobId: number | string) {
  return request<any>({
    url: `/api/platform/video/download/job/${jobId}/resume`,
    method: 'post'
  });
}

export function fetchStopVideoJob(jobId: number | string) {
  return request<any>({
    url: `/api/platform/video/download/job/${jobId}/stop`,
    method: 'post'
  });
}

export function fetchPauseAllVideoJobs() {
  return request<any>({
    url: '/api/platform/video/download/queue/pause-all',
    method: 'post'
  });
}

export function fetchResumeAllVideoJobs() {
  return request<any>({
    url: '/api/platform/video/download/queue/resume-all',
    method: 'post'
  });
}
