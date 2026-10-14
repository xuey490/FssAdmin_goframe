<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { useBoolean } from '@sa/hooks';
import { fetchCreateRole, fetchGetDeptTree, fetchGetRoleDetail, fetchUpdateRole } from '@/service/api';
import { useForm, useFormRules } from '@/hooks/common/form';
import { $t } from '@/locales';
import MenuAuthModal from './menu-auth-modal.vue';
import ButtonAuthModal from './button-auth-modal.vue';

defineOptions({ name: 'RoleOperateDrawer' });

interface Props {
  /** the type of operation */
  operateType: UI.TableOperateType;
  /** the edit row data */
  rowData?: Api.SystemManage.Role | null;
}

const props = defineProps<Props>();

interface Emits {
  (e: 'submitted'): void;
}

const emit = defineEmits<Emits>();

const visible = defineModel<boolean>('visible', {
  default: false
});

const { formRef, validate, restoreValidation } = useForm();
const { defaultRequiredRule } = useFormRules();
const { bool: menuAuthVisible, setTrue: openMenuAuthModal } = useBoolean();
const { bool: buttonAuthVisible, setTrue: openButtonAuthModal } = useBoolean();

const title = computed(() => {
  const titles: Record<UI.TableOperateType, string> = {
    add: $t('page.manage.role.addRole'),
    edit: $t('page.manage.role.editRole')
  };
  return titles[props.operateType];
});

type Model = Pick<Api.SystemManage.Role, 'name' | 'code' | 'remark' | 'status'> & {
  data_scope: number;
  dept_ids: number[];
  level: number;
  sort?: number;
};

const model = ref(createDefaultModel());

function createDefaultModel(): Model {
  return {
    name: '',
    code: '',
    remark: '',
    status: '1',
    data_scope: 1,
    dept_ids: [],
    level: 1,
    sort: 100
  };
}

type RuleKey = Exclude<keyof Model, 'remark' | 'dept_ids' | 'sort' | 'level'>;

const rules: Record<RuleKey, App.Global.FormRule> = {
  name: defaultRequiredRule,
  code: defaultRequiredRule,
  status: defaultRequiredRule,
  data_scope: defaultRequiredRule
};

const roleId = computed(() => props.rowData?.id || -1);

const isEdit = computed(() => props.operateType === 'edit');
const deptTree = ref<Api.SystemManage.MenuTree[]>([]);

const dataScopeOptions = computed(() => [
  { label: $t('page.manage.role.dataScopeOptions.all'), value: 1 },
  { label: $t('page.manage.role.dataScopeOptions.dept'), value: 2 },
  { label: $t('page.manage.role.dataScopeOptions.deptAndChild'), value: 3 },
  { label: $t('page.manage.role.dataScopeOptions.self'), value: 4 },
  { label: $t('page.manage.role.dataScopeOptions.deptAndSelf'), value: 5 },
  { label: $t('page.manage.role.dataScopeOptions.custom'), value: 6 }
]);

function normalizeRoleStatus(status: unknown): Api.Common.EnableStatus {
  const value = String(status ?? '1');
  if (value === '0' || value === '2') return '0';
  return '1';
}

function normalizeDataScope(scope: unknown): number {
  const value = Number(scope ?? 1);
  return [1, 2, 3, 4, 5, 6].includes(value) ? value : 1;
}

function toDbRoleStatus(status: unknown): number {
  const value = String(status ?? '1');
  return value === '0' || value === '2' ? 0 : 1;
}

function handleInitModel() {
  model.value = createDefaultModel();

  if (props.operateType === 'edit' && props.rowData) {
    Object.assign(model.value, {
      ...props.rowData,
      status: normalizeRoleStatus((props.rowData as any).status),
      data_scope: normalizeDataScope((props.rowData as any).data_scope)
    });
  }
}

async function loadDeptTree() {
  const { error, data } = await fetchGetDeptTree();
  if (!error) {
    deptTree.value = data;
  }
}

async function loadRoleDetail() {
  if (props.operateType !== 'edit' || !props.rowData) return;
  const { error, data } = await fetchGetRoleDetail(props.rowData.id);
  if (!error && data) {
    Object.assign(model.value, {
      ...data,
      dept_ids: data.dept_ids || [],
      level: data.level ?? 1,
      sort: data.sort ?? 100,
      status: normalizeRoleStatus((data as any).status),
      data_scope: normalizeDataScope((data as any).data_scope)
    });
  }
}

