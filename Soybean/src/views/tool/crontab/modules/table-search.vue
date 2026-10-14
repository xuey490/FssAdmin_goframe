<script setup lang="ts">
import { $t } from '@/locales';

defineOptions({ name: 'CrontabTableSearch' });

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
      <ElFormItem :label="$t('page.tool.crontab.form.name')" prop="name">
        <ElInput v-model="model.name" :placeholder="$t('page.tool.crontab.form.namePlaceholder')" clearable />
      </ElFormItem>
      <ElFormItem :label="$t('page.tool.crontab.form.type')" prop="type">
        <SaSelect
          v-model="model.type"
          dict="crontab_task_type"
          clearable
          :placeholder="$t('page.tool.crontab.form.typePlaceholder')"
          style="width: 140px"
        />
      </ElFormItem>
      <ElFormItem :label="$t('page.tool.crontab.form.status')" prop="status">
        <SaSelect
          v-model="model.status"
          dict="data_status"
          clearable
          :placeholder="$t('page.tool.crontab.form.statusPlaceholder')"
          style="width: 140px"
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
      </ElFormItem>
    </ElForm>
  </ElCard>
</template>
