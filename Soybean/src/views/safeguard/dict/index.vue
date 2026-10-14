<script setup lang="tsx">
import { ref } from 'vue';
import { ElMessage, ElMessageBox, ElTag } from 'element-plus';
import { Search } from '@element-plus/icons-vue';
import {
  fetchGetDictTypeList,
  fetchDeleteDictType,
  fetchGetDictDataList,
  fetchDeleteDictData,
  fetchBatchDeleteDictData
} from '@/service/api';
import { useUIPaginatedTable, useTableOperate, defaultTransform } from '@/hooks/common/table';
import { $t } from '@/locales';
import DictSearch from './modules/dict-search.vue';
import TypeEditDialog from './modules/type-edit-dialog.vue';
import DictEditDialog from './modules/dict-edit-dialog.vue';

defineOptions({ name: 'DictManage' });

// ===== Dict Type (Left) =====
const selectedId = ref(0);
const selectedRow = ref<any>({});
const typeSearch = ref({ name: '', code: '' });
const typeSearchParams = ref<Record<string, any>>({
  name: undefined,
  code: undefined
});

const {
  data: typeData,
  loading: typeLoading,
  getData: getTypeData,
  mobilePagination: typePagination,
  handleCurrentPageChange: handleTypePageChange,
  handlePageSizeChange: handleTypePageSizeChange
} = useUIPaginatedTable({
  paginationProps: { currentPage: 1, pageSize: 10 },
  api: () => fetchGetDictTypeList(typeSearchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    typeSearchParams.value.page = params.currentPage;
    typeSearchParams.value.limit = params.pageSize;
  },
  columns: () => []
});

const { checkedRowKeys: typeCheckedKeys } = useTableOperate(typeData, 'id', getTypeData);

const refreshTypeData = () => {
  selectedId.value = 0;
  selectedRow.value = {};
  getTypeData();
  getDictData();
};

const handleTypeChange = (val: any, row?: any) => {
  selectedId.value = val;
  selectedRow.value = row;
  searchDictParams.value.type_id = val;
  getDictDataByPage(1);
};

const handleTypeSearch = () => {
  Object.assign(typeSearchParams.value, typeSearch.value);
  getTypeData();
};

// Type dialog
const typeDialogVisible = ref(false);
const typeDialogType = ref<'add' | 'edit'>('add');
const typeDialogData = ref<any>(null);

function typeShowDialog(type: 'add' | 'edit', data?: any) {
  typeDialogType.value = type;
  typeDialogData.value = data || null;
  typeDialogVisible.value = true;
}

function syncSelectedTypeRow() {
  if (!selectedId.value) return;
  const current = typeData.value.find((item: any) => item.id === selectedId.value);
  if (current) {
    selectedRow.value = current;
    return;
  }
  selectedId.value = 0;
  selectedRow.value = {};
}

async function handleTypeEditSuccess() {
  await getTypeData();
  syncSelectedTypeRow();
}

function updateTypeDialog() {
  if (selectedId.value === 0) { ElMessage.error('请选择要修改的数据'); return; }
  const current = typeData.value.find((item: any) => item.id === selectedId.value) || selectedRow.value;
  typeShowDialog('edit', { ...current });
}

async function deleteTypeDialog() {
  if (selectedId.value === 0) { ElMessage.error('请选择要删除的数据'); return; }
  const { error } = await fetchDeleteDictType(selectedId.value);
  if (!error) { ElMessage.success('删除成功'); refreshTypeData(); }
}

// ===== Dict Data (Right) =====
const searchDictParams = ref<Record<string, any>>({
  label: '',
  value: '',
  status: '',
  type_id: null
});

const {
  data: dictData,
  columns: dictColumns,
  loading: dictLoading,
  getData: getDictData,
  getDataByPage: getDictDataByPage,
  mobilePagination: dictPagination,
  handleCurrentPageChange: handleDictPageChange,
  handlePageSizeChange: handleDictPageSizeChange
} = useUIPaginatedTable({
  paginationProps: { currentPage: 1, pageSize: 10 },
  api: () => fetchGetDictDataList(searchDictParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchDictParams.value.page = params.currentPage;
    searchDictParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const },
    {
      prop: 'label',
      label: '字典标签',
      formatter: (row: any) => {
        const color = row.color;
        const bg = getColor(color, 'bg');
        const border = getColor(color, 'border');
        const text = getColor(color, 'text');
        return <ElTag style={{ backgroundColor: bg, borderColor: border, color: text }}>{row.label}</ElTag>;
      }
    },
    { prop: 'value', label: '字典键值' },
    { prop: 'color', label: '颜色' },
    { prop: 'sort', label: '排序' },
    {
      prop: 'status',
      label: '状态',
      formatter: (row: any) => {
        if (row.status === undefined) return '';
        return row.status == 1 ? <ElTag type="success" size="small">启用</ElTag> : <ElTag type="danger" size="small">禁用</ElTag>;
      }
    },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 120,
      formatter: (row: any) => (
        <div class="flex-center gap-4px">
          <ElButton type="primary" plain size="small" onClick={() => showDataDialog('edit', row)}>
            {$t('common.edit')}
          </ElButton>
          <ElPopconfirm title={$t('common.confirmDelete')} onConfirm={() => handleDictDelete(row.id)}>
            {{
              reference: () => (
                <ElButton type="danger" plain size="small">
                  {$t('common.delete')}
                </ElButton>
              )
            }}
          </ElPopconfirm>
        </div>
      )
    }
  ]
});

