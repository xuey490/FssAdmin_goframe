<script setup lang="ts">
import { enableStatusOptions } from '@/constants/business';
import { translateOptions } from '@/utils/common';
import { $t } from '@/locales';

defineOptions({ name: 'PostSearch' });

interface Emits {
  (e: 'reset'): void;
  (e: 'search'): void;
}

const emit = defineEmits<Emits>();

const model = defineModel<Api.Post.PostSearchParams>('model', { required: true });

function reset() {
  emit('reset');
}

function search() {
  emit('search');
}
</script>

<template>
  <ElCard class="card-wrapper">
    <ElForm :model="model" label-position="right" :label-width="80">
      <ElRow :gutter="24">
        <ElCol :lg="6" :md="8" :sm="12">
          <ElFormItem :label="$t('page.manage.post.postName')" prop="name">
            <ElInput v-model="model.name" :placeholder="$t('page.manage.post.form.postName')" clearable />
          </ElFormItem>
        </ElCol>
        <ElCol :lg="6" :md="8" :sm="12">
          <ElFormItem :label="$t('page.manage.post.postCode')" prop="code">
            <ElInput v-model="model.code" :placeholder="$t('page.manage.post.form.postCode')" clearable />
          </ElFormItem>
        </ElCol>
        <ElCol :lg="6" :md="8" :sm="12">
          <ElFormItem :label="$t('page.manage.post.postStatus')" prop="status">
            <ElSelect v-model="model.status" :placeholder="$t('page.manage.post.form.postStatus')" clearable>
              <ElOption
                v-for="{ label, value } in translateOptions(enableStatusOptions)"
                :key="value"
                :label="label"
                :value="value"
              />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :lg="6" :md="24" :sm="24">
          <ElSpace class="w-full justify-end" alignment="end">
            <ElButton @click="reset">
              <template #icon>
                <icon-ic-round-refresh class="text-icon" />
              </template>
              {{ $t('common.reset') }}
            </ElButton>
            <ElButton type="primary" plain @click="search">
              <template #icon>
                <icon-ic-round-search class="text-icon" />
              </template>
              {{ $t('common.search') }}
            </ElButton>
          </ElSpace>
        </ElCol>
      </ElRow>
    </ElForm>
  </ElCard>
</template>
