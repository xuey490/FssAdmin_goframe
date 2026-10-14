<script setup lang="ts">
import { enableStatusOptions } from '@/constants/business';
import { useForm } from '@/hooks/common/form';
import { translateOptions } from '@/utils/common';
import { $t } from '@/locales';

defineOptions({ name: 'UserTableSearch' });

interface Emits {
  (e: 'reset'): void;
  (e: 'search'): void;
}

const emit = defineEmits<Emits>();

const { formRef } = useForm();

const model = defineModel<Api.SystemManage.UserSearchParams>('model', { required: true });

function reset() {
  emit('reset');
}

function search() {
  emit('search');
}
</script>

<template>
  <ElCard class="card-wrapper">
    <ElForm ref="formRef" :model="model" label-position="right" :label-width="80" inline>
      <ElFormItem :label="$t('page.manage.user.userName')" prop="username">
        <ElInput v-model="model.username" :placeholder="$t('page.manage.user.form.userName')" clearable />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.user.userPhone')" prop="phone">
        <ElInput v-model="model.phone" :placeholder="$t('page.manage.user.form.userPhone')" clearable />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.user.userStatus')" prop="status">
        <ElSelect v-model="model.status" clearable :placeholder="$t('page.manage.user.form.userStatus')" style="width: 120px">
          <ElOption
            v-for="{ label, value } in translateOptions(enableStatusOptions)"
            :key="value"
            :label="label"
            :value="value"
          />
        </ElSelect>
      </ElFormItem>
      <ElFormItem>
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
      </ElFormItem>
    </ElForm>
  </ElCard>
</template>
