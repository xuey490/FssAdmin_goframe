<script setup lang="ts">
import { reactive, ref, watch } from 'vue';
import type { FormInstance, FormRules } from 'element-plus';
import { ElMessage } from 'element-plus';
import { fetchCreateVideo } from '@/service/api';

defineOptions({ name: 'VideoCreateDialog' });

const visible = defineModel<boolean>({ default: false });
const emit = defineEmits<{ success: [] }>();

const formRef = ref<FormInstance>();
const submitting = ref(false);
const formData = reactive({
  urlsText: '',
  enqueue: false
});

const rules: FormRules = {
  urlsText: [{ required: true, message: '请输入视频链接', trigger: 'blur' }]
};

watch(visible, val => {
  if (val) {
    formData.urlsText = '';
    formData.enqueue = false;
  }
});

async function handleSubmit() {
  await formRef.value?.validate();
  const urls = formData.urlsText
    .split(/\r?\n/)
    .map(s => s.trim())
    .filter(Boolean);
  if (!urls.length) {
    ElMessage.warning('请输入至少一个链接');
    return;
  }
  submitting.value = true;
  try {
    const { data, error } = await fetchCreateVideo({ urls, enqueue: formData.enqueue });
    if (error) return;
    const n = Array.isArray(data) ? data.length : 0;
    ElMessage.success(n > 0 ? `保存成功，新增 ${n} 条` : '保存成功');
    visible.value = false;
    emit('success');
  } finally {
    submitting.value = false;
  }
}
</script>

<template>
  <ElDialog v-model="visible" title="新建视频链接" width="640px" align-center :close-on-click-modal="false">
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
      <ElFormItem label="视频链接" prop="urlsText">
        <ElInput
          v-model="formData.urlsText"
          type="textarea"
          :rows="10"
          placeholder="每行一个链接。合集 / B 站多 P 会在保存前自动解析并拆成单集入库"
        />
      </ElFormItem>
      <ElFormItem label="下载队列">
        <ElCheckbox v-model="formData.enqueue">保存后加入下载队列（元数据获取成功后自动下载最佳画质）</ElCheckbox>
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="visible = false">取消</ElButton>
      <ElButton type="primary" :loading="submitting" @click="handleSubmit">保存</ElButton>
    </template>
  </ElDialog>
</template>
