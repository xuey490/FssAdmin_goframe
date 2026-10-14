<script setup lang="ts">
import { ref, watch, nextTick, reactive, computed } from 'vue';
import { ElMessage } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchCreateDictData, fetchUpdateDictData } from '@/service/api';

defineOptions({ name: 'DictDataEditDialog' });

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
  label: [{ required: true, message: '请输入字典标签', trigger: 'blur' }],
  value: [{ required: true, message: '请输入字典键值', trigger: 'blur' }]
};

const predefineColors = [
  '#ff4500', '#ff8c00', '#ffd700', '#90ee90', '#00ced1',
  '#1e90ff', '#c71585', '#5d87ff', '#b48df3', '#1d84ff',
  '#60c041', '#38c0fc', '#f9901f', '#ff80c8', '#909399'
];

const initialFormData = {
  id: null,
  type_id: '',
  code: '',
  label: '',
  color: '#5d87ff',
  value: '',
  remark: '',
  sort: 100,
  status: 1
};
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
      await fetchCreateDictData(formData);
      ElMessage.success('新增成功');
    } else if (formData.id != null) {
      await fetchUpdateDictData(formData.id, formData);
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
    :title="dialogType === 'add' ? '新增字典项数据' : '编辑字典项数据'"
    width="600px"
    align-center
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
      <ElFormItem label="字典标签" prop="label">
        <ElInput v-model="formData.label" placeholder="请输入字典标签" />
      </ElFormItem>
      <ElFormItem label="字典键值" prop="value">
        <ElInput v-model="formData.value" placeholder="请输入字典键值" />
      </ElFormItem>
      <ElFormItem label="颜色选择" prop="color">
        <ElColorPicker v-model="formData.color" color-format="hex" :predefine="predefineColors" />
      </ElFormItem>
      <ElFormItem label="排序" prop="sort">
        <ElInputNumber v-model="formData.sort" placeholder="请输入排序" />
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
