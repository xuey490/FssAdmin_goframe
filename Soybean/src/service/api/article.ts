import { request } from '../request';

function buildArticleListParams(params?: Api.Article.ArticleSearchParams) {
  const { limit, page, page_size, ...rest } = params || {};
  return {
    ...rest,
    page: page ?? 1,
    page_size: page_size ?? limit ?? 10
  };
}

/** 获取文章列表 */
export function fetchGetArticleList(params?: Api.Article.ArticleSearchParams) {
  return request<Api.Article.ArticleList>({
    url: '/api/article/list',
    method: 'get',
    params: buildArticleListParams(params)
  });
}

/** 获取文章详情 */
export function fetchGetArticleDetail(id: number | string) {
  return request<Api.Article.Article>({
    url: `/api/article/detail/${id}`
  });
}

/** 创建文章 */
export function fetchCreateArticle(data: Api.Article.ArticleForm) {
  return request<any>({
    url: '/api/article/create',
    method: 'post',
    data
  });
}

/** 更新文章 */
export function fetchUpdateArticle(id: number, data: Api.Article.ArticleForm) {
  return request<any>({
    url: `/api/article/update/${id}`,
    method: 'put',
    data
  });
}

/** 删除文章（go 只认 body.ids） */
export function fetchDeleteArticle(id: number | string) {
  return request<any>({
    url: '/api/article/delete',
    method: 'delete',
    data: { ids: [id] }
  });
}

/** 批量删除文章 */
export function fetchBatchDeleteArticle(ids: (number | string)[]) {
  return request<any>({
    url: '/api/article/delete',
    method: 'delete',
    data: { ids }
  });
}

/** 更新文章状态 */
export function fetchUpdateArticleStatus(id: number | string, status: number) {
  return request<any>({
    url: `/api/article/status/${id}`,
    method: 'put',
    data: { status }
  });
}
