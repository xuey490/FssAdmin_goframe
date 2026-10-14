<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { enableStatusOptions } from '@/constants/business';
import {
  fetchCreateTenant,
  fetchGetTenantDetail,
  fetchUpdateTenant
} from '@/service/api';
import { useForm, useFormRules } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({ name: 'TenantOperateDialog' });

interface Props {
  operateType: UI.TableOperateType;
  rowData?: Api.Tenant.Tenant | null;
}

const props = defineProps<Props>();

interface Emits {
  (e: 'submitted'): void;
}

const emit = defineEmits<Emits>();

const visible = defineModel<boolean>('visible', { default: false });

const { formRef, validate, restoreValidation } = useForm();
const { defaultRequiredRule } = useFormRules();

const title = computed(() => {
  const titles: Record<UI.TableOperateType, string> = {
    add: $t('page.manage.tenant.addTenant'),
    edit: $t('page.manage.tenant.editTenant')
  };
  return titles[props.operateType];
});

type Model = Pick<
  Api.Tenant.Tenant,
  | 'tenant_name'
  | 'tenant_code'
  | 'contact_name'
  | 'contact_phone'
  | 'max_users'
  | 'expire_time'
  | 'status'
  | 'remark'
>;

const model = ref(createDefaultModel());

function createDefaultModel(): Model {
  return {
    tenant_name: '',
    tenant_code: '',
    contact_name: '',
    contact_phone: '',
    max_users: undefined as unknown as number,
    expire_time: undefined as unknown as string,
    status: '1',
    remark: ''
  };
}

type RuleKey = Extract<keyof Model, 'tenant_name' | 'tenant_code' | 'status'>;

const rules: Record<RuleKey, App.Global.FormRule> = {
  tenant_name: defaultRequiredRule,
  tenant_code: defaultRequiredRule,
  status: defaultRequiredRule
};

async function handleInitModel() {
  model.value = createDefaultModel();

  if (props.operateType === 'edit' && props.rowData) {
    // 先尝试从详情接口获取完整数据
    const { data, error } = await fetchGetTenantDetail(props.rowData.id);
    if (!error && data) {
      Object.assign(model.value, {
        ...data,
        status: String(data.status ?? '1') as Api.Common.EnableStatus
      });
      return;
    }
    // fallback 到 rowData
    Object.assign(model.value, {
      ...props.rowData,
      status: String(props.rowData.status ?? '1') as Api.Common.EnableStatus
    });
  }
}

function closeDialog() {
  visible.value = false;
}

async function handleSubmit() {
  await validate();
  const payload = { ...model.value };
  const request =
    props.operateType === 'add'
      ? fetchCreateTenant(payload)
      : fetchUpdateTenant(props.rowData!.id, payload);
  const { error } = await request;
  if (error) return;

  window.$message?.success($t('common.updateSuccess'));
  closeDialog();
  emit('submitted');
}

watch(visible, () => {
  if (visible.value) {
    void handleInitModel();
    restoreValidation();
  }
});
</script>

<template>
  <ElDialog v-model="visible" :title="title" width="700px">
    <ElForm ref="formRef" :model="model" :rules="rules" label-width="100px" class="pr-2">
      <ElRow :gutter="16">
        <ElCol :span="12">
          <ElFormItem label="租户名称" prop="tenant_name">
            <ElInput v-model="model.tenant_name" placeholder="请输入租户名称" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="租户编码" prop="tenant_code">
            <ElInput v-model="model.tenant_code" placeholder="请输入租户编码" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="联系人" prop="contact_name">
            <ElInput v-model="model.contact_name" placeholder="请输入联系人" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="联系电话" prop="contact_phone">
            <ElInput v-model="model.contact_phone" placeholder="请输入联系电话" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="最大用户数" prop="max_users">
            <ElInputNumber v-model="model.max_users" :min="0" class="w-full" controls-position="right" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="过期时间" prop="expire_time">
            <el-date-picker
              v-model="model.expire_time"
              type="datetime"
              placeholder="请选择过期时间"
              value-format="YYYY-MM-DD HH:mm:ss"
              class="!w-full"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="24">
          <ElFormItem label="备注" prop="remark">
            <ElInput v-model="model.remark" type="textarea" :rows="3" placeholder="请输入备注" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="24">
          <ElFormItem label="状态" prop="status">
            <ElRadioGroup v-model="model.status">
              <ElRadio v-for="item in enableStatusOptions" :key="item.value" :value="item.value">
                {{ $t(item.label) }}
              </ElRadio>
            </ElRadioGroup>
          </ElFormItem>
        </ElCol>
      </ElRow>
    </ElForm>
    <template #footer>
      <ElSpace :size="16">
        <ElButton @click="closeDialog">{{ $t('common.cancel') }}</ElButton>
        <ElButton type="primary" @click="handleSubmit">{{ $t('common.confirm') }}</ElButton>
      </ElSpace>
    </template>
  </ElDialog>
</template>

<style scoped lang="scss">
::deep(.el-form-item__label) {
  color: #4b5565;
}
::deep(.el-input__wrapper),
::deep(.el-textarea__inner),
::deep(.el-select__wrapper) {
  min-height: 40px;
}
::deep(.el-input-number .el-input__wrapper) {
  min-height: 40px;
}
::deep(.el-dialog__body) {
  padding-top: 18px;
}
</style>
