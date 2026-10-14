<script setup lang="ts">
import { onMounted } from 'vue';
import { useEcharts } from '@/hooks/common/echarts';
import ChartCard from '@/components/dashboard/chart-card.vue';

defineOptions({ name: 'DashboardVisitorInsights' });

const xAxisData = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];

const chartData = [
  { name: '老客户', data: [280, 350, 300, 250, 230, 210, 240, 280, 320, 350, 300, 200] },
  { name: '新客户', data: [260, 200, 150, 130, 180, 270, 340, 380, 300, 220, 170, 130] }
];

const colors = ['#4d8dff', '#fb7348'];

const { domRef, updateOptions } = useEcharts(() => ({
  tooltip: { trigger: 'axis' },
  legend: { data: chartData.map(item => item.name), bottom: 0 },
  grid: { left: '3%', right: '4%', bottom: '12%', top: '8%', containLabel: true },
  xAxis: {
    type: 'category',
    boundaryGap: false,
    data: xAxisData,
    axisLine: { show: false },
    axisLabel: { show: true }
  },
  yAxis: {
    type: 'value',
    axisLine: { show: false },
    splitLine: { show: true, lineStyle: { type: 'dashed' } }
  },
  series: chartData.map((item, index) => ({
    name: item.name,
    type: 'line',
    smooth: true,
    symbol: 'none',
    color: colors[index],
    data: item.data
  }))
}));

onMounted(() => {
  updateOptions(opts => {
    opts.xAxis.data = xAxisData;
    opts.legend = { data: chartData.map(item => item.name), bottom: 0 };
    opts.series = chartData.map((item, index) => ({
      name: item.name,
      type: 'line',
      smooth: true,
      symbol: 'none',
      color: colors[index],
      data: item.data
    }));
    return opts;
  });
});
</script>

<template>
  <ChartCard class="visitor-insights-card" title="访客洞察" full-height>
    <div ref="domRef" class="visitor-insights-card__chart" />
  </ChartCard>
</template>

<style scoped>
.visitor-insights-card {
  height: 328px;
  margin-bottom: 0;
  overflow: hidden;
}

.visitor-insights-card :deep(.el-card__body) {
  flex: 1;
  min-height: 0;
  overflow: hidden;
  padding-top: 8px;
}

.visitor-insights-card :deep(.chart-card__body) {
  height: 100% !important;
  min-height: 0;
}

.visitor-insights-card__chart {
  width: 100%;
  height: 100%;
  overflow: hidden;
}
</style>
