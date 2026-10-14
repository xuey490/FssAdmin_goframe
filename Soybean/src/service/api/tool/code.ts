import axios from 'axios';
import { request } from '../../request';
import { getAuthorization } from '../../request/shared';
import { getServiceBaseURL, shouldUseHttpProxy } from '@/utils/service';

/**
 * 代码生成 API
 */
export function fetchGetCodeGenerateList(params?: Record<string, any>) {
  return request<Api.Common.PaginatingQueryRecord<any>>({
    url: '/api/tool/code/index',
    method: 'get',
    params
  });
}

export function fetchReadCodeGenerate(params?: Record<string, any>) {
  return request<any>({
    url: '/api/tool/code/read',
    method: 'get',
    params
  });
}

export function fetchUpdateCodeGenerate(data: Record<string, any>) {
  return request<any>({
    url: '/api/tool/code/update',
    method: 'put',
    data
  });
}

export function fetchDeleteCodeGenerate(data: Record<string, any>) {
  return request<any>({
    url: '/api/tool/code/destroy',
    method: 'delete',
    data
  });
}

export function fetchGetCodeTableColumns(params?: Record<string, any>) {
  return request<any[]>({
    url: '/api/tool/code/getTableColumns',
    method: 'get',
    params
  });
}

export function fetchLoadCodeTable(params?: Record<string, any>) {
  return request<any>({
    url: '/api/tool/code/loadTable',
    method: 'post',
    params
  });
}

export function fetchSyncCodeTable(params?: Record<string, any>) {
  return request<any>({
    url: '/api/tool/code/sync',
    method: 'post',
    params
  });
}

export function fetchPreviewCodeGenerate(params?: Record<string, any>) {
  return request<any[]>({
    url: '/api/tool/code/preview',
    method: 'get',
    params
  });
}

export function fetchGenerateCodeFile(params?: Record<string, any>) {
  return request<any>({
    url: '/api/tool/code/generateFile',
    method: 'post',
    params
  });
}

/** 下载生成的代码 zip（blob 响应） */
export async function fetchGenerateCodeDownload(params?: Record<string, any>) {
  const isHttpProxy = shouldUseHttpProxy();
  const { baseURL } = getServiceBaseURL(import.meta.env, isHttpProxy);

  return axios({
    method: 'post',
    url: '/api/tool/code/generate',
    baseURL,
    params,
    responseType: 'blob',
    timeout: 20 * 1000,
    headers: {
      Authorization: getAuthorization()
    }
  });
}
