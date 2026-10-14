import { request } from '../../../request';

const API_PATH = '/api/task/cronjob/node';

export interface NodePageQuery {
  page_no?: number;
  page_size?: number;
  name?: string;
  code?: string;
  func?: string;
  status?: number;
  [key: string]: unknown;
}

export type TriggerType = 'now' | 'cron' | 'interval' | 'date';
export type NodeTriggerType = TriggerType | '';

export interface ExecuteNodeParams {
  trigger: TriggerType;
  trigger_args?: string;
  start_date?: string;
  end_date?: string;
}

export interface ExecuteNodeResult {
  job_id: number;
  status: number;
  trigger: string;
  result?: string;
  registered?: boolean;
  node_status?: number;
  trigger_label?: string;
  next_run_time?: string;
}

export type RuntimeStatus =
  | 'waiting'
  | 'running'
  | 'success'
  | 'failed'
  | 'paused'
  | 'disabled'
  | 'unconfigured'
  | 'unsupported'
  | 'unregistered';

export interface ParamSpec {
  name: string;
  title: string;
  type: 'string' | 'text' | 'number' | 'bool' | 'json' | 'select';
  required: boolean;
  default?: unknown;
  options?: Array<string | number>;
  help?: string;
}

export interface HandlerOption {
  name: string;
  title: string;
  category: string;
  description: string;
  needs_root: boolean;
  params: ParamSpec[];
  default_timeout_second: number;
  enabled: boolean;
  disabled_hint?: string;
}

export interface TriggerOption {
  value: NodeTriggerType;
  label: string;
  hint: string;
}

export interface RuntimeStatusOption {
  value: RuntimeStatus;
  label: string;
  type: string;
}

export interface NodeTypeDict {
  handlers: HandlerOption[];
  triggers: TriggerOption[];
  runtime_status: RuntimeStatusOption[];
}

export interface NodeTable {
  id?: number;
  name: string;
  code: string;
  func?: string;
  handler_title?: string;
  handler_enabled?: boolean;
  trigger?: string;
  trigger_type?: string;
  trigger_args?: string;
  start_date?: string;
  end_date?: string;
  args?: string;
  kwargs?: string;
  coalesce?: boolean | number;
  max_instances?: number;
  status?: number;
  description?: string;
  create_time?: string;
  update_time?: string;
  tenant_id?: number;
  created_by?: number;
  updated_by?: number;
  runtime_status?: RuntimeStatus;
  runtime_status_text?: string;
  supported?: boolean;
  unsupported_reason?: string;
  running?: boolean;
  next_run_time?: string;
  last_run_time?: string;
  last_status?: number | null;
  last_duration_ms?: number | null;
  fail_count?: number;
  last_error?: string;
  scheduler_state?: string;
}

export interface NodeForm {
  id?: number;
  name: string;
  code?: string;
  func?: string;
  trigger?: NodeTriggerType;
  trigger_args?: string;
  start_date?: string;
  end_date?: string;
  args?: string;
  kwargs?: string;
  coalesce?: boolean;
  max_instances?: number;
  status?: number;
  description?: string;
}

export interface NodeType {
  id: number;
  name: string;
  code: string;
  func?: string;
  args?: string;
  kwargs?: string;
}

export interface NodeBatchStatus {
  ids: number[];
  status: number;
}

export interface NodePageResult {
  page_no?: number;
  page_size?: number;
  total: number;
  has_next?: boolean;
  items: NodeTable[];
  list?: NodeTable[];
}

export interface NodeLogRow {
  id?: number;
  job_id: string;
  job_name?: string;
  trigger_type?: string;
  next_run_time?: string;
  job_state?: string;
  result?: string;
  error?: string;
  status?: number;
  description?: string;
  create_time?: string;
  update_time?: string;
}

export interface NodeLogPageResult {
  page_no?: number;
  page_size?: number;
  total: number;
  has_next?: boolean;
  items: NodeLogRow[];
  list?: NodeLogRow[];
}

async function unwrap<T>(p: ReturnType<typeof request<T>>): Promise<T> {
  const { data, error } = await p;
  if (error) throw error;
  return data as T;
}

const NodeAPI = {
  getNodeTypes() {
    return unwrap(request<NodeTypeDict>({ url: `${API_PATH}/types` }));
  },
  getNodeTypeOptions() {
    return unwrap(request<NodeType[]>({ url: `${API_PATH}/options` }));
  },
  listNode(query: NodePageQuery) {
    return unwrap(request<NodePageResult>({ url: `${API_PATH}/list`, params: query }));
  },
  detailNode(id: number) {
    return unwrap(request<NodeTable>({ url: `${API_PATH}/detail/${id}` }));
  },
  createNode(body: NodeForm) {
    return unwrap(request<NodeTable>({ url: `${API_PATH}/create`, method: 'post', data: body }));
  },
  updateNode(id: number, body: NodeForm) {
    return unwrap(request<NodeTable>({ url: `${API_PATH}/update/${id}`, method: 'put', data: body }));
  },
  deleteNode(ids: number[]) {
    return unwrap(request<void>({ url: `${API_PATH}/delete`, method: 'delete', data: ids }));
  },
  clearNode() {
    return unwrap(request<void>({ url: `${API_PATH}/clear`, method: 'delete' }));
  },
  batchNode(body: NodeBatchStatus) {
    return unwrap(request<void>({ url: `${API_PATH}/status/batch`, method: 'patch', data: body }));
  },
  executeNode(id: number, params: ExecuteNodeParams = { trigger: 'now' }) {
    return unwrap(request<ExecuteNodeResult>({ url: `${API_PATH}/execute/${id}`, method: 'post', data: params }));
  },
  listNodeLogs(
    id: number,
    query: {
      page_no?: number;
      page_size?: number;
      status?: number;
      trigger_type?: string;
      [key: string]: unknown;
    }
  ) {
    return unwrap(request<NodeLogPageResult>({ url: `${API_PATH}/logs/${id}`, params: query }));
  }
};

export default NodeAPI;
export const {
  getNodeTypes,
  getNodeTypeOptions,
  listNode,
  detailNode,
  createNode,
  updateNode,
  deleteNode,
  clearNode,
  batchNode,
  executeNode,
  listNodeLogs
} = NodeAPI;
