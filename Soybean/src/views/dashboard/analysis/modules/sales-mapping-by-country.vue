<script setup lang="ts">
import { onMounted } from 'vue';
import { useEcharts } from '@/hooks/common/echarts';
import ChartCard from '@/components/dashboard/chart-card.vue';

defineOptions({ name: 'DashboardSalesMappingByCountry' });

const pieData = [
  { value: 30, name: '北京' },
  { value: 25, name: '上海' },
  { value: 45, name: '广州' }
];

const colors = ['#4C87F3', '#93F1B4', '#8BD8FC'];

const { domRef, updateOptions } = useEcharts(() => ({
  tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
  series: [
    {
      name: '数据占比',
      type: 'pie',
      radius: ['46%', '60%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 10,
        borderColor: '#fff',
        borderWidth: 0
      },
      label: { show: false },
      emphasis: {
        label: { show: false, fontSize: 14, fontWeight: 'bold' }
      },
      labelLine: { show: false },
      data: pieData,
      color: colors
    }
  ]
}));

onMounted(() => {
  updateOptions(opts => {
    opts.series = [
      {
        name: '数据占比',
        type: 'pie',
        radius: ['46%', '60%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 0
        },
        label: { show: false },
        emphasis: {
          label: { show: false, fontSize: 14, fontWeight: 'bold' }
        },
        labelLine: { show: false },
        data: pieData,
        color: colors
      }
    ];
    return opts;
  });
});
</script>

<template>
  <ChartCard title="全国销售分布" full-height>
    <div ref="domRef" class="h-full min-h-360px overflow-hidden" />
  </ChartCard>
</template>
