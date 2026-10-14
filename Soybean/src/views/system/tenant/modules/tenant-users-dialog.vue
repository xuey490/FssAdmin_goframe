<script setup lang="ts">
import { reactive, ref, watch } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import {
  fetchAddUsersToTenant,
  fetchGetTenantAvailableUsers,
  fetchGetTenantUsers,
  fetchRemoveUserFromTenant,
  fetchSetDefaultTenant,
  fetchSetTenantAdmin
} from '@/service/api';

defineOptions({ name: 'TenantUsersDialog' });

interface Props {
  tenantId: number;
  tenantName: string;
}

const props = withDefaults(defineProps<Props>(), {
  tenantId: 0,
  tenantName: ''
});

interface Emits {
  (e: 'update:modelValue', value: boolean): void;
}

const emit = defineEmits<Emits>();

const visible = defineModel<boolean>('modelValue', { default: false });

// ── Tabs ──
const activeTab = ref<'bound' | 'available'>('bound');

// ── 已关联用户 ──
const boundLoading = ref(false);
const boundRows = ref<Record<string, any>[]>([]);
const boundPagination = reactive({ page: 1, limit: 10, total: 0 });
const boundSearch = reactive({ username: '', realname: '', phone: '' });

// ── 可添加用户 ──
const availableLoading = ref(false);
const availableRows = ref<Record<string, any>[]>([]);
const availablePagination = reactive({ page: 1, limit: 10, total: 0 });
const availableSearch = reactive({ username: '', realname: '', phone: '' });
const selectedAvailableRows = ref<Record<string, any>[]>([]);

watch(
  visible,
  val => {
    if (!val) {
      activeTab.value = 'bound';
      selectedAvailableRows.value = [];
    }
  }
);

watch(activeTab, tab => {
  if (!visible.value) return;
  if (tab === 'bound') loadBoundUsers();
  else loadAvailableUsers();
});

/** 解析分页数据 */
function parsePageRows(res: unknown): Record<string, any>[] {
  const page = (res || {}) as Record<string, any>;
  if (Array.isArray(page.list)) return page.list;
  if (Array.isArray(page.data)) return page.data;
  return [];
}

// ── 加载已关联用户 ──
async function loadBoundUsers() {
  if (!props.tenantId) return;
  boundLoading.value = true;
  try {
    const res = await fetchGetTenantUsers(props.tenantId, {
      page: boundPagination.page,
      limit: boundPagination.limit,
      ...boundSearch
    });
    const payload = (res as any).data ?? res;
    boundRows.value = parsePageRows(payload);
    boundPagination.total = Number(payload?.total || 0);
  } finally {
    boundLoading.value = false;
  }
}

// ── 加载可添加用户 ──
async function loadAvailableUsers() {
  if (!props.tenantId) return;
  availableLoading.value = true;
  try {
    const res = await fetchGetTenantAvailableUsers(props.tenantId, {
      page: availablePagination.page,
      limit: availablePagination.limit,
      ...availableSearch
    });
    const payload = (res as any).data ?? res;
    availableRows.value = parsePageRows(payload);
    availablePagination.total = Number(payload?.total || 0);
  } finally {
    availableLoading.value = false;
  }
}

// ── 搜索 ──
function searchBound() {
  boundPagination.page = 1;
  loadBoundUsers();
}

function searchAvailable() {
  availablePagination.page = 1;
  loadAvailableUsers();
}

// ── 选择变化 ──
function handleAvailableSelectionChange(rows: Record<string, any>[]) {
  selectedAvailableRows.value = rows;
}

// ── 批量添加用户到租户 ──
async function handleAddUsers() {
  if (selectedAvailableRows.value.length === 0) {
    ElMessage.warning('请先选择要添加的用户');
    return;
  }
  const userIds = selectedAvailableRows.value.map(item => Number(item.id));
  const { error } = await fetchAddUsersToTenant(props.tenantId, userIds);
  if (error) return;

  ElMessage.success('添加成功');
  selectedAvailableRows.value = [];
  availablePagination.page = 1;
  await loadAvailableUsers();
  boundPagination.page = 1;
  activeTab.value = 'bound';
  await loadBoundUsers();
}

// ── 设置租户管理员 ──
async function handleAdminChange(userId: number, value: boolean) {
  const isSuper = value ? 1 : 0;
  const action = isSuper === 1 ? '设为租户管理员' : '取消租户管理员';
  const { error } = await fetchSetTenantAdmin(props.tenantId, userId, isSuper);
  if (error) {
    ElMessage.error('设置失败');
    await loadBoundUsers();
    return;
  }
  ElMessage.success(`${action}成功`);
  await loadBoundUsers();
}

// ── 设置默认租户 ──
async function handleDefaultChange(userId: number, value: boolean) {
  const isDefault = value ? 1 : 0;
  const action = isDefault === 1 ? '设为默认租户' : '取消默认租户';
  const { error } = await fetchSetDefaultTenant(props.tenantId, userId, isDefault);
  if (error) {
    ElMessage.error('设置失败');
    await loadBoundUsers();
    return;
  }
  ElMessage.success(`${action}成功`);
  await loadBoundUsers();
}

