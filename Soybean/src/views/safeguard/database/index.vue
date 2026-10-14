<script setup lang="tsx">
import { ref } from 'vue';
import { ElMessage, ElMessageBox, ElTooltip } from 'element-plus';
import {
  fetchGetDatabaseTableList,
  fetchOptimizeDatabaseTable,
  fetchFragmentDatabaseTable
} from '@/service/api';
import { useUIPaginatedTable, useTableOperate, defaultTransform } from '@/hooks/common/table';
import { $t } from '@/locales';
import TableSearch from './modules/table-search.vue';
import TableDialog from './modules/table-dialog.vue';
import DdlDialog from './modules/ddl-dialog.vue';
import RecycleList from './modules/recycle-list.vue';

defineOptions({ name: 'DatabaseManage' });

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  name: undefined
});

const {
  columns,
  columnChecks,
  data,
  loading,
  getData,
  getDataByPage,
  mobilePagination
} = useUIPaginatedTable({
  paginationProps: {
    currentPage: 1,
    pageSize: 10
  },
  api: () => fetchGetDatabaseTableList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const },
    { prop: 'name', label: '表名称', minWidth: 200 },
    { prop: 'comment', label: '表注释', minWidth: 150, showOverflowTooltip: true },
    { prop: 'engine', label: '表引擎', width: 120 },
    { prop: 'update_time', label: '更新时间', width: 180, sortable: true },
    { prop: 'rows', label: '总行数', width: 120 },
    { prop: 'data_free', label: '碎片大小', width: 120 },
    { prop: 'data_length', label: '数据大小', width: 120 },
    { prop: 'collation', label: '字符集', width: 180 },
    { prop: 'create_time', label: '创建时间', width: 180, sortable: true },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 160,
      fixed: 'right' as const,
      formatter: (row: any) => (
        <div class="flex-center gap-4px">
          <ElTooltip content="表结构" placement="top">
            <ElButton type="primary" plain size="small" onClick={() => handleTableDialog(row)}>
              <icon-ic-round-account-tree />
            </ElButton>
          </ElTooltip>
          <ElTooltip content="建表语句" placement="top">
            <ElButton type="info" plain size="small" onClick={() => handleDdlDialog(row)}>
              <icon-ic-round-code />
            </ElButton>
          </ElTooltip>
          <ElTooltip content="回收站" placement="top">
            <ElButton type="success" plain size="small" onClick={() => handleRecycleDialog(row)}>
              <icon-ic-round-restore-from-trash />
            </ElButton>
          </ElTooltip>
        </div>
      )
    }
  ]
});

const { checkedRowKeys } = useTableOperate(data, 'name', getData);

// Dialogs
const dialogVisible = ref(false);
const dialogData = ref({});
const ddlVisible = ref(false);
const ddlData = ref({});
const recycleVisible = ref(false);
const recycleData = ref({});

function handleTableDialog(row: Record<string, any>) {
  dialogVisible.value = true;
  dialogData.value = row;
}

function handleDdlDialog(row: Record<string, any>) {
  ddlData.value = row;
  ddlVisible.value = true;
}

function handleRecycleDialog(row: Record<string, any>) {
  recycleVisible.value = true;
  recycleData.value = row;
}

async function handleOptimizeRows() {
  if (checkedRowKeys.value.length === 0) {
    ElMessage.warning('请选择要优化的行');
    return;
  }
  try {
    await ElMessageBox.confirm(
      `确定要优化选中的 ${checkedRowKeys.value.length} 条数据吗？`,
      '优化选中数据',
      { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
    );
    const { error } = await fetchOptimizeDatabaseTable({
      tables: checkedRowKeys.value
    });
    if (!error) {
      ElMessage.success('操作成功');
      checkedRowKeys.value = [];
      await getData();
    }
  } catch {}
}

async function handleFragmentRows() {
  if (checkedRowKeys.value.length === 0) {
    ElMessage.warning('请选择要清理碎片的行');
    return;
  }
  try {
    await ElMessageBox.confirm(
      `确定要清理选中的 ${checkedRowKeys.value.length} 条数据吗？`,
      '清理碎片操作',
      { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
    );
    const { error } = await fetchFragmentDatabaseTable({
      tables: checkedRowKeys.value
    });
    if (!error) {
      ElMessage.success('操作成功');
      checkedRowKeys.value = [];
      await getData();
    }
  } catch {}
}

function handleSearch() {
  getDataByPage(1);
}

function resetSearchParams() {
  searchParams.value = { name: undefined };
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <TableSearch v-model:model="searchParams" @reset="resetSearchParams" @search="handleSearch" />
    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>数据库表</p>
          <div class="flex items-center gap-8px">
            <ElButton type="primary" plain size="small" :disabled="checkedRowKeys.length === 0" @click="handleOptimizeRows">
              优化表
            </ElButton>
            <ElButton type="warning" plain size="small" :disabled="checkedRowKeys.length === 0" @click="handleFragmentRows">
              清理碎片
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
        <ElTable v-loading="loading" height="100%" border class="sm:h-full" :data="data" row-key="name" @selection-change="(rows: any) => (checkedRowKeys = rows.map((r: any) => r.name))">
          <ElTableColumn v-for="col in columns" :key="col.prop as string" v-bind="col" />
        </ElTable>
      </div>
    </ElCard>

    <TableDialog v-model="dialogVisible" :data="dialogData" />
    <DdlDialog v-model="ddlVisible" :data="ddlData" />
    <RecycleList v-model="recycleVisible" :data="recycleData" />
  </div>
</template>
