<script setup lang="ts">
import { ref, watch, nextTick, reactive, computed } from 'vue';
import { ElMessage } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchGetCategoryList, fetchCreateCategory, fetchUpdateCategory } from '@/service/api';

defineOptions({ name: 'AttachmentCategoryDialog' });

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
const optionData = reactive({ treeData: [] as any[] });

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
});

const rules: FormRules = {
  parent_id: [{ required: true, message: '请选择上级分类', trigger: 'change' }],
  category_name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }]
};

const initialFormData = { id: null as number | null, parent_id: null, level: '', category_name: '', sort: 100 };
const formData = reactive({ ...initialFormData });

watch(
  () => props.modelValue,
  async newVal => {
    if (newVal) {
      Object.assign(formData, initialFormData);
      const { data } = await fetchGetCategoryList({ tree: true });
      let tree = (data as any) || [];

      // Disable current node and children in edit mode
      if (props.dialogType === 'edit' && props.data?.id) {
        const disableNodes = (nodes: any[], targetId: number, parentDisabled = false) => {
          nodes.forEach(node => {
            const isDisabled = parentDisabled || node.id === targetId;
            if (isDisabled) node.disabled = true;
            if (node.children?.length > 0) disableNodes(node.children, targetId, isDisabled);
          });
        };
        disableNodes(tree, props.data.id);
      }

      optionData.treeData = tree;

      if (props.data) {
        await nextTick();
        for (const key in formData) {
          if (props.data[key] != null && props.data[key] != undefined) {
            (formData as any)[key] = props.data[key];
          }
        }
      }
    }
  }
);

const handleClose = () => {
  visible.value = false;
  formRef.value?.resetFields();
};

const handleSubmit = async () => {
  if (!formRef.value) return;
  try {
    await formRef.value.validate();
    if (props.dialogType === 'add') {
      await fetchCreateCategory(formData);
      ElMessage.success('新增成功');
    } else if (formData.id != null) {
      await fetchUpdateCategory(formData.id, formData);
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
    :title="dialogType === 'add' ? '新增分类' : '编辑分类'"
    width="600px"
    align-center
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
      <ElFormItem label="上级分类" prop="parent_id">
        <ElTreeSelect
          v-model="formData.parent_id"
          :data="optionData.treeData"
          :render-after-expand="false"
          check-strictly
          clearable
        />
      </ElFormItem>
      <ElFormItem label="分类名称" prop="category_name">
        <ElInput v-model="formData.category_name" placeholder="请输入分类名称" />
      </ElFormItem>
      <ElFormItem label="排序" prop="sort">
        <ElInputNumber v-model="formData.sort" placeholder="请输入排序" />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" @click="handleSubmit">提交</ElButton>
    </template>
  </ElDialog>
</template>
