<script setup lang="tsx">
import { nextTick, ref } from 'vue';
import SvgIcon from '@/components/custom/svg-icon.vue';
import { fetchBatchDeleteMenu, fetchDeleteMenu, fetchGetMenuList } from '@/service/api';
import { $t } from '@/locales';
import MenuOperateModal, { type OperateType } from './modules/menu-operate-modal.vue';

defineOptions({ name: 'MenuManage' });

const loading = ref(false);
const data = ref<Api.SystemManage.Menu[]>([]);
const tableRef = ref();
const isExpanded = ref(false);
const selectedRows = ref<Api.SystemManage.Menu[]>([]);

async function getData() {
  loading.value = true;
  try {
    const { error, data: result } = await fetchGetMenuList();
    if (!error) {
      data.value = Array.isArray(result) ? result : [];
    }
  } finally {
    loading.value = false;
  }
}

const menuTypeBadge = (type: number | string) => {
  const t = Number(type);
  const map: Record<number, { label: string; color: UI.ThemeColor }> = {
    1: { label: '目录', color: 'info' },
    2: { label: '菜单', color: 'primary' },
    3: { label: '按钮', color: 'warning' },
    4: { label: '外链', color: 'success' }
  };
  return map[t] || { label: '未知', color: 'info' };
};

const columns = [
  {
    prop: 'selection',
    type: 'selection',
    width: 48,
    reserveSelection: true
  },
  { prop: 'name', 
    label: $t('page.manage.menu.menuName'), 
    minWidth: 100,
    align: 'left'    
  },
  {
    prop: 'type',
    label: $t('page.manage.menu.menuType'),
    width: 100,
    align: 'center',
    formatter: (row: any) => {
      const { label, color } = menuTypeBadge(row.type);
      return <ElTag type={color} size="small">{label}</ElTag>;
    }
  },
  {
    prop: 'icon',
    label: $t('page.manage.menu.icon'),
    width: 100,
    align: 'center',
    formatter: (row: any) => {
      const icon = String(row.icon || '').trim();
      if (!icon) return '-';
      return (
        <div class="w-full flex items-center justify-center">
          <SvgIcon icon={icon} class="text-lg" />
        </div>
      );
    }
  },
  { prop: 'code', label: $t('page.manage.menu.routeName'), minWidth: 100, align: 'left', },
  {
    prop: 'path',
    label: $t('page.manage.menu.routePath'),
    minWidth: 100,
    align: 'left',
    formatter: (row: any) => (Number(row.type) === 3 ? '' : row.path || '')
  },
  {
    prop: 'slug',
    label: '权限标识',
    minWidth: 100,
    formatter: (row: any) => {
      if (Number(row.type) === 2) {
        const count = row.children?.length ?? 0;
        return count ? `${count} 个权限标识` : '';
      }
      return row.slug || '';
    }
  },
  { prop: 'sort', label: $t('page.manage.menu.order'), width: 70, align: 'center' },
  {
    prop: 'status',
    label: $t('page.manage.menu.menuStatus'),
    width: 100,
    align: 'center',
    formatter: (row: any) => {
      const normal = Number(row.status) === 1;
      return (
        <ElTag class={normal ? 'menu-status-tag menu-status-normal' : 'menu-status-tag menu-status-stop'} size="small">
          {normal ? '正常' : '停用'}
        </ElTag>
      );
    }
  },
  {
    prop: 'operate',
    label: $t('common.operate'),
    width: 150,
    align: 'center',
    fixed: 'right',
    formatter: (row: any) => (
      <div class="w-full flex items-center justify-center gap-2">
        {Number(row.type) < 3 && (
          <ElButton type="primary" text bg class="op-btn op-add" onClick={() => handleAddChild(row)}>
            <icon-ic-round-plus class="text-icon" />
          </ElButton>
        )}
        <ElButton type="primary" text bg class="op-btn op-edit" onClick={() => handleEdit(row)}>
          <icon-ic-round-edit class="text-icon" />
        </ElButton>
        <ElPopconfirm title={$t('common.confirmDelete')} onConfirm={() => handleDelete(Number(row.id))}>
          {{
            reference: () => (
              <ElButton type="danger" text bg class="op-btn op-delete">
                <icon-ic-round-delete class="text-icon" />
              </ElButton>
            )
          }}
        </ElPopconfirm>
      </div>
    )
  }
];

