<!-- 定时任务节点：任务类型 + 参数 描述执行体，触发器描述执行时机 -->
<template>
  <div class="art-full-height">
    <ArtPageReady variant="table">
      <SaSearchBar
        v-show="showSearchBar"
        v-model="searchForm"
        label-width="80px"
        :show-expand="false"
        @search="handleSearch"
        @reset="onResetSearch"
      >
        <ElCol :xs="24" :sm="12" :md="6">
          <ElFormItem label="节点名称" prop="name">
            <ElInput v-model="searchForm.name" placeholder="请输入节点名称" clearable />
          </ElFormItem>
        </ElCol>
        <ElCol :xs="24" :sm="12" :md="6">
          <ElFormItem label="节点编码" prop="code">
            <ElInput v-model="searchForm.code" placeholder="请输入节点编码" clearable />
          </ElFormItem>
        </ElCol>
        <ElCol :xs="24" :sm="12" :md="6">
          <ElFormItem label="任务类型" prop="func">
            <ElSelect v-model="searchForm.func" placeholder="请选择任务类型" clearable class="w-full">
              <ElOption
                v-for="item in handlers"
                :key="item.name"
                :label="item.title"
                :value="item.name"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :xs="24" :sm="12" :md="6">
          <ElFormItem label="状态" prop="status">
            <ElSelect v-model="searchForm.status" placeholder="请选择状态" clearable class="w-full">
              <ElOption label="启用" :value="0" />
              <ElOption label="停用" :value="1" />
            </ElSelect>
          </ElFormItem>
        </ElCol>
      </SaSearchBar>

      <ElCard
        class="art-table-card"
        shadow="never"
        :style="{ 'margin-top': showSearchBar ? '12px' : '0' }"
      >
        <ArtTableHeader
          v-model:columns="columnChecks"
          v-model:showSearchBar="showSearchBar"
          :loading="loading"
          @refresh="refreshData"
        >
          <template #left>
            <ElSpace wrap>
              <ElButton
                v-auth="'module_task:cronjob:node:create'"
                type="primary"
                :loading="createLoading"
                @click="handleAdd"
              >
                <template #icon><SvgIcon icon="ri:add-fill" /></template>
                新增
              </ElButton>
              <ElButton
                v-auth="'module_task:cronjob:node:delete'"
                type="danger"
                plain
                :disabled="selectedIds.length === 0"
                :loading="batchDeleting"
                @click="handleBatchDelete"
              >
                <template #icon><SvgIcon icon="ri:delete-bin-line" /></template>
                批量删除
              </ElButton>
              <ElDivider direction="vertical" />
              <ElTooltip content="调度器检测到任务执行后自动刷新列表" placement="top">
                <span class="watch-toggle">
                  <ElSwitch v-model="autoRefresh" size="small" />
                  <span class="watch-toggle__label">自动刷新</span>
                </span>
              </ElTooltip>
              <span class="watch-time">{{ watchTip }}</span>
            </ElSpace>
          </template>
        </ArtTableHeader>

        <ArtTable
          ref="tableRef"
          row-key="id"
          :loading="loading"
          :data="data"
          :columns="columns"
          :pagination="pagination"
          @selection-change="onTableSelectionChange"
          @pagination:size-change="handleSizeChange"
          @pagination:current-change="handleCurrentChange"
        >
          <template #handler_title="{ row }">
            <div class="handler-cell">
              <span>{{ row.handler_title || '—' }}</span>
              <ElTooltip v-if="row.unsupported_reason" :content="row.unsupported_reason" placement="top">
                <SvgIcon icon="ri:error-warning-line" class="handler-warn" />
              </ElTooltip>
            </div>
          </template>
          <template #trigger="{ row }">
            <span v-if="row.trigger">{{ triggerLabel(row.trigger, row.trigger_args) }}</span>
            <ElTag v-else type="info" size="small">不启用</ElTag>
          </template>
          <template #runtime_status="{ row }">
            <ElTag :type="runtimeTagType(row.runtime_status)" size="small">
              {{ row.runtime_status_text || '—' }}
            </ElTag>
          </template>
          <template #last_run="{ row }">
            <div class="last-run-cell">
              <span>{{ row.last_run_time || '—' }}</span>
              <span v-if="row.last_duration_ms != null" class="last-run-cost">
                {{ row.last_duration_ms }} ms
              </span>
            </div>
          </template>
          <template #status="{ row }">
            <ElSwitch
              v-auth="'module_task:cronjob:node:update'"
              :model-value="row.status ?? 1"
              :active-value="0"
              :inactive-value="1"
              :loading="statusLoadingId === row.id"
              @change="(val: number | string | boolean) => handleToggleStatus(row, val)"
            />
          </template>
          <template #operation="{ row }">
            <div class="flex gap-1 justify-end">
              <SaButton
                v-auth="'module_task:cronjob:node:query'"
                type="info"
                icon="ri:file-list-3-line"
                tool-tip="执行日志"
                @click="handleOpenLogDrawer(row)"
              />
              <SaButton
                v-auth="'module_task:cronjob:node:execute'"
                type="primary"
                icon="ri:play-circle-line"
                tool-tip="调试"
                @click="handleOpenExecuteDialog(row)"
              />
              <SaButton
                v-auth="'module_task:cronjob:node:update'"
                type="secondary"
                tool-tip="编辑"
                @click="handleOpenDialog('update', row.id)"
              />
              <SaButton
                v-auth="'module_task:cronjob:node:delete'"
                type="error"
                tool-tip="删除"
                @click="deleteNodeRow(row.id)"
              />
            </div>
          </template>
        </ArtTable>
      </ElCard>
    </ArtPageReady>

    <!-- 新增/编辑 -->
    <ElDialog
      v-model="dialogVisible.visible"
      :title="dialogVisible.title"
      width="1000px"
      destroy-on-close
      append-to-body
      @closed="handleCloseDialog"
    >
      <ElAlert
        v-if="legacyTypeWarning"
        class="mb-3"
        type="warning"
        :closable="false"
        show-icon
        title="该节点由 Python 版本创建"
        description="原代码块无法在 Go 调度器执行，请重新选择任务类型后保存。"
      />
      <ElAlert
        v-if="currentRuntime && dialogVisible.type === 'update'"
        class="mb-3"
        :type="runtimeAlertType(currentRuntime.runtime_status)"
        :closable="false"
        show-icon
        :title="`调度状态：${currentRuntime.runtime_status_text || '—'}`"
        :description="runtimeAlertDescription"
      />
      <ElRow :gutter="16">
        <ElCol :span="11">
          <ElForm
            ref="dataFormRef"
            :model="formData"
            :rules="rules"
            label-width="100px"
            label-suffix=":"
          >
            <ElFormItem label="节点名称" prop="name">
              <ElInput v-model="formData.name" maxlength="64" placeholder="请输入节点名称" />
            </ElFormItem>
            <ElFormItem label="节点编码" prop="code">
              <ElInput v-model="formData.code" maxlength="32" placeholder="请输入节点编码" />
            </ElFormItem>
            <ElFormItem label="任务类型" prop="func">
              <ElSelect
                v-model="formData.func"
                placeholder="请选择任务类型"
                class="w-full"
                @change="handleHandlerChange"
              >
                <ElOption
                  v-for="item in handlers"
                  :key="item.name"
                  :label="item.title"
                  :value="item.name"
                  :disabled="!item.enabled"
                >
                  <span>{{ item.title }}</span>
                  <span class="option-tip">{{ item.enabled ? item.category : item.disabled_hint }}</span>
                </ElOption>
              </ElSelect>
            </ElFormItem>
            <ElFormItem v-if="activeHandler?.description" label="任务说明">
              <span class="form-plain-text">{{ activeHandler.description }}</span>
            </ElFormItem>

            <ElFormItem label="触发器" prop="trigger">
              <ElSelect
                v-model="formData.trigger"
                placeholder="请选择触发器"
                class="w-full"
                @change="handleTriggerChange"
              >
                <ElOption
                  v-for="item in triggers"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </ElSelect>
            </ElFormItem>
            <ElFormItem v-if="triggerHint" label=" ">
              <span class="form-plain-text">{{ triggerHint }}</span>
            </ElFormItem>

            <ElFormItem v-if="formData.trigger === 'cron'" label="定时规则" prop="trigger_args">
              <CronBuilder v-model="formData.trigger_args" />
            </ElFormItem>
            <ElFormItem v-else-if="formData.trigger === 'interval'" label="间隔时间" prop="trigger_args">
              <ElPopover
                :visible="openInterval"
                width="360px"
                trigger="click"
                :persistent="false"
                placement="bottom"
              >
                <template #reference>
                  <ElInput
                    v-model="formData.trigger_args"
                    placeholder="格式：秒 分 时 天 周，点击设置"
                    @click="openInterval = true"
                  />
                </template>
                <IntervalTab
                  :cron-value="formData.trigger_args || ''"
                  @confirm="handleIntervalConfirm"
                  @cancel="openInterval = false"
                />
              </ElPopover>
            </ElFormItem>
            <ElFormItem v-else-if="formData.trigger === 'date'" label="执行时间" prop="trigger_args">
              <ElDatePicker
                v-model="formData.trigger_args"
                type="datetime"
                format="YYYY-MM-DD HH:mm:ss"
                value-format="YYYY-MM-DD HH:mm:ss"
                placeholder="请选择执行时间（一次性）"
                class="w-full"
              />
            </ElFormItem>

            <template v-if="formData.trigger === 'cron' || formData.trigger === 'interval'">
              <ElFormItem label="开始时间">
                <ElDatePicker
                  v-model="formData.start_date"
                  type="datetime"
                  format="YYYY-MM-DD HH:mm:ss"
                  value-format="YYYY-MM-DD HH:mm:ss"
                  placeholder="可选"
                  class="w-full"
                />
              </ElFormItem>
              <ElFormItem label="结束时间">
                <ElDatePicker
                  v-model="formData.end_date"
                  type="datetime"
                  format="YYYY-MM-DD HH:mm:ss"
                  value-format="YYYY-MM-DD HH:mm:ss"
                  placeholder="可选"
                  class="w-full"
                />
              </ElFormItem>
            </template>

            <ElFormItem label="位置参数">
              <ElInput v-model="formData.args" placeholder="多个参数用英文逗号分隔，可留空" />
            </ElFormItem>
            <ElFormItem label="合并运行">
              <ElSwitch v-model="formData.coalesce" />
              <span class="form-plain-text ml-2">开启后同一时刻只跑一个实例</span>
            </ElFormItem>
            <ElFormItem label="最大实例数">
              <ElInputNumber
                v-model="formData.max_instances"
                :min="1"
                :max="10"
                controls-position="right"
              />
            </ElFormItem>
            <ElFormItem label="启用">
              <ElSwitch v-model="formData.status" :active-value="0" :inactive-value="1" />
              <span class="form-plain-text ml-2">停用后不参与调度</span>
            </ElFormItem>
            <ElFormItem label="备注">
              <ElInput
                v-model="formData.description"
                type="textarea"
                :rows="2"
                maxlength="255"
                placeholder="可选"
              />
            </ElFormItem>
          </ElForm>
        </ElCol>
        <ElCol :span="13">
          <div class="code-label">
            任务参数
            <span class="code-label-tip">（对应 kwargs，留空使用默认值）</span>
          </div>
          <div class="param-panel">
            <template v-if="activeHandler && activeHandler.params.length">
              <div v-for="spec in activeHandler.params" :key="spec.name" class="param-row">
                <div class="param-row-label">
                  <span v-if="spec.required" class="param-required">*</span>
                  {{ spec.title }}
                </div>
                <div class="param-row-control">
                  <ElSelect
                    v-if="spec.type === 'select'"
                    v-model="paramValues[spec.name]"
                    class="w-full"
                    clearable
                    :placeholder="spec.help || '请选择'"
                  >
                    <ElOption
                      v-for="opt in spec.options || []"
                      :key="String(opt)"
                      :label="String(opt)"
                      :value="opt"
                    />
                  </ElSelect>
                  <ElSwitch v-else-if="spec.type === 'bool'" v-model="paramValues[spec.name]" />
                  <ElInputNumber
                    v-else-if="spec.type === 'number'"
                    v-model="paramValues[spec.name]"
                    controls-position="right"
                    class="w-full"
                  />
                  <ElInput
                    v-else-if="spec.type === 'json' || spec.type === 'text'"
                    v-model="paramValues[spec.name]"
                    type="textarea"
                    :rows="spec.type === 'json' ? 4 : 3"
                    :placeholder="spec.help || ''"
                  />
                  <ElInput
                    v-else
                    v-model="paramValues[spec.name]"
                    :placeholder="spec.help || ''"
                  />
                  <div v-if="spec.help && spec.type !== 'json'" class="param-help">{{ spec.help }}</div>
                </div>
              </div>
            </template>
            <ElEmpty v-else :description="activeHandler ? '该任务类型无需参数' : '请先选择任务类型'" />
          </div>
        </ElCol>
      </ElRow>
      <template #footer>
        <ElButton @click="dialogVisible.visible = false">取消</ElButton>
        <ElButton type="primary" :loading="submitLoading" @click="handleSubmit">确定</ElButton>
      </template>
    </ElDialog>

    <!-- 调试 -->
    <ElDialog
      v-model="executeDialogVisible"
      title="调试节点"
      width="700px"
      destroy-on-close
      append-to-body
      @closed="handleCloseExecuteDialog"
    >
      <ElForm
        ref="executeFormRef"
        :model="executeFormData"
        :rules="executeRules"
        label-width="100px"
        label-suffix=":"
      >
        <ElFormItem label="节点名称">
          <ElInput v-model="executeFormData.node_display_name" disabled />
        </ElFormItem>
        <ElAlert
          class="mb-3"
          type="info"
          :closable="false"
          show-icon
          title="执行方式说明"
          description="「立即执行」只跑一次并写日志；Cron / 时间间隔 / 固定日期会把该节点注册到调度器长期运行（同时写回节点触发器并置为启用）。"
        />
        <ElFormItem label="执行方式" prop="trigger">
          <ElRadioGroup v-model="executeFormData.trigger" @change="handleExecuteTriggerChange">
            <ElRadio value="now">立即执行</ElRadio>
            <ElRadio value="cron">Cron表达式</ElRadio>
            <ElRadio value="interval">时间间隔</ElRadio>
            <ElRadio value="date">固定日期</ElRadio>
          </ElRadioGroup>
        </ElFormItem>
        <ElFormItem
          v-if="executeFormData.trigger !== 'now'"
          :label="triggerArgsLabel"
          prop="trigger_args"
        >
          <template v-if="executeFormData.trigger === 'cron'">
            <CronBuilder v-model="executeFormData.trigger_args" />
          </template>
          <template v-else-if="executeFormData.trigger === 'interval'">
            <ElPopover
              :visible="openInterval"
              width="360px"
              trigger="click"
              :persistent="false"
              placement="bottom"
            >
              <template #reference>
                <ElInput
                  v-model="executeFormData.trigger_args"
                  placeholder="格式：秒 分 时 天 周，点击设置"
                  @click="openInterval = true"
                />
              </template>
              <IntervalTab
                :cron-value="executeFormData.trigger_args || ''"
                @confirm="handleIntervalConfirm"
                @cancel="openInterval = false"
              />
            </ElPopover>
          </template>
          <template v-else-if="executeFormData.trigger === 'date'">
            <ElDatePicker
              v-model="executeFormData.trigger_args"
              type="datetime"
              format="YYYY-MM-DD HH:mm:ss"
              value-format="YYYY-MM-DD HH:mm:ss"
              placeholder="请选择执行时间"
              class="w-full"
            />
          </template>
        </ElFormItem>
        <ElFormItem
          v-if="executeFormData.trigger === 'cron' || executeFormData.trigger === 'interval'"
          label="开始时间"
        >
          <ElDatePicker
            v-model="executeFormData.start_date"
            type="datetime"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            placeholder="可选"
            class="w-full"
          />
        </ElFormItem>
        <ElFormItem
          v-if="executeFormData.trigger === 'cron' || executeFormData.trigger === 'interval'"
          label="结束时间"
        >
          <ElDatePicker
            v-model="executeFormData.end_date"
            type="datetime"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            placeholder="可选"
            class="w-full"
          />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="handleCloseExecuteDialog">取消</ElButton>
        <ElButton type="primary" :loading="submitLoading" @click="handleExecuteNode">确认</ElButton>
      </template>
    </ElDialog>

    <ElDrawer
      v-model="logDrawerVisible"
      :title="logDrawerTitle"
      direction="rtl"
      size="80%"
      append-to-body
    >
      <div class="node-log-drawer">
        <SaSearchBar
          v-model="logSearchForm"
          label-width="80px"
          :show-expand="false"
          @search="handleLogSearch"
          @reset="onLogResetSearch"
        >
          <ElCol :xs="24" :sm="12" :md="8">
            <ElFormItem label="执行状态" prop="status">
              <ElSelect
                v-model="logSearchForm.status"
                placeholder="请选择状态"
                clearable
                class="w-full"
              >
                <ElOption label="待执行" :value="0" />
                <ElOption label="执行中" :value="1" />
                <ElOption label="成功" :value="2" />
                <ElOption label="失败" :value="3" />
                <ElOption label="超时" :value="4" />
                <ElOption label="已取消" :value="5" />
              </ElSelect>
            </ElFormItem>
          </ElCol>
          <ElCol :xs="24" :sm="12" :md="8">
            <ElFormItem label="触发方式" prop="trigger_type">
              <ElSelect
                v-model="logSearchForm.trigger_type"
                placeholder="请选择"
                clearable
                class="w-full"
              >
                <ElOption label="Cron表达式" value="cron" />
                <ElOption label="时间间隔" value="interval" />
                <ElOption label="固定日期" value="date" />
                <ElOption label="一次性任务" value="manual" />
              </ElSelect>
            </ElFormItem>
          </ElCol>
        </SaSearchBar>

        <ElCard class="art-table-card node-log-table-card mt-3" shadow="never">
          <ArtTableHeader
            v-model:columns="logColumnChecks"
            layout="refresh"
            :loading="logLoading"
            @refresh="refreshLogData"
          />
          <ArtTable
            row-key="id"
            :loading="logLoading"
            :data="logTableData"
            :columns="logColumns"
            :pagination="logPagination"
            @pagination:size-change="logHandleSizeChange"
            @pagination:current-change="logHandleCurrentChange"
          >
            <template #trigger_type="{ row }">
              {{ logTriggerLabel(row.trigger_type) }}
            </template>
            <template #status="{ row }">
              <ElTag :type="logStatusTagType(row.status)" size="small">
                {{ logStatusLabel(row.status) }}
              </ElTag>
            </template>
            <template #result="{ row }">
              <ElButton
                v-if="row.result"
                type="primary"
                link
                size="small"
                @click="handleViewJobState(row.result)"
              >
                查看
              </ElButton>
              <span v-else>—</span>
            </template>
            <template #job_state="{ row }">
              <ElButton
                v-if="row.job_state"
                type="primary"
                link
                size="small"
                @click="handleViewJobState(row.job_state)"
              >
                查看
              </ElButton>
              <span v-else>—</span>
            </template>
          </ArtTable>
        </ElCard>
      </div>
    </ElDrawer>

    <ElDialog
      v-model="jobStateVisible"
      title="执行详情"
      width="800px"
      append-to-body
      destroy-on-close
    >
      <pre class="job-state-pre">{{ jobStateText }}</pre>
      <template #footer>
        <ElButton type="primary" @click="jobStateVisible = false">关闭</ElButton>
      </template>
    </ElDialog>
  </div>
