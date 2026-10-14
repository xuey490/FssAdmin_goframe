<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue';
import * as echarts from 'echarts';
import { Clock, Connection, Coin, TrendCharts } from '@element-plus/icons-vue';
import { fetchGetRedisInfo, fetchGetRedisMonitor } from '@/service/api';

defineOptions({ name: 'RedisMonitor' });

const redisData = ref<any>({});
const loading = ref(true);

// The API may return structured or flat data — use flexible access
const rawData = computed(() => redisData.value || {});
const variableData = computed(() => {
  // Handle both flat (variable sub-object) and structured (back type) shapes
  const d = rawData.value;
  if (d.variable) return d.variable;
  // Map structured back type to flat fields
  return {
    used_memory: d.memory?.used ? parseMemoryBytes(d.memory.used) : undefined,
    used_memory_peak: d.memory?.peak ? parseMemoryBytes(d.memory.peak) : undefined,
    used_memory_rss: d.memory?.total ? parseMemoryBytes(d.memory.total) : undefined,
    mem_fragmentation_ratio: d.memory?.fragmentation ? parseFloat(d.memory.fragmentation) : undefined,
    keyspace_hits: d.stats?.hits ? parseFloat(d.stats.hits) : 0,
    keyspace_misses: d.stats?.misses ? parseFloat(d.stats.misses) : 0,
    expired_keys: d.stats?.expires ? parseFloat(d.stats.expires) : 0,
    instantaneous_ops_per_sec: d.stats?.commands ? parseFloat(d.stats.commands) : 0,
    total_commands_processed: d.stats?.commands ? parseFloat(d.stats.commands) : 0,
    redis_version: d.version,
    redis_mode: d.mode,
    os: d.os,
    connected_clients: d.clients ? parseFloat(d.clients) : 0,
    // Keep original for table display
    _original: d
  };
});

const hitRate = computed(() => {
  const v = variableData.value;
  const hits = v.keyspace_hits || 0;
  const misses = v.keyspace_misses || 0;
  const total = hits + misses;
  return total > 0 ? (hits / total) * 100 : 0;
});

const coreMetrics = computed(() => {
  const d = rawData.value;
  const v = variableData.value;
  return [
    { title: '运行时间', value: formatUptime(d.uptime_in_seconds || 0), desc: d.uptime_in_days ? `${d.uptime_in_days} 天` : '系统运行', icon: Clock, theme: 'blue' },
    { title: '连接数', value: d.connected_clients || v.connected_clients || 0, desc: '当前活跃连接', icon: Connection, theme: 'green' },
    { title: '内存使用', value: formatBytes(v.used_memory || 0), desc: '当前占用', icon: Coin, theme: 'orange' },
    { title: 'OPS', value: v.instantaneous_ops_per_sec || 0, desc: '每秒操作数', icon: TrendCharts, theme: 'purple' }
  ];
});

const performanceMetrics = computed(() => {
  const v = variableData.value;
  return [
    { label: '每秒操作', value: v.instantaneous_ops_per_sec || 0 },
    { label: '输入流量', value: '-' },
    { label: '输出流量', value: '-' },
    { label: '总命令数', value: formatNumber(v.total_commands_processed || 0) }
  ];
});

const tableData = computed(() => {
  const v = variableData.value;
  const d = rawData.value;
  if (!v || Object.keys(v).length === 0) return [];

  const entries: [string, any][] = [];
  // Use original data if available, otherwise variable data
  const source = v._original ? { ...v._original, ...v } : v;
  delete source._original;

  for (const [key, value] of Object.entries(source)) {
    if (value !== undefined && value !== null && key !== '_original') {
      entries.push([key, value]);
    }
  }
  return entries.map(([key, value]) => ({
    key: key.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase()),
    value: formatTableValue(value)
  }));
});

// Charts
const memoryChartRef = ref<HTMLDivElement | null>(null);
const hitRateChartRef = ref<HTMLDivElement | null>(null);
let memoryChartInstance: echarts.ECharts | null = null;
let hitRateChartInstance: echarts.ECharts | null = null;
let resizeHandler: (() => void) | null = null;

