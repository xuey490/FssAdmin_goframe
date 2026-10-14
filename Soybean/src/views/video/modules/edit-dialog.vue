<script setup lang="ts">
import { reactive, ref, watch } from 'vue';
import type { FormInstance, FormRules } from 'element-plus';
import { ElMessage } from 'element-plus';
import { fetchRefreshVideo, fetchUpdateVideo } from '@/service/api';

defineOptions({ name: 'VideoEditDialog' });

const visible = defineModel<boolean>({ default: false });
const props = defineProps<{ data?: Record<string, any> }>();
const emit = defineEmits<{ success: [] }>();

const formRef = ref<FormInstance>();
const submitting = ref(false);
const refreshing = ref(false);
const formData = reactive({ id: 0, url: '' });

const rules: FormRules = {
  url: [{ required: true, message: '请输入链接', trigger: 'blur' }]
};

watch(visible, val => {
  if (!val || !props.data) return;
  formData.id = props.data.id;
  formData.url = props.data.url || '';
});

async function handleRefresh() {
  if (!formData.id) return;
  refreshing.value = true;
  try {
    const { error } = await fetchRefreshVideo(formData.id);
    if (!error) {
      ElMessage.success('已重新获取');
      emit('success');
    }
  } finally {
    refreshing.value = false;
  }
}

async function handleSubmit() {
  await formRef.value?.validate();
  submitting.value = true;
  try {
    const { error } = await fetchUpdateVideo(formData.id, { url: formData.url.trim() });
    if (!error) {
      ElMessage.success('更新成功');
      visible.value = false;
      emit('success');
    }
  } finally {
    submitting.value = false;
  }
}
</script>

<template>
  <ElDialog v-model="visible" title="编辑视频链接" width="640px" align-center :close-on-click-modal="false">
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="90px">
      <ElFormItem label="视频链接" prop="url">
        <ElInput v-model="formData.url" type="textarea" :rows="3" />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton :loading="refreshing" @click="handleRefresh">重新获取信息</ElButton>
      <ElButton @click="visible = false">取消</ElButton>
      <ElButton type="primary" :loading="submitting" @click="handleSubmit">保存</ElButton>
    </template>
  </ElDialog>
</template>