</template>

<script lang="ts" setup>
defineOptions({ name: 'Node', inheritAttrs: false })

import NodeAPI, {
  type NodeTable,
  type NodeForm,
  type NodeLogRow,
  type HandlerOption,
  type TriggerOption,
  type RuntimeStatus,
  type NodeTriggerType,
  type TriggerType,
  type ExecuteNodeParams
} from '@/service/api/task/cronjob/node'
import IntervalTab from '@/components/custom/interval-tab/index.vue'
import CronBuilder from './modules/cron-builder.vue'
import { useSchedulerWatch } from '../composables/useSchedulerWatch'
import { useTable, type ColumnOption } from '@/hooks/business/use-ported-table'
import { describeTrigger, isValidCron } from '@/utils/cron'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import { computed, nextTick, reactive, ref } from 'vue'

const BATCH_DELETE_NODE_MSG =
  '确认删除选中的节点吗？\n此操作将同时删除节点定义并移除调度器中的相关任务。'

type NodeSearchForm = {
  name?: string
  code?: string
  func?: string
  status?: number
}

const searchForm = ref<NodeSearchForm>({
  name: undefined,
  code: undefined,
  func: undefined,
  status: undefined
})
const showSearchBar = ref(true)
const tableRef = ref<{ elTableRef?: { clearSelection: () => void } } | null>(null)
const selectedRows = ref<NodeTable[]>([])
const selectedIds = computed(() =>
  selectedRows.value.map((r) => r.id).filter((id): id is number => typeof id === 'number')
)
const batchDeleting = ref(false)
const createLoading = ref(false)
const submitLoading = ref(false)
const statusLoadingId = ref<number>()

