<script setup lang="tsx">
import { ref } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { fetchForceLogout, fetchGetOnlineList } from '@/service/api';
import { defaultTransform, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import TableSearch from './modules/table-search.vue';

defineOptions({ name: 'OnlineUserManage' });

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  ipaddr: undefined,
  userName: undefined
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
  api: () => fetchGetOnlineList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'index' as const, label: '序号', width: 70 },
    { prop: 'tokenId', label: '会话编号', minWidth: 220, showOverflowTooltip: true },
    { prop: 'userName', label: '登录账号', width: 120 },
    { prop: 'deptName', label: '所属部门', width: 140 },
    { prop: 'ipaddr', label: '主机', width: 140 },
    { prop: 'loginLocation', label: '登录地点', minWidth: 180, showOverflowTooltip: true },
    { prop: 'os', label: '操作系统', width: 120 },
    { prop: 'browser', label: '浏览器', minWidth: 160, showOverflowTooltip: true },
    { prop: 'loginTime', label: '登录时间', width: 180, sortable: true },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 90,
      fixed: 'right' as const,
      formatter: (row: any) => (
        <div class="flex gap-2">
          <SaButton type="error" toolTip="强退" onClick={() => handleForceLogout(row)} />
        </div>
      )
    }
  ]
});

async function handleForceLogout(row: Record<string, any>) {
  if (!row?.tokenId) {
    ElMessage.warning('会话标识不存在，无法强退');
    return;
  }
  try {
    await ElMessageBox.confirm(`确认强制下线用户【${row.userName || '-'}】吗？`, '提示', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    });
    const { error } = await fetchForceLogout(row.tokenId);
    if (!error) {
      ElMessage.success('强退成功');
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
    ipaddr: undefined,
    userName: undefined
  };
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <TableSearch v-model:model="searchParams" @reset="resetSearchParams" @search="handleSearch" />
    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('route.safeguard_online') }}</p>
          <TableHeaderOperation v-model:columns="columnChecks" :loading="loading" :show-add="false" :show-delete="false" @refresh="getData" />
        </div>
      </template>
      <div class="h-[calc(100%-52px)]">
        <ElTable v-loading="loading" height="100%" border class="sm:h-full" :data="data" row-key="tokenId">
          <ElTableColumn v-for="col in columns" :key="(col.prop as string) || col.type" v-bind="col" />
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
