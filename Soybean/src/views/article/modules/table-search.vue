<script setup lang="ts">
import { $t } from '@/locales';

defineOptions({ name: 'ArticleTableSearch' });

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
      <ElFormItem :label="$t('page.article.form.title')" prop="title">
        <ElInput v-model="model.title" :placeholder="$t('page.article.form.titlePlaceholder')" clearable />
      </ElFormItem>
      <ElFormItem :label="$t('page.article.form.author')" prop="author">
        <ElInput v-model="model.author" :placeholder="$t('page.article.form.authorPlaceholder')" clearable />
      </ElFormItem>
      <ElFormItem :label="$t('page.article.form.status')" prop="status">
        <SaSelect
          v-model="model.status"
          dict="data_status"
          clearable
          :placeholder="$t('page.article.form.statusPlaceholder')"
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