const { checkedRowKeys: dictCheckedKeys, onDeleted: dictDeleted } = useTableOperate(dictData, 'id', getDictData);

async function handleDictDelete(id: number) {
  const { error } = await fetchDeleteDictData(id);
  if (!error) dictDeleted();
}

async function handleDictBatchDelete() {
  if (dictCheckedKeys.value.length === 0) return;
  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${dictCheckedKeys.value.length} 条字典项吗？`,
      '批量删除确认',
      { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
    );
    const ids = dictCheckedKeys.value.map(Number);
    const { error } = await fetchBatchDeleteDictData(ids);
    if (!error) {
      ElMessage.success('删除成功');
      dictCheckedKeys.value = [];
      getDictData();
    }
  } catch {}
}

// Dict data dialog
const dictDialogVisible = ref(false);
const dictDialogType = ref<'add' | 'edit'>('add');
const dictDialogData = ref<any>(null);

function showDataDialog(type: 'add' | 'edit', data?: any) {
  dictDialogType.value = type;
  dictDialogData.value = type === 'add' ? { type_id: selectedId.value } : data;
  dictDialogVisible.value = true;
}

// Search handlers
function handleSearch() {
  getDictDataByPage(1);
}

function handleReset() {
  if (!selectedId.value) { ElMessage.warning('请选择字典类型'); return; }
  Object.assign(searchDictParams.value, { label: '', value: '', status: '', type_id: selectedId.value });
  getDictDataByPage(1);
}

// Color helper
const getColor = (color: string | undefined, type: 'bg' | 'border' | 'text') => {
  if (!color) {
    const colors = { bg: 'var(--el-color-primary-light-9)', border: 'var(--el-color-primary-light-8)', text: 'var(--el-color-primary)' };
    return colors[type];
  }
  let r = 0, g = 0, b = 0;
  if (color.startsWith('#')) {
    const hex = color.slice(1);
    r = parseInt(hex.slice(0, 2), 16);
    g = parseInt(hex.slice(2, 4), 16);
    b = parseInt(hex.slice(4, 6), 16);
  } else if (color.startsWith('rgb')) {
    const match = color.match(/rgb\((\d+),\s*(\d+),\s*(\d+)\)/);
    if (match) { r = parseInt(match[1]); g = parseInt(match[2]); b = parseInt(match[3]); }
    else return color;
  } else return color;

  switch (type) {
    case 'bg': return `rgba(${r}, ${g}, ${b}, 0.1)`;
    case 'border': return `rgba(${r}, ${g}, ${b}, 0.3)`;
    case 'text': return `rgb(${r}, ${g}, ${b})`;
    default: return color;
  }
};
</script>

<template>
  <div class="dict-page min-h-500px">
    <ElRow :gutter="16" class="dict-row h-full">
      <!-- Left: Dict Type -->
      <ElCol :xs="24" :sm="24" :md="8" :lg="8" class="panel-col">
        <ElCard class="panel-card h-full" shadow="never">
          <template #header>
            <b>数据字典</b>
          </template>
          <div class="panel-body">
            <ElSpace wrap class="panel-toolbar">
              <ElButton type="primary" plain size="small" @click="refreshTypeData">
                <template #icon><icon-ic-round-refresh class="text-icon" /></template>
              </ElButton>
              <ElButton type="primary" plain size="small" @click="typeShowDialog('add')">新增</ElButton>
              <ElButton plain size="small" @click="updateTypeDialog">修改</ElButton>
              <ElButton type="danger" plain size="small" @click="deleteTypeDialog">删除</ElButton>
            </ElSpace>
            <div class="panel-table">
              <ElTable v-loading="typeLoading" height="100%" border :data="typeData" row-key="id" highlight-current-row>
                <ElTableColumn prop="name" label="字典名称" min-width="100">
                  <template #header>
                    <ElPopover placement="bottom" :width="200" trigger="hover">
                      <template #reference>
                        <div class="flex items-center gap-8px c-p">
                          <span>字典名称</span>
                          <ElIcon><Search /></ElIcon>
                        </div>
                      </template>
                      <ElInput v-model="typeSearch.name" placeholder="搜索字典名称" size="small" clearable @input="handleTypeSearch" />
                    </ElPopover>
                  </template>
                </ElTableColumn>
                <ElTableColumn prop="code" label="字典标识" min-width="100">
                  <template #header>
                    <ElPopover placement="bottom" :width="200" trigger="hover">
                      <template #reference>
                        <div class="flex items-center gap-8px c-p">
                          <span>字典标识</span>
                          <ElIcon><Search /></ElIcon>
                        </div>
                      </template>
                      <ElInput v-model="typeSearch.code" placeholder="搜索字典标识" size="small" clearable @input="handleTypeSearch" />
                    </ElPopover>
                  </template>
                </ElTableColumn>
                <ElTableColumn prop="status" label="状态" width="80">
                  <template #default="{ row }">
                    <ElTag v-if="row.status == 1" type="success" size="small">启用</ElTag>
                    <ElTag v-else type="danger" size="small">禁用</ElTag>
                  </template>
                </ElTableColumn>
                <ElTableColumn prop="id" label="选中" width="70" align="center">
                  <template #default="{ row }">
                    <ElRadio v-model="selectedId" :value="row.id" @change="handleTypeChange(row.id, row)" />
                  </template>
                </ElTableColumn>
              </ElTable>
            </div>
            <div class="panel-pagination">
              <ElPagination
                v-if="typePagination.total"
                size="small"
                layout="prev, pager, next"
                v-bind="typePagination"
                @current-change="handleTypePageChange"
                @size-change="handleTypePageSizeChange"
              />
            </div>
          </div>
        </ElCard>
      </ElCol>

      <!-- Right: Dict Data -->
      <ElCol :xs="24" :sm="24" :md="16" :lg="16" class="panel-col">
        <div v-if="selectedId === 0" class="h-full">
          <ElCard class="panel-card h-full" shadow="never">
            <ElEmpty description="请先选择左侧字典类型配置" />
          </ElCard>
        </div>

        <div v-else class="right-panel h-full">
          <DictSearch v-model:model="searchDictParams" @search="handleSearch" @reset="handleReset" />

          <ElCard class="panel-card flex-1 min-h-0" shadow="never">
            <div class="panel-body">
              <ElSpace wrap class="panel-toolbar">
                <ElButton type="primary" plain size="small" @click="showDataDialog('add', { type_id: selectedId })">
                  <template #icon><icon-ic-round-add class="text-icon" /></template>
                  新增
                </ElButton>
                <ElButton type="danger" plain size="small" :disabled="dictCheckedKeys.length === 0" @click="handleDictBatchDelete">
                  <template #icon><icon-ic-round-delete class="text-icon" /></template>
                  删除
                </ElButton>
              </ElSpace>
              <div class="panel-table">
                <ElTable
                  v-loading="dictLoading"
                  height="100%"
                  border
                  :data="dictData"
                  row-key="id"
                  @selection-change="(rows: any) => (dictCheckedKeys = rows.map((r: any) => String(r.id)))"
                >
                  <ElTableColumn v-for="col in dictColumns" :key="col.prop as string" v-bind="col" />
                </ElTable>
              </div>
              <div class="panel-pagination">
                <ElPagination
                  v-if="dictPagination.total"
                  layout="total,prev,pager,next,sizes"
                  v-bind="dictPagination"
                  @current-change="handleDictPageChange"
                  @size-change="handleDictPageSizeChange"
                />
              </div>
            </div>
          </ElCard>
        </div>
      </ElCol>
    </ElRow>

    <TypeEditDialog v-model="typeDialogVisible" :dialog-type="typeDialogType" :data="typeDialogData" @success="handleTypeEditSuccess" />
    <DictEditDialog v-model="dictDialogVisible" :dialog-type="dictDialogType" :data="dictDialogData" @success="getDictDataByPage(1)" />
  </div>
</template>

<style scoped>
.dict-page {
  height: calc(100vh - 180px);
}

.dict-row {
  min-height: 100%;
}

.panel-col {
  margin-bottom: 16px;
  height: 100%;
}

.right-panel {
  display: flex;
  flex-direction: column;
  gap: 16px;
  min-height: 0;
}

.panel-card {
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.panel-card :deep(.el-card__body) {
  display: flex;
  flex: 1;
  flex-direction: column;
  min-height: 0;
  padding-bottom: 16px;
}

.panel-body {
  display: flex;
  flex: 1;
  flex-direction: column;
  min-height: 0;
}

.panel-toolbar {
  flex-shrink: 0;
  margin-bottom: 12px;
}

.panel-table {
  flex: 1;
  min-height: 0;
  overflow: hidden;
}

.panel-pagination {
  display: flex;
  flex-shrink: 0;
  justify-content: flex-end;
  margin-top: auto;
  padding-top: 12px;
}

@media (min-width: 992px) {
  .panel-col {
    margin-bottom: 0;
  }
}

@media (max-width: 991px) {
  .dict-page {
    height: auto;
  }

  .panel-table {
    height: 320px;
  }
}
</style>
