import { request } from '../../request';

export function fetchGetFlowTemplateList(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Template>>({
    url: '/api/flow/template/list',
    method: 'get',
    params
  });
}

export function fetchGetFlowTemplateDetail(id: number | string) {
  return request<Api.Flow.TemplateDetail>({
    url: `/api/flow/template/detail/${id}`,
    method: 'get'
  });
}

export function fetchCreateFlowTemplate(data: Partial<Api.Flow.TemplatePayload>) {
  return request({
    url: '/api/flow/template/create',
    method: 'post',
    data
  });
}

export function fetchUpdateFlowTemplate(id: number | string, data: Partial<Api.Flow.TemplatePayload>) {
  return request({
    url: `/api/flow/template/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeleteFlowTemplate(id: number | string) {
  return request({
    url: `/api/flow/template/delete/${id}`,
    method: 'delete'
  });
}

export function fetchSaveFlowTemplateDefinition(id: number | string, flow_definition: string) {
  return request({
    url: `/api/flow/template/save-definition/${id}`,
    method: 'put',
    data: { flow_definition }
  });
}

export function fetchSaveFlowTemplateForm(id: number | string, form_json: string) {
  return request({
    url: `/api/flow/template/save-form/${id}`,
    method: 'put',
    data: { form_json }
  });
}

export function fetchGetFlowTemplateFixedForms() {
  return request<Api.Flow.FixedFormOption[]>({
    url: '/api/flow/template/fixed-forms',
    method: 'get'
  });
}

