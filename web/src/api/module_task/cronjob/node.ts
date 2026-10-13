import request from '@/utils/http'

const API_PATH = '/api/task/cronjob/node'

export interface NodePageQuery {
  page_no?: number
  page_size?: number
  name?: string
  code?: string
  /** 任务类型（task_node.func） */
  func?: string
  status?: number
  [key: string]: unknown
}

/** 调试弹窗的执行方式；now=立即执行一次 */
export type TriggerType = 'now' | 'cron' | 'interval' | 'date'

/** 节点触发器类型（form 里空串表示不启用） */
export type NodeTriggerType = TriggerType | ''

export interface ExecuteNodeParams {
  trigger: TriggerType
  trigger_args?: string
  start_date?: string
  end_date?: string
}

export interface ExecuteNodeResult {
  job_id: number
  /** 2=已执行一次，1=已注册进调度器 */
  status: number
  trigger: string
  result?: string
  registered?: boolean
  node_status?: number
  trigger_label?: string
  next_run_time?: string
}

/** 运行状态码（后端派生字段 runtime_status） */
export type RuntimeStatus =
  | 'waiting'
  | 'running'
  | 'success'
  | 'failed'
  | 'paused'
  | 'disabled'
  | 'unconfigured'
  | 'unsupported'
  | 'unregistered'

/** 任务参数规格，对应后端 service.ParamSpec */
export interface ParamSpec {
  name: string
  title: string
  type: 'string' | 'text' | 'number' | 'bool' | 'json' | 'select'
  required: boolean
  default?: unknown
  /** type=select 时的候选值 */
  options?: Array<string | number>
  help?: string
}

/** 内置任务类型，对应后端 service.Handler */
export interface HandlerOption {
  name: string
  title: string
  category: string
  description: string
  needs_root: boolean
  params: ParamSpec[]
  default_timeout_second: number
  enabled: boolean
  disabled_hint?: string
}

export interface TriggerOption {
  value: NodeTriggerType
  label: string
  hint: string
}

export interface RuntimeStatusOption {
  value: RuntimeStatus
  label: string
  type: string
}

export interface NodeTypeDict {
  handlers: HandlerOption[]
  triggers: TriggerOption[]
  runtime_status: RuntimeStatusOption[]
}

export interface NodeTable {
  id?: number
  name: string
  code: string
  /** 任务类型（后端字段名仍为 func） */
  func?: string
  handler_title?: string
  handler_enabled?: boolean
  trigger?: string
  trigger_type?: string
  trigger_args?: string
  start_date?: string
  end_date?: string
  args?: string
  kwargs?: string
  coalesce?: boolean | number
  max_instances?: number
  status?: number
  description?: string
  create_time?: string
  update_time?: string
  tenant_id?: number
  created_by?: number
  updated_by?: number

  // 以下为调度器派生运行态
  runtime_status?: RuntimeStatus
  runtime_status_text?: string
  supported?: boolean
  unsupported_reason?: string
  running?: boolean
  next_run_time?: string
  last_run_time?: string
  last_status?: number | null
  last_duration_ms?: number | null
  fail_count?: number
  last_error?: string
  scheduler_state?: string
}

export interface NodeForm {
  id?: number
  name: string
  code?: string
  /** 任务类型标识 */
  func?: string
  trigger?: NodeTriggerType
  trigger_args?: string
  start_date?: string
  end_date?: string
  args?: string
  kwargs?: string
  coalesce?: boolean
  max_instances?: number
  status?: number
  description?: string
}

/** 节点选项（调度器/工作流引用节点时使用） */
export interface NodeType {
  id: number
  name: string
  code: string
  func?: string
  args?: string
  kwargs?: string
}

export interface NodeBatchStatus {
  ids: number[]
  status: number
}

/** 与后端 PageResultSchema 对齐 */
export interface NodePageResult {
  page_no?: number
  page_size?: number
  total: number
  has_next?: boolean
  items: NodeTable[]
}

/** 节点执行日志（task_job） */
export interface NodeLogRow {
  id?: number
  job_id: string
  job_name?: string
  trigger_type?: string
  next_run_time?: string
  job_state?: string
  result?: string
  error?: string
  status?: number
  description?: string
  create_time?: string
  update_time?: string
}

export interface NodeLogPageResult {
  page_no?: number
  page_size?: number
  total: number
  has_next?: boolean
  items: NodeLogRow[]
}

const NodeAPI = {
  /** 任务类型字典：内置任务 + 参数规格 + 触发器/运行态枚举 */
  getNodeTypes() {
    return request.get<NodeTypeDict>({ url: `${API_PATH}/types` })
  },

  getNodeTypeOptions() {
    return request.get<NodeType[]>({ url: `${API_PATH}/options` })
  },

  listNode(query: NodePageQuery) {
    return request.get<NodePageResult>({ url: `${API_PATH}/list`, params: query })
  },

  detailNode(id: number) {
    return request.get<NodeTable>({ url: `${API_PATH}/detail/${id}` })
  },

  createNode(body: NodeForm) {
    return request.post<NodeTable>({ url: `${API_PATH}/create`, data: body })
  },

  updateNode(id: number, body: NodeForm) {
    return request.put<NodeTable>({ url: `${API_PATH}/update/${id}`, data: body })
  },

  deleteNode(ids: number[]) {
    return request.del<void>({ url: `${API_PATH}/delete`, data: ids })
  },

  clearNode() {
    return request.del<void>({ url: `${API_PATH}/clear` })
  },

  batchNode(body: NodeBatchStatus) {
    return request.request<void>({ url: `${API_PATH}/status/batch`, method: 'PATCH', data: body })
  },

  /**
   * 调试节点。
   * - trigger=now：立即执行一次并写日志；
   * - trigger=cron/interval/date：把该节点注册（或覆盖）进调度器长期运行。
   */
  executeNode(id: number, params: ExecuteNodeParams = { trigger: 'now' }) {
    return request.post<ExecuteNodeResult>({ url: `${API_PATH}/execute/${id}`, data: params })
  },

  /** 节点执行日志（task_job，job_id = 节点 id） */
  listNodeLogs(
    id: number,
    query: {
      page_no?: number
      page_size?: number
      status?: number
      trigger_type?: string
      [key: string]: unknown
    }
  ) {
    return request.get<NodeLogPageResult>({ url: `${API_PATH}/logs/${id}`, params: query })
  }
}

export default NodeAPI
