<script setup lang="tsx">
import { computed, ref, watch } from 'vue';
import { ElMessage, ElMessageBox, ElTag } from 'element-plus';
import { fetchCleanCrontabLog, fetchDeleteCrontabLog, fetchGetCrontabLogList } from '@/service/api';
import { defaultTransform, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';

defineOptions({ name: 'CrontabLogList' });

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
  set: value => emit('update:modelValue', value)
});

const checkedRowKeys = ref<string[]>([]);
const createTimeRange = ref<string[]>([]);

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  crontab_id: '',
  orderType: 'desc',
  create_time: undefined
});

const {
  columns,
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
  api: () => fetchGetCrontabLogList(searchParams.value),
  transform: response => defaultTransform(response),
  immediate: false,
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const },
    { prop: 'create_time', label: $t('page.tool.crontab.log.executeTime'), width: 180, sortable: true },
    { prop: 'target', label: $t('page.tool.crontab.log.target'), minWidth: 160, showOverflowTooltip: true },
    { prop: 'parameter', label: $t('page.tool.crontab.log.parameter'), minWidth: 120, showOverflowTooltip: true },
    {
      prop: 'status',
      label: $t('page.tool.crontab.log.executeStatus'),
      width: 100,
      formatter: (row: any) => {
        const isSuccess = row.status == 1;
        return (
          <ElTag type={isSuccess ? 'success' : 'danger'} size="small">
            {isSuccess ? $t('page.tool.crontab.log.success') : $t('page.tool.crontab.log.failure')}
          </ElTag>
        );
      }
    }
  ]
});

watch(
  () => props.modelValue,
  newVal => {
    if (newVal) initPage();
  }
);

function initPage() {
  if (!props.data?.id) {
    ElMessage.error($t('page.tool.crontab.log.selectTaskFirst'));
    return;
  }
  searchParams.value.crontab_id = props.data.id;
  createTimeRange.value = [];
  searchParams.value.create_time = undefined;
  checkedRowKeys.value = [];
  getDataByPage(1);
}

function handleSearch() {
  searchParams.value.create_time = createTimeRange.value?.length ? createTimeRange.value : undefined;
  getDataByPage(1);
}

function handleReset() {
  createTimeRange.value = [];
  searchParams.value.create_time = undefined;
  getDataByPage(1);
}

async function handleBatchDelete() {
  if (checkedRowKeys.value.length < 1) {
    ElMessage.info($t('page.tool.crontab.log.selectAtLeastOne'));
    return;
  }
  try {
    await ElMessageBox.confirm(
      $t('page.tool.crontab.log.confirmBatchDelete', { count: checkedRowKeys.value.length }),
      $t('page.tool.crontab.log.deleteTitle'),
      { confirmButtonText: $t('common.confirm'), cancelButtonText: $t('common.cancel'), type: 'warning' }
    );
    const ids = checkedRowKeys.value.map(Number);
    const { error } = await fetchDeleteCrontabLog({ ids });
    if (!error) {
      ElMessage.success($t('common.deleteSuccess'));
      checkedRowKeys.value = [];
      await getData();
    }
  } catch {}
}

async function handleClean() {
  try {
    await ElMessageBox.confirm('确认清空全部执行日志？', $t('common.tip'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    const { error } = await fetchCleanCrontabLog();
    if (!error) {
      ElMessage.success($t('common.deleteSuccess'));
      checkedRowKeys.value = [];
      await getData();
    }
  } catch {}
}

function handleClose() {
  visible.value = false;
  checkedRowKeys.value = [];
}
</script>

<template>
  <ElDrawer
    v-model="visible"
    :title="$t('page.tool.crontab.log.title')"
    size="70%"
    destroy-on-close
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden">
      <div class="flex items-center justify-between flex-wrap gap-12px">
        <ElDatePicker
          v-model="createTimeRange"
          type="datetimerange"
          :range-separator="$t('page.tool.crontab.log.rangeSeparator')"
          :start-placeholder="$t('page.tool.crontab.log.startTime')"
          :end-placeholder="$t('page.tool.crontab.log.endTime')"
          value-format="YYYY-MM-DD HH:mm:ss"
          clearable
        />
        <div class="flex gap-8px">
          <ElButton @click="handleReset">
            <template #icon>
              <SvgIcon icon="ri:reset-right-line" />
            </template>
            {{ $t('common.reset') }}
          </ElButton>
          <ElButton type="primary" @click="handleSearch">
            <template #icon>
              <SvgIcon icon="ri:search-line" />
            </template>
            {{ $t('common.search') }}
          </ElButton>
        </div>
      </div>

      <ElCard class="card-wrapper sm:flex-1-hidden">
        <template #header>
          <div class="flex items-center justify-between">
            <p>{{ $t('page.tool.crontab.log.listTitle') }}</p>
            <div class="flex gap-8px">
              <ElButton :disabled="checkedRowKeys.length === 0" @click="handleBatchDelete">
                <template #icon>
                  <SvgIcon icon="ri:delete-bin-5-line" />
                </template>
                {{ $t('common.delete') }}
              </ElButton>
              <ElButton @click="handleClean">清空日志</ElButton>
            </div>
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
  </ElDrawer>
</template>
