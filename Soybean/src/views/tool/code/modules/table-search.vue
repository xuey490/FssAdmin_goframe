<script setup lang="ts">
import { $t } from '@/locales';

defineOptions({ name: 'CodeGenerateTableSearch' });

interface Emits {
  (e: 'reset'): void;
  (e: 'search'): void;
}

const emit = defineEmits<Emits>();

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
    <ElForm :model="model" label-position="right" :label-width="80" inline>
      <ElFormItem :label="$t('page.tool.code.form.tableName')" prop="table_name">
        <ElInput
          v-model="model.table_name"
          :placeholder="$t('page.tool.code.form.tableNamePlaceholder')"
          clearable
        />
      </ElFormItem>
      <ElFormItem :label="$t('page.tool.code.form.source')" prop="source">
        <ElInput v-model="model.source" :placeholder="$t('page.tool.code.form.sourcePlaceholder')" clearable />
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