/** 任务类型字典（后端 /node/types） */
const handlers = ref<HandlerOption[]>([])
const triggers = ref<TriggerOption[]>([])

async function loadNodeTypes() {
  try {
    const dict = await NodeAPI.getNodeTypes()
    handlers.value = dict.handlers || []
    triggers.value = dict.triggers || []
  } catch (e) {
    console.error(e)
  }
}
loadNodeTypes()

/** 触发器列展示可读描述，避免用户直接面对表达式 */
function triggerLabel(trigger?: string, triggerArgs?: string) {
  return describeTrigger(trigger, triggerArgs)
}

type RuntimeTagType = 'primary' | 'success' | 'info' | 'warning' | 'danger'

function runtimeTagType(status?: RuntimeStatus): RuntimeTagType {
  const map: Record<string, RuntimeTagType> = {
    waiting: 'info',
    running: 'primary',
    success: 'success',
    failed: 'danger',
    paused: 'warning',
    disabled: 'info',
    unconfigured: 'warning',
    unsupported: 'danger',
    unregistered: 'warning'
  }
  return (status && map[status]) || 'info'
}

/** ElAlert 的 type 只接受 success/warning/info/error */
function runtimeAlertType(status?: RuntimeStatus): 'success' | 'warning' | 'info' | 'error' {
  const level = runtimeTagType(status)
  if (level === 'danger') return 'error'
  if (level === 'primary') return 'info'
  return level
}

