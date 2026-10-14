<script setup lang="ts">
import { onMounted } from 'vue';
import { useEcharts } from '@/hooks/common/echarts';
import ChartCard from '@/components/dashboard/chart-card.vue';
import { hexToRgb } from '@/utils/ui';

defineOptions({ name: 'DashboardCustomerSatisfaction' });

const xAxisData = ['1', '2', '3', '4', '5', '6', '7'];

const chartData = [
  { name: '上个月', data: [65, 72, 68, 75, 82, 78, 85] },
  { name: '本月', data: [78, 85, 82, 88, 92, 89, 95] }
];

const colors = ['#4d8dff', '#fb7348'];

function buildAreaStyle(color: string) {
  const rgb = hexToRgb(color);
  return {
    color: {
      type: 'linear' as const,
      x: 0,
      y: 0,
      x2: 0,
      y2: 1,
      colorStops: [
        { offset: 0, color: `rgba(${rgb}, 0.08)` },
        { offset: 1, color: `rgba(${rgb}, 0)` }
      ]
    }
  };
}

const { domRef, updateOptions } = useEcharts(() => ({
  tooltip: { trigger: 'axis' },
  legend: { data: chartData.map(item => item.name), bottom: 0 },
  grid: { left: '3%', right: '4%', bottom: '12%', top: '8%', containLabel: true },
  xAxis: {
    type: 'category',
    boundaryGap: false,
    data: xAxisData,
    axisLine: { show: false },
    axisLabel: { show: true }
  },
  yAxis: {
    type: 'value',
    axisLine: { show: false },
    splitLine: { show: true, lineStyle: { type: 'dashed' } }
  },
  series: chartData.map((item, index) => ({
    name: item.name,
    type: 'line',
    smooth: true,
    symbol: 'none',
    color: colors[index],
    areaStyle: buildAreaStyle(colors[index]),
    data: item.data
  }))
}));

onMounted(() => {
  updateOptions(opts => {
    if (opts.xAxis && !Array.isArray(opts.xAxis)) {
      opts.xAxis.data = xAxisData;
    }
    opts.legend = { data: chartData.map(item => item.name), bottom: 0 };
    opts.series = chartData.map((item, index) => ({
      name: item.name,
      type: 'line',
      smooth: true,
      symbol: 'none',
      color: colors[index],
      areaStyle: buildAreaStyle(colors[index]),
      data: item.data
    }));
    return opts;
  });
});
</script>

<template>
  <ChartCard title="客户满意度" full-height body-class="min-h-320px">
    <div ref="domRef" class="h-full min-h-360px overflow-hidden" />
  </ChartCard>
</template>
