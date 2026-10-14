<script setup lang="ts">
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardEcommerceTotalProducts' });

const barData = [50, 80, 40, 90, 60, 70];

const { domRef } = useEcharts(
  () => ({
    grid: { top: 8, right: 0, left: 0, bottom: 12, containLabel: false },
    xAxis: {
      type: 'category',
      data: barData.map((_, index) => String(index + 1)),
      show: false
    },
    yAxis: {
      type: 'value',
      show: false
    },
    series: [
      {
        type: 'bar',
        data: barData,
        barWidth: 18,
        itemStyle: {
          borderRadius: 4,
          color: '#4C87F3'
        }
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
        <h4 class="text-2xl font-medium">55,231</h4>
        <p>商品总数</p>
      </div>
    </div>

    <div ref="domRef" class="h-28 overflow-hidden pb-2" />
  </div>
</template>
