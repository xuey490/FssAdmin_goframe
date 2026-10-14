<script setup lang="ts">
import { useForm } from '@/hooks/common/form';

defineOptions({ name: 'VideoSearch' });

interface Emits {
  (e: 'reset'): void;
  (e: 'search'): void;
}

const emit = defineEmits<Emits>();
const { formRef } = useForm();
const model = defineModel<Record<string, any>>('model', { required: true });
</script>

<template>
  <ElCard class="card-wrapper">
    <ElForm ref="formRef" :model="model" label-position="right" :label-width="80" inline>
      <ElFormItem label="标题" prop="title">
        <ElInput v-model="model.title" placeholder="请输入标题关键字" clearable />
      </ElFormItem>
      <ElFormItem label="作者" prop="uploader">
        <ElInput v-model="model.uploader" placeholder="请输入作者关键字" clearable />
      </ElFormItem>
      <ElFormItem>
        <ElButton @click="emit('reset')">重置</ElButton>
        <ElButton type="primary" plain @click="emit('search')">搜索</ElButton>
      </ElFormItem>
    </ElForm>
  </ElCard>
</template>
