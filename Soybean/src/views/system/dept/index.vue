<script setup lang="tsx">
import { computed, ref } from 'vue';
import { ElButton, ElMessage, ElPopconfirm, ElSwitch } from 'element-plus';
import {
  fetchDeleteDept,
  fetchGetDeptList,
  fetchUpdateDeptStatus
} from '@/service/api';
import { useTableOperate, useUITable } from '@/hooks/common/table';
import { useAuthStore } from '@/store/modules/auth';
import { $t } from '@/locales';
import DeptOperateDrawer from './modules/dept-operate-drawer.vue';
import DeptSearch from './modules/dept-search.vue';

defineOptions({ name: 'DeptManage' });

const authStore = useAuthStore();
const searchParams = ref<Api.Dept.DeptSearchParams>({
  name: undefined,
  code: undefined,
  status: undefined
});

const { columns, columnChecks, data, getData, loading } = useUITable({
  api: () => fetchGetDeptList(searchParams.value),
  transform: response => response.data ?? [],
  columns: () => [
    { prop: 'index', type: 'index', label: $t('common.index'), width: 64 },
    { prop: 'name', label: $t('page.manage.dept.deptName'), minWidth: 140, align:'left' },
    { prop: 'code', label: $t('page.manage.dept.deptCode'), minWidth: 140 },
    {
      prop: 'parent_name',
      label: $t('page.manage.dept.parentDept'),
      minWidth: 150,
      formatter: (row: Api.Dept.Dept) => {
        const parentId = Number(row.parent_id || 0);
        if (!parentId) return '-';
        return row.parent_name || deptNameMap.value.get(parentId) || '-';
      }
    },
    {
      prop: 'leader_name',
      label: $t('page.manage.dept.leader'),
      minWidth: 140,
      formatter: (row: Api.Dept.Dept) => row.leader_name || (row as any)?.leader?.realname || (row as any)?.leader?.username || '-'
    },
    {
      prop: 'status',
      label: $t('page.manage.dept.deptStatus'),
      width: 120,
      formatter: (row: Api.Dept.Dept) => {
        if (row.status === undefined) return '';
        return (
          <ElSwitch
            modelValue={normalizeDeptStatus(row.status)}
            activeValue={1}
            inactiveValue={0}
            inlinePrompt
            activeText="启"
            inactiveText="停"
            onChange={(value: string | number | boolean) => handleStatusChange(row, Number(value))}
          />
        );
      }
    },
    { prop: 'sort', label: $t('page.manage.dept.sort'), width: 90 },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 220,
      formatter: (row: Api.Dept.Dept) => {
        const { buttons } = authStore.userInfo;
        const hasEdit = buttons.includes('*') || buttons.includes('core:dept:update');
        const hasDelete = buttons.includes('*') || buttons.includes('core:dept:delete');

        if (!hasEdit && !hasDelete) return <span />;

        return (
          <div class="flex-center">
            {hasEdit && (
              <ElButton type="primary" plain size="small" onClick={() => edit(row)}>
                {$t('common.edit')}
              </ElButton>
            )}
            {hasDelete && (
              <ElPopconfirm title={$t('common.confirmDelete')} onConfirm={() => handleDelete(row.id)}>
                {{
                  reference: () => (
                    <ElButton type="danger" plain size="small">
                      {$t('common.delete')}
                    </ElButton>
                  )
                }}
              </ElPopconfirm>
            )}
          </div>
        );
      }
    }
  ]
});

const deptNameMap = computed(() => {
  const map = new Map<number, string>();
  const walk = (rows: Api.Dept.Dept[]) => {
    rows.forEach(row => {
      map.set(Number(row.id), row.name);
      if (row.children?.length) {
        walk(row.children);
      }
    });
  };
  walk(data.value as Api.Dept.Dept[]);
  return map;
});

const { drawerVisible, operateType, editingData, handleAdd, openDrawer } = useTableOperate(data, 'id', getData);

async function handleDelete(id: number) {
  const { error } = await fetchDeleteDept(id);
  if (!error) {
    window.$message?.success($t('common.deleteSuccess'));
    await getData();
  }
}

function normalizeDeptStatus(status: unknown): number {
  const value = Number(status);
  if (value === 2) return 0;
  return value === 0 ? 0 : 1;
}

async function handleStatusChange(row: Api.Dept.Dept, status: number) {
  const previous = normalizeDeptStatus(row.status);
  row.status = status as any;
  const { error } = await fetchUpdateDeptStatus(row.id, status);
  if (error) {
    row.status = previous as any;
    ElMessage.error('状态更新失败');
    return;
  }
  ElMessage.success('状态更新成功');
}

function resetSearchParams() {
  searchParams.value = {
    name: undefined,
    code: undefined,
    status: undefined
  };
}

function edit(row: Api.Dept.Dept) {
  operateType.value = 'edit';
  editingData.value = { ...row };
  openDrawer();
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <DeptSearch v-model:model="searchParams" @reset="resetSearchParams" @search="getData" />
    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('page.manage.dept.title') }}</p>
          <TableHeaderOperation
            v-model:columns="columnChecks"
            :loading="loading"
            :show-delete="false"
            add-auth="core:dept:save"
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
          default-expand-all
        >
          <ElTableColumn v-for="col in columns" :key="col.prop" v-bind="col" />
        </ElTable>
      </div>
      <DeptOperateDrawer
        v-model:visible="drawerVisible"
        :operate-type="operateType"
        :row-data="editingData"
        @submitted="getData"
      />
    </ElCard>
  </div>
</template>
