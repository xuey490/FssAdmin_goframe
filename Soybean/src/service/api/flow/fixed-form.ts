import { request } from '../../request';

export function fetchGetFlowFixedFormList(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.FixedForm>>({
    url: '/api/flow/fixed-form/list',
    method: 'get',
    params
  });
}

export function fetchGetFlowFixedFormDetail(id: number | string) {
  return request<Api.Flow.FixedForm>({
    url: `/api/flow/fixed-form/detail/${id}`,
    method: 'get'
  });
}

export function fetchCreateFlowFixedForm(data: Partial<Api.Flow.FixedFormPayload>) {
  return request({
    url: '/api/flow/fixed-form/create',
    method: 'post',
    data
  });
}

export function fetchUpdateFlowFixedForm(id: number | string, data: Partial<Api.Flow.FixedFormPayload>) {
  return request({
    url: `/api/flow/fixed-form/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteFlowFixedForm(id: number | string) {
  return request({
    url: `/api/flow/fixed-form/delete/${id}`,
    method: 'delete'
  });
}

export function fetchUpdateFlowFixedFormStatus(id: number | string, status: number) {
  return request({
    url: `/api/flow/fixed-form/status/${id}`,
    method: 'put',
    data: { status }
  });
}

