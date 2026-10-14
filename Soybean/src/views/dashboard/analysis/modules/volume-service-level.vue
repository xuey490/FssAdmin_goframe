<script setup lang="ts">
import { onMounted } from 'vue';
import { useEcharts } from '@/hooks/common/echarts';
import ChartCard from '@/components/dashboard/chart-card.vue';

defineOptions({ name: 'DashboardVolumeServiceLevel' });

const serviceCategories = ['产品A', '产品B', '产品C', '产品D', '产品E'];

const volumeServiceData = [
  { name: '业务量', data: [20, 25, 30, 35, 40], stack: 'total' },
  { name: '服务量', data: [30, 35, 40, 45, 50], stack: 'total' }
];

const colors = ['#4d8dff', '#fb7348'];

const { domRef, updateOptions } = useEcharts(() => ({
  tooltip: { trigger: 'axis' },
  legend: { data: volumeServiceData.map(item => item.name), bottom: 0 },
  grid: { left: '3%', right: '4%', bottom: '12%', top: '12%', containLabel: true },
  xAxis: {
    type: 'category',
    data: serviceCategories,
    axisLine: { show: false }
  },
  yAxis: {
    type: 'value',
    axisLine: { show: false },
    splitLine: { show: true, lineStyle: { type: 'dashed' } }
  },
  series: volumeServiceData.map((item, index) => ({
    name: item.name,
    type: 'bar',
    stack: item.stack,
    barWidth: '22%',
    color: colors[index],
    data: item.data
  }))
}));

onMounted(() => {
  updateOptions(opts => {
    opts.xAxis.data = serviceCategories;
    opts.legend = { data: volumeServiceData.map(item => item.name), bottom: 0 };
    opts.series = volumeServiceData.map((item, index) => ({
      name: item.name,
      type: 'bar',
      stack: item.stack,
      barWidth: '22%',
      color: colors[index],
      data: item.data
    }));
    return opts;
  });
});
</script>

<template>
  <ChartCard title="业务量与服务水平" full-height body-class="pt-24px">
    <div ref="domRef" class="h-full min-h-360px overflow-hidden" />
  </ChartCard>
</template>
