import { request } from '../../request';

/**
 * 附件分类 API
 */
export function fetchGetCategoryList(params?: Record<string, any>) {
  return request<Api.Safeguard.AttachmentCategory[]>({
    url: '/api/system/attachment-category/list',
    method: 'get',
    params
  });
}

export function fetchGetCategoryDetail(id: number) {
  return request<Api.Safeguard.AttachmentCategory>({
    url: `/api/system/attachment-category/detail/${id}`
  });
}

export function fetchCreateCategory(data: Record<string, any>) {
  return request<any>({
    url: '/api/system/attachment-category/create',
    method: 'post',
    data
  });
}

export function fetchUpdateCategory(id: number, data: Record<string, any>) {
  return request<any>({
    url: `/api/system/attachment-category/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteCategory(id: number) {
  return request<any>({
    url: `/api/system/attachment-category/delete/${id}`,
    method: 'delete'
  });
}
