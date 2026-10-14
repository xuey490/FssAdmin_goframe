<script setup lang="tsx">
import { computed, ref } from 'vue';
import { enableStatusRecord } from '@/constants/business';
import { fetchDeleteRole, fetchGetRoleList } from '@/service/api';
import { defaultTransform, useTableOperate, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import RoleOperateDrawer from './modules/role-operate-drawer.vue';
import RoleSearch from './modules/role-search.vue';
import MenuAuthModal from './modules/menu-auth-modal.vue';

const searchParams = ref(getInitSearchParams());

function getInitSearchParams(): Api.SystemManage.RoleSearchParams {
  return {
    page: 1,
    limit: 10,
    status: undefined,
    name: undefined,
    code: undefined
  };
}

const { columns, columnChecks, data, loading, getData, getDataByPage, mobilePagination, handleCurrentPageChange, handlePageSizeChange } = useUIPaginatedTable({
  paginationProps: {
    currentPage: searchParams.value.page,
    pageSize: searchParams.value.limit
  },
  api: () => fetchGetRoleList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { prop: 'index', type: 'index', label: $t('common.index'), width: 64 },
    { prop: 'name', label: $t('page.manage.role.roleName'), minWidth: 120 },
    { prop: 'code', label: $t('page.manage.role.roleCode'), minWidth: 120 },
    {
      prop: 'data_scope',
      label: $t('page.manage.role.dataScope'),
      minWidth: 160,
      formatter: row => {
        const map: Record<number, string> = {
          1: $t('page.manage.role.dataScopeOptions.all'),
          2: $t('page.manage.role.dataScopeOptions.dept'),
          3: $t('page.manage.role.dataScopeOptions.deptAndChild'),
          4: $t('page.manage.role.dataScopeOptions.self'),
          5: $t('page.manage.role.dataScopeOptions.deptAndSelf'),
          6: $t('page.manage.role.dataScopeOptions.custom')
        };
        return map[Number(row.data_scope) || 1] || '-';
      }
    },
    { prop: 'remark', label: $t('page.manage.role.roleDesc'), minWidth: 120 },
    {
      prop: 'status',
      label: $t('page.manage.role.roleStatus'),
      width: 100,
      formatter: row => {
        if (row.status === undefined) {
          return '';
        }

        const status = String((row as any).status ?? '1') as Api.Common.EnableStatus;
        const tagMap: Record<Api.Common.EnableStatus, UI.ThemeColor> = {
          '1': 'success',
          '0': 'warning'
        };

        const label = $t(enableStatusRecord[status]);

        return <ElTag type={tagMap[status]}>{label}</ElTag>;
      }
    },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 250,
      formatter: row => (
        <div class="flex-center">
          <ElButton type="primary" plain size="small" disabled={row.id === 1} onClick={() => edit(row.id)}>
            {$t('common.edit')}
          </ElButton>
          <ElButton type="info" plain size="small" disabled={row.id === 1} onClick={() => openMenuAuth(row)}>
            {$t('page.manage.role.menuAuth')}
          </ElButton>
          {row.id === 1 ? (
            <ElButton type="danger" plain size="small" disabled>
              {$t('common.delete')}
            </ElButton>
          ) : (
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
      )
    }
  ]
});

const {
  drawerVisible,
  operateType,
  editingData,
  handleAdd,
  handleEdit,
  onDeleted
  // closeDrawer
} = useTableOperate(data, 'id', getData);

async function handleDelete(id: number) {
  if (id === 1) {
    window.$message?.warning('系统内置角色不可删除');
    return;
  }
  const { error } = await fetchDeleteRole(id);
  if (!error) {
    onDeleted();
  }
}

function resetSearchParams() {
  searchParams.value = getInitSearchParams();
}

function edit(id: number) {
  if (id === 1) {
    window.$message?.warning('系统内置角色不可编辑');
    return;
  }
  handleEdit(id);
}

const menuAuthVisible = ref(false);
const menuAuthRoleId = ref(0);
const menuAuthRoleName = ref('');

function openMenuAuth(row: Api.SystemManage.Role) {
  if (Number(row.id) === 1) {
    window.$message?.warning('系统内置角色不可编辑');
    return;
  }
  menuAuthRoleId.value = Number(row.id);
  menuAuthRoleName.value = row.name || '';
  menuAuthVisible.value = true;
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <RoleSearch v-model:model="searchParams" @reset="resetSearchParams" @search="getDataByPage" />
    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('page.manage.role.title') }}</p>
          <TableHeaderOperation
            v-model:columns="columnChecks"
            :loading="loading"
            :show-delete="false"
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
        >
          <ElTableColumn v-for="col in columns" :key="col.prop" v-bind="col" />
        </ElTable>
        <div class="mt-20px flex justify-end">
          <ElPagination
            v-if="mobilePagination.total"
            layout="total,prev,pager,next,sizes"
            v-bind="mobilePagination"
            @current-change="handleCurrentPageChange"
            @size-change="handlePageSizeChange"
          />
        </div>
      </div>
      <RoleOperateDrawer
        v-model:visible="drawerVisible"
        :operate-type="operateType"
        :row-data="editingData"
        @submitted="getDataByPage"
      />
    </ElCard>

    <MenuAuthModal
      v-model:visible="menuAuthVisible"
      :role-id="menuAuthRoleId"
      :role-name="menuAuthRoleName"
    />
  </div>
</template>

<style lang="scss" scoped>
:deep(.el-card) {
  .ht50 {
    height: calc(100% - 50px);
  }
}
</style>
