<script setup lang="tsx">
import { ref } from 'vue';
import { enableStatusRecord } from '@/constants/business';
import { fetchDeletePost, fetchGetPostList } from '@/service/api';
import { defaultTransform, useTableOperate, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import PostOperateDialog from './modules/post-operate-dialog.vue';
import PostSearch from './modules/post-search.vue';

defineOptions({ name: 'PostManage' });

const searchParams = ref<Api.Post.PostSearchParams>({
  page: 1,
  limit: 20,
  name: undefined,
  code: undefined,
  status: undefined
});

const { columns, columnChecks, data, getData, getDataByPage, loading, mobilePagination, handleCurrentPageChange, handlePageSizeChange } = useUIPaginatedTable({
  paginationProps: {
    currentPage: searchParams.value.page,
    pageSize: searchParams.value.limit
  },
  api: () => fetchGetPostList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { prop: 'selection', type: 'selection', width: 48 },
    { prop: 'index', type: 'index', label: $t('common.index'), width: 64 },
    { prop: 'name', label: $t('page.manage.post.postName'), minWidth: 160 },
    { prop: 'code', label: $t('page.manage.post.postCode'), minWidth: 160 },
    { prop: 'sort', label: $t('page.manage.dept.sort'), width: 90, align: 'center' },
    {
      prop: 'status',
      label: $t('page.manage.common.status.enable'),
      width: 100,
      formatter: (row: Api.Post.Post) => {
        if (row.status === undefined) return '';
        const tagMap: Record<Api.Common.EnableStatus, UI.ThemeColor> = { '1': 'success', '0': 'warning' };
        const status = String(row.status ?? '1') as Api.Common.EnableStatus;
        return <ElTag type={tagMap[status]}>{$t(enableStatusRecord[status])}</ElTag>;
      }
    },
    { prop: 'remark', label: $t('page.manage.dept.remark'), minWidth: 200, showOverflowTooltip: true },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 140,
      formatter: (row: Api.Post.Post) => (
        <div class="flex-center">
          <ElButton type="primary" plain size="small" onClick={() => handleEdit(Number(row.id))}>
            {$t('common.edit')}
          </ElButton>
          <ElPopconfirm title={$t('common.confirmDelete')} onConfirm={() => handleDelete(Number(row.id))}>
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

const { drawerVisible, operateType, editingData, handleAdd, handleEdit, checkedRowKeys, onDeleted } = useTableOperate(
  data,
  'id',
  getData
);

async function handleDelete(id: number) {
  const { error } = await fetchDeletePost(id);
  if (!error) {
    onDeleted();
  }
}

function resetSearchParams() {
  searchParams.value = {
    page: 1,
    limit: 20,
    name: undefined,
    code: undefined,
    status: undefined
  };
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <PostSearch v-model:model="searchParams" @reset="resetSearchParams" @search="getDataByPage" />

    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('page.manage.post.title') }}</p>
          <TableHeaderOperation
            v-model:columns="columnChecks"
            :disabled-delete="checkedRowKeys.length === 0"
            :loading="loading"
            @add="handleAdd"
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
          @selection-change="checkedRowKeys = $event.map((row: any) => row.id)"
        >
          <ElTableColumn v-for="col in columns" :key="col.prop" v-bind="col" />
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

      <PostOperateDialog
        v-model:visible="drawerVisible"
        :operate-type="operateType"
        :row-data="editingData as Api.Post.Post"
        @submitted="getDataByPage"
      />
    </ElCard>
  </div>
</template>