function onTableSelectionChange(rows: NodeTable[]) {
  selectedRows.value = rows
}

const {
  columns,
  columnChecks,
  data,
  loading,
  pagination,
  getData,
  replaceSearchParams,
  resetSearchParams,
  handleSizeChange,
  handleCurrentChange,
  refreshData,
  refreshCreate,
  refreshUpdate,
  refreshRemove
} = useTable({
  core: {
    apiFn: NodeAPI.listNode,
    apiParams: { page_no: 1, page_size: 10 },
    paginationKey: { current: 'page_no', size: 'page_size' },
    columnsFactory: (): ColumnOption<NodeTable>[] => [
      { type: 'selection', width: 48, fixed: 'left' },
      { type: 'globalIndex', width: 56, label: '序号' },
      { prop: 'name', label: '节点名称', minWidth: 140, showOverflowTooltip: true },
      { prop: 'code', label: '节点编码', minWidth: 120, showOverflowTooltip: true },
      {
        prop: 'handler_title',
        label: '任务类型',
        minWidth: 130,
        useSlot: true,
        showOverflowTooltip: true
      },
      { prop: 'trigger', label: '触发器', minWidth: 190, useSlot: true, showOverflowTooltip: true },
      { prop: 'runtime_status', label: '运行状态', minWidth: 100, useSlot: true },
      { prop: 'next_run_time', label: '下次执行时间', minWidth: 170, showOverflowTooltip: true },
      { prop: 'last_run', label: '最近执行', minWidth: 190, useSlot: true },
      { prop: 'fail_count', label: '连续失败', minWidth: 90 },
      { prop: 'status', label: '启用', width: 80, useSlot: true },
      {
        prop: 'operation',
        label: '操作',
        width: 180,
        fixed: 'right',
        align: 'center',
        useSlot: true
      }
    ]
  }
})

