export interface FlowPageResult<T = any> {
  list: T[];
  total: number;
  currentPage: number;
  pageSize: number;
}

/** 解析 flow 模块分页响应（后端统一返回 list/total/page/limit） */
export function parseFlowPageResponse<T = any>(
  resp: unknown,
  fallback?: { page?: number; limit?: number }
): FlowPageResult<T> {
  const page = fallback?.page ?? 1;
  const limit = fallback?.limit ?? 15;

  if (!resp || typeof resp !== 'object') {
    return { list: [], total: 0, currentPage: page, pageSize: limit };
  }

  const data = resp as Record<string, any>;
  const list = Array.isArray(data.list)
    ? data.list
    : Array.isArray(data.data)
      ? data.data
      : Array.isArray(data.items)
        ? data.items
        : [];

  return {
    list: list as T[],
    total: Number(data.total ?? 0),
    currentPage: Number(data.page ?? data.current_page ?? page),
    pageSize: Number(data.limit ?? data.per_page ?? limit)
  };
}
