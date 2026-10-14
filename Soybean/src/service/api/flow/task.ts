import { request } from '../../request';

export function fetchGetFlowPendingTasks(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Task>>({
    url: '/api/flow/task/pending',
    method: 'get',
    params
  });
}

export function fetchGetFlowCompletedTasks(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Task>>({
    url: '/api/flow/task/completed',
    method: 'get',
    params
  });
}

export function fetchGetFlowRevertedCanceledTasks(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Task>>({
    url: '/api/flow/task/reverted-canceled',
    method: 'get',
    params
  });
}

export function fetchGetFlowCopyMeTasks(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Task>>({
    url: '/api/flow/task/copy-me',
    method: 'get',
    params
  });
}

export function fetchGetFlowPendingTemplateCounts() {
  return request<Api.Flow.PendingTemplateCount[]>({
    url: '/api/flow/task/pending-template-counts',
    method: 'get'
  });
}

export function fetchApproveFlowTask(data: Api.Flow.TaskApprovePayload) {
  return request({
    url: '/api/flow/task/approve',
    method: 'post',
    data
  });
}

export function fetchAddSignFlowTask(data: Api.Flow.TaskAddSignPayload) {
  return request({
    url: '/api/flow/task/add-sign',
    method: 'post',
    data
  });
}

export function fetchTransferFlowTask(data: Api.Flow.TaskTransferPayload) {
  return request({
    url: '/api/flow/task/transfer',
    method: 'post',
    data
  });
}

export function fetchGetFlowTaskTrace(instanceId: number | string) {
  return request<Api.Flow.TaskTraceNode[]>({
    url: `/api/flow/task/trace/${instanceId}`,
    method: 'get'
  });
}

