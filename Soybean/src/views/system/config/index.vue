<script setup lang="tsx">
import { ref } from 'vue';
import {
  fetchBatchUpdateConfig,
  fetchDeleteConfigGroup,
  fetchGetConfigGroupList,
  fetchGetConfigList,
  fetchTestEmail
} from '@/service/api';
import { defaultTransform, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import ConfigListDrawer from './modules/config-list-drawer.vue';
import GroupEditDialog from './modules/group-edit-dialog.vue';

defineOptions({ name: 'ConfigManage' });

const searchParams = ref<Api.Config.ConfigGroupSearchParams>({
  page: 1,
  limit: 20,
  name: undefined,
  code: undefined
});

const searchForm = ref({
  name: '',
  code: ''
});

const selectedId = ref(0);
const selectedRow = ref<Partial<Api.Config.ConfigGroup>>({});

const formArray = ref<Api.Config.ConfigItemWithDisplay[]>([]);
const email = ref('');

const groupDialogVisible = ref(false);
const groupDialogType = ref<'add' | 'edit'>('add');
const groupDialogData = ref<Partial<Api.Config.ConfigGroup> | null>(null);

const configVisible = ref(false);

const {
  columns: groupColumns,
  data: groupData,
  getDataByPage: getGroupDataByPage,
  loading: groupLoading,
  mobilePagination: groupPagination,
  handleCurrentPageChange: handleGroupPageChange,
  handlePageSizeChange: handleGroupPageSizeChange
} = useUIPaginatedTable({
  paginationProps: {
    currentPage: searchParams.value.page,
    pageSize: searchParams.value.limit
  },
  api: () => fetchGetConfigGroupList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { prop: 'index', type: 'index', label: $t('common.index'), width: 64 },
    { prop: 'name', label: '配置名称', minWidth: 180 },
    { prop: 'code', label: '配置标识', minWidth: 160 }
  ]
});

function reloadConfigData() {
  selectedId.value = 0;
  selectedRow.value = {};
  formArray.value = [];
  email.value = '';
  getGroupDataByPage(1).catch(() => undefined);
}

function handleGroupSearch() {
  searchParams.value = {
    ...searchParams.value,
    name: searchForm.value.name || undefined,
    code: searchForm.value.code || undefined,
    page: 1
  };
  getGroupDataByPage(1).catch(() => undefined);
}

function resetGroupSearch() {
  searchForm.value = { name: '', code: '' };
  searchParams.value = { page: 1, limit: 20, name: undefined, code: undefined };
  getGroupDataByPage(1).catch(() => undefined);
}

function openAddGroup() {
  groupDialogType.value = 'add';
  groupDialogData.value = null;
  groupDialogVisible.value = true;
}

function openEditGroup() {
  if (!selectedId.value) {
    window.$message?.error('请选择要修改的数据');
    return;
  }
  groupDialogType.value = 'edit';
  groupDialogData.value = { ...selectedRow.value };
  groupDialogVisible.value = true;
}

async function deleteGroup() {
  if (!selectedId.value) {
    window.$message?.error('请选择要删除的数据');
    return;
  }
  const { error } = await fetchDeleteConfigGroup(selectedId.value);
  if (error) return;
  window.$message?.success($t('common.deleteSuccess'));
  reloadConfigData();
}

function handleGroupChange(row: Api.Config.ConfigGroup) {
  selectedId.value = Number(row.id);
  selectedRow.value = row;
  getConfigData().catch(() => undefined);
}

async function getConfigData() {
  if (!selectedId.value) return;
  const { data, error } = await fetchGetConfigList({ group_id: selectedId.value, saiType: 'all' });
  if (error) return;

  const rows = (data as any[]) || [];
  formArray.value = rows.map(row => {
    const item: Api.Config.ConfigItemWithDisplay = { ...(row as any) };
    if (
      item.key?.includes('local_') ||
      item.key?.includes('qiniu_') ||
      item.key?.includes('cos_') ||
      item.key?.includes('oss_') ||
      item.key?.includes('s3_')
    ) {
      item.display = false;
    } else {
      item.display = true;
    }
    return item;
  });

  if (selectedId.value === 2) {
    const uploadMode = formArray.value.find(item => item.key === 'upload_mode');
    if (uploadMode) {
      await handleSelect(uploadMode.value, uploadMode);
    }
  }
}

async function handleSelect(val: any, ele: Api.Config.ConfigItemWithDisplay) {
  if (ele.key !== 'upload_mode') return;

  const toggle = (showPrefix: string) => {
    formArray.value.forEach(item => {
      if (item.key?.includes(showPrefix)) {
        item.display = true;
        return;
      }
      if (
        item.key?.includes('local_') ||
        item.key?.includes('qiniu_') ||
        item.key?.includes('cos_') ||
        item.key?.includes('oss_') ||
        item.key?.includes('s3_')
      ) {
        item.display = false;
        return;
      }
      item.display = true;
    });
  };

  if (val === 1) toggle('local_');
  if (val === 2) toggle('oss_');
  if (val === 3) toggle('qiniu_');
  if (val === 4) toggle('cos_');
  if (val === 5) toggle('s3_');
}

async function submit() {
  if (!selectedId.value) return;
  const { error } = await fetchBatchUpdateConfig({ group_id: selectedId.value, config: formArray.value as any[] });
  if (error) return;
  window.$message?.success('保存成功');
}

async function sendMail() {
  const reg = /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/;
  if (!reg.test(email.value)) {
    window.$message?.warning('请输入正确的邮箱地址');
    return;
  }
  const { error } = await fetchTestEmail({ email: email.value });
  if (error) return;
  window.$message?.success('发送成功');
}

