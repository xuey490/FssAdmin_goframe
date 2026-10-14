<script setup lang="tsx">
import { computed, ref, watch } from 'vue';
import { ElButton, ElPopconfirm } from 'element-plus';
import { fetchDeleteConfig, fetchGetConfigList } from '@/service/api';
import { defaultTransform, useTableOperate, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import ConfigEditDialog from './config-edit-dialog.vue';

defineOptions({ name: 'ConfigListDrawer' });

interface Props {
  visible: boolean;
  data?: Partial<Api.Config.ConfigGroup> | null;
}

const props = withDefaults(defineProps<Props>(), {
  data: null
});

interface Emits {
  (e: 'update:visible', value: boolean): void;
  (e: 'success'): void;
}

const emit = defineEmits<Emits>();

const show = computed({
  get: () => props.visible,
  set: value => emit('update:visible', value)
});

const searchParams = ref<Api.Config.ConfigItemSearchParams>({
  page: 1,
  limit: 20,
  group_id: undefined,
  key: undefined,
  name: undefined,
  status: undefined
});

const {
  columns,
  data: tableData,
  getData,
  loading,
  mobilePagination,
  handleCurrentPageChange,
  handlePageSizeChange
} = useUIPaginatedTable({
  immediate: false,
  paginationProps: {
    currentPage: searchParams.value.page,
    pageSize: searchParams.value.limit
  },
  api: () => fetchGetConfigList(searchParams.value),
  transform: response => defaultTransform<Api.Config.ConfigItem>(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { prop: 'selection', type: 'selection', width: 48 },
    { prop: 'key', label: $t('page.manage.config.key'), minWidth: 160 },
    { prop: 'name', label: $t('page.manage.config.name'), minWidth: 160 },
    { prop: 'input_type', label: $t('page.manage.config.inputType'), width: 110 },
    { prop: 'sort', label: $t('page.manage.config.sort'), width: 90 },
    { prop: 'remark', label: $t('page.manage.config.remark'), minWidth: 160 },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 140,
      formatter: (row: Api.Config.ConfigItem) => (
        <div class="flex-center gap-8px">
          <ElButton type="primary" plain size="small" onClick={() => openEdit(row)}>
            {$t('common.edit')}
          </ElButton>
          <ElPopconfirm title={$t('common.confirmDelete')} onConfirm={() => deleteRows([row.id])}>
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

const { checkedRowKeys } = useTableOperate(tableData, 'id', getData);

watch(
  () => props.visible,
  value => {
    if (!value) return;
    searchParams.value.page = 1;
    searchParams.value.group_id = props.data?.id as any;
    getData();
  }
);

const dialogVisible = ref(false);
const dialogType = ref<'add' | 'edit'>('add');
const dialogData = ref<Partial<Api.Config.ConfigItem> | null>(null);

function openAdd() {
  if (!props.data?.id) return;
  dialogType.value = 'add';
  dialogData.value = { group_id: props.data.id } as any;
  dialogVisible.value = true;
}

function openEdit(row: Api.Config.ConfigItem) {
  dialogType.value = 'edit';
  dialogData.value = { ...row };
  dialogVisible.value = true;
}

async function deleteRows(ids: number[]) {
  if (!ids.length) return;
  const { error } = await fetchDeleteConfig({ ids });
  if (error) return;
  window.$message?.success($t('common.deleteSuccess'));
  checkedRowKeys.value = [];
  await getData();
}

async function batchDelete() {
  const ids = checkedRowKeys.value.map(v => Number(v)).filter(Boolean);
  await deleteRows(ids);
}

function close() {
  show.value = false;
  emit('success');
}
</script>

<template>
  <ElDrawer
    v-model="show"
    :title="$t('page.manage.config.title')"
    size="70%"
    destroy-on-close
    :close-on-click-modal="false"
    @close="close"
  >
    <div class="h-full flex-col-stretch gap-12px overflow-hidden">
      <div class="flex items-center justify-between">
        <ElSpace wrap>
          <ElButton type="primary" @click="openAdd">{{ $t('common.add') }}</ElButton>
          <ElPopconfirm :title="$t('common.confirmDelete')" @confirm="batchDelete">
            <template #reference>
              <ElButton type="danger" :disabled="!checkedRowKeys.length">{{ $t('common.delete') }}</ElButton>
            </template>
          </ElPopconfirm>
        </ElSpace>
        <ElButton @click="getData">{{ $t('common.refresh') }}</ElButton>
      </div>
      <div class="min-h-0 flex-1">
        <ElTable
          v-loading="loading"
          height="100%"
          border
          :data="tableData"
          row-key="id"
          @selection-change="checkedRowKeys = $event.map((row: any) => row.id)"
        >
          <ElTableColumn v-for="col in columns" :key="col.prop" v-bind="col" />
        </ElTable>
      </div>
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

    <ConfigEditDialog v-model:visible="dialogVisible" :dialog-type="dialogType" :data="dialogData" @success="getData" />
  </ElDrawer>
</template>
