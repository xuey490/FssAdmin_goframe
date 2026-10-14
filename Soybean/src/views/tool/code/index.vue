<script setup lang="tsx">
import { ref } from 'vue';
import { ElMessage, ElMessageBox, ElTag } from 'element-plus';
import {
  fetchDeleteCodeGenerate,
  fetchGenerateCodeDownload,
  fetchGenerateCodeFile,
  fetchGetCodeGenerateList,
  fetchSyncCodeTable
} from '@/service/api/tool/code';
import { defaultTransform, useTableOperate, useUIPaginatedTable } from '@/hooks/common/table';
import { downloadFile } from '@/utils/download';
import { $t } from '@/locales';
import TableSearch from './modules/table-search.vue';
import LoadTable from './components/loadTable.vue';
import Preview from './components/preview.vue';
import EditInfo from './components/editInfo.vue';

defineOptions({ name: 'CodeGenerateManage' });

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  table_name: undefined,
  source: undefined
});

const tableVisible = ref(false);
const previewVisible = ref(false);
const previewData = ref<Record<string, any>>({});
const editVisible = ref(false);
const editData = ref<Record<string, any>>({});

const {
  columns,
  columnChecks,
  data,
  loading,
  getData,
  getDataByPage,
  mobilePagination,
  handleCurrentPageChange,
  handlePageSizeChange
} = useUIPaginatedTable({
  paginationProps: {
    currentPage: 1,
    pageSize: 10
  },
  api: () => fetchGetCodeGenerateList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const },
    { prop: 'table_name', label: $t('page.tool.code.tableName'), minWidth: 180, align: 'left' },
    { prop: 'table_comment', label: $t('page.tool.code.tableComment'), minWidth: 150, align: 'left' },
    { prop: 'template', label: $t('page.tool.code.template'), minWidth: 120 },
    { prop: 'namespace', label: $t('page.tool.code.namespace'), minWidth: 120 },
    { prop: 'stub', label: $t('page.tool.code.stub'), minWidth: 120 },
    {
      prop: 'tpl_category',
      label: $t('page.tool.code.tplCategory'),
      minWidth: 120,
      formatter: (row: any) => {
        if (!row.tpl_category) return '';
        const isSingle = row.tpl_category === 'single';
        return (
          <ElTag type={isSingle ? 'success' : 'danger'} size="small">
            {isSingle ? $t('page.tool.code.singleCrud') : $t('page.tool.code.treeCrud')}
          </ElTag>
        );
      }
    },
    { prop: 'update_time', label: $t('page.tool.code.updateTime'), width: 180, sortable: true },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 240,
      fixed: 'right' as const,
      formatter: (row: any) => (
        <div class="flex items-center gap-2">
          <SaButton
            type="success"
            icon="ri:eye-line"
            toolTip={$t('page.tool.code.preview')}
            onClick={() => openPreview(row)}
          />
          <SaButton
            type="primary"
            icon="ri:refresh-line"
            toolTip={$t('page.tool.code.sync')}
            onClick={() => syncTable(row.id)}
          />
          <SaButton
            type="secondary"
            icon="ri:pencil-line"
            toolTip={$t('common.edit')}
            onClick={() => openEdit(row)}
          />
          <SaButton
            type="error"
            icon="ri:delete-bin-5-line"
            toolTip={$t('common.delete')}
            onClick={() => handleDelete(row.id)}
          />
          <ElDropdown trigger="click">
            {{
              default: () => <SaButton type="info" toolTip={$t('page.tool.code.more')} />,
              dropdown: () => (
                <ElDropdownMenu>
                  <ElDropdownItem onClick={() => generateFile(row.id)}>
                    <span class="flex items-center gap-2">
                      <SvgIcon icon="ri:folder-add-line" />
                      {$t('page.tool.code.generateToProject')}
                    </span>
                  </ElDropdownItem>
                  <ElDropdownItem onClick={() => generateCode(row.id)}>
                    <span class="flex items-center gap-2">
                      <SvgIcon icon="ri:download-line" />
                      {$t('page.tool.code.codeDownload')}
                    </span>
                  </ElDropdownItem>
                </ElDropdownMenu>
              )
            }}
          </ElDropdown>
        </div>
      )
    }
  ]
});

const { checkedRowKeys, onDeleted } = useTableOperate(data, 'id', getData);

function openPreview(row: Record<string, any>) {
  previewData.value = row;
  previewVisible.value = true;
}

function openEdit(row: Record<string, any>) {
  editData.value = row;
  editVisible.value = true;
}

function showLoadTable() {
  tableVisible.value = true;
}

