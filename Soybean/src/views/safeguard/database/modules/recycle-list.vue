<script setup lang="tsx">
import { computed, nextTick, ref, watch } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import {
  fetchDestroyDatabaseRecycle,
  fetchGetDatabaseRecycleList,
  fetchRecoveryDatabaseRecycle
} from '@/service/api';
import { defaultTransform, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';

defineOptions({ name: 'RecycleList' });

interface Props {
  modelValue: boolean;
  data?: Record<string, any>;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  data: undefined
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
}>();

const visible = computed({
  get: () => props.modelValue,
  set: val => emit('update:modelValue', val)
});

const drawerTitle = computed(() =>
  $t('page.safeguard.database.recycle.drawerTitle', { name: props.data?.name || '' })
);

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  table: null
});

const selectedRows = ref<any[]>([]);

function handleSelectionChange(rows: any[]) {
  selectedRows.value = rows;
}

const { columns, data, loading, getData, getDataByPage, mobilePagination, handleCurrentPageChange, handlePageSizeChange } = useUIPaginatedTable({
  immediate: false,
  paginationProps: {
    currentPage: 1,
    pageSize: 10
  },
  api: () => fetchGetDatabaseRecycleList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const },
    { prop: 'id', label: 'ID', width: 80 },
    { prop: 'delete_time', label: $t('page.safeguard.database.recycle.deleteTime'), width: 180 },
    {
      prop: 'json_data',
      label: $t('page.safeguard.database.recycle.dataDetail'),
      showOverflowTooltip: true,
      formatter: (row: any) => JSON.stringify(row)
    }
  ]
});

watch(
  () => props.modelValue,
  async newVal => {
    if (newVal && props.data) {
      await nextTick();
      searchParams.value.table = props.data.name;
      getDataByPage(1);
    }
  }
);

function handleClose() {
  visible.value = false;
}

async function handleDestroyRows() {
  if (selectedRows.value.length === 0) {
    ElMessage.warning($t('page.safeguard.database.recycle.selectDestroyRows'));
    return;
  }
  try {
    await ElMessageBox.confirm(
      $t('page.safeguard.database.recycle.confirmDestroy', { count: selectedRows.value.length }),
      $t('page.safeguard.database.recycle.destroyTitle'),
      { confirmButtonText: $t('common.confirm'), cancelButtonText: $t('common.cancel'), type: 'error' }
    );
    const { error } = await fetchDestroyDatabaseRecycle({
      table: searchParams.value.table,
      ids: selectedRows.value.map(row => row.id)
    });
    if (!error) {
      ElMessage.success($t('page.safeguard.database.recycle.operateSuccess'));
      selectedRows.value = [];
      getDataByPage(1);
    }
  } catch {}
}

async function handleRestoreRows() {
  if (selectedRows.value.length === 0) {
    ElMessage.warning($t('page.safeguard.database.recycle.selectRestoreRows'));
    return;
  }
  try {
    await ElMessageBox.confirm(
      $t('page.safeguard.database.recycle.confirmRestore', { count: selectedRows.value.length }),
      $t('page.safeguard.database.recycle.restoreTitle'),
      { confirmButtonText: $t('common.confirm'), cancelButtonText: $t('common.cancel'), type: 'warning' }
    );
    const { error } = await fetchRecoveryDatabaseRecycle({
      table: searchParams.value.table,
      ids: selectedRows.value.map(row => row.id)
    });
    if (!error) {
      ElMessage.success($t('page.safeguard.database.recycle.operateSuccess'));
      selectedRows.value = [];
      getDataByPage(1);
    }
  } catch {}
}
</script>

<template>
  <ElDrawer
    v-model="visible"
    :title="drawerTitle"
    size="70%"
    destroy-on-close
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <div class="flex-col-stretch gap-16px">
      <div>
        <ElSpace wrap>
          <ElButton type="danger" plain :disabled="selectedRows.length === 0" @click="handleDestroyRows">
            <template #icon>
              <icon-ic-round-delete class="text-icon" />
            </template>
            {{ $t('page.safeguard.database.recycle.destroy') }}
          </ElButton>
          <ElButton type="success" plain :disabled="selectedRows.length === 0" @click="handleRestoreRows">
            <template #icon>
              <icon-ic-round-restore class="text-icon" />
            </template>
            {{ $t('page.safeguard.database.recycle.restore') }}
          </ElButton>
        </ElSpace>
      </div>
      <ElTable v-loading="loading" border :data="data" row-key="id" @selection-change="handleSelectionChange">
        <ElTableColumn v-for="col in columns" :key="col.prop as string" v-bind="col" />
      </ElTable>
      <div class="flex justify-end">
        <ElPagination
          v-if="mobilePagination.total"
          layout="total,prev,pager,next,sizes"
          v-bind="mobilePagination"
          @current-change="handleCurrentPageChange"
          @size-change="handlePageSizeChange"
        />
      </div>
    </div>
  </ElDrawer>
</template>
