<script setup lang="ts">
import { enableStatusOptions } from '@/constants/business';
import { translateOptions } from '@/utils/common';
import { $t } from '@/locales';

defineOptions({ name: 'TenantSearch' });

interface Emits {
  (e: 'reset'): void;
  (e: 'search'): void;
}

const emit = defineEmits<Emits>();

const model = defineModel<Api.Tenant.TenantSearchParams>('model', { required: true });

function reset() {
  emit('reset');
}

function search() {
  emit('search');
}
</script>

<template>
  <ElCard class="card-wrapper">
    <ElForm :model="model" label-position="right" :label-width="90">
      <ElRow :gutter="24">
        <ElCol :lg="6" :md="8" :sm="12">
          <ElFormItem label="租户名称" prop="tenant_name">
            <ElInput v-model="model.tenant_name" placeholder="请输入租户名称" clearable />
          </ElFormItem>
        </ElCol>
        <ElCol :lg="6" :md="8" :sm="12">
          <ElFormItem label="租户编码" prop="tenant_code">
            <ElInput v-model="model.tenant_code" placeholder="请输入租户编码" clearable />
          </ElFormItem>
        </ElCol>
        <ElCol :lg="6" :md="8" :sm="12">
          <ElFormItem label="状态" prop="status">
            <ElSelect v-model="model.status" clearable placeholder="请选择状态">
              <ElOption
                v-for="{ label, value } in translateOptions(enableStatusOptions)"
                :key="value"
                :label="label"
                :value="value"
              ></ElOption>
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

<style scoped></style>
