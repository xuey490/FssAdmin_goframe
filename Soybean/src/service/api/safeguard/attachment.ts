import { request } from '../../request';

/**
 * 附件管理 API
 */
export function fetchGetAttachmentList(params?: Api.Safeguard.AttachmentSearchParams) {
  return request<Api.Safeguard.AttachmentList>({
    url: '/api/system/attachment/list',
    method: 'get',
    params
  });
}

export function fetchGetAttachmentDetail(id: number) {
  return request<Api.Safeguard.Attachment>({
    url: `/api/system/attachment/detail/${id}`
  });
}

export function fetchUploadAttachment(data: FormData) {
  return request<any>({
    url: '/api/system/attachment/upload',
    method: 'post',
    data
  });
}

export function fetchUpdateAttachment(id: number, data: Record<string, any>) {
  return request<any>({
    url: `/api/system/attachment/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteAttachment(id: number) {
  return request<any>({
    url: `/api/system/attachment/delete/${id}`,
    method: 'delete'
  });
}

export function fetchBatchDeleteAttachment(ids: (number | string)[]) {
  return request<any>({
    url: '/api/system/attachment/batchDelete',
    method: 'delete',
    data: { ids }
  });
}

export function fetchMoveAttachment(data: { ids: (number | string)[]; category_id: number | null }) {
  return request<any>({
    url: '/api/system/attachment/move',
    method: 'put',
    data
  });
}

export function fetchDownloadAttachment(id: number) {
  return request<Blob, 'blob'>({
    url: `/api/system/attachment/download/${id}`,
    method: 'get',
    responseType: 'blob'
  });
}

export function fetchGetAttachmentStats() {
  return request<any>({
    url: '/api/system/attachment/stats'
  });
}

export function fetchGetAttachmentCategoryList(params?: Record<string, any>) {
  return request<any>({
    url: '/api/system/attachment-category/list',
    method: 'get',
    params
  });
}
