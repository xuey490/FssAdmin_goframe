<script setup lang="ts">
import { computed } from 'vue';
import { useAuthStore } from '@/store/modules/auth';
import SponsorQrPopup from '@/components/custom/sponsor-qr-popup.vue';
import CardList from './modules/card-list.vue';
import ActiveUser from './modules/active-user.vue';
import SalesOverview from './modules/sales-overview.vue';
import AboutProject from './modules/about-project.vue';
import NewUser from './modules/new-user.vue';
import Dynamic from './modules/dynamic-stats.vue';
import TodoList from './modules/todo-list.vue';

defineOptions({ name: 'DashboardConsole' });
const authStore = useAuthStore();
const userInfo = computed(() => authStore.userInfo);
</script>

<template>
  <div>
    <template v-if="userInfo.dashboard === 'statistics' || !userInfo.dashboard">
      <CardList />
      <ElRow :gutter="20">
        <ElCol :lg="10" :md="12" :sm="24">
          <ActiveUser />
        </ElCol>
        <ElCol :lg="14" :md="12" :sm="24">
          <SalesOverview />
        </ElCol>
      </ElRow>
    </template>



    <template v-if="userInfo.dashboard === 'work'">
      <ElRow :gutter="20">
        <ElCol :lg="12" :md="24" :sm="24">
          <NewUser />
        </ElCol>
        <ElCol :lg="6" :md="12" :sm="24">
          <Dynamic />
        </ElCol>
        <ElCol :lg="6" :md="12" :sm="24">
          <TodoList />
        </ElCol>
      </ElRow>
    </template>
    <AboutProject />
    <SponsorQrPopup />
  </div>
</template>

