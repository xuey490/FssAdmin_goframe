import { request } from '../../request';

export function fetchGetFlowCategoryTree() {
  return request<Api.Flow.CategoryNode[]>({
    url: '/api/flow/category/tree',
    method: 'get'
  });
}

export function fetchCreateFlowCategory(data: Partial<Api.Flow.Category>) {
  return request({
    url: '/api/flow/category/create',
    method: 'post',
    data
  });
}

export function fetchUpdateFlowCategory(id: number | string, data: Partial<Api.Flow.Category>) {
  return request({
    url: `/api/flow/category/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteFlowCategory(id: number | string) {
  return request({
    url: `/api/flow/category/delete/${id}`,
    method: 'delete'
  });
}

export function fetchUpdateFlowCategoryStatus(id: number | string, status: number) {
  return request({
    url: `/api/flow/category/status/${id}`,
    method: 'put',
    data: { status }
  });
}

