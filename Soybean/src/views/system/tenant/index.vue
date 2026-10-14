<script setup lang="tsx">
import { ref } from 'vue';
import { ElButton, ElPopconfirm, ElTag } from 'element-plus';
import IconEdit from '~icons/ic/round-edit';
import IconDelete from '~icons/ic/round-delete';
import { enableStatusRecord } from '@/constants/business';
import { fetchDeleteTenant, fetchGetTenantList } from '@/service/api';
import { defaultTransform, useTableOperate, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import TenantSearch from './modules/tenant-search.vue';
import TenantOperateDialog from './modules/tenant-operate-dialog.vue';
import TenantUsersDialog from './modules/tenant-users-dialog.vue';

defineOptions({ name: 'TenantManage' });

const searchParams = ref(getInitSearchParams());

function getInitSearchParams(): Api.Tenant.TenantSearchParams {
  return {
    page: 1,
    limit: 20,
    tenant_name: undefined,
    tenant_code: undefined,
    status: undefined
  };
}

const { columns, columnChecks, data, loading, getData, getDataByPage, mobilePagination, handleCurrentPageChange, handlePageSizeChange } = useUIPaginatedTable({
  paginationProps: {
    currentPage: searchParams.value.page,
    pageSize: searchParams.value.limit
  },
  api: () => fetchGetTenantList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { prop: 'id', label: $t('page.manage.tenant.id'), width: 80, align: 'center' },
    { prop: 'tenant_name', label: $t('page.manage.tenant.tenantName'), minWidth: 150 },
    { prop: 'tenant_code', label: $t('page.manage.tenant.tenantCode'), minWidth: 130 },
    { prop: 'contact_name', label: $t('page.manage.tenant.contactName'), minWidth: 110 },
    { prop: 'contact_phone', label: $t('page.manage.tenant.contactPhone'), minWidth: 130 },
    {
      prop: 'max_users',
      label: $t('page.manage.tenant.maxUsers'),
      width: 110,
      align: 'center'
    },
    {
      prop: 'user_count',
      label: $t('page.manage.tenant.userCount'),
      width: 110,
      align: 'center'
    },
    {
      prop: 'expire_time',
      label: $t('page.manage.tenant.expireTime'),
      minWidth: 170
    },
    {
      prop: 'status',
      label: $t('page.manage.tenant.tenantStatus'),
      width: 100,
      formatter: (row: Api.Tenant.Tenant) => {
        if (row.status === undefined) return '';
        const s = String(row.status);
        const tagMap: Record<string, UI.ThemeColor> = { '1': 'success', '0': 'warning' };
        const label =
          s in enableStatusRecord
            ? enableStatusRecord[s as Api.Common.EnableStatus]
            : s === '1'
              ? 'page.manage.common.status.enable'
              : 'page.manage.common.status.disable';
        return (
          <ElTag type={tagMap[s] || 'info'} size="small">
            {$t(label)}
          </ElTag>
        );
      }
    },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 260,
      fixed: 'right',
      formatter: (row: Api.Tenant.Tenant) => (
        <div class="flex-center gap-1">
          <ElButton type="primary" plain size="small" onClick={() => handleEdit(row.id)}>
            <IconEdit class="mr-1" />
            {$t('common.edit')}
          </ElButton>
          <ElButton type="info" plain size="small" onClick={() => openTenantUsers(row)}>
            {$t('page.manage.tenant.viewUsers')}
          </ElButton>
          <ElPopconfirm title={$t('common.confirmDelete')} onConfirm={() => handleDelete(row.id)}>
            {{
              reference: () => (
                <ElButton type="danger" plain size="small">
                  <IconDelete class="mr-1" />
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

const { drawerVisible, operateType, editingData, handleAdd, handleEdit, onDeleted } = useTableOperate(data, 'id', getData);

async function handleDelete(id: number) {
  const { error } = await fetchDeleteTenant(id);
  if (!error) onDeleted();
}

function resetSearchParams() {
  searchParams.value = getInitSearchParams();
}

function handleReset() {
  resetSearchParams();
  void getDataByPage(1);
}

function handleSearch() {
  void getDataByPage(1);
}

const tenantUsersVisible = ref(false);
const currentTenantId = ref(0);
const currentTenantName = ref('');

function openTenantUsers(row: Api.Tenant.Tenant) {
  currentTenantId.value = Number(row.id);
  currentTenantName.value = row.tenant_name || '';
  tenantUsersVisible.value = true;
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <TenantSearch v-model:model="searchParams" @reset="handleReset" @search="handleSearch" />

    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('page.manage.tenant.title') }}</p>
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
        <ElTable v-loading="loading" height="100%" border class="sm:h-full" :data="data" row-key="id">
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

      <TenantOperateDialog
        v-model:visible="drawerVisible"
        :operate-type="operateType"
        :row-data="editingData"
        @submitted="getDataByPage"
      />
    </ElCard>

    <TenantUsersDialog
      v-model="tenantUsersVisible"
      :tenant-id="currentTenantId"
      :tenant-name="currentTenantName"
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
