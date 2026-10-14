<script setup lang="ts">
import { ref, watch, computed, reactive } from 'vue';
import { ElMessage } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchGetCategoryList, fetchMoveAttachment } from '@/service/api';

defineOptions({ name: 'AttachmentMoveDialog' });

interface Props {
  modelValue: boolean;
  selectedRows: any[];
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  selectedRows: () => []
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

const selectedCount = computed(() => props.selectedRows.length);

const rules: FormRules = {
  category_id: [{ required: true, message: '请选择目标分类', trigger: 'change' }]
};

const formData = reactive({ category_id: null as number | null });

watch(
  () => props.modelValue,
  async newVal => {
    if (newVal) {
      Object.assign(formData, { category_id: null });
      const { data } = await fetchGetCategoryList({ tree: true });
      optionData.treeData = (data as any) || [];
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
    const ids = props.selectedRows.map(row => row.id);
    await fetchMoveAttachment({ ids, category_id: formData.category_id! });
    ElMessage.success(`成功移动 ${ids.length} 个文件`);
    emit('success');
    handleClose();
  } catch (error) {
    console.log('表单验证失败:', error);
  }
};
</script>

<template>
  <ElDialog v-model="visible" title="移动到分类" width="500px" align-center :close-on-click-modal="false" @close="handleClose">
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
      <ElFormItem>
        <div class="text-gray-400 mb-8px">
          已选择 <span class="text-primary font-medium">{{ selectedCount }}</span> 个文件
        </div>
      </ElFormItem>
      <ElFormItem label="目标分类" prop="category_id">
        <ElTreeSelect
          v-model="formData.category_id"
          :data="optionData.treeData"
          :render-after-expand="false"
          check-strictly
          clearable
          placeholder="请选择目标分类"
        />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" @click="handleSubmit">确定移动</ElButton>
    </template>
  </ElDialog>
</template>
