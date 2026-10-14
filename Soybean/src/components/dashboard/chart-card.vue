<script setup lang="ts">
defineOptions({ name: 'DashboardChartCard' });

interface Props {
  title?: string;
  subtitle?: string;
  height?: string;
  bodyClass?: string;
  fullHeight?: boolean;
}

withDefaults(defineProps<Props>(), {
  title: '',
  subtitle: '',
  height: '360px',
  bodyClass: '',
  fullHeight: false
});
</script>

<template>
  <ElCard class="card-wrapper chart-card" :class="{ 'chart-card--full': fullHeight }" shadow="hover">
    <template v-if="title || subtitle" #header>
      <div class="flex items-center justify-between">
        <span class="font-600">{{ title }}</span>
        <span v-if="subtitle" class="text-xs text-gray-400">{{ subtitle }}</span>
      </div>
    </template>
    <div
      class="chart-card__body"
      :class="bodyClass"
      :style="fullHeight ? undefined : { height }"
    >
      <slot />
    </div>
  </ElCard>
</template>

<style scoped>
.chart-card {
  margin-bottom: 20px;
}

.chart-card--full {
  display: flex;
  flex-direction: column;
  height: 100%;
  margin-bottom: 0;
}

.chart-card--full :deep(.el-card__body) {
  display: flex;
  flex: 1;
  flex-direction: column;
}

.chart-card__body {
  width: 100%;
  overflow: hidden;
}

.chart-card--full .chart-card__body {
  flex: 1;
}
</style>
