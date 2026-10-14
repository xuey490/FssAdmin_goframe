<script setup lang="ts">
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardEcommerceSalesClassification' });

const chartData = [
  { value: 30, name: '电子产品' },
  { value: 55, name: '服装鞋包' },
  { value: 36, name: '家居用品' }
];

const { domRef } = useEcharts(
  () => ({
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c} ({d}%)'
    },
    title: {
      text: '¥300,458',
      left: '50%',
      top: '50%',
      textAlign: 'center',
      textVerticalAlign: 'middle',
      textStyle: {
        fontSize: 18,
        fontWeight: 500,
        color: '#ADB0BC'
      }
    },
    series: [
      {
        type: 'pie',
        radius: ['70%', '80%'],
        center: ['50%', '50%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 0,
          borderWidth: 0
        },
        label: { show: false },
        labelLine: { show: false },
        data: chartData,
        color: ['#4C87F3', '#EDF2FF', '#8BD8FC']
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
        <h4>销售分类</h4>
        <p>按产品类别</p>
      </div>
    </div>

    <div ref="domRef" class="h-66 overflow-hidden" />

    <div class="flex justify-around">
      <div class="flex-c">
        <div class="flex-cc size-10.5 mr-2.5 text-theme bg-theme/10 rounded-lg">
          <SvgIcon icon="ri:money-cny-circle-line" class="text-xl" />
        </div>
        <div>
          <p class="text-lg">¥500,458</p>
          <span class="text-sm">总收入</span>
        </div>
      </div>
      <div class="flex-c">
        <div class="flex-cc size-10.5 mr-2.5 text-theme bg-theme/10 rounded-lg">
          <SvgIcon icon="ri:heart-3-line" class="text-xl" />
        </div>
        <div>
          <p class="text-lg">¥130,580</p>
          <span class="text-sm">净利润</span>
        </div>
      </div>
    </div>
  </div>
</template>