function formatUptime(seconds: number) {
  if (!seconds) return '0天0小时';
  const days = Math.floor(seconds / 86400);
  const hours = Math.floor((seconds % 86400) / 3600);
  if (days > 0) return `${days}天${hours}小时`;
  const mins = Math.floor((seconds % 3600) / 60);
  return `${hours}小时${mins}分`;
}

function parseMemoryBytes(val: string): number {
  if (typeof val === 'number') return val;
  const num = parseFloat(val);
  return isNaN(num) ? 0 : num;
}

function formatBytes(bytes: number | string) {
  if (typeof bytes !== 'number') return bytes || '-';
  if (bytes >= 1024 ** 3) return `${(bytes / 1024 ** 3).toFixed(2)} GB`;
  if (bytes >= 1024 ** 2) return `${(bytes / 1024 ** 2).toFixed(2)} MB`;
  if (bytes >= 1024) return `${(bytes / 1024).toFixed(2)} KB`;
  return `${bytes} B`;
}

function formatNumber(num: number | string) {
  if (typeof num !== 'number') return num || '-';
  if (num >= 1000000) return `${(num / 1000000).toFixed(2)} M`;
  if (num >= 1000) return `${(num / 1000).toFixed(2)} K`;
  return num.toString();
}

function formatTableValue(value: any): string {
  if (value === null || value === undefined) return '-';
  if (typeof value === 'number') return formatNumber(value);
  if (typeof value === 'boolean') return value ? '是' : '否';
  return String(value);
}

function createPieOption(value: number, total: number, centerText: string, color1: string, color2: string) {
  return {
    tooltip: { trigger: 'item' },
    series: [{
      type: 'pie',
      radius: ['55%', '75%'],
      center: ['50%', '50%'],
      avoidLabelOverlap: false,
      label: { show: false },
      data: [
        { value, name: '已用', itemStyle: { color: color1 } },
        { value: Math.max(0, total - value), name: '剩余', itemStyle: { color: color2 } }
      ]
    }],
    graphic: {
      elements: [
        { type: 'text', left: 'center', top: '40%', style: { text: centerText, textAlign: 'center', fill: '#303133', fontSize: 14, fontWeight: 'bold' } },
        { type: 'text', left: 'center', top: '55%', style: { text: '已用', textAlign: 'center', fill: '#909399', fontSize: 12 } }
      ]
    }
  };
}

function initMemoryChart() {
  if (!memoryChartRef.value || !variableData.value) return;
  memoryChartInstance?.dispose();
  memoryChartInstance = echarts.init(memoryChartRef.value!);
  const used = variableData.value.used_memory || 0;
  const peak = variableData.value.used_memory_peak || used;
  const total = Math.max(used, peak) * 1.2;
  memoryChartInstance.setOption(createPieOption(used, total, formatBytes(used), '#409EFF', '#E6F7FF'));
}

function initHitRateChart() {
  if (!hitRateChartRef.value || !variableData.value) return;
  hitRateChartInstance?.dispose();
  hitRateChartInstance = echarts.init(hitRateChartRef.value!);
  const hits = variableData.value.keyspace_hits || 0;
  const misses = variableData.value.keyspace_misses || 0;
  const total = hits + misses || 1;
  hitRateChartInstance.setOption(createPieOption(hits, total, `${hitRate.value.toFixed(1)}%`, '#67C23A', '#E6FFED'));
}

function initCharts() {
  initMemoryChart();
  initHitRateChart();
  resizeHandler = () => {
    memoryChartInstance?.resize();
    hitRateChartInstance?.resize();
  };
  window.addEventListener('resize', resizeHandler);
}

async function loadRedisData() {
  loading.value = true;
  try {
    const monitor = await fetchGetRedisMonitor();
    const info = monitor.error || !monitor.data ? await fetchGetRedisInfo() : monitor;
    redisData.value = (info.data as any) || {};
    await nextTick();
    initCharts();
  } catch (error) {
    console.error('加载Redis数据失败:', error);
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  loadRedisData();
});