async function handleDelete(id: number) {
  const { error } = await fetchDeleteMenu(id);
  if (!error) {
    window.$message?.success($t('common.deleteSuccess'));
    await getData();
  }
}

async function handleBatchDelete() {
  const ids = selectedRows.value.map(row => Number(row.id)).filter(Boolean);
  if (!ids.length) return;
  const { error } = await fetchBatchDeleteMenu(ids);
  if (!error) {
    window.$message?.success($t('common.deleteSuccess'));
    selectedRows.value = [];
    await getData();
  }
}

const visible = ref(false);
const operateType = ref<OperateType>('add');
const editingData = ref<Api.SystemManage.Menu | null>(null);

function handleAdd() {
  operateType.value = 'add';
  editingData.value = null;
  visible.value = true;
}

function handleEdit(row: Api.SystemManage.Menu) {
  operateType.value = 'edit';
  editingData.value = { ...row };
  visible.value = true;
}

function handleAddChild(row: Api.SystemManage.Menu) {
  operateType.value = 'addChild';
  editingData.value = { ...row };
  visible.value = true;
}

function toggleExpand() {
  isExpanded.value = !isExpanded.value;
  nextTick(() => {
    if (tableRef.value && data.value) {
      const processRows = (rows: any[]) => {
        rows.forEach(row => {
          if (row.children?.length) {
            tableRef.value.toggleRowExpansion(row, isExpanded.value);
            processRows(row.children);
          }
        });
      };
      processRows(data.value);
    }
  });
}

getData();
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('page.manage.menu.title') }}</p>
          <div class="flex items-center gap-8px">
            <ElButton type="primary" class="head-action-btn" @click="handleAdd">
              <template #icon>
                <icon-ic-round-plus class="text-icon" />
              </template>
              {{ $t('common.add') }}
            </ElButton>
            <ElPopconfirm :title="$t('common.confirmDelete')" @confirm="handleBatchDelete">
              <template #reference>
                <ElButton type="danger" plain class="head-action-btn" :disabled="selectedRows.length === 0">
                  <template #icon>
                    <icon-ic-round-delete class="text-icon" />
                  </template>
                  {{ $t('common.batchDelete') }}
                </ElButton>
              </template>
            </ElPopconfirm>
            <ElButton class="head-action-btn" @click="toggleExpand">
              <template #icon>
                <icon-mdi-arrow-expand-vertical />
              </template>
              {{ isExpanded ? '收起' : '展开' }}
            </ElButton>
            <ElButton class="head-action-btn" :loading="loading" @click="getData">
              <template #icon>
                <icon-ic-round-refresh />
              </template>
              刷新
            </ElButton>
          </div>
        </div>
      </template>

      <ElTable
        ref="tableRef"
        v-loading="loading"
        :data="data"
        border
        row-key="id"
        :default-expand-all="false"
        class="w-full"
        @selection-change="selectedRows = $event"
      >
        <ElTableColumn v-for="col in columns" :key="col.prop" v-bind="col" />
      </ElTable>
    </ElCard>

    <MenuOperateModal
      v-model:visible="visible"
      :operate-type="operateType"
      :row-data="editingData"
      @submitted="getData"
    />
  </div>
</template>

<style lang="scss" scoped>
:deep(.el-table .cell) {
  padding: 4px 8px;
}

:deep(.op-btn) {
  width: 34px;
  height: 34px;
  padding: 0;
  border-radius: 8px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

:deep(.op-add),
:deep(.op-edit) {
  color: var(--el-color-primary);
  background-color: var(--el-color-primary-light-9);
}

:deep(.op-delete) {
  color: var(--el-color-danger);
  background-color: var(--el-color-danger-light-9);
}

:deep(.head-action-btn) {
  border-radius: 8px;
}

:deep(.menu-status-tag) {
  border-radius: 4px;
  font-weight: 500;
}

:deep(.menu-status-normal) {
  color: #2bbd3a;
  border-color: #b8ebbf;
  background-color: #f0fff2;
}

:deep(.menu-status-stop) {
  color: #f59e0b;
  border-color: #fde68a;
  background-color: #fff9eb;
}
</style>
