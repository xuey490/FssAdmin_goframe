<script setup lang="tsx">
import { onMounted, ref } from 'vue';
import { ElAvatar, ElMessageBox } from 'element-plus';
import IconMore from '~icons/ic/round-more-horiz';
import IconHome from '~icons/ic/round-home';
import IconKey from '~icons/ic/round-vpn-key';
import IconClear from '~icons/ic/round-delete-sweep';
import IconMenu from '~icons/ic/round-menu';
import IconEdit from '~icons/ic/round-edit';
import IconDelete from '~icons/ic/round-delete';
import { enableStatusRecord } from '@/constants/business';
import {
  fetchChangeUserPassword,
  fetchClearUserCache,
  fetchDeleteUser,
  fetchGetAccessDeptTree,
  fetchGetUserList
} from '@/service/api';
import { defaultTransform, useUIPaginatedTable } from '@/hooks/common/table';
import { useAuthStore } from '@/store/modules/auth';
import { useDictStore } from '@/store/modules/dict';
import { $t } from '@/locales';
import TableSearch from './modules/table-search.vue';
import EditDialog from './modules/edit-dialog.vue';
import WorkDialog from './modules/work-dialog.vue';
import AssignMenuDialog from './modules/assign-menu-dialog.vue';

defineOptions({ name: 'UserManage' });

const authStore = useAuthStore();
const dictStore = useDictStore();

const searchParams = ref(getInitSearchParams());
const selectedDeptId = ref<number | undefined>(undefined);
const deptTree = ref<Api.SystemManage.MenuTree[]>([]);

const dialogVisible = ref(false);
const dialogType = ref<'add' | 'edit'>('add');
const dialogData = ref<Api.SystemManage.User | null>(null);

const workDialogVisible = ref(false);
const workDialogData = ref<Api.SystemManage.User | null>(null);

const assignMenuDialogVisible = ref(false);
const assignMenuDialogData = ref<Api.SystemManage.User | null>(null);

function getInitSearchParams(): Api.SystemManage.UserSearchParams {
  return {
    page: 1,
    limit: 30,
    status: undefined,
    username: undefined,
    gender: undefined,
    realname: undefined,
    phone: undefined,
    email: undefined,
    dept_id: undefined
  };
}

function avatarHue(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  return Math.abs(hash) % 360;
}

function avatarBg(name: string, id?: number | string): string {
  const key = `${name}_${id ?? ''}`;
  return `background-color: hsl(${avatarHue(key)}, 55%, 60%); color:#fff; font-weight:600;`;
}

function getDictLabel(code: string, value: unknown) {
  if (value === undefined || value === null || value === '') return '-';
  return dictStore.getDataByValue(code, String(value))?.label || String(value);
}

function canOperateRow(row: Api.SystemManage.User) {
  const rowId = Number(row.id);
  const currentUserId = Number(authStore.userInfo.userId);
  return rowId !== 1 && rowId !== currentUserId;
}

