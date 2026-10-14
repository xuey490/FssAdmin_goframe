<script setup lang="ts">
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardEcommerceProductSales' });

const barData = [50, 80, 50, 90, 60, 70, 50];

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
        barWidth: 16,
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
  <div class="art-card p-5 pt-3.5 mb-5 h-46 max-sm:mb-4">
    <div class="art-card-header">
      <div class="title">
        <h4 class="text-2xl">
          <span>14.5k</span>
          <SvgIcon icon="ri:arrow-right-up-line" class="text-success text-lg ml-1" />
        </h4>
        <p>销售量</p>
      </div>
    </div>

    <div ref="domRef" class="h-22.4 overflow-hidden pb-2" />
  </div>
</template>
