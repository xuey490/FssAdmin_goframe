import { request } from '../request';

export function fetchGetPostList(params?: Api.Post.PostSearchParams) {
  return request<Api.Post.PostList>({
    url: '/api/system/post/list',
    method: 'get',
    params
  });
}

export function fetchCreatePost(data: Partial<Api.Post.Post>) {
  return request({
    url: '/api/system/post/create',
    method: 'post',
    data
  });
}

export function fetchUpdatePost(id: number, data: Partial<Api.Post.Post>) {
  return request({
    url: `/api/system/post/update/${id}`,
    method: 'put',
    data
  });
}

export function fetchDeletePost(id: number) {
  return request({
    url: `/api/system/post/delete/${id}`,
    method: 'delete'
  });
}

export function fetchUpdatePostStatus(id: number, status: Api.Common.EnableStatus) {
  return request({
    url: `/api/system/post/status/${id}`,
    method: 'put',
    params: { status }
  });
}

export function fetchGetAccessPostList() {
  return request<Array<{ id: number; name: string }>>({
    url: '/api/system/post/access-post',
    method: 'get'
  });
}
