<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { enableStatusOptions } from '@/constants/business';
import { fetchCreatePost, fetchUpdatePost } from '@/service/api';
import { useForm, useFormRules } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({ name: 'PostOperateDialog' });

interface Props {
  operateType: UI.TableOperateType;
  rowData?: Api.Post.Post | null;
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
  return props.operateType === 'add' ? $t('page.manage.post.addPost') : $t('page.manage.post.editPost');
});

type Model = Pick<Api.Post.Post, 'name' | 'code' | 'sort' | 'remark'> & {
  status: Api.Common.EnableStatus;
};

const model = ref<Model>(createDefaultModel());

function createDefaultModel(): Model {
  return {
    name: '',
    code: '',
    sort: 100,
    status: '1',
    remark: ''
  };
}

type RuleKey = 'name' | 'code';

const rules: Record<RuleKey, App.Global.FormRule> = {
  name: defaultRequiredRule,
  code: defaultRequiredRule
};

function handleInitModel() {
  model.value = createDefaultModel();
  if (props.operateType === 'edit' && props.rowData) {
    Object.assign(model.value, {
      name: props.rowData.name || '',
      code: props.rowData.code || '',
      sort: props.rowData.sort ?? 100,
      status: String(props.rowData.status || '1') as Api.Common.EnableStatus,
      remark: props.rowData.remark || ''
    });
  }
}

function closeDialog() {
  visible.value = false;
}

async function handleSubmit() {
  await validate();

  const request =
    props.operateType === 'add'
      ? fetchCreatePost(model.value)
      : fetchUpdatePost(Number(props.rowData!.id), model.value);

  const { error } = await request;
  if (error) return;

  window.$message?.success($t('common.updateSuccess'));
  closeDialog();
  emit('submitted');
}

watch(visible, val => {
  if (val) {
    handleInitModel();
    restoreValidation();
  }
});
</script>

<template>
  <ElDialog v-model="visible" :title="title" width="600px" align-center :close-on-click-modal="false">
    <ElForm ref="formRef" :model="model" :rules="rules" label-width="100px">
      <ElFormItem label="岗位名称" prop="name">
        <ElInput v-model="model.name" placeholder="请输入岗位名称" />
      </ElFormItem>
      <ElFormItem label="岗位编码" prop="code">
        <ElInput v-model="model.code" placeholder="请输入岗位编码" />
      </ElFormItem>
      <ElFormItem label="描述" prop="remark">
        <ElInput v-model="model.remark" type="textarea" :rows="3" placeholder="请输入描述" />
      </ElFormItem>
      <ElFormItem label="排序" prop="sort">
        <ElInputNumber v-model="model.sort" class="w-full" controls-position="right" />
      </ElFormItem>
      <ElFormItem label="启用" prop="status">
        <ElRadioGroup v-model="model.status">
          <ElRadio v-for="item in enableStatusOptions" :key="item.value" :value="item.value">
            {{ $t(item.label) }}
          </ElRadio>
        </ElRadioGroup>
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElSpace :size="16">
        <ElButton @click="closeDialog">{{ $t('common.cancel') }}</ElButton>
        <ElButton type="primary" @click="handleSubmit">{{ $t('common.confirm') }}</ElButton>
      </ElSpace>
    </template>
  </ElDialog>
</template>

<style scoped>
:deep(.el-input-number) {
  width: 100%;
}
</style>
