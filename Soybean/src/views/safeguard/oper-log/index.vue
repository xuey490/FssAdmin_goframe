<script setup lang="tsx">
import { h, ref } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { fetchGetOperLogList, fetchDeleteOperLog } from '@/service/api';
import { useUIPaginatedTable, useTableOperate, defaultTransform } from '@/hooks/common/table';
import { $t } from '@/locales';
import TableSearch from './modules/table-search.vue';

defineOptions({ name: 'OperLogManage' });

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  username: undefined,
  ip: undefined,
  service_name: undefined,
  router: undefined,
  create_time: undefined
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
  api: () => fetchGetOperLogList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const },
    { prop: 'id', label: '序号', width: 100, align: 'center' },
    { prop: 'username', label: '账号' },
    { prop: 'service_name', label: '应用名称' },
    { prop: 'router', label: '路由', minWidth: 180, showOverflowTooltip: true },
    { prop: 'ip', label: '操作IP' },
    { prop: 'ip_location', label: '所属地区' },
    { prop: 'duration', label: '时间(ms)' },
    { prop: 'create_time', label: '操作时间', width: 180, sortable: true },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 120,
      fixed: 'right' as const,
      formatter: (row: any) => (
        <div class="flex-center gap-8px">
          <ElButton type="success" plain size="small" onClick={() => handleParams(row)}>
            参数
          </ElButton>
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
  const { error } = await fetchDeleteOperLog({ ids: [id] });
  if (!error) onDeleted();
}

async function handleBatchDelete() {
  if (checkedRowKeys.value.length === 0) return;
  try {
    await ElMessageBox.confirm(
      `确定要删除选中${checkedRowKeys.value.length} 条记录吗？`,
      '批量删除确认',
      { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
    );
    const ids = checkedRowKeys.value.map(Number);
    const { error } = await fetchDeleteOperLog({ ids });
    if (!error) {
      ElMessage.success('删除成功!');
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
    username: undefined,
    ip: undefined,
    service_name: undefined,
    router: undefined,
    create_time: undefined
  };
}

function handleParams(row: any) {
  let formattedData = row.request_data;
  if (row.request_data) {
    try {
      const parsedData = typeof row.request_data === 'string' ? JSON.parse(row.request_data) : row.request_data;
      formattedData = JSON.stringify(parsedData, null, 2);
    } catch {
      formattedData = row.request_data;
    }
  }

  ElMessageBox({
    title: '请求参数',
    message: h(
      'div',
      {
        style: {
          maxHeight: '400px',
          minWidth: '380px',
          overflow: 'auto',
          backgroundColor: '#f5f5f5',
          padding: '16px',
          borderRadius: '4px'
        }
      },
      [
        h(
          'pre',
          {
            style: {
              margin: 0,
              fontFamily: 'Consolas, Monaco, "Courier New", monospace',
              fontSize: '14px',
              lineHeight: '1.5',
              color: '#333'
            }
          },
          formattedData
        )
      ]
    )
  });
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <TableSearch v-model:model="searchParams" @reset="resetSearchParams" @search="handleSearch" />
    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>操作日志</p>
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
        <ElTable v-loading="loading" height="100%" border class="sm:h-full" :data="data" row-key="id" @selection-change="(rows: any) => (checkedRowKeys = rows.map((r: any) => String(r.id)))">
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