const { columns, columnChecks, data, getData, getDataByPage, loading, mobilePagination, handleCurrentPageChange, handlePageSizeChange } = useUIPaginatedTable({
  paginationProps: {
    currentPage: searchParams.value.page,
    pageSize: searchParams.value.limit
  },
  api: () => fetchGetUserList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { prop: 'index', type: 'index', label: $t('common.index'), width: 64 },
    {
      prop: 'username',
      label: $t('page.manage.user.userName'),
      minWidth: 180,
      align: 'left',
      formatter: (row: Api.SystemManage.User) => {
        const name = row.realname || row.username || '?';
        const firstChar = name.charAt(0).toUpperCase();
        //console.log(row.avatar);
        return (
          <div class="w-full flex items-center justify-start gap-2 pl-[10px]">
            {row.avatar ? (
              <ElAvatar size={36} src={row.avatar} shape="circle" />
            ) : (
              <ElAvatar size={36} shape="circle" style={avatarBg(name, row.id)}>
                {firstChar}
              </ElAvatar>
            )}
            <div class="min-w-0 text-left">
              <p class="text-sm font-medium leading-tight truncate">{row.username}</p>
              {row.email && (
                <p class="text-xs text-gray-400 leading-tight truncate mt-0.5">{row.email}</p>
              )}
            </div>
          </div>
        );
      }
    },
    { prop: 'realname', label: $t('page.manage.user.nickName'), minWidth: 100 },
    { prop: 'phone', label: $t('page.manage.user.userPhone'), width: 130 },
    {
      prop: 'dept',
      label: $t('page.manage.dept.deptName'),
      minWidth: 140,
      formatter: (row: Api.SystemManage.User) => (row as any)?.dept?.name || '-'
    },
    {
      prop: 'status',
      label: $t('page.manage.user.userStatus'),
      width: 90,
      formatter: (row: Api.SystemManage.User) => {
        if (row.status === undefined) return '';
        const status = String(row.status ?? '1') as Api.Common.EnableStatus;
        const tagMap: Record<Api.Common.EnableStatus, UI.ThemeColor> = { '1': 'success', '0': 'warning' };
        return <ElTag type={tagMap[status]} size="small">{$t(enableStatusRecord[status])}</ElTag>;
      }
    },
    {
      prop: 'dashboard',
      label: $t('page.manage.user.homePage'),
      width: 100,
      formatter: (row: Api.SystemManage.User) => getDictLabel('dashboard', (row as any).dashboard)
    },
    {
      prop: 'login_time',
      label: $t('page.manage.user.lastLogin'),
      width: 170,
      formatter: (row: Api.SystemManage.User) => (row as any).login_time || '-'
    },
    {
      prop: 'operate',
      label: $t('common.operate'),
      align: 'center',
      width: 240,
      fixed: 'right',
      formatter: (row: Api.SystemManage.User) => {
        if (!canOperateRow(row)) return <span />;

        const { buttons } = authStore.userInfo;
        const hasEdit = buttons.includes('*') || buttons.includes('core:user:update');
        const hasDelete = buttons.includes('*') || buttons.includes('core:user:delete');
        const hasHome = buttons.includes('*') || buttons.includes('core:user:home');
        const hasPassword = buttons.includes('*') || buttons.includes('core:user:password');
        const hasCache = buttons.includes('*') || buttons.includes('core:user:cache');
        const hasMenu = buttons.includes('*') || buttons.includes('core:user:menu');

        return (
          <div class="flex-center gap-1">
            {hasEdit && (
              <ElButton type="primary" plain size="small" onClick={() => showDialog('edit', row)}>
                <IconEdit class="mr-1" />
                {$t('common.edit')}
              </ElButton>
            )}
            {hasDelete && (
              <ElPopconfirm title={$t('common.confirmDelete')} onConfirm={() => handleDelete(row)}>
                {{
                  reference: () => (
                    <ElButton type="danger" plain size="small">
                      <IconDelete class="mr-1" />
                      {$t('common.delete')}
                    </ElButton>
                  )
                }}
              </ElPopconfirm>
            )}
            {(hasHome || hasPassword || hasCache || hasMenu) && (
              <ElDropdown trigger="click">
                {{
                  default: () => (
                    <ElButton plain size="small" class="px-1.5">
                      <IconMore class="text-base" />
                    </ElButton>
                  ),
                  dropdown: () => (
                    <ElDropdownMenu>
                      {hasHome && (
                        <ElDropdownItem onClick={() => showWorkDialog(row)}>
                          <span class="flex items-center gap-2">
                            <IconHome class="text-primary" />
                            {$t('page.manage.user.setHomePage')}
                          </span>
                        </ElDropdownItem>
                      )}
                      {hasPassword && (
                        <ElDropdownItem onClick={() => handlePassword(row)}>
                          <span class="flex items-center gap-2">
                            <IconKey class="text-warning" />
                            {$t('page.manage.user.changePassword')}
                          </span>
                        </ElDropdownItem>
                      )}
                      {hasCache && (
                        <ElDropdownItem onClick={() => handleCache(row)}>
                          <span class="flex items-center gap-2">
                            <IconClear class="text-danger" />
                            {$t('page.manage.user.clearCache')}
                          </span>
                        </ElDropdownItem>
                      )}
                      {hasMenu && (
                        <ElDropdownItem onClick={() => showAssignMenuDialog(row)}>
                          <span class="flex items-center gap-2">
                            <IconMenu class="text-success" />
                            {$t('page.manage.user.assignMenu')}
                          </span>
                        </ElDropdownItem>
                      )}
                    </ElDropdownMenu>
                  )
                }}
              </ElDropdown>
            )}
          </div>
        );
      }
    }
  ]
});

