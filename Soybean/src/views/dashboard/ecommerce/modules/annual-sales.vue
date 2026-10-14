<script setup lang="ts">
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardEcommerceAnnualSales' });

const barData = [50, 80, 50, 90, 60, 70, 50];

const { domRef } = useEcharts(
  () => ({
    grid: { top: 8, right: 0, left: 0, bottom: 0, containLabel: false },
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
        barWidth: 26,
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
  <div class="art-card p-5 h-[28.2rem] mb-5 max-sm:mb-4">
    <div class="art-card-header">
      <div class="title">
        <h4>年度销售额</h4>
        <p>按季度统计</p>
      </div>
    </div>

    <div ref="domRef" class="annual-sales-chart overflow-hidden" />

    <div class="flex justify-around mt-10">
      <div class="flex-c">
        <div class="flex-cc size-10.5 mr-2.5 text-theme bg-theme/10 rounded-lg">
          <SvgIcon icon="ri:money-cny-circle-line" class="text-xl" />
        </div>
        <div>
          <p class="text-lg">¥200,858</p>
          <span class="text-sm">线上销售</span>
        </div>
      </div>
      <div class="flex-c">
        <div class="flex-cc size-10.5 mr-2.5 text-theme bg-theme/10 rounded-lg">
          <SvgIcon icon="ri:heart-3-line" class="text-xl" />
        </div>
        <div>
          <p class="text-lg">¥102,927</p>
          <span class="text-sm">线下销售</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.annual-sales-chart {
  height: calc(100% - 155px);
}
</style>
