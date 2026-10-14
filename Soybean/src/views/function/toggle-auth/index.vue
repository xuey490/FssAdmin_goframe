<script setup lang="ts">
import { computed, ref } from 'vue';
import { useRoute } from 'vue-router';
import { useLoading } from '@sa/hooks';
import { fetchGetCaptcha, fetchGetTenantsByUsername } from '@/service/api';
import { useAppStore } from '@/store/modules/app';
import { useAuthStore } from '@/store/modules/auth';
import { useTabStore } from '@/store/modules/tab';
import { useAuth } from '@/hooks/business/auth';
import { $t } from '@/locales';

defineOptions({ name: 'ToggleAuth' });

const route = useRoute();
const appStore = useAppStore();
const authStore = useAuthStore();
const tabStore = useTabStore();
const { hasAuth } = useAuth();
const { loading, startLoading, endLoading } = useLoading();

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

const loginAccount = ref<AccountKey>('super');

async function handleToggleAccount(account: Account) {
  loginAccount.value = account.key;

  startLoading();
  const [{ data: captcha, error: captchaError }, { data: tenants, error: tenantError }] = await Promise.all([
    fetchGetCaptcha(),
    fetchGetTenantsByUsername(account.username)
  ]);

  if (!captchaError && !tenantError && tenants.length) {
    await authStore.login(
      {
        username: account.username,
        password: account.password,
        tenant_id: tenants[0].id,
        code: '0000',
        uuid: captcha.uuid
      },
      false
    );
  }
  tabStore.initTabStore(route);
  endLoading();
  appStore.reloadPage();
}
</script>

<template>
  <ElSpace direction="vertical" fill :size="16">
    <ElCard :header="$t('route.function_toggle-auth')" class="card-wrapper">
      <ElDescriptions direction="vertical" border :column="1">
        <ElDescriptionsItem :label="$t('page.manage.user.userRole')">
          <ElSpace>
            <ElTag v-for="role in authStore.userInfo.roles" :key="role">{{ role }}</ElTag>
          </ElSpace>
        </ElDescriptionsItem>
        <ElDescriptionsItem ions-item :label="$t('page.function.toggleAuth.toggleAccount')">
          <ElSpace>
            <ElButton
              v-for="account in accounts"
              :key="account.key"
              :loading="loading && loginAccount === account.key"
              :disabled="loading && loginAccount !== account.key"
              @click="handleToggleAccount(account)"
            >
              {{ account.label }}
            </ElButton>
          </ElSpace>
        </ElDescriptionsItem>
      </ElDescriptions>
    </ElCard>
    <ElCard :header="$t('page.function.toggleAuth.authHook')" class="card-wrapper">
      <ElSpace>
        <ElButton v-if="hasAuth('B_CODE1')">{{ $t('page.function.toggleAuth.superAdminVisible') }}</ElButton>
        <ElButton v-if="hasAuth('B_CODE2')">{{ $t('page.function.toggleAuth.adminVisible') }}</ElButton>
        <ElButton v-if="hasAuth('B_CODE3')">
          {{ $t('page.function.toggleAuth.adminOrUserVisible') }}
        </ElButton>
      </ElSpace>
    </ElCard>
  </ElSpace>
</template>

<style scoped></style>
