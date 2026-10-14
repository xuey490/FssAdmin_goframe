<script setup lang="ts">
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardEcommerceTotalOrderVolume' });

const chartData = [
  { value: 30, name: '已完成' },
  { value: 25, name: '处理中' },
  { value: 45, name: '待发货' }
];

const { domRef } = useEcharts(
  () => ({
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c} ({d}%)'
    },
    series: [
      {
        type: 'pie',
        radius: ['56%', '76%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 0,
          borderWidth: 0
        },
        label: { show: false },
        labelLine: { show: false },
        data: chartData,
        color: ['#4C87F3', '#93F1B4', '#8BD8FC']
      }
    ]
  }),
  { onRender() {} }
);
</script>

<template>
  <div class="art-card h-53 p-5 pt-3.5 mb-5 max-sm:mb-4">
    <div class="art-card-header">
      <div class="title">
        <h4 class="text-2xl font-medium">205,216</h4>
        <p>这个月增长</p>
      </div>
    </div>

    <div ref="domRef" class="h-28 overflow-hidden" />
  </div>
</template>