function closeDrawer() {
  visible.value = false;
}

async function handleSubmit() {
  await validate();
  const payload: Record<string, any> = {
    name: model.value.name,
    code: model.value.code,
    remark: model.value.remark,
    status: toDbRoleStatus(model.value.status),
    level: model.value.level,
    sort: model.value.sort,
    data_scope: model.value.data_scope,
    dept_ids: model.value.data_scope === 6 ? model.value.dept_ids : []
  };
  const request = props.operateType === 'add' ? fetchCreateRole(payload) : fetchUpdateRole(props.rowData!.id, payload);
  const { error } = await request;
  if (error) return;
  window.$message?.success($t('common.updateSuccess'));
  closeDrawer();
  emit('submitted');
}

watch(visible, () => {
  if (visible.value) {
    handleInitModel();
    restoreValidation();
    void loadDeptTree();
    void loadRoleDetail();
  }
});
</script>

<template>
  <ElDialog v-model="visible" :title="title" width="860px">
    <ElForm ref="formRef" :model="model" :rules="rules" label-width="96px" class="pr-2">
      <ElFormItem :label="$t('page.manage.role.roleName')" prop="name">
        <ElInput v-model="model.name" :placeholder="$t('page.manage.role.form.roleName')" />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.role.roleCode')" prop="code">
        <ElInput v-model="model.code" :placeholder="$t('page.manage.role.form.roleCode')" />
      </ElFormItem>
      <ElFormItem label="角色级别" prop="level">
        <ElInputNumber v-model="model.level" class="w-[180px]" :min="1" :max="100" />
        <p class="mt-2 text-[13px] leading-5 text-[#b5bfd3]">控制角色的权限层级, 不能操作权限高于自己的角色</p>
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.role.dataScope')" prop="data_scope">
        <ElSelect v-model="model.data_scope" class="w-full">
          <ElOption v-for="item in dataScopeOptions" :key="item.value" :label="item.label" :value="item.value" />
        </ElSelect>
      </ElFormItem>
      <ElFormItem v-if="model.data_scope === 6" :label="$t('page.manage.role.customDept')" prop="dept_ids">
        <ElTreeSelect
          v-model="model.dept_ids"
          multiple
          clearable
          check-strictly
          node-key="id"
          :data="deptTree"
          :props="{ label: 'label', children: 'children' }"
        />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.role.roleDesc')" prop="remark">
        <ElInput v-model="model.remark" type="textarea" :placeholder="$t('page.manage.role.form.roleDesc')" />
      </ElFormItem>
      <ElFormItem label="排序" prop="sort">
        <ElInputNumber v-model="model.sort" class="w-[180px]" :min="0" />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.role.roleStatus')" prop="status">
        <ElRadioGroup v-model="model.status">
          <ElRadio value="1">正常</ElRadio>
          <ElRadio value="0">停用</ElRadio>
        </ElRadioGroup>
      </ElFormItem>
    </ElForm>
    <ElSpace v-if="isEdit" class="mb-12px">
      <ElButton @click="openMenuAuthModal">{{ $t('page.manage.role.menuAuth') }}</ElButton>
      <MenuAuthModal v-model:visible="menuAuthVisible" :role-id="roleId" />
      <ElButton @click="openButtonAuthModal">{{ $t('page.manage.role.buttonAuth') }}</ElButton>
      <ButtonAuthModal v-model:visible="buttonAuthVisible" :role-id="roleId" />
    </ElSpace>
    <template #footer>
      <ElSpace :size="16">
        <ElButton @click="closeDrawer">{{ $t('common.cancel') }}</ElButton>
        <ElButton type="primary" @click="handleSubmit">{{ $t('common.confirm') }}</ElButton>
      </ElSpace>
    </template>
  </ElDialog>
</template>

<style scoped lang="scss">
:deep(.el-form-item__label) {
  width: 110px;
  color: #4b5565;
}

:deep(.el-input__wrapper),
:deep(.el-textarea__inner),
:deep(.el-select__wrapper) {
  min-height: 40px;
}

:deep(.el-input-number) {
  width: 180px;
}

:deep(.el-input-number .el-input__wrapper) {
  min-height: 40px;
}

:deep(.el-dialog__body) {
  padding-top: 18px;
}
</style>