onBeforeUnmount(() => {
  memoryChartInstance?.dispose();
  hitRateChartInstance?.dispose();
  if (resizeHandler) window.removeEventListener('resize', resizeHandler);
});
</script>

<template>
  <div class="redis-monitor">
    <!-- Metric Cards -->
    <ElRow :gutter="20" class="mb-20px">
      <ElCol v-for="item in coreMetrics" :key="item.title" :sm="12" :md="6" :lg="6">
        <ElCard shadow="never" class="metric-card" :class="`metric-card--${item.theme}`">
          <div class="metric-content">
            <div class="metric-text">
              <div class="metric-title">{{ item.title }}</div>
              <div class="metric-value">{{ item.value }}</div>
              <div class="metric-desc">{{ item.desc }}</div>
            </div>
            <div v-if="item.icon" class="icon-wrapper">
              <ElIcon :size="32"><component :is="item.icon" /></ElIcon>
            </div>
          </div>
        </ElCard>
      </ElCol>
    </ElRow>

    <!-- Memory + Cache Efficiency -->
    <ElRow :gutter="20" class="mb-20px">
      <ElCol :span="12" class="lt-md:span-24">
        <ElCard shadow="hover">
          <template #header>
            <span class="font-600">内存分析</span>
          </template>
          <div v-if="variableData" class="memory-content">
            <div ref="memoryChartRef" class="memory-chart"></div>
            <div class="memory-details">
              <div class="memory-item">
                <span class="label">已用内存</span>
                <span class="value used">{{ formatBytes(variableData.used_memory) }}</span>
              </div>
              <div class="memory-item">
                <span class="label">峰值内存</span>
                <span class="value peak">{{ formatBytes(variableData.used_memory_peak) }}</span>
              </div>
              <div class="memory-item">
                <span class="label">物理占用</span>
                <span class="value">{{ formatBytes(variableData.used_memory_rss) }}</span>
              </div>
              <div class="memory-item">
                <span class="label">碎片率</span>
                <span class="value" :class="{ warning: variableData.mem_fragmentation_ratio > 1.5 }">
                  {{ variableData.mem_fragmentation_ratio }}
                </span>
              </div>
            </div>
          </div>
          <ElSkeleton v-else-if="loading" :rows="4" animated />
          <ElEmpty v-else description="暂无数据" />
        </ElCard>
      </ElCol>

      <ElCol :span="12" class="lt-md:span-24">
        <ElCard shadow="hover">
          <template #header>
            <span class="font-600">缓存效率</span>
          </template>
          <div v-if="variableData" class="cache-content">
            <div ref="hitRateChartRef" class="memory-chart"></div>
            <div class="memory-details">
              <div class="memory-item">
                <span class="label">命中次数</span>
                <span class="value hit">{{ variableData.keyspace_hits || 0 }}</span>
              </div>
              <div class="memory-item">
                <span class="label">未命中</span>
                <span class="value miss">{{ variableData.keyspace_misses || 0 }}</span>
              </div>
              <div class="memory-item">
                <span class="label">命中率</span>
                <span class="value" :class="{ success: hitRate >= 50, danger: hitRate < 30 }">
                  {{ hitRate.toFixed(2) }}%
                </span>
              </div>
              <div class="memory-item">
                <span class="label">过期键</span>
                <span class="value">{{ variableData.expired_keys || 0 }}</span>
              </div>
            </div>
          </div>
          <ElSkeleton v-else-if="loading" :rows="4" animated />
          <ElEmpty v-else description="暂无数据" />
        </ElCard>
      </ElCol>
    </ElRow>

    <!-- Performance -->
    <ElCard shadow="hover" class="performance-card mb-20px">
      <template #header>
        <div class="flex justify-between items-center">
          <span class="font-600">实时性能</span>
          <span class="text-xs text-gray-400">每秒操作数 (OPS)</span>
        </div>
      </template>
      <div v-if="variableData" class="performance-content">
        <div v-for="item in performanceMetrics" :key="item.label" class="perf-item">
          <div class="perf-value">{{ item.value }}</div>
          <div class="perf-label">{{ item.label }}</div>
        </div>
      </div>
      <ElSkeleton v-else-if="loading" :rows="2" animated />
      <ElEmpty v-else description="暂无数据" />
    </ElCard>

    <!-- Config Table -->
    <ElCard shadow="hover">
      <template #header>
        <span class="font-600">详细配置信息</span>
      </template>
      <ElTable v-if="tableData.length" :data="tableData" style="width: 100%">
        <ElTableColumn prop="key" label="属性" min-width="180" />
        <ElTableColumn prop="value" label="值" min-width="220">
          <template #default="{ row }">
            <span v-html="row.value"></span>
          </template>
        </ElTableColumn>
      </ElTable>
      <ElEmpty v-else description="暂无数据" />
    </ElCard>
  </div>
