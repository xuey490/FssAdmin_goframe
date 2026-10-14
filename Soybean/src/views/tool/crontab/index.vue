<script setup lang="tsx">
import { ref } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { fetchDeleteCrontab, fetchGetCrontabList, fetchRunCrontab } from '@/service/api';
import { defaultTransform, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import TableSearch from './modules/table-search.vue';
import EditDialog from './modules/edit-dialog.vue';
import LogListDialog from './modules/log-list.vue';

defineOptions({ name: 'CrontabManage' });

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  name: undefined,
  type: undefined,
  status: undefined
});

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
  api: () => fetchGetCrontabList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { prop: 'id', label: $t('page.tool.crontab.id'), width: 100, align: 'center' },
    { prop: 'name', label: $t('page.tool.crontab.name'), minWidth: 120 },
    {
      prop: 'type',
      label: $t('page.tool.crontab.type'),
      minWidth: 120,
      formatter: (row: any) => <SaDict dict="crontab_task_type" value={row.type} />
    },
    { prop: 'rule', label: $t('page.tool.crontab.rule'), minWidth: 140 },
    { prop: 'target', label: $t('page.tool.crontab.target'), minWidth: 200, showOverflowTooltip: true },
    {
      prop: 'status',
      label: $t('page.tool.crontab.status'),
      width: 100,
      formatter: (row: any) => <SaDict dict="data_status" value={row.status} />
    },
    { prop: 'update_time', label: $t('page.tool.crontab.updateTime'), width: 180, sortable: true },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 180,
      fixed: 'right' as const,
      formatter: (row: any) => (
        <div class="flex gap-2">
          <SaButton
            type="primary"
            icon="ri:play-fill"
            toolTip={$t('page.tool.crontab.runTask')}
            onClick={() => handleRun(row)}
          />
          <SaButton
            type="primary"
            icon="ri:history-line"
            toolTip={$t('page.tool.crontab.runLog')}
            onClick={() => showLogDialog(row)}
          />
          <SaButton type="secondary" toolTip={$t('common.edit')} onClick={() => showDialog('edit', row)} />
          <SaButton type="error" toolTip={$t('common.delete')} onClick={() => confirmDelete(row)} />
        </div>
      )
    }
  ]
});

const dialogVisible = ref(false);
const dialogType = ref<'add' | 'edit'>('add');
const dialogData = ref<any>(null);

const logVisible = ref(false);
const logData = ref<any>(null);

function showDialog(type: 'add' | 'edit', row?: any) {
  dialogType.value = type;
  dialogData.value = row || null;
  dialogVisible.value = true;
}

function showLogDialog(row: any) {
  logData.value = row;
  logVisible.value = true;
}

async function handleRun(row: any) {
  try {
    await ElMessageBox.confirm($t('page.tool.crontab.confirmRun', { name: row.name }), $t('page.tool.crontab.runTask'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    const { error } = await fetchRunCrontab(row.id);
    if (!error) {
      ElMessage.success($t('page.tool.crontab.runSuccess'));
      await getData();
    }
  } catch {}
}

async function confirmDelete(row: any) {
  try {
    await ElMessageBox.confirm($t('common.confirmDelete'), $t('common.tip'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    const { error } = await fetchDeleteCrontab({ ids: [row.id] });
    if (!error) {
      ElMessage.success($t('common.deleteSuccess'));
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
    name: undefined,
    type: undefined,
    status: undefined
  };
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <TableSearch v-model:model="searchParams" @reset="resetSearchParams" @search="handleSearch" />

    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('page.tool.crontab.title') }}</p>
          <TableHeaderOperation
            v-model:columns="columnChecks"
            :loading="loading"
            :show-delete="false"
            @add="showDialog('add')"
            @refresh="getData"
          />
        </div>
      </template>
      <div class="h-[calc(100%-52px)]">
        <ElTable v-loading="loading" height="100%" border class="sm:h-full" :data="data" row-key="id">
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

    <EditDialog v-model="dialogVisible" :dialog-type="dialogType" :data="dialogData" @success="getData" />

    <LogListDialog v-model="logVisible" :data="logData" />
  </div>
</template>
