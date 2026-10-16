<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { loginModuleRecord } from '@/constants/app';
import { fetchGetCaptcha, fetchGetTenantsByUsername } from '@/service/api';
import { useAuthStore } from '@/store/modules/auth';
import { useRouterPush } from '@/hooks/common/router';
import { useForm, useFormRules } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({ name: 'PwdLogin' });

const authStore = useAuthStore();
const { toggleLoginModule } = useRouterPush();
const { formRef, validate } = useForm();

interface FormModel {
  username: string;
  password: string;
  tenant_id?: number;
  code: string;
  uuid: string;
  rememberPassword: boolean;
}

const model = ref<FormModel>({
  username: 'admin',
  password: '123456',
  tenant_id: undefined,
  code: '',
  uuid: '',
  rememberPassword: false
});

const rules = computed<Record<keyof FormModel, App.Global.FormRule[]>>(() => {
  // inside computed to make locale ref, if not apply i18n, you can define it without computed
  const { formRules, createRequiredRule } = useFormRules();

  return {
    username: formRules.userName,
    password: formRules.pwd,
    tenant_id: [createRequiredRule($t('form.required'))],
    code: [createRequiredRule($t('form.required'))],
    uuid: [],
    rememberPassword: []
  };
});

const captchaImg = ref('');
const tenantOptions = ref<Api.Auth.TenantItem[]>([]);
const loadingTenants = ref(false);

async function loadCaptcha() {
  model.value.code = '';
  const { data, error } = await fetchGetCaptcha();
  if (!error) {
    model.value.uuid = data.uuid;
    captchaImg.value = data.image;
  }
  formRef.value?.clearValidate('code');
}

async function loadTenants() {
  if (!model.value.username) {
    tenantOptions.value = [];
    model.value.tenant_id = undefined;
    return;
  }
  loadingTenants.value = true;
  const { data, error } = await fetchGetTenantsByUsername(model.value.username);
  loadingTenants.value = false;
  if (!error) {
    tenantOptions.value = data;
    if (!tenantOptions.value.some(item => item.id === model.value.tenant_id)) {
      model.value.tenant_id = tenantOptions.value[0]?.id;
    }
  } else {
    tenantOptions.value = [];
    model.value.tenant_id = undefined;
  }
}

async function handleSubmit() {
  await validate();
  const ok = await authStore.login({
    username: model.value.username,
    password: model.value.password,
    tenant_id: Number(model.value.tenant_id),
    code: model.value.code,
    uuid: model.value.uuid,
    rememberPassword: model.value.rememberPassword
  });
  // 验证码一次性有效，输错或登录失败后清空并换一张
  if (!ok) {
    await loadCaptcha();
  }
}

type AccountKey = 'super' | 'admin' | 'user';

interface Account {
  key: AccountKey;
  label: string;
  username: string;
  password: string;
}

const accounts = computed<Account[]>(() => [
  {
    key: 'super',
    label: $t('page.login.pwdLogin.superAdmin'),
    username: 'super',
    password: '123456'
  },
  {
    key: 'admin',
    label: $t('page.login.pwdLogin.admin'),
    username: 'admin',
    password: '123456'
  },
  {
    key: 'user',
    label: $t('page.login.pwdLogin.user'),
    username: 'user',
    password: '123456'
  }
]);

async function handleAccountLogin(account: Account) {
  model.value.username = account.username;
  model.value.password = account.password;
  await loadTenants();
  await handleSubmit();
}

watch(
  () => model.value.username,
  () => {
    model.value.tenant_id = undefined;
  }
);

loadCaptcha();
</script>

<template>
  <ElForm ref="formRef" :model="model" :rules="rules" size="large" :show-label="false" @keyup.enter="handleSubmit">
    <ElFormItem prop="username">
      <ElInput
        v-model="model.username"
        :placeholder="$t('page.login.common.userNamePlaceholder')"
        @blur="loadTenants"
      />
    </ElFormItem>
    <ElFormItem prop="password">
      <ElInput
        v-model="model.password"
        type="password"
        show-password-on="click"
        :placeholder="$t('page.login.common.passwordPlaceholder')"
      />
    </ElFormItem>
    <ElFormItem prop="tenant_id">
      <ElSelect
        v-model="model.tenant_id"
        clearable
        filterable
        :loading="loadingTenants"
        placeholder="请选择租户"
        @visible-change="val => val && loadTenants()"
      >
        <ElOption v-for="tenant in tenantOptions" :key="tenant.id" :label="tenant.name" :value="tenant.id" />
      </ElSelect>
    </ElFormItem>
    <ElFormItem prop="code">
      <div class="w-full flex items-center gap-8px">
        <ElInput v-model="model.code" placeholder="请输入验证码" />
        <img
          v-if="captchaImg"
          :src="captchaImg"
          alt="captcha"
          class="h-40px w-120px cursor-pointer border border-#ddd rounded border-solid"
          @click="loadCaptcha"
        />
      </div>
    </ElFormItem>
    <ElSpace direction="vertical" :size="24" class="w-full" fill>
      <div class="flex-y-center justify-between">
        <ElCheckbox v-model="model.rememberPassword">{{ $t('page.login.pwdLogin.rememberMe') }}</ElCheckbox>
        <!--
<ElButton text @click="toggleLoginModule('reset-pwd')">
          {{ $t('page.login.pwdLogin.forgetPassword') }}
        </ElButton>
        -->
      </div>
      <ElButton type="primary" size="large" round block :loading="authStore.loginLoading" @click="handleSubmit">
        {{ $t('common.confirm') }}
      </ElButton>

      <div class="flex-y-center justify-between gap-12px">
        <!--
<ElButton class="flex-1" size="default" @click="toggleLoginModule('code-login')">
          {{ $t(loginModuleRecord['code-login']) }}
        </ElButton>
        <ElButton class="flex-1" size="default" @click="toggleLoginModule('register')">
          {{ $t(loginModuleRecord.register) }}
        </ElButton>
-->
      </div>

      <!--
<ElDivider class="text-14px text-#666 !m-0">{{ $t('page.login.pwdLogin.otherAccountLogin') }}</ElDivider>
      <div class="flex-center gap-12px">
         <ElButton
          v-for="item in accounts"
          :key="item.key"
          size="default"
          type="primary"
          :disabled="authStore.loginLoading"
          @click="handleAccountLogin(item)"
        >
          {{ item.label }}
        </ElButton>
      </div>
-->
    </ElSpace>
  </ElForm>
</template>

<style scoped></style>