function showDialog(type: 'add' | 'edit', row?: Api.SystemManage.User) {
  dialogType.value = type;
  dialogData.value = row || null;
  dialogVisible.value = true;
}

function showWorkDialog(row: Api.SystemManage.User) {
  workDialogData.value = row;
  workDialogVisible.value = true;
}

function showAssignMenuDialog(row: Api.SystemManage.User) {
  assignMenuDialogData.value = row;
  assignMenuDialogVisible.value = true;
}

async function handleDelete(row: Api.SystemManage.User) {
  if (Number(row.id) === 1) {
    window.$message?.warning($t('page.manage.user.sysUserNoDelete'));
    return;
  }
  const { error } = await fetchDeleteUser(Number(row.id));
  if (!error) {
    window.$message?.success($t('common.deleteSuccess'));
    await getData();
  }
}

async function handlePassword(row: Api.SystemManage.User) {
  try {
    const { value } = await ElMessageBox.prompt($t('page.manage.user.promptNewPassword'), $t('page.manage.user.changePassword'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      inputType: 'password',
      inputPattern: /^.{6,20}$/,
      inputErrorMessage: $t('page.manage.user.passwordLengthError')
    });
    const { error } = await fetchChangeUserPassword(Number(row.id), value);
    if (!error) window.$message?.success($t('page.manage.user.passwordChanged'));
  } catch {
    // cancelled
  }
}

async function handleCache(row: Api.SystemManage.User) {
  try {
    await ElMessageBox.confirm($t('page.manage.user.confirmClearCache', { username: row.username }), $t('common.tip'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    const { error } = await fetchClearUserCache(Number(row.id));
    if (!error) window.$message?.success($t('page.manage.user.cacheCleared'));
  } catch {
    // cancelled
  }
}

function resetSearchParams() {
  searchParams.value = getInitSearchParams();
  selectedDeptId.value = undefined;
}

async function loadDeptTree() {
  const { data: d, error } = await fetchGetAccessDeptTree();
  if (!error) deptTree.value = d;
}

function handleDeptNodeClick(node: Api.SystemManage.MenuTree) {
  selectedDeptId.value = Number(node.id);
  searchParams.value.page = 1;
  searchParams.value.dept_id = Number(node.id);
  void getDataByPage(1);
}

onMounted(() => {
  void loadDeptTree();
  void dictStore.ensureLoaded();
});
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <div class="min-h-500px flex gap-16px overflow-hidden lt-sm:flex-col lt-sm:overflow-auto">
      <ElCard class="w-260px flex-shrink-0 lt-sm:w-full" shadow="never">
        <template #header>
          <div class="flex items-center justify-between">
            <span class="font-medium">{{ $t('page.manage.dept.title') }}</span>
            <ElButton
              v-if="selectedDeptId"
              size="small"
              text
              type="primary"
              @click="
                selectedDeptId = undefined;
                searchParams.dept_id = undefined;
                getDataByPage(1);
              "
            >
              {{ $t('common.reset') }}
            </ElButton>
          </div>
        </template>
        <ElTree
          node-key="id"
          :data="deptTree"
          :props="{ label: 'label', children: 'children' }"
          highlight-current
          default-expand-all
          @node-click="handleDeptNodeClick"
        />
      </ElCard>

      <div class="min-w-0 flex-1 flex-col-stretch gap-16px">
        <TableSearch v-model:model="searchParams" @reset="resetSearchParams" @search="getDataByPage" />

        <ElCard class="card-wrapper sm:flex-1-hidden">
          <template #header>
            <div class="flex items-center justify-between">
              <p>{{ $t('page.manage.user.title') }}</p>
              <TableHeaderOperation
                v-model:columns="columnChecks"
                :loading="loading"
                :show-delete="false"
                add-auth="core:user:save"
                @add="showDialog('add')"
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
    </div>

    <EditDialog
      v-model="dialogVisible"
      :dialog-type="dialogType"
      :data="dialogData"
      @success="getDataByPage"
    />

    <WorkDialog v-model="workDialogVisible" :data="workDialogData" @success="getDataByPage" />

    <AssignMenuDialog
      v-model="assignMenuDialogVisible"
      :data="assignMenuDialogData"
      @success="getDataByPage"
    />
  </div>
</template>

<style lang="scss" scoped>
:deep(.el-table td) {
  padding: 6px 0;
}
</style>
