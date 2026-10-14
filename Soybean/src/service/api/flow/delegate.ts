import { request } from '../../request';

export function fetchGetFlowDelegateList(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Delegate>>({
    url: '/api/flow/delegate/list',
    method: 'get',
    params
  });
}

export function fetchGetFlowDelegateDetail(id: number | string) {
  return request<Api.Flow.Delegate>({
    url: `/api/flow/delegate/detail/${id}`,
    method: 'get'
  });
}

export function fetchCreateFlowDelegate(data: Partial<Api.Flow.DelegatePayload>) {
  return request({
    url: '/api/flow/delegate/create',
    method: 'post',
    data
  });
}

export function fetchUpdateFlowDelegate(id: number | string, data: Partial<Api.Flow.DelegatePayload>) {
  return request({
    url: `/api/flow/delegate/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteFlowDelegate(id: number | string) {
  return request({
    url: `/api/flow/delegate/delete/${id}`,
    method: 'delete'
  });
}

export function fetchUpdateFlowDelegateStatus(id: number | string, status: number) {
  return request({
    url: `/api/flow/delegate/status/${id}`,
    method: 'put',
    data: { status }
  });
}

export function fetchGetFlowDelegateTemplateOptions() {
  return request<Api.Flow.TemplateOption[]>({
    url: '/api/flow/delegate/template-options',
    method: 'get'
  });
}

export function fetchGetFlowDelegateUserOptions(params: Api.Flow.FlowPageParams & { keyword?: string }) {
  return request<Api.Flow.LaravelPage<Api.Flow.UserOption>>({
    url: '/api/flow/delegate/user-options',
    method: 'get',
    params
  });
}

