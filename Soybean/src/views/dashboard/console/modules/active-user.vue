<script setup lang="ts">
import { onMounted } from 'vue';
import { fetchLoginBarChart } from '@/service/api';
import ChartCard from '@/components/dashboard/chart-card.vue';
import { useEcharts } from '@/hooks/common/echarts';

defineOptions({ name: 'DashboardConsoleActiveUser' });

const { domRef, updateOptions } = useEcharts(() => ({
  tooltip: { trigger: 'axis' },
  grid: { left: '3%', right: '4%', bottom: '3%', top: '8%', containLabel: true },
  xAxis: {
    type: 'category',
    data: [] as string[],
    axisLine: { show: false }
  },
  yAxis: {
    type: 'value',
    axisLine: { show: false }
  },
  series: [
    {
      type: 'bar',
      barWidth: '50%',
      data: [] as number[],
      color: '#409eff'
    }
  ]
}));

onMounted(async () => {
  const { data, error } = await fetchLoginBarChart();
  if (!error && data) {
    const barData = data as Api.Dashboard.LoginBarChartData & { login_month?: string[] };
    updateOptions(opts => {
      opts.xAxis.data = barData.login_month ?? barData.login_date ?? [];
      opts.series[0].data = barData.login_count ?? [];
      return opts;
    });
  }
});
</script>

<template>
  <ChartCard title="月度登录汇总" height="360px">
    <div ref="domRef" class="h-full w-full overflow-hidden" />
  </ChartCard>
</template>