// 调度器监控：有任务执行或调度器状态变化时自动刷新列表
const { autoRefresh, lastSyncAt, syncError, start: startSchedulerWatch } = useSchedulerWatch({
  onSync: () => refreshData()
})
startSchedulerWatch()

const watchTip = computed(() => {
  if (syncError.value) return syncError.value
  if (!autoRefresh.value) return '已关闭自动刷新'
  return lastSyncAt.value ? `最后更新 ${lastSyncAt.value}` : '监控中…'
})

function handleSearch() {
  replaceSearchParams({
    name: searchForm.value.name,
    code: searchForm.value.code,
    func: searchForm.value.func,
    status: searchForm.value.status
  })
  getData()
}

async function onResetSearch() {
  searchForm.value = { name: undefined, code: undefined, func: undefined, status: undefined }
  await resetSearchParams()
}

async function handleToggleStatus(row: any, val: number | string | boolean) {
  const id = row.id
  if (id == null) return
  statusLoadingId.value = id
  try {
    await NodeAPI.batchNode({ ids: [id], status: Number(val) })
    ElMessage.success(Number(val) === 0 ? '已启用并同步调度器' : '已停用并移出调度器')
    await refreshData()
  } catch (e) {
    console.error(e)
    await refreshData()
  } finally {
    statusLoadingId.value = undefined
  }
}

