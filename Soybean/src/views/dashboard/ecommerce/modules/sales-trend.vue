<script setup lang="ts">
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardEcommerceSalesTrend' });

const positiveData = [50, 80, 120, 90, 60];
const negativeData = [30, 60, 90, 70, 40];
const xAxisData = ['一月', '二月', '三月', '四月', '五月'];

const { domRef } = useEcharts(
  () => ({
    grid: { top: 20, right: 0, left: 0, bottom: 0, containLabel: true },
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'none' }
    },
    xAxis: {
      type: 'category',
      data: xAxisData,
      axisLine: { show: false },
      axisTick: { show: false }
    },
    yAxis: {
      type: 'value',
      min: -100,
      max: 100,
      axisLine: { show: false },
      splitLine: { show: false }
    },
    series: [
      {
        name: '负向数据',
        type: 'bar',
        stack: 'total',
        barWidth: 16,
        barGap: '-100%',
        data: negativeData.map(val => (val > 0 ? -val : val)),
        itemStyle: {
          borderRadius: [0, 0, 10, 10],
          color: '#93F1B4'
        }
      },
      {
        name: '正向数据',
        type: 'bar',
        stack: 'total',
        barWidth: 16,
        data: positiveData,
        itemStyle: {
          borderRadius: [10, 10, 0, 0],
          color: '#4C87F3'
        }
      }
    ]
  }),
  { onRender() {} }
);
</script>

<template>
  <div class="art-card p-5 mb-5 h-105 max-sm:mb-4">
    <div class="art-card-header">
      <div class="title">
        <h4>销售趋势</h4>
        <p>月度销售对比</p>
      </div>
    </div>

    <div ref="domRef" class="h-76 overflow-hidden" />
  </div>
</template>
