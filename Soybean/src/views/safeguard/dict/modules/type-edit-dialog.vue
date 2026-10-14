<script setup lang="ts">
import { ref, watch, nextTick, reactive, computed } from 'vue';
import { ElMessage } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchCreateDictType, fetchUpdateDictType } from '@/service/api';

defineOptions({ name: 'DictTypeEditDialog' });

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
  name: [{ required: true, message: '请输入字典名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入字典标识', trigger: 'blur' }]
};

const initialFormData = { id: null, name: '', code: '', remark: '', status: 1 };
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
    for (const key in formData) {
      if (props.data[key] != null && props.data[key] != undefined) {
        (formData as any)[key] = props.data[key];
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
    if (props.dialogType === 'add') {
      await fetchCreateDictType(formData);
      ElMessage.success('新增成功');
    } else if (formData.id != null) {
      await fetchUpdateDictType(formData.id, formData);
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
    :title="dialogType === 'add' ? '新增字典数据' : '编辑字典数据'"
    width="600px"
    align-center
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
      <ElFormItem label="字典名称" prop="name">
        <ElInput v-model="formData.name" placeholder="请输入字典名称" />
      </ElFormItem>
      <ElFormItem label="字典标识" prop="code">
        <ElInput v-model="formData.code" placeholder="请输入字典标识" />
      </ElFormItem>
      <ElFormItem label="状态" prop="status">
        <ElRadioGroup v-model="formData.status">
          <ElRadio :value="1">启用</ElRadio>
          <ElRadio :value="0">禁用</ElRadio>
        </ElRadioGroup>
      </ElFormItem>
      <ElFormItem label="备注" prop="remark">
        <ElInput v-model="formData.remark" type="textarea" :rows="3" placeholder="请输入备注" />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" @click="handleSubmit">提交</ElButton>
    </template>
  </ElDialog>
</template>
