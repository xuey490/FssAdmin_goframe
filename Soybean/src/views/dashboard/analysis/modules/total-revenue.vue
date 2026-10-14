<script setup lang="ts">
import { onMounted } from 'vue';
import { useEcharts } from '@/hooks/common/echarts';
import ChartCard from '@/components/dashboard/chart-card.vue';

defineOptions({ name: 'DashboardTotalRevenue' });

const weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

const revenueData = [
  { name: '线上销售', data: [12, 13, 5, 15, 10, 15, 18] },
  { name: '线下销售', data: [10, 11, 20, 5, 11, 13, 10] }
];

const colors = ['#4d8dff', '#69c970'];

const { domRef, updateOptions } = useEcharts(() => ({
  tooltip: { trigger: 'axis' },
  legend: { data: revenueData.map(item => item.name), bottom: 0 },
  grid: { left: '3%', right: '4%', bottom: '12%', top: '8%', containLabel: true },
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
  series: revenueData.map((item, index) => ({
    name: item.name,
    type: 'bar',
    barWidth: '18%',
    color: colors[index],
    data: item.data
  }))
}));

onMounted(() => {
  updateOptions(opts => {
    opts.xAxis.data = weekDays;
    opts.legend = { data: revenueData.map(item => item.name), bottom: 0 };
    opts.series = revenueData.map((item, index) => ({
      name: item.name,
      type: 'bar',
      barWidth: '18%',
      color: colors[index],
      data: item.data
    }));
    return opts;
  });
});
</script>

<template>
  <ChartCard title="总收入" full-height body-class="min-h-320px">
    <div ref="domRef" class="h-full min-h-360px overflow-hidden" />
  </ChartCard>
</template>