async function generateCode(ids: number | string | (number | string)[]) {
  const idList = Array.isArray(ids)
    ? ids.map(String)
    : String(ids)
        .split(',')
        .filter(Boolean);

  if (idList.length === 0) {
    ElMessage.error($t('page.tool.code.selectAtLeastOne'));
    return;
  }

  ElMessage.info($t('page.tool.code.codeGenerating'));

  try {
    const res = await fetchGenerateCodeDownload({ ids: idList });
    downloadFile(res, 'code.zip');
    ElMessage.success($t('page.tool.code.codeGenerateSuccess'));
  } catch {
    ElMessage.error($t('page.tool.code.downloadFailed'));
  }
}

async function syncTable(id: number) {
  try {
    await ElMessageBox.confirm($t('page.tool.code.syncConfirm'), $t('common.tip'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    const { error } = await fetchSyncCodeTable({ id });
    if (!error) {
      ElMessage.success($t('page.tool.code.syncSuccess'));
      await getData();
    }
  } catch {}
}

async function generateFile(id: number) {
  try {
    await ElMessageBox.confirm($t('page.tool.code.generateFileConfirm'), $t('common.tip'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    const { error } = await fetchGenerateCodeFile({ id });
    if (!error) {
      ElMessage.success($t('page.tool.code.generateFileSuccess'));
    }
  } catch {}
}

function batchGenerate() {
  if (checkedRowKeys.value.length === 0) {
    ElMessage.error($t('page.tool.code.selectAtLeastOne'));
    return;
  }
  generateCode(checkedRowKeys.value);
}

async function handleDelete(id: number) {
  try {
    await ElMessageBox.confirm($t('common.confirmDelete'), $t('common.tip'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    const { error } = await fetchDeleteCodeGenerate({ ids: [id] });
    if (!error) {
      onDeleted();
    }
  } catch {}
}

async function handleBatchDelete() {
  if (checkedRowKeys.value.length === 0) return;
  try {
    await ElMessageBox.confirm(
      $t('page.tool.code.confirmBatchDelete', { count: checkedRowKeys.value.length }),
      $t('common.batchDelete'),
      { confirmButtonText: $t('common.confirm'), cancelButtonText: $t('common.cancel'), type: 'warning' }
    );
    const ids = checkedRowKeys.value.map(Number);
    const { error } = await fetchDeleteCodeGenerate({ ids });
    if (!error) {
      ElMessage.success($t('common.deleteSuccess'));
      checkedRowKeys.value = [];
      await getData();
    }
  } catch {}
}

function handleSearch() {
  getDataByPage(1);
}

function resetSearchParams() {
  searchParams.value = {
    page: 1,
    limit: searchParams.value.limit ?? 10,
    table_name: undefined,
    source: undefined
  };
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <TableSearch v-model:model="searchParams" @reset="resetSearchParams" @search="handleSearch" />

    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('page.tool.code.title') }}</p>
          <div class="flex items-center gap-8px">
            <ElButton @click="showLoadTable">
              <template #icon>
                <SvgIcon icon="ri:upload-2-line" />
              </template>
              {{ $t('page.tool.code.load') }}
            </ElButton>
            <ElButton :disabled="checkedRowKeys.length === 0" @click="batchGenerate">
              <template #icon>
                <SvgIcon icon="ri:download-2-line" />
              </template>
              {{ $t('page.tool.code.generate') }}
            </ElButton>
            <ElButton type="danger" plain :disabled="checkedRowKeys.length === 0" @click="handleBatchDelete">
              <template #icon>
                <SvgIcon icon="ri:delete-bin-5-line" />
              </template>
              {{ $t('common.delete') }}
            </ElButton>
            <TableHeaderOperation
              v-model:columns="columnChecks"
              :loading="loading"
              :show-add="false"
              :show-delete="false"
              @refresh="getData"
            />
          </div>
        </div>
      </template>
      <div class="h-[calc(100%-52px)]">
        <ElTable
          v-loading="loading"
          height="100%"
          border
          class="sm:h-full"
          :data="data"
          row-key="id"
          @selection-change="(rows: any) => (checkedRowKeys = rows.map((r: any) => String(r.id)))"
        >
          <ElTableColumn v-for="col in columns" :key="col.prop as string" v-bind="col" />
        </ElTable>
      </div>
      <div class="mt-20px flex justify-end">
        <ElPagination
          v-if="mobilePagination.total"
          layout="total,prev,pager,next,sizes"
          v-bind="mobilePagination"
          @current-change="handleCurrentPageChange"
          @size-change="handlePageSizeChange"
        />
      </div>
    </ElCard>

    <LoadTable v-model="tableVisible" @success="getData" />
    <Preview v-model="previewVisible" :data="previewData" />
    <EditInfo v-model="editVisible" :data="editData" @success="getData" />
  </div>
</template>

<style lang="scss" scoped>
:deep(.el-drawer__header) {
  margin-bottom: 10px !important;
}
</style>
