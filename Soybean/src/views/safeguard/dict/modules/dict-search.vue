<script setup lang="ts">
import { useForm } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({ name: 'DictDataSearch' });

interface Emits {
  (e: 'reset'): void;
  (e: 'search'): void;
}

const emit = defineEmits<Emits>();

const { formRef } = useForm();

const model = defineModel<Record<string, any>>('model', { required: true });

function handleReset() {
  emit('reset');
}

function handleSearch() {
  emit('search');
}
</script>

<template>
  <ElCard class="card-wrapper">
    <ElForm ref="formRef" :model="model" label-position="right" :label-width="80" inline>
      <ElFormItem label="字典标签" prop="label">
        <ElInput v-model="model.label" placeholder="请输入字典标签" clearable />
      </ElFormItem>
      <ElFormItem label="字典键值" prop="value">
        <ElInput v-model="model.value" placeholder="请输入字典键值" clearable />
      </ElFormItem>
      <ElFormItem label="状态" prop="status">
        <ElSelect v-model="model.status" clearable placeholder="请选择状态" style="width: 120px">
          <ElOption label="启用" :value="1" />
          <ElOption label="禁用" :value="0" />
        </ElSelect>
      </ElFormItem>
      <ElFormItem>
        <ElButton @click="handleReset">
          <template #icon>
            <icon-ic-round-refresh class="text-icon" />
          </template>
          {{ $t('common.reset') }}
        </ElButton>
        <ElButton type="primary" plain @click="handleSearch">
          <template #icon>
            <icon-ic-round-search class="text-icon" />
          </template>
          {{ $t('common.search') }}
        </ElButton>
      </ElFormItem>
    </ElForm>
  </ElCard>
</template>
