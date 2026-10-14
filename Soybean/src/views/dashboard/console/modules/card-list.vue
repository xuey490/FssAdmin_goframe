<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { fetchStatistics } from '@/service/api';
import StatCard from '@/components/dashboard/stat-card.vue';

defineOptions({ name: 'DashboardConsoleCardList' });

const statData = ref({
  user: 0,
  attach: 0,
  login: 0,
  operate: 0
});

onMounted(async () => {
  const { data, error } = await fetchStatistics();
  if (!error && data) {
    statData.value = {
      user: data.user ?? 0,
      attach: data.attach ?? 0,
      login: data.login ?? 0,
      operate: data.operate ?? 0
    };
  }
});
</script>

<template>
  <ElRow :gutter="20">
    <ElCol :lg="6" :md="6" :sm="12">
      <StatCard
        title="用户统计"
        :value="statData.user"
        desc="较上周"
        trend="+10%"
        icon="ri:group-line"
        theme="blue"
      />
    </ElCol>
    <ElCol :lg="6" :md="6" :sm="12">
      <StatCard
        title="附件统计"
        :value="statData.attach"
        desc="较上周"
        trend="+10%"
        icon="ri:attachment-line"
        theme="green"
      />
    </ElCol>
    <ElCol :lg="6" :md="6" :sm="12">
      <StatCard
        title="登录统计"
        :value="statData.login"
        desc="较上周"
        trend="+12%"
        icon="ri:fire-line"
        theme="orange"
      />
    </ElCol>
    <ElCol :lg="6" :md="6" :sm="12">
      <StatCard
        title="操作统计"
        :value="statData.operate"
        desc="较上周"
        trend="-5%"
        icon="ri:pie-chart-line"
        theme="purple"
      />
    </ElCol>
  </ElRow>
</template>