// ── 移除用户 ──
async function removeUser(userId: number) {
  await ElMessageBox.confirm('确定要将该用户从租户中移除吗？', '移除用户', {
    type: 'warning',
    confirmButtonText: '确定',
    cancelButtonText: '取消'
  });
  const { error } = await fetchRemoveUserFromTenant(props.tenantId, userId);
  if (error) return;

  ElMessage.success('移除成功');
  await loadBoundUsers();
  await loadAvailableUsers();
}
</script>

<template>
  <ElDialog
    v-model="visible"
    :title="`租户用户管理 - ${tenantName}`"
    width="1080px"
    align-center
    :close-on-click-modal="false"
    @open="loadBoundUsers"
  >
    <ElTabs v-model="activeTab">
      <!-- 已关联用户 -->
      <ElTabPane label="已关联用户" name="bound">
        <div class="mb-3 flex flex-wrap gap-3">
          <ElInput v-model="boundSearch.username" clearable placeholder="账号" style="width: 180px" />
          <ElInput v-model="boundSearch.realname" clearable placeholder="姓名" style="width: 180px" />
          <ElInput v-model="boundSearch.phone" clearable placeholder="手机号" style="width: 180px" />
          <ElButton type="primary" @click="searchBound">查询</ElButton>
        </div>

        <ElTable :data="boundRows" border height="360" v-loading="boundLoading">
          <ElTableColumn prop="user_id" label="用户ID" width="90" align="center" />
          <ElTableColumn prop="username" label="账号" min-width="140" />
          <ElTableColumn prop="realname" label="姓名" min-width="120" />
          <ElTableColumn prop="phone" label="手机号" min-width="130" />

          <ElTableColumn label="默认租户" width="100" align="center">
            <template #default="{ row }">
              <ElSwitch
                :model-value="row.is_default === 1"
                @change="(val: string | number | boolean) => handleDefaultChange(row.user_id, Boolean(val))"
                :disabled="row.id === 1"
              />
            </template>
          </ElTableColumn>

          <ElTableColumn label="租户管理员" width="100" align="center">
            <template #default="{ row }">
              <ElSwitch
                :model-value="row.is_super === 1"
                @change="(val: string | number | boolean) => handleAdminChange(row.user_id, Boolean(val))"
                :disabled="row.id === 1"
              />
            </template>
          </ElTableColumn>

          <ElTableColumn label="状态" width="90" align="center">
            <template #default="{ row }">
              <ElTag :type="row.status === 1 ? 'success' : 'danger'" size="small">
                {{ row.status === 1 ? '启用' : '禁用' }}
              </ElTag>
            </template>
          </ElTableColumn>

          <ElTableColumn label="操作" width="120" align="center">
            <template #default="{ row }">
              <ElButton
                v-if="row.id !== 1"
                type="danger"
                link
                size="small"
                @click="removeUser(row.user_id)"
              >
                移除
              </ElButton>
            </template>
          </ElTableColumn>
        </ElTable>

        <div class="mt-3 flex justify-end">
          <ElPagination
            v-model:current-page="boundPagination.page"
            v-model:page-size="boundPagination.limit"
            :total="boundPagination.total"
            :page-sizes="[10, 20, 50]"
            layout="total, sizes, prev, pager, next"
            @size-change="loadBoundUsers"
            @current-change="loadBoundUsers"
          />
        </div>
      </ElTabPane>

      <!-- 添加用户 -->
      <ElTabPane label="添加用户" name="available">
        <div class="mb-3 flex flex-wrap gap-3">
          <ElInput v-model="availableSearch.username" clearable placeholder="账号" style="width: 180px" />
          <ElInput v-model="availableSearch.realname" clearable placeholder="姓名" style="width: 180px" />
          <ElInput v-model="availableSearch.phone" clearable placeholder="手机号" style="width: 180px" />
          <ElButton type="primary" @click="searchAvailable">查询</ElButton>
          <ElButton
            type="success"
            :disabled="selectedAvailableRows.length === 0"
            @click="handleAddUsers"
          >
            添加选中用户
          </ElButton>
        </div>

        <ElTable
          :data="availableRows"
          border
          height="360"
          v-loading="availableLoading"
          @selection-change="handleAvailableSelectionChange"
        >
          <ElTableColumn type="selection" width="50" />
          <ElTableColumn prop="id" label="用户ID" width="90" align="center" />
          <ElTableColumn prop="username" label="账号" min-width="140" />
          <ElTableColumn prop="realname" label="姓名" min-width="120" />
          <ElTableColumn prop="phone" label="手机号" min-width="130" />
          <ElTableColumn prop="email" label="邮箱" min-width="180" />
          <ElTableColumn label="状态" width="90" align="center">
            <template #default="{ row }">
              <ElTag :type="row.status === 1 ? 'success' : 'danger'" size="small">
                {{ row.status === 1 ? '启用' : '禁用' }}
              </ElTag>
            </template>
          </ElTableColumn>
        </ElTable>

        <div class="mt-3 flex justify-end">
          <ElPagination
            v-model:current-page="availablePagination.page"
            v-model:page-size="availablePagination.limit"
            :total="availablePagination.total"
            :page-sizes="[10, 20, 50]"
            layout="total, sizes, prev, pager, next"
            @size-change="loadAvailableUsers"
            @current-change="loadAvailableUsers"
          />
        </div>
      </ElTabPane>
    </ElTabs>

    <template #footer>
      <ElButton @click="visible = false">关闭</ElButton>
    </template>
  </ElDialog>
</template>

<style scoped lang="scss"></style>
