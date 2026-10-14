<script setup lang="tsx">
import { ref } from 'vue';
import { ElButton, ElMessage, ElMessageBox, ElPopconfirm, ElTag } from 'element-plus';
import { fetchDeleteLoginLog, fetchGetLoginLogList } from '@/service/api';
import { defaultTransform, useTableOperate, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import TableSearch from './modules/table-search.vue';

defineOptions({ name: 'LoginLogManage' });

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  username: undefined,
  ip: undefined,
  status: undefined,
  login_time: undefined
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
  api: () => fetchGetLoginLogList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const },
    { prop: 'id', label: $t('page.safeguard.loginLog.id'), width: 100, align: 'center' },
    { prop: 'username', label: $t('page.safeguard.loginLog.username') },
    {
      prop: 'status',
      label: $t('page.safeguard.loginLog.status'),
      formatter: (row: any) => {
        if (row.status === undefined) return '';
        const isSuccess = row.status == 1;
        return (
          <ElTag type={isSuccess ? 'success' : 'danger'} size="small">
            {isSuccess ? $t('page.safeguard.loginLog.success') : $t('page.safeguard.loginLog.failure')}
          </ElTag>
        );
      }
    },
    { prop: 'ip', label: $t('page.safeguard.loginLog.ip') },
    { prop: 'ip_location', label: $t('page.safeguard.loginLog.ipLocation') },
    { prop: 'os', label: $t('page.safeguard.loginLog.os') },
    { prop: 'browser', label: $t('page.safeguard.loginLog.browser') },
    { prop: 'message', label: $t('page.safeguard.loginLog.message'), showOverflowTooltip: true },
    { prop: 'login_time', label: $t('page.safeguard.loginLog.loginTime'), width: 180, sortable: true },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 100,
      fixed: 'right' as const,
      formatter: (row: any) => (
        <div class="flex-center">
          <ElPopconfirm title={$t('common.confirmDelete')} onConfirm={() => handleDelete(row.id)}>
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

const { checkedRowKeys, onDeleted } = useTableOperate(data, 'id', getData);

async function handleDelete(id: number) {
  const { error } = await fetchDeleteLoginLog({ ids: [id] });
  if (!error) onDeleted();
}

async function handleBatchDelete() {
  if (checkedRowKeys.value.length === 0) return;
  try {
    await ElMessageBox.confirm(
      $t('page.safeguard.loginLog.confirmBatchDelete', { count: checkedRowKeys.value.length }),
      $t('common.batchDelete'),
      { confirmButtonText: $t('common.confirm'), cancelButtonText: $t('common.cancel'), type: 'warning' }
    );
    const ids = checkedRowKeys.value.map(Number);
    const { error } = await fetchDeleteLoginLog({ ids });
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
    limit: searchParams.value.limit,
    username: undefined,
    ip: undefined,
    status: undefined,
    login_time: undefined
  };
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <TableSearch v-model:model="searchParams" @reset="resetSearchParams" @search="handleSearch" />
    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('route.safeguard_login-log') }}</p>
          <TableHeaderOperation
            v-model:columns="columnChecks"
            :loading="loading"
            :show-add="false"
            :show-delete="checkedRowKeys.length > 0"
            @delete="handleBatchDelete"
            @refresh="getData"
          />
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
  </div>
</template>
