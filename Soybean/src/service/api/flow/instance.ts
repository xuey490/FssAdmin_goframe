import { request } from '../../request';

export function fetchGetFlowInstanceStartMeta(templateId: number | string) {
  return request<Api.Flow.InstanceStartMeta>({
    url: `/api/flow/instance/start-meta/${templateId}`,
    method: 'get'
  });
}

export function fetchGetFlowInstanceResubmitMeta(instanceId: number | string) {
  return request<Api.Flow.InstanceResubmitMeta>({
    url: `/api/flow/instance/resubmit-meta/${instanceId}`,
    method: 'get'
  });
}

export function fetchStartFlowInstance(data: Api.Flow.InstanceStartPayload) {
  return request({
    url: '/api/flow/instance/start',
    method: 'post',
    data
  });
}

export function fetchResubmitFlowInstance(data: Api.Flow.InstanceResubmitPayload) {
  return request({
    url: '/api/flow/instance/resubmit',
    method: 'post',
    data
  });
}

export function fetchGetMyStartedFlowInstances(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Instance>>({
    url: '/api/flow/instance/my-started',
    method: 'get',
    params
  });
}

export function fetchGetAllFlowInstances(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Instance>>({
    url: '/api/flow/instance/all',
    method: 'get',
    params
  });
}

export function fetchGetFlowTemplateInstances(templateId: number | string, params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Instance>>({
    url: `/api/flow/instance/template-list/${templateId}`,
    method: 'get',
    params
  });
}

export function fetchGetFlowInstanceDetail(id: number | string) {
  return request<Api.Flow.InstanceDetail>({
    url: `/api/flow/instance/detail/${id}`,
    method: 'get'
  });
}

export function fetchCancelFlowInstance(id: number | string, data: Record<string, any> = {}) {
  return request({
    url: `/api/flow/instance/cancel/${id}`,
    method: 'put',
    data
  });
}

export function fetchTerminateFlowInstance(id: number | string) {
  return request({
    url: `/api/flow/instance/terminate/${id}`,
    method: 'put'
  });
}

export function fetchGetFlowInstanceCurrentApprovers(id: number | string) {
  return request<Api.Flow.Approver[]>({
    url: `/api/flow/instance/current-approvers/${id}`,
    method: 'get'
  });
}

export function fetchAddFlowInstanceSigner(data: Api.Flow.InstanceSignerPayload) {
  return request({
    url: '/api/flow/instance/add-signer',
    method: 'post',
    data
  });
}

export function fetchRemoveFlowInstanceSigner(data: Api.Flow.InstanceSignerPayload) {
  return request({
    url: '/api/flow/instance/remove-signer',
    method: 'post',
    data
  });
}

export function fetchChangeFlowInstanceSigner(data: Api.Flow.InstanceSignerPayload) {
  return request({
    url: '/api/flow/instance/change-signer',
    method: 'post',
    data
  });
}

export function fetchCopyFlowInstance(data: Api.Flow.InstanceCopyPayload) {
  return request({
    url: '/api/flow/instance/copy',
    method: 'post',
    data
  });
}

