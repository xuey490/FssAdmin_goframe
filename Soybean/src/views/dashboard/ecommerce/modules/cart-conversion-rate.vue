<script setup lang="ts">
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardEcommerceCartConversionRate' });

const chartData = [120, 132, 101, 134, 90, 230, 210];
const percentage = 1.2;

const { domRef } = useEcharts(
  () => ({
    grid: { top: 0, right: 0, bottom: 0, left: 0 },
    xAxis: {
      type: 'category',
      show: false,
      boundaryGap: false
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
        data: chartData,
        lineStyle: { width: 3, color: '#4C87F3' },
        areaStyle: {
          color: {
            type: 'linear' as const,
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(76, 135, 243, 0.2)' },
              { offset: 1, color: 'rgba(76, 135, 243, 0.01)' }
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
  <div class="art-card line-chart-card relative overflow-hidden mb-5 max-sm:mb-4">
    <div class="mb-2.5 flex-b items-start p-5">
      <div>
        <p class="text-2xl font-medium leading-none">2545</p>
        <p class="mt-1 text-sm text-g-500">购物车转化率</p>
      </div>
      <div class="text-sm font-medium text-success">+{{ percentage }}%</div>
    </div>
    <div ref="domRef" class="absolute bottom-0 left-0 right-0 w-full overflow-hidden chart-area" />
  </div>
</template>

<style scoped>
.chart-area {
  height: calc(13.5rem - 5rem);
}
</style>
