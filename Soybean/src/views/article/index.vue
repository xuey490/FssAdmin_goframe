<script setup lang="tsx">
import { ref } from 'vue';
import { ElImage, ElMessage, ElMessageBox, ElSwitch, ElTag } from 'element-plus';
import {
  fetchBatchDeleteArticle,
  fetchDeleteArticle,
  fetchGetArticleList,
  fetchUpdateArticleStatus
} from '@/service/api';
import { defaultTransform, useTableOperate, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import TableSearch from './modules/table-search.vue';
import EditDialog from './modules/form.vue';

defineOptions({ name: 'ArticleManage' });

const searchParams = ref<Api.Article.ArticleSearchParams>({
  page: 1,
  limit: 10,
  title: undefined,
  author: undefined,
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
  api: () => fetchGetArticleList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const },
    { prop: 'id', label: 'ID', width: 80, align: 'center' },
    { prop: 'title', label: $t('page.article.articleTitle'), minWidth: 200, showOverflowTooltip: true },
    { prop: 'author', label: $t('page.article.author'), width: 120 },
    {
      prop: 'image',
      label: $t('page.article.coverImage'),
      width: 100,
      formatter: (row: Api.Article.Article) =>
        row.image ? (
          <ElImage
            src={row.image}
            preview-src-list={[row.image]}
            preview-teleported
            z-index={9999}
            fit="cover"
            style="width: 50px; height: 50px; border-radius: 4px"
          />
        ) : (
          <span>-</span>
        )
    },
    { prop: 'views', label: $t('page.article.views'), width: 100, align: 'center' },
    {
      prop: 'is_link',
      label: $t('page.article.isLink'),
      width: 100,
      align: 'center',
      formatter: (row: Api.Article.Article) => (
        <ElTag type={row.is_link === 1 ? 'success' : 'info'} size="small">
          {row.is_link === 1 ? $t('common.yesOrNo.yes') : $t('common.yesOrNo.no')}
        </ElTag>
      )
    },
    {
      prop: 'is_hot',
      label: $t('page.article.isHot'),
      width: 100,
      align: 'center',
      formatter: (row: Api.Article.Article) => (
        <ElTag type={row.is_hot === 1 ? 'danger' : 'info'} size="small">
          {row.is_hot === 1 ? $t('page.article.hot') : $t('page.article.normal')}
        </ElTag>
      )
    },
    { prop: 'sort', label: $t('page.article.sort'), width: 80, align: 'center' },
    {
      prop: 'status',
      label: $t('page.article.status'),
      width: 100,
      formatter: (row: Api.Article.Article) => (
        <ElSwitch
          modelValue={row.status}
          activeValue={1}
          inactiveValue={0}
          onChange={(val: string | number | boolean) => handleStatusChange(row, Number(val))}
        />
      )
    },
    { prop: 'create_time', label: $t('page.article.createTime'), width: 180, sortable: true },
    {
      prop: 'operate',
      align: 'center',
      label: $t('common.operate'),
      width: 150,
      fixed: 'right' as const,
      formatter: (row: Api.Article.Article) => (
        <div class="flex gap-2">
          <SaButton type="secondary" toolTip={$t('common.edit')} onClick={() => showDialog('edit', row)} />
          <SaButton type="error" toolTip={$t('common.delete')} onClick={() => deleteRow(row)} />
        </div>
      )
    }
  ]
});

const { checkedRowKeys } = useTableOperate(data, 'id', getData);

const dialogVisible = ref(false);
const dialogType = ref<'add' | 'edit'>('add');
const dialogData = ref<Record<string, any> | undefined>(undefined);

function showDialog(type: 'add' | 'edit', row?: Api.Article.Article) {
  dialogType.value = type;
  dialogData.value = row ? { ...row } : undefined;
  dialogVisible.value = true;
}

async function handleStatusChange(row: Api.Article.Article, status: number) {
  const previous = row.status;
  row.status = status;
  const { error } = await fetchUpdateArticleStatus(row.id, status);
  if (error) {
    row.status = previous;
    ElMessage.error($t('page.article.statusUpdateFailed'));
    return;
  }
  ElMessage.success($t('page.article.statusUpdateSuccess'));
}

async function deleteRow(row: Api.Article.Article) {
  try {
    await ElMessageBox.confirm($t('common.confirmDelete'), $t('common.tip'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    const { error } = await fetchDeleteArticle(row.id);
    if (!error) {
      ElMessage.success($t('common.deleteSuccess'));
      await getData();
    }
  } catch {}
}

async function deleteSelectedRows() {
  if (checkedRowKeys.value.length === 0) {
    ElMessage.warning($t('page.article.selectAtLeastOne'));
    return;
  }
  try {
    await ElMessageBox.confirm($t('common.confirmDelete'), $t('common.tip'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    const { error } = await fetchBatchDeleteArticle(checkedRowKeys.value);
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
    title: undefined,
    author: undefined,
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
          <p>{{ $t('page.article.title') }}</p>
          <TableHeaderOperation
            v-model:columns="columnChecks"
            :loading="loading"
            :disabled-delete="checkedRowKeys.length === 0"
            @add="showDialog('add')"
            @delete="deleteSelectedRows"
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
          @selection-change="(rows: Api.Article.Article[]) => (checkedRowKeys = rows.map(row => String(row.id)))"
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

      <EditDialog v-model="dialogVisible" :dialog-type="dialogType" :data="dialogData" @success="getData" />
    </ElCard>
  </div>
</template>

<style scoped>
.text-ellipsis {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 200px;
}
</style>
