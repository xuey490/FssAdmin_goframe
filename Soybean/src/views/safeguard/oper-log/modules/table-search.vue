<script setup lang="ts">
import { ref } from 'vue';
import { useForm } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({ name: 'OperLogSearch' });

interface Emits {
  (e: 'reset'): void;
  (e: 'search'): void;
}

const emit = defineEmits<Emits>();

const { formRef } = useForm();

const model = defineModel<Record<string, any>>('model', { required: true });

const isExpanded = ref(false);

function handleReset() {
  emit('reset');
}

function handleSearch() {
  emit('search');
}

function toggleExpand() {
  isExpanded.value = !isExpanded.value;
}
</script>

<template>
  <ElCard class="card-wrapper">
    <ElForm ref="formRef" :model="model" label-position="right" :label-width="80" inline>
      <ElFormItem label="操作用户" prop="username">
        <ElInput v-model="model.username" placeholder="请输入操作用户" clearable />
      </ElFormItem>
      <ElFormItem label="操作路由" prop="router">
        <ElInput v-model="model.router" placeholder="请输入操作路由" clearable />
      </ElFormItem>
      <ElFormItem label="操作IP" prop="ip">
        <ElInput v-model="model.ip" placeholder="请输入操作IP" clearable />
      </ElFormItem>
      <ElFormItem v-show="isExpanded" label="操作时间" prop="create_time">
        <ElDatePicker
          v-model="model.create_time"
          type="datetimerange"
          range-separator="至"
          start-placeholder="开始时间"
          end-placeholder="结束时间"
          value-format="YYYY-MM-DD HH:mm:ss"
          clearable
        />
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
        <ElButton text type="primary" @click="toggleExpand">
          {{ isExpanded ? '收起' : '展开' }}
          <template #icon>
            <icon-ic-round-arrow-drop-down v-if="!isExpanded" class="text-icon" />
            <icon-ic-round-arrow-drop-up v-else class="text-icon" />
          </template>
        </ElButton>
      </ElFormItem>
    </ElForm>
  </ElCard>
</template>