</template>

<style lang="scss" scoped>
.redis-monitor {
  .mb-20px { margin-bottom: 20px; }
}

.metric-card {
  box-sizing: border-box;
  height: 120px;
  border: none;
  transition: all 0.3s ease;

  :deep(.el-card__body) {
    display: flex;
    align-items: center;
    height: 100%;
    padding: 18px;
  }

  .metric-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;

    .metric-text {
      flex: 1;
      min-width: 0;

      .metric-title {
        margin-bottom: 6px;
        font-size: 14px;
        color: var(--el-text-color-secondary);
      }

      .metric-value {
        margin-bottom: 4px;
        font-size: 22px;
        font-weight: bold;
        color: var(--el-text-color-primary);
      }

      .metric-desc {
        font-size: 12px;
        color: var(--el-text-color-secondary);
      }
    }

    .icon-wrapper {
      display: flex;
      flex-shrink: 0;
      align-items: center;
      justify-content: center;
      width: 48px;
      height: 48px;
      border-radius: 10px;
    }
  }

  &--blue {
    background: var(--el-color-primary-light-9);

    .icon-wrapper {
      color: var(--el-color-primary);
      background-color: var(--el-color-primary-light-8);
    }
  }

  &--green {
    background: var(--el-color-success-light-9);

    .icon-wrapper {
      color: var(--el-color-success);
      background-color: var(--el-color-success-light-8);
    }
  }

  &--orange {
    background: var(--el-color-warning-light-9);

    .icon-wrapper {
      color: var(--el-color-warning);
      background-color: var(--el-color-warning-light-8);
    }
  }

  &--purple {
    background: #f4f0ff;

    .icon-wrapper {
      color: #7c3aed;
      background-color: #ebe4ff;
    }
  }
}

.memory-content, .cache-content {
  display: flex;
  flex-direction: column;
  .memory-chart { height: 180px; width: 100%; }
  .memory-details {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
    padding: 0 10px;
    .memory-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 8px 12px;
      background: var(--el-fill-color-light);
      border-radius: 6px;
      .label { font-size: 13px; color: #909399; }
      .value {
        font-size: 14px; font-weight: 600; color: #303133;
        &.used { color: #409eff; }
        &.peak { color: #e6a23c; }
        &.hit { color: #67c23a; }
        &.miss { color: #f56c6c; }
        &.success { color: #67c23a; }
        &.danger { color: #f56c6c; }
        &.warning { color: #e6a23c; }
      }
    }
  }
}

.performance-card {
  overflow: hidden;

  :deep(.el-card__body) {
    overflow: hidden;
  }
}

.performance-content {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
  width: 100%;

  .perf-item {
    min-width: 0;
    padding: 15px 0;
    text-align: center;
    background: var(--el-fill-color-light);
    border-radius: 8px;

    .perf-value {
      margin-bottom: 8px;
      font-size: 24px;
      font-weight: bold;
      color: #409eff;
    }

    .perf-label {
      font-size: 13px;
      color: #909399;
    }
  }
}

@media (max-width: 768px) {
  .performance-content {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
</style>
