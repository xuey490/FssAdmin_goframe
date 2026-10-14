<script setup lang="ts">
import { ref, watch, nextTick, reactive, computed } from 'vue';
import { ElMessage } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchUpdateAttachment } from '@/service/api';

defineOptions({ name: 'AttachmentEditDialog' });

interface Props {
  modelValue: boolean;
  dialogType: string;
  data?: Record<string, any>;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  dialogType: 'add',
  data: undefined
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'success'): void;
}>();

const formRef = ref<FormInstance>();

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
});

const rules: FormRules = {
  origin_name: [{ required: true, message: '请输入文件名称', trigger: 'blur' }]
};

const initialFormData = { id: null as number | null, origin_name: '' };
const formData = reactive({ ...initialFormData });

watch(
  () => props.modelValue,
  newVal => {
    if (newVal) initPage();
  }
);

const initPage = async () => {
  Object.assign(formData, initialFormData);
  if (props.data) {
    await nextTick();
    initForm(props.data);
  }
};

const initForm = (data: any) => {
  if (data) {
    for (const key in formData) {
      if (data[key] != null && data[key] != undefined) {
        (formData as any)[key] = data[key];
      }
    }
  }
};

const handleClose = () => {
  visible.value = false;
  formRef.value?.resetFields();
};

const handleSubmit = async () => {
  if (!formRef.value) return;
  try {
    await formRef.value.validate();
    if (props.dialogType === 'edit' && formData.id != null) {
      await fetchUpdateAttachment(formData.id, formData);
      ElMessage.success('修改成功');
    }
    emit('success');
    handleClose();
  } catch (error) {
    console.log('表单验证失败:', error);
  }
};
</script>

<template>
  <ElDialog
    v-model="visible"
    :title="dialogType === 'edit' ? '编辑文件' : '新增文件'"
    width="800px"
    align-center
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
      <ElFormItem label="文件名称" prop="origin_name">
        <ElInput v-model="formData.origin_name" placeholder="请输入文件名称" />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" @click="handleSubmit">提交</ElButton>
    </template>
  </ElDialog>
</template>