async function deleteNodeRow(id: number | undefined) {
  if (id == null) return
  try {
    await ElMessageBox.confirm(BATCH_DELETE_NODE_MSG, '警告', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await NodeAPI.deleteNode([id])
    tableRef.value?.elTableRef?.clearSelection()
    await refreshRemove()
  } catch {
    // cancel
  }
}

async function handleBatchDelete() {
  const ids = selectedIds.value
  if (!ids.length) return
  try {
    await ElMessageBox.confirm(BATCH_DELETE_NODE_MSG, '警告', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    batchDeleting.value = true
    await NodeAPI.deleteNode(ids)
    selectedRows.value = []
    await refreshRemove()
  } catch {
    // cancel
  } finally {
    batchDeleting.value = false
  }
}

// ---------------------------------------------------------------------------
// 新增 / 编辑
// ---------------------------------------------------------------------------

const defaultForm = (): NodeForm => ({
  id: undefined,
  name: '',
  code: undefined,
  func: undefined,
  trigger: '' as NodeTriggerType,
  trigger_args: undefined,
  start_date: undefined,
  end_date: undefined,
  args: undefined,
  kwargs: undefined,
  coalesce: false,
  max_instances: 1,
  status: 0,
  description: undefined
})

const formData = ref<NodeForm>(defaultForm())
/** 任务参数值，键为 ParamSpec.name；类型随控件不同，与 kwargs 一一对应 */
const paramValues = ref<Record<string, any>>({})
const currentRuntime = ref<NodeTable | null>(null)
const legacyTypeWarning = ref(false)
const dataFormRef = ref<FormInstance>()
const openInterval = ref(false)
const dialogVisible = reactive({
  title: '',
  visible: false,
  type: 'create' as 'create' | 'update'
})

const activeHandler = computed(() =>
  handlers.value.find((item) => item.name === formData.value.func)
)

const triggerHint = computed(
  () => triggers.value.find((item) => item.value === formData.value.trigger)?.hint || ''
)

const runtimeAlertDescription = computed(() => {
  const runtime = currentRuntime.value
  if (!runtime) return ''
  const parts: string[] = []
  if (runtime.scheduler_state) parts.push(`调度器：${runtime.scheduler_state}`)
  if (runtime.next_run_time) parts.push(`下次执行：${runtime.next_run_time}`)
  if (runtime.last_run_time) parts.push(`最近执行：${runtime.last_run_time}`)
  if (runtime.unsupported_reason) parts.push(`原因：${runtime.unsupported_reason}`)
  if (runtime.last_error) parts.push(`最近错误：${runtime.last_error}`)
  return parts.join('；') || '暂无运行记录'
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入节点名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入节点编码', trigger: 'blur' }],
  func: [{ required: true, message: '请选择任务类型', trigger: 'change' }]
}

/** 依据任务类型的参数规格初始化参数值（保留已填内容） */
function syncParamValues(keep = false) {
  const spec = activeHandler.value
  const next: Record<string, unknown> = keep ? { ...paramValues.value } : {}
  if (!spec) {
    paramValues.value = {}
    return
  }
  for (const p of spec.params) {
    if (!(p.name in next)) {
      next[p.name] = p.default ?? (p.type === 'bool' ? false : undefined)
    }
  }
  paramValues.value = next
}

function handleHandlerChange() {
  syncParamValues(false)
}

function resetForm() {
  formData.value = defaultForm()
  paramValues.value = {}
  currentRuntime.value = null
  legacyTypeWarning.value = false
  dataFormRef.value?.clearValidate()
}

function handleCloseDialog() {
  dialogVisible.visible = false
  resetForm()
}

/** 把节点 kwargs（JSON 字符串）回填到参数表单 */
function fillParamsFromNode(node: NodeTable) {
  const raw = node.kwargs
  if (!raw) {
    syncParamValues(false)
    return
  }
  try {
    const parsed = JSON.parse(raw) as Record<string, unknown>
    paramValues.value = { ...parsed }
  } catch {
    paramValues.value = {}
  }
  syncParamValues(true)
}

async function handleAdd() {
  createLoading.value = true
  try {
    dialogVisible.type = 'create'
    dialogVisible.title = '新增节点'
    resetForm()
    formData.value.func = handlers.value.find((item) => item.enabled)?.name
    syncParamValues(false)
    dialogVisible.visible = true
  } finally {
    createLoading.value = false
  }
}

async function handleOpenDialog(type: 'create' | 'update', id?: number) {
  dialogVisible.type = type
  if (id) {
    const detail = await NodeAPI.detailNode(id)
    dialogVisible.title = '修改节点'
    resetForm()
    Object.assign(formData.value, {
      ...defaultForm(),
      ...detail,
      trigger: (detail.trigger || '') as NodeTriggerType,
      coalesce: Boolean(detail.coalesce),
      max_instances: detail.max_instances || 1,
      status: detail.status ?? 0
    })
    currentRuntime.value = detail
    legacyTypeWarning.value = !handlers.value.some((item) => item.name === detail.func)
    fillParamsFromNode(detail)
  } else {
    dialogVisible.title = '新增节点'
    resetForm()
    formData.value.func = handlers.value.find((item) => item.enabled)?.name
    syncParamValues(false)
  }
  dialogVisible.visible = true
}

/**
 * 切换触发器类型时清空旧参数：
 * cron（秒 分 时 日 月 周）与 interval（秒 分 时 天 周）语义不同，不能互相沿用。
 */
function handleTriggerChange() {
  formData.value.trigger_args = undefined
}

/** 校验 cron 表达式（仅格式层，语义由后端解析确认） */
function cronValid(expr?: string) {
  if (!expr) return false
  if (isValidCron(expr)) return true
  ElMessage.warning('cron 表达式格式不正确，请用「定时规则」选择或填写 秒 分 时 日 月 周')
  return false
}

function handleIntervalConfirm(value: string) {
  formData.value.trigger_args = value
  openInterval.value = false
}

/** 收集任务参数为 kwargs JSON 字符串 */
function collectKwargs(): string | undefined {
  const spec = activeHandler.value
  if (!spec) return undefined
  const out: Record<string, unknown> = {}
  for (const p of spec.params) {
    const v = paramValues.value[p.name]
    if (v === undefined || v === null || v === '') continue
    if (p.type === 'number') {
      out[p.name] = Number(v)
    } else if (p.type === 'bool') {
      out[p.name] = Boolean(v)
    } else {
      out[p.name] = v
    }
  }
  return Object.keys(out).length ? JSON.stringify(out) : undefined
}

function validateBeforeSubmit(): boolean {
  const spec = activeHandler.value
  if (!spec) {
    ElMessage.warning('请选择任务类型')
    return false
  }
  if (!spec.enabled) {
    ElMessage.warning(spec.disabled_hint || '该任务类型已被禁用')
    return false
  }
  for (const p of spec.params) {
    if (!p.required) continue
    const v = paramValues.value[p.name]
    if (v === undefined || v === null || v === '') {
      ElMessage.warning(`请填写「${p.title}」`)
      return false
    }
  }
  const trigger = formData.value.trigger
  if (trigger && trigger !== 'now' && !formData.value.trigger_args) {
    ElMessage.warning('请填写触发器参数')
    return false
  }
  // cron 交给「定时规则」生成，这里只做格式兜底，避免存进库后调度器解析失败
  if (trigger === 'cron' && !cronValid(formData.value.trigger_args)) {
    return false
  }
  return true
}

async function handleSubmit() {
  const valid = await dataFormRef.value?.validate().catch(() => false)
  if (!valid) return
  if (!validateBeforeSubmit()) return
  submitLoading.value = true
  try {
    const submitData: NodeForm = {
      ...formData.value,
      kwargs: collectKwargs()
    }
    const id = formData.value.id
    if (id) {
      await NodeAPI.updateNode(id, submitData)
      dialogVisible.visible = false
      resetForm()
      await refreshUpdate()
    } else {
      await NodeAPI.createNode(submitData)
      dialogVisible.visible = false
      resetForm()
      await refreshCreate()
    }
  } catch (e) {
    console.error(e)
  } finally {
    submitLoading.value = false
  }
}

// ---------------------------------------------------------------------------
// 调试
// ---------------------------------------------------------------------------

const executeDialogVisible = ref(false)
const executeFormRef = ref<FormInstance>()
const currentExecuteNode = ref<NodeTable | null>(null)
const executeFormData = ref<{
  node_display_name: string
  trigger: TriggerType
  trigger_args?: string
  start_date?: string
  end_date?: string
}>({
  node_display_name: '',
  trigger: 'now',
  trigger_args: undefined,
  start_date: undefined,
  end_date: undefined
})

const triggerArgsLabel = computed(() => {
  const t = executeFormData.value.trigger
  if (t === 'cron') return 'Cron表达式'
  if (t === 'interval') return '间隔时间'
  if (t === 'date') return '执行时间'
  return '执行参数'
})

const executeRules = computed<FormRules>(() => ({
  trigger: [{ required: true, message: '请选择执行方式', trigger: 'change' }],
  trigger_args:
    executeFormData.value.trigger === 'now'
      ? []
      : [{ required: true, message: '请设置执行参数', trigger: 'blur' }]
}))

function handleOpenExecuteDialog(row: any) {
  currentExecuteNode.value = row
  executeFormData.value = {
    node_display_name: row.name ?? '',
    trigger: 'now',
    // 节点已有触发器时预填，便于直接沿用同一套定时设置
    trigger_args: row.trigger && row.trigger !== 'now' ? row.trigger_args : undefined,
    start_date: undefined,
    end_date: undefined
  }
  executeDialogVisible.value = true
}

/** 切换执行方式：沿用同类触发器的参数，类型不同则清空重新设置 */
function handleExecuteTriggerChange(val: string | number | boolean | undefined) {
  const trigger = (val ?? 'now') as TriggerType
  const node = currentExecuteNode.value
  executeFormData.value.trigger_args =
    node && node.trigger === trigger ? node.trigger_args : undefined
}

function handleCloseExecuteDialog() {
  executeDialogVisible.value = false
  currentExecuteNode.value = null
  openInterval.value = false
}

async function handleExecuteNode() {
  if (executeFormData.value.trigger !== 'now') {
    const valid = await executeFormRef.value?.validate().catch(() => false)
    if (!valid) return
    if (
      executeFormData.value.trigger === 'cron' &&
      !cronValid(executeFormData.value.trigger_args)
    ) {
      return
    }
  }
  const id = currentExecuteNode.value?.id
  if (id == null) return
  submitLoading.value = true
  try {
    const params: ExecuteNodeParams = { trigger: executeFormData.value.trigger }
    if (executeFormData.value.trigger !== 'now') {
      params.trigger_args = executeFormData.value.trigger_args
      params.start_date = executeFormData.value.start_date
      params.end_date = executeFormData.value.end_date
    }
    const res = await NodeAPI.executeNode(id, params)
    if (res?.registered) {
      ElMessage.success(
        res.next_run_time ? `已注册到调度器，下次执行：${res.next_run_time}` : '已注册到调度器'
      )
    } else {
      ElMessage.success('已执行完成')
    }
    handleCloseExecuteDialog()
    await refreshData()
  } catch (e) {
    console.error(e)
  } finally {
    submitLoading.value = false
  }
}

// ---------------------------------------------------------------------------
// 执行日志
// ---------------------------------------------------------------------------

const logDrawerVisible = ref(false)
const currentLogNodeId = ref<number>()
const currentLogNodeName = ref('')
const logDrawerTitle = computed(() =>
  currentLogNodeName.value ? `执行日志 — ${currentLogNodeName.value}` : '执行日志'
)
const logSearchForm = ref<{ status?: number; trigger_type?: string }>({
  status: undefined,
  trigger_type: undefined
})
const jobStateVisible = ref(false)
const jobStateText = ref('')

async function fetchNodeLogs(params: Record<string, unknown>) {
  if (currentLogNodeId.value == null) {
    return { total: 0, items: [] as NodeLogRow[] }
  }
  return NodeAPI.listNodeLogs(currentLogNodeId.value, params)
}

const {
  columns: logColumns,
  columnChecks: logColumnChecks,
  data: logTableData,
  loading: logLoading,
  pagination: logPagination,
  getData: getLogData,
  replaceSearchParams: replaceLogSearchParams,
  resetSearchParams: resetLogSearchParams,
  handleSizeChange: logHandleSizeChange,
  handleCurrentChange: logHandleCurrentChange,
  refreshData: refreshLogData
} = useTable({
  core: {
    apiFn: fetchNodeLogs,
    immediate: false,
    apiParams: { page_no: 1, page_size: 10, status: undefined, trigger_type: undefined },
    paginationKey: { current: 'page_no', size: 'page_size' },
    columnsFactory: (): ColumnOption<NodeLogRow>[] => [
      { type: 'globalIndex', width: 56, label: '序号' },
      { prop: 'job_id', label: '任务ID', minWidth: 80, showOverflowTooltip: true },
      { prop: 'job_name', label: '任务名称', minWidth: 140, showOverflowTooltip: true },
      { prop: 'trigger_type', label: '触发方式', minWidth: 110, useSlot: true },
      { prop: 'status', label: '状态', minWidth: 90, useSlot: true },
      { prop: 'next_run_time', label: '下次执行时间', minWidth: 180, showOverflowTooltip: true },
      { prop: 'result', label: '执行结果', minWidth: 120, useSlot: true },
      { prop: 'error', label: '错误信息', minWidth: 120, showOverflowTooltip: true },
      { prop: 'job_state', label: '执行元数据', minWidth: 100, useSlot: true },
      { prop: 'create_time', label: '创建时间', minWidth: 160, showOverflowTooltip: true }
    ]
  }
})

function logTriggerLabel(t?: string) {
  const map: Record<string, string> = {
    cron: 'Cron表达式',
    interval: '时间间隔',
    date: '固定日期',
    manual: '一次性任务'
  }
  return (t && map[t]) || t || '—'
}

function logStatusLabel(status?: number) {
  const map: Record<number, string> = {
    0: '待执行',
    1: '执行中',
    2: '成功',
    3: '失败',
    4: '超时',
    5: '已取消'
  }
  return status != null ? map[status] ?? String(status) : '—'
}

function logStatusTagType(status?: number) {
  switch (status) {
    case 1:
      return 'primary'
    case 2:
      return 'success'
    case 3:
      return 'danger'
    case 4:
      return 'warning'
    default:
      return 'info'
  }
}

async function handleOpenLogDrawer(row: any) {
  if (row.id == null) return
  currentLogNodeId.value = row.id
  currentLogNodeName.value = row.name || ''
  logSearchForm.value = { status: undefined, trigger_type: undefined }
  logDrawerVisible.value = true
  await nextTick()
  replaceLogSearchParams({
    page_no: 1,
    page_size: 10,
    status: undefined,
    trigger_type: undefined
  })
  await getLogData()
}

function handleLogSearch() {
  if (currentLogNodeId.value == null) return
  replaceLogSearchParams({
    status: logSearchForm.value.status,
    trigger_type: logSearchForm.value.trigger_type
  })
  getLogData()
}

async function onLogResetSearch() {
  logSearchForm.value = { status: undefined, trigger_type: undefined }
  await resetLogSearchParams()
}

function handleViewJobState(jobState?: string) {
  if (!jobState) return
  try {
    jobStateText.value = JSON.stringify(JSON.parse(jobState), null, 2)
  } catch {
    jobStateText.value = jobState
  }
  jobStateVisible.value = true
}
</script>

<style scoped>
.w-full {
  width: 100%;
}
.mb-3 {
  margin-bottom: 12px;
}
.ml-2 {
  margin-left: 8px;
}
.code-label {
  margin-bottom: 8px;
  font-size: 13px;
  color: var(--el-text-color-regular);
}
.code-label-tip {
  color: var(--el-text-color-secondary);
  font-size: 12px;
}
.param-panel {
  min-height: 320px;
  max-height: 560px;
  overflow: auto;
  padding: 12px;
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 6px;
  background: var(--el-fill-color-blank);
}
.param-row {
  margin-bottom: 14px;
}
.param-row-label {
  margin-bottom: 6px;
  font-size: 13px;
  color: var(--el-text-color-regular);
}
.param-required {
  color: var(--el-color-danger);
  margin-right: 2px;
}
.param-help {
  margin-top: 4px;
  font-size: 12px;
  color: var(--el-text-color-secondary);
}
.form-plain-text {
  font-size: 12px;
  color: var(--el-text-color-secondary);
}
.option-tip {
  float: right;
  margin-left: 16px;
  font-size: 12px;
  color: var(--el-text-color-secondary);
}
.watch-toggle {
  display: inline-flex;
  gap: 6px;
  align-items: center;
}
.watch-toggle__label {
  font-size: 13px;
  color: var(--el-text-color-regular);
}
.watch-time {
  font-size: 12px;
  color: var(--el-text-color-secondary);
}
.handler-cell {
  display: flex;
  gap: 4px;
  align-items: center;
}
.handler-warn {
  color: var(--el-color-danger);
}
.last-run-cell {
  display: flex;
  flex-direction: column;
  line-height: 1.4;
}
.last-run-cost {
  font-size: 12px;
  color: var(--el-text-color-secondary);
}
.node-log-drawer {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px);
  min-height: 420px;
}
.node-log-table-card {
  flex: 1;
  min-height: 280px;
}
.job-state-pre {
  max-height: 60vh;
  overflow: auto;
  margin: 0;
  padding: 12px;
  font-size: 12px;
  line-height: 1.5;
  white-space: pre-wrap;
  word-break: break-all;
  background: var(--el-fill-color-light);
  border-radius: 4px;
}
</style>

