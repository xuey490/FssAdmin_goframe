<script setup lang="ts">
import { ref } from 'vue';
import { useForm } from '@/hooks/common/form';

defineOptions({ name: 'OnlineSearch' });

interface Emits {
  (e: 'reset'): void;
  (e: 'search'): void;
}

const emit = defineEmits<Emits>();
const { formRef } = useForm();
const model = defineModel<Record<string, any>>('model', { required: true });
const isExpanded = ref(false);
</script>

<template>
  <ElCard class="card-wrapper">
    <ElForm ref="formRef" :model="model" label-position="right" :label-width="90" inline>
      <ElFormItem label="登录地址" prop="ipaddr">
        <ElInput v-model="model.ipaddr" placeholder="请输入登录地址" clearable />
      </ElFormItem>
      <ElFormItem label="用户账号" prop="userName">
        <ElInput v-model="model.userName" placeholder="请输入用户账号" clearable />
      </ElFormItem>
      <ElFormItem>
        <ElButton @click="emit('reset')">重置</ElButton>
        <ElButton type="primary" plain @click="emit('search')">搜索</ElButton>
      </ElFormItem>
    </ElForm>
  </ElCard>
</template>