function openConfigManage() {
  if (!selectedId.value) {
    window.$message?.error('请选择要管理的配置');
    return;
  }
  configVisible.value = true;
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <div class="h-full flex gap-16px lt-md:flex-col">
      <ElCard class="w-420px card-wrapper lt-md:w-full sm:flex-1-hidden">
        <template #header>
          <div class="flex items-center justify-between">
            <p>系统设置</p>
            <ElSpace wrap>
              <ElButton @click="reloadConfigData">刷新</ElButton>
              <ElButton type="primary" @click="openAddGroup">新增</ElButton>
              <ElButton :disabled="!selectedId" @click="openEditGroup">编辑</ElButton>
              <ElPopconfirm title="确认删除？" @confirm="deleteGroup">
                <template #reference>
                  <ElButton type="danger" :disabled="!selectedId">删除</ElButton>
                </template>
              </ElPopconfirm>
            </ElSpace>
          </div>
        </template>

        <ElCard shadow="never" class="mb-12px">
          <ElForm inline>
            <ElFormItem label="配置名称">
              <ElInput v-model="searchForm.name" placeholder="搜索配置名称" clearable />
            </ElFormItem>
            <ElFormItem label="配置标识">
              <ElInput v-model="searchForm.code" placeholder="搜索配置标识" clearable />
            </ElFormItem>
            <ElFormItem>
              <ElButton type="primary" @click="handleGroupSearch">搜索</ElButton>
              <ElButton @click="resetGroupSearch">重置</ElButton>
            </ElFormItem>
          </ElForm>
        </ElCard>

        <div class="h-[calc(100%-168px)]">
          <ElTable
            v-loading="groupLoading"
            height="100%"
            border
            class="sm:h-full"
            :data="groupData"
            row-key="id"
            highlight-current-row
            @row-click="handleGroupChange"
          >
            <ElTableColumn label="选中" width="80" align="center">
              <template #default="{ row }">
                <ElRadio v-model="selectedId" :value="row.id" @update:model-value="handleGroupChange(row as Api.Config.ConfigGroup)" />
              </template>
            </ElTableColumn>
            <ElTableColumn v-for="col in groupColumns" :key="col.prop" v-bind="col" />
          </ElTable>
        </div>
        <div class="mt-20px flex justify-end">
          <ElPagination
            v-if="groupPagination.total"
            layout="total,prev,pager,next,sizes"
            v-bind="groupPagination"
            @current-change="handleGroupPageChange"
            @size-change="handleGroupPageSizeChange"
          />
        </div>
      </ElCard>

      <ElCard class="min-w-0 flex-1 card-wrapper sm:flex-1-hidden">
        <template #header>
          <div class="flex items-center justify-between">
            <p>{{ selectedRow.name || '未选择配置' }}</p>
            <ElButton type="primary" :disabled="!selectedId" @click="openConfigManage">配置项管理</ElButton>
          </div>
        </template>

        <div class="max-h-[calc(100vh-250px)] overflow-y-auto">
          <ElForm label-width="140px">
            <template v-for="(item, index) in formArray" :key="index">
              <ElFormItem v-show="item.display !== false" :label="item.name" :prop="item.key">
                <template v-if="item.input_type === 'select'">
                  <ElSelect
                    v-model="item.value"
                    class="w-full"
                    :placeholder="'请选择' + item.name"
                    @change="val => handleSelect(val, item)"
                  >
                    <ElOption
                      v-for="opt in item.config_select_data || []"
                      :key="String(opt.value)"
                      :label="opt.label"
                      :value="opt.value"
                    />
                  </ElSelect>
                </template>
                <template v-else-if="item.input_type === 'input'">
                  <ElInput v-model="item.value" class="w-full" :placeholder="'请输入' + item.name" />
                </template>
                <template v-else-if="item.input_type === 'radio'">
                  <ElRadioGroup v-model="item.value">
                    <ElRadio v-for="opt in item.config_select_data || []" :key="String(opt.value)" :value="opt.value">
                      {{ opt.label }}
                    </ElRadio>
                  </ElRadioGroup>
                </template>
                <template v-else-if="item.input_type === 'textarea'">
                  <ElInput
                    v-model="item.value"
                    type="textarea"
                    :rows="3"
                    class="w-full"
                    :placeholder="'请输入' + item.name"
                  />
                </template>
                <template v-else-if="item.input_type === 'uploadImage'">
                  <SaImagePicker v-model="item.value" />
                </template>
                <template v-else-if="item.input_type === 'uploadFile'">
                  <SaFileUpload v-model="item.value" />
                </template>
                <template v-else-if="item.input_type === 'wangEditor'">
                  <SaEditor v-model="item.value" />
                </template>
                <div class="py-8px text-xs text-gray-400">{{ item.remark }}</div>
              </ElFormItem>
            </template>

            <ElFormItem v-if="formArray.length > 0">
              <ElButton type="primary" @click="submit">保存修改</ElButton>
            </ElFormItem>

            <ElFormItem v-if="selectedRow.code === 'email_config'" label="测试邮件">
              <div class="flex items-center gap-12px">
                <ElInput v-model="email" class="w-300px" placeholder="请输入正确的邮箱接收地址" />
                <ElButton @click="sendMail">发送</ElButton>
              </div>
            </ElFormItem>

            <ElEmpty v-if="selectedId === 0" description="请先选择左侧配置" />
          </ElForm>
        </div>
      </ElCard>
    </div>

    <GroupEditDialog
      v-model:visible="groupDialogVisible"
      :dialog-type="groupDialogType"
      :data="groupDialogData"
      @success="reloadConfigData"
    />

    <ConfigListDrawer v-model:visible="configVisible" :data="selectedRow" @success="getConfigData" />
  </div>
</template>
