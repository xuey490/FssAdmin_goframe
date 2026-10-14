<script setup lang="ts">
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardEcommerceHotCommodity' });

const lineData = [8, 40, 82, 35, 90, 52, 35];

interface WeeklyItem {
  icon: string;
  title: string;
  subtitle: string;
  value: string;
  iconBgClass: string;
  valueBgClass: string;
}

const weeklyList: WeeklyItem[] = [
  {
    icon: 'ri:money-cny-circle-line',
    title: '智能手表Pro',
    subtitle: '电子产品',
    value: '1,286件',
    iconBgClass: 'bg-theme/12 text-theme',
    valueBgClass: 'bg-theme/12 text-theme'
  },
  {
    icon: 'ri:money-cny-circle-line',
    title: '时尚连衣裙',
    subtitle: '女装服饰',
    value: '892件',
    iconBgClass: 'bg-success/12 text-success',
    valueBgClass: 'bg-success/12 text-success'
  },
  {
    icon: 'ri:money-cny-circle-line',
    title: '厨房小家电',
    subtitle: '家居用品',
    value: '756件',
    iconBgClass: 'bg-error/12 text-error',
    valueBgClass: 'bg-error/12 text-error'
  }
];

const { domRef } = useEcharts(
  () => ({
    grid: { top: 8, right: 0, left: 0, bottom: 0, containLabel: false },
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
  <div class="art-card p-5 h-[28.2rem] mb-5 max-sm:mb-4">
    <div class="art-card-header">
      <div class="title">
        <h4>热销商品</h4>
        <p>本周销售排行</p>
      </div>
    </div>
    <div ref="domRef" class="h-36 overflow-hidden" />
    <div class="mt-10 space-y-5">
      <div v-for="item in weeklyList" :key="item.title" class="flex-c">
        <div class="size-10.5 flex-cc rounded-lg" :class="item.iconBgClass">
          <SvgIcon :icon="item.icon" class="text-xl" />
        </div>
        <div class="ml-2.5">
          <p class="text-sm font-medium text-g-800">{{ item.title }}</p>
          <span class="text-sm text-g-600">{{ item.subtitle }}</span>
        </div>
        <div class="ml-auto px-3 py-1.5 text-sm text-center rounded" :class="item.valueBgClass">
          <span>+{{ item.value }}</span>
        </div>
      </div>
    </div>
  </div>
</template>
