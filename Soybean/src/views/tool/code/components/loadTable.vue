<template>
  <ElDrawer
    v-model="visible"
    title="装载数据表"
    size="70%"
    destroy-on-close
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <div class="min-h-500px flex-col-stretch gap-16px">
      <ElAlert type="info" :closable="false">
        <template #title>
          <div>1、支持配置多数据源；</div>
          <div>
            2、载入表[sa_shop_category]会自动处理为[SaShopCategory]类，可以编辑对类名进行修改[ShopCategory]
          </div>
        </template>
      </ElAlert>

      <div class="flex items-center justify-between">
        <ElSpace wrap>
          <ElSelect v-model="searchForm.source" placeholder="切换数据源" style="width: 200px">
            <ElOption
              v-for="item in dataSourceList"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </ElSelect>
          <ElInput
            v-model="searchForm.name"
            placeholder="请输入数据表名称"
            style="width: 300px"
            clearable
          />
        </ElSpace>
        <ElSpace wrap>
          <ElButton @click="handleReset">
            <template #icon>
              <SvgIcon icon="ri:reset-right-line" />
            </template>
            重置
          </ElButton>
          <ElButton type="primary" @click="handleSearch">
            <template #icon>
              <SvgIcon icon="ri:search-line" />
            </template>
            查询
          </ElButton>
        </ElSpace>
      </div>

      <ElCard class="card-wrapper" shadow="never">
        <div class="mb-12px">
          <ElButton :disabled="selectedRows.length === 0" type="primary" @click="handleLoadTable">
            <template #icon>
              <SvgIcon icon="ri:check-fill" />
            </template>
            确认选择
          </ElButton>
        </div>
        <ElTable
          v-loading="loading"
          border
          :data="data"
          row-key="name"
          max-height="500"
          @selection-change="handleSelectionChange"
        >
          <ElTableColumn v-for="col in columns" :key="col.prop as string" v-bind="col" />
        </ElTable>
        <div class="mt-20px flex justify-end">
          <ElPagination
            v-if="mobilePagination.total"
            layout="total,prev,pager,next,sizes"
            v-bind="mobilePagination"
            @current-change="handlePageChange"
            @size-change="handleSizeChange"
          />
        </div>
      </ElCard>
    </div>
  </ElDrawer>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { ElMessage } from 'element-plus';
import { fetchGetDatabaseDataSource, fetchGetDatabaseTableList } from '@/service/api';
import { fetchLoadCodeTable } from '@/service/api/tool/code';
import { defaultTransform, useUIPaginatedTable } from '@/hooks/common/table';

defineOptions({ name: 'CodeLoadTable' });

interface Props {
  modelValue: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'success'): void;
}>();

const selectedRows = ref<Record<string, any>[]>([]);
const dataSourceList = ref<{ label: string; value: string }[]>([]);
const searchForm = ref({
  name: '',
  source: ''
});

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  name: '',
  source: ''
});

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
});

const {
  columns,
  data,
  loading,
  getData,
  mobilePagination,
  pagination,
  handleCurrentPageChange,
  handlePageSizeChange
} = useUIPaginatedTable({
  immediate: false,
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
    { prop: 'name', label: '表名称', minWidth: 180 },
    { prop: 'comment', label: '表注释', minWidth: 150, showOverflowTooltip: true },
    { prop: 'engine', label: '引擎', width: 120 },
    { prop: 'collation', label: '编码', width: 120 },
    { prop: 'create_time', label: '创建时间', width: 180 }
  ]
});

watch(
  () => props.modelValue,
  newVal => {
    if (newVal) {
      initPage();
    }
  }
);

async function initPage() {
  const { data: sources, error } = await fetchGetDatabaseDataSource();
  if (error) return;

  dataSourceList.value = (sources || []).map((item: string) => ({
    label: item,
    value: item
  }));
  searchForm.value.source = dataSourceList.value[0]?.value || '';
  refreshData();
}

function syncSearchParams() {
  searchParams.value = {
    ...searchParams.value,
    page: pagination.currentPage as number,
    limit: pagination.pageSize as number,
    name: searchForm.value.name || undefined,
    source: searchForm.value.source
  };
}

async function handlePageChange(page: number) {
  handleCurrentPageChange(page);
  syncSearchParams();
  await getData();
}

async function handleSizeChange(size: number) {
  handlePageSizeChange(size);
  syncSearchParams();
  await getData();
}

function refreshData() {
  pagination.currentPage = 1;
  syncSearchParams();
  searchParams.value.page = 1;
  getData();
}

function handleSearch() {
  refreshData();
}

function handleReset() {
  searchForm.value.name = '';
  refreshData();
}

function handleSelectionChange(selection: Record<string, any>[]) {
  selectedRows.value = selection;
}

async function handleLoadTable() {
  if (selectedRows.value.length < 1) {
    ElMessage.info('至少要选择一条数据');
    return;
  }

  const names = selectedRows.value.map(item => ({
    name: item.name,
    comment: item.comment,
    sourceName: item.name
  }));

  const { error } = await fetchLoadCodeTable({
    source: searchForm.value.source,
    names
  });

  if (!error) {
    ElMessage.success('装载成功');
    emit('success');
    handleClose();
  }
}

function handleClose() {
  visible.value = false;
  selectedRows.value = [];
}
</script>
