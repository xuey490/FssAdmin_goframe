import { request } from '../../request';

export function fetchGetFlowMessageList(params: Api.Flow.FlowPageParams) {
  return request<Api.Flow.LaravelPage<Api.Flow.Message>>({
    url: '/api/flow/message/list',
    method: 'get',
    params
  });
}

export function fetchGetFlowMessageGrouped(params: Record<string, any> = {}) {
  return request<Api.Flow.MessageGrouped>({
    url: '/api/flow/message/grouped',
    method: 'get',
    params
  });
}

export function fetchGetFlowMessageUnreadCount() {
  return request<Api.Flow.MessageUnreadCount>({
    url: '/api/flow/message/unread-count',
    method: 'get'
  });
}

export function fetchReadFlowMessage(id: number | string) {
  return request({
    url: `/api/flow/message/read/${id}`,
    method: 'put'
  });
}

export function fetchReadAllFlowMessages(messageType: string = '') {
  return request({
    url: '/api/flow/message/read-all',
    method: 'put',
    data: { message_type: messageType }
  });
}

export function fetchDeleteFlowMessage(id: number | string) {
  return request({
    url: `/api/flow/message/delete/${id}`,
    method: 'delete'
  });
}

