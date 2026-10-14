<script setup lang="ts">
import { ref } from 'vue';
import { useForm } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({ name: 'LoginLogSearch' });

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
      <ElFormItem :label="$t('page.safeguard.loginLog.form.username')" prop="username">
        <ElInput
          v-model="model.username"
          :placeholder="$t('page.safeguard.loginLog.form.usernamePlaceholder')"
          clearable
        />
      </ElFormItem>
      <ElFormItem :label="$t('page.safeguard.loginLog.form.ip')" prop="ip">
        <ElInput v-model="model.ip" :placeholder="$t('page.safeguard.loginLog.form.ipPlaceholder')" clearable />
      </ElFormItem>
      <ElFormItem :label="$t('page.safeguard.loginLog.form.status')" prop="status">
        <ElSelect
          v-model="model.status"
          :placeholder="$t('page.safeguard.loginLog.form.statusPlaceholder')"
          clearable
          style="width: 140px"
        >
          <ElOption :label="$t('page.safeguard.loginLog.success')" :value="1" />
          <ElOption :label="$t('page.safeguard.loginLog.failure')" :value="2" />
        </ElSelect>
      </ElFormItem>
      <ElFormItem v-show="isExpanded" :label="$t('page.safeguard.loginLog.form.loginTime')" prop="login_time">
        <ElDatePicker
          v-model="model.login_time"
          type="datetimerange"
          :range-separator="$t('page.safeguard.loginLog.form.rangeSeparator')"
          :start-placeholder="$t('page.safeguard.loginLog.form.startTime')"
          :end-placeholder="$t('page.safeguard.loginLog.form.endTime')"
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
          {{ isExpanded ? $t('table.searchBar.collapse') : $t('table.searchBar.expand') }}
          <template #icon>
            <icon-ic-round-arrow-drop-down v-if="!isExpanded" class="text-icon" />
            <icon-ic-round-arrow-drop-up v-else class="text-icon" />
          </template>
        </ElButton>
      </ElFormItem>
    </ElForm>
  </ElCard>
</template>
