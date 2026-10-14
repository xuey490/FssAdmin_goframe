<script setup lang="ts">
import { onMounted } from 'vue';
import { fetchLoginChart } from '@/service/api';
import ChartCard from '@/components/dashboard/chart-card.vue';
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardConsoleSalesOverview' });

const { domRef, updateOptions } = useEcharts(() => ({
  tooltip: { trigger: 'axis' },
  grid: { left: '3%', right: '4%', bottom: '3%', top: '8%', containLabel: true },
  xAxis: {
    type: 'category',
    boundaryGap: false,
    data: [] as string[],
    axisLine: { show: false }
  },
  yAxis: {
    type: 'value',
    axisLine: { show: false }
  },
  series: [
    {
      type: 'line',
      smooth: true,
      showSymbol: false,
      data: [] as number[],
      color: '#409eff',
      areaStyle: {
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 0,
          y2: 1,
          colorStops: [
            { offset: 0, color: 'rgba(64, 158, 255, 0.35)' },
            { offset: 1, color: 'rgba(64, 158, 255, 0.02)' }
          ]
        }
      }
    }
  ]
}));

onMounted(async () => {
  const { data, error } = await fetchLoginChart();
  if (!error && data) {
    updateOptions(opts => {
      opts.xAxis.data = data.login_date ?? [];
      opts.series[0].data = data.login_count ?? [];
      return opts;
    });
  }
});
</script>

<template>
  <ChartCard title="近期登录统计" height="360px">
    <div ref="domRef" class="h-full w-full overflow-hidden" />
  </ChartCard>
</template>
