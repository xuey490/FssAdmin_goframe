<script setup lang="ts">
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardEcommerceSalesGrowth' });

const lineData = [50, 85, 65, 95, 75, 130, 180];

const { domRef } = useEcharts(
  () => ({
    grid: { top: 8, right: 0, left: 0, bottom: 12, containLabel: false },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: lineData.map((_, index) => String(index + 1)),
      show: false
    },
    yAxis: {
      type: 'value',
      show: false
    },
    series: [
      {
        type: 'line',
        smooth: true,
        showSymbol: false,
        data: lineData,
        lineStyle: { width: 2.5, color: '#4C87F3' },
        areaStyle: {
          color: {
            type: 'linear' as const,
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(76, 135, 243, 0.2)' },
              { offset: 1, color: 'rgba(76, 135, 243, 0.02)' }
            ]
          }
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
          <span>12%</span>
          <SvgIcon icon="ri:arrow-right-up-line" class="text-success text-lg ml-1" />
        </h4>
        <p>增长</p>
      </div>
    </div>

    <div ref="domRef" class="h-20 overflow-hidden pb-2" />
  </div>
</template>
