<script setup lang="ts">
import { onMounted } from 'vue';
import { useEcharts } from '@/hooks/common/echarts';
import ChartCard from '@/components/dashboard/chart-card.vue';

defineOptions({ name: 'DashboardTargetVsReality' });

const weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

const revenueData = [{ name: '线上销售', data: [12, 13, 5, 15, 10, 15, 18] }];

const totalItems = [
  {
    icon: 'ri:shopping-bag-line',
    iconClass: 'text-[var(--el-color-primary)] bg-[var(--el-color-primary)]/12',
    label: '实际销售额',
    subLabel: '全球',
    value: '8,823',
    valueClass: 'text-[var(--el-color-primary)]'
  },
  {
    icon: 'ri:money-dollar-circle-line',
    iconClass: 'text-[var(--el-color-primary)] bg-[var(--el-color-primary)]/12',
    label: '目标销售额',
    subLabel: '商业',
    value: '12,122',
    valueClass: 'text-[var(--el-color-primary)]'
  }
];

const { domRef, updateOptions } = useEcharts(() => ({
  tooltip: { trigger: 'axis' },
  grid: { left: '3%', right: '4%', bottom: '3%', top: '8%', containLabel: true },
  xAxis: {
    type: 'category',
    data: weekDays,
    axisLine: { show: false }
  },
  yAxis: {
    type: 'value',
    axisLine: { show: false },
    splitLine: { show: true, lineStyle: { type: 'dashed' } }
  },
  series: revenueData.map(item => ({
    name: item.name,
    type: 'bar',
    barWidth: '28%',
    color: '#4d8dff',
    data: item.data
  }))
}));

onMounted(() => {
  updateOptions(opts => {
    opts.xAxis.data = weekDays;
    opts.series = revenueData.map(item => ({
      name: item.name,
      type: 'bar',
      barWidth: '28%',
      color: '#4d8dff',
      data: item.data
    }));
    return opts;
  });
});
</script>

<template>
  <ChartCard title="目标与实际" full-height body-class="!h-auto flex-1">
    <div ref="domRef" class="h-192px shrink-0 overflow-hidden px-20px" />
    <div class="px-20px mt-16px">
      <div v-for="item in totalItems" :key="item.label" class="flex items-center mb-20px last:mb-0">
        <div class="flex items-center justify-start w-3/5 text-sm">
          <div class="w-40px h-40px mr-12px text-lg rounded-md flex items-center justify-center" :class="item.iconClass">
            <SvgIcon :icon="item.icon" />
          </div>
          <div class="flex flex-col items-start">
            <span class="text-base text-gray-800">{{ item.label }}</span>
            <span class="mt-4px text-xs text-gray-500">{{ item.subLabel }}</span>
          </div>
        </div>
        <div class="text-lg font-normal" :class="item.valueClass">{{ item.value }}</div>
      </div>
    </div>
  </ChartCard>
</template>
