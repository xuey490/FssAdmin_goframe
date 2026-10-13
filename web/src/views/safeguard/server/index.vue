<template>
  <ArtPageReady variant="dashboard">
    <div class="server-monitor">
      <el-row :gutter="16">
        <el-col :xs="24" :sm="12" :lg="6" v-for="item in cards" :key="item.key" class="mb">
          <div class="stat-card" :class="{ 'has-chart': item.hasChart }">
            <div class="stat-header">
              <div class="stat-icon" :class="item.tone">
                <el-icon :size="20"><component :is="item.icon" /></el-icon>
              </div>
              <div class="stat-text">
                <div class="stat-title" :class="{ num: item.num }">{{ item.title }}</div>
                <div class="stat-sub">{{ item.sub }}</div>
              </div>
            </div>
            <div v-if="item.hasChart" class="stat-chart">
              <div :ref="(el) => setChartRef(item.key, el as HTMLElement)" class="gauge-mini"></div>
            </div>
          </div>
        </el-col>
      </el-row>

      <el-row :gutter="16">
        <el-col :xs="24" :md="12" class="mb">
          <div class="panel">
            <div class="panel-title">
              <el-icon><Monitor /></el-icon>
              <span>系统信息</span>
            </div>
            <div class="info-row" v-for="row in systemRows" :key="row.label">
              <span class="label">{{ row.label }}</span>
              <span class="value">{{ row.value }}</span>
            </div>
          </div>
        </el-col>
        <el-col :xs="24" :md="12" class="mb">
          <div class="panel">
            <div class="panel-title">
              <el-icon><Cpu /></el-icon>
              <span>Go 运行时</span>
            </div>
            <div class="info-row" v-for="row in runtimeRows" :key="row.label">
              <span class="label">{{ row.label }}</span>
              <span class="value">{{ row.value }}</span>
            </div>
          </div>
        </el-col>
      </el-row>

      <el-row :gutter="16">
        <el-col :span="24" class="mb">
          <div class="panel">
            <div class="panel-title">
              <el-icon><Box /></el-icon>
              <span>硬件分区</span>
            </div>
            <el-table :data="info.partitions" stripe style="width: 100%" empty-text="暂无分区数据">
              <el-table-column prop="device" label="盘符/设备" min-width="120" />
              <el-table-column prop="mountpoint" label="挂载点" min-width="140" show-overflow-tooltip />
              <el-table-column prop="fstype" label="文件系统" min-width="100" />
              <el-table-column prop="total" label="总大小" min-width="100" />
              <el-table-column prop="used" label="已使用" min-width="100" />
              <el-table-column prop="free" label="可用" min-width="100" />
              <el-table-column label="使用情况" min-width="200">
                <template #default="{ row }">
                  <div class="disk-usage">
                    <el-progress
                      :percentage="parsePercent(row.usedPercent)"
                      :color="usageColor(parsePercent(row.usedPercent))"
                      :stroke-width="10"
                      :text-inside="true"
                    />
                    <span class="disk-percent">{{ row.usedPercent }}</span>
                  </div>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-col>
      </el-row>
    </div>
  </ArtPageReady>
</template>

<script setup lang="ts">
  import api from '@/api/safeguard/server'
  import { echarts, type EChartsOption } from '@/plugins/echarts'
  import { GaugeChart } from 'echarts/charts'
  import { Box, Coin, Connection, Cpu, Monitor } from '@element-plus/icons-vue'
  import { onBeforeUnmount, onMounted, nextTick } from 'vue'

  echarts.use([GaugeChart])

  type Usage = { percent: number; text: string; detail: string; cores?: number; model?: string }
  type Info = {
    cpu: Usage
    memory: Usage
    disk: Usage
    goroutines: number
    processes: number
    partitions: Array<{
      device: string
      mountpoint: string
      fstype: string
      total: string
      used: string
      free: string
      usedPercent: string
    }>
    system: {
      hostname: string
      os: string
      arch: string
      cpuModel: string
      uptime: string
      appUptime: string
      processes: number
    }
    runtime: {
      version: string
      goroutines: number
      heapAlloc: string
      heapSys: string
      stackInUse: string
      numGC: number
      lastGC: string
    }
  }

  const emptyUsage = (): Usage => ({ percent: 0, text: '—', detail: '—' })
  const info = reactive<Info>({
    cpu: emptyUsage(),
    memory: emptyUsage(),
    disk: emptyUsage(),
    goroutines: 0,
    processes: 0,
    partitions: [],
    system: {
      hostname: '—',
      os: '—',
      arch: '—',
      cpuModel: '—',
      uptime: '—',
      appUptime: '—',
      processes: 0
    },
    runtime: {
      version: '—',
      goroutines: 0,
      heapAlloc: '—',
      heapSys: '—',
      stackInUse: '—',
      numGC: 0,
      lastGC: '—'
    }
  })

  const cards = computed(() => [
    {
      key: 'cpu' as const,
      icon: Cpu,
      tone: 'green',
      title: `CPU 使用率 ${info.cpu.text}`,
      sub: info.cpu.detail,
      hasChart: true,
      num: false
    },
    {
      key: 'mem' as const,
      icon: Coin,
      tone: 'green',
      title: `内存 ${info.memory.text}`,
      sub: info.memory.detail,
      hasChart: true,
      num: false
    },
    {
      key: 'disk' as const,
      icon: Box,
      tone: 'green',
      title: `磁盘 ${info.disk.text}`,
      sub: info.disk.detail,
      hasChart: true,
      num: false
    },
    {
      key: 'go' as const,
      icon: Connection,
      tone: 'gray',
      num: true,
      title: String(info.goroutines || 0),
      sub: 'Goroutines',
      hasChart: false
    }
  ])

  const systemRows = computed(() => [
    { label: '主机名', value: info.system.hostname },
    { label: '操作系统', value: info.system.os },
    { label: '系统架构', value: info.system.arch },
    { label: 'CPU 型号', value: info.system.cpuModel },
    { label: '系统运行时长', value: info.system.uptime },
    { label: '应用运行时长', value: info.system.appUptime },
    { label: '进程数量', value: String(info.system.processes || info.processes || 0) }
  ])

  const runtimeRows = computed(() => [
    { label: 'Go 版本', value: info.runtime.version },
    { label: 'Goroutine 数量', value: String(info.runtime.goroutines || 0) },
    { label: '堆内存分配', value: info.runtime.heapAlloc },
    { label: '堆内存总共', value: info.runtime.heapSys },
    { label: '栈内存使用', value: info.runtime.stackInUse },
    { label: 'GC 次数', value: String(info.runtime.numGC || 0) },
    { label: '上次 GC', value: info.runtime.lastGC }
  ])

  // chart refs stored by key
  const chartRefs = reactive<Record<string, HTMLElement | undefined>>({
    cpu: undefined,
    mem: undefined,
    disk: undefined
  })
  let timer = 0

  const setChartRef = (key: string, el: HTMLElement | undefined) => {
    chartRefs[key] = el
  }

  const gaugeColor = (percent: number) => {
    if (percent >= 80) return '#ef4444'
    if (percent >= 60) return '#f5a524'
    return '#22c55e'
  }

  const usageColor = (percent: number) => {
    if (percent >= 80) return '#ef4444'
    if (percent >= 60) return '#f5a524'
    return '#22c55e'
  }

  const parsePercent = (s: string): number => {
    const n = parseFloat(s)
    return isNaN(n) ? 0 : Math.min(100, Math.max(0, n))
  }

  const gaugeOption = (percent: number, name: string, text: string): EChartsOption => ({
    series: [
      {
        type: 'gauge',
        startAngle: 90,
        endAngle: -270,
        radius: '70%',
        pointer: { show: false },
        progress: {
          show: true,
          roundCap: true,
          width: 8,
          itemStyle: { color: gaugeColor(percent) }
        },
        axisLine: { lineStyle: { width: 8, color: [[1, '#eef1f5']] } },
        splitLine: { show: false },
        axisTick: { show: false },
        axisLabel: { show: false },
        data: [{ value: Math.min(100, Math.max(0, percent)) }],
        detail: {
          fontSize: 12,
          fontWeight: 500,
          color: '#606266',
          offsetCenter: [0, '0%'],
          formatter: () => `${text || '—'} ${name}`
        }
      }
    ]
  })

  // 等待 DOM 容器有实际宽高后再初始化 ECharts，避免 "Can't get DOM width or height" 警告
  // ArtPageReady 骨架屏用 v-show(display:none) 控制，loading 期间容器宽高为 0
  const waitForLayout = (el: HTMLElement, maxAttempts = 40): Promise<boolean> => {
    return new Promise((resolve) => {
      let attempts = 0
      const check = () => {
        attempts++
        if (el.clientWidth > 0 && el.clientHeight > 0) {
          resolve(true)
          return
        }
        if (attempts >= maxAttempts) {
          resolve(false)
          return
        }
        requestAnimationFrame(check)
      }
      check()
    })
  }

  const paint = async () => {
    const specs: Array<[string, number, string, string]> = [
      ['cpu', info.cpu.percent, 'CPU', info.cpu.text],
      ['mem', info.memory.percent, '内存', info.memory.text],
      ['disk', info.disk.percent, '磁盘', info.disk.text]
    ]
    // 等待所有图表容器有尺寸（仅对尚未初始化的容器等待）
    const pendingEls = specs
      .map((s) => chartRefs[s[0]])
      .filter((el): el is HTMLElement => !!el && (el.clientWidth === 0 || el.clientHeight === 0))
    if (pendingEls.length > 0) {
      await Promise.all(pendingEls.map((el) => waitForLayout(el)))
    }
    for (const [key, percent, name, text] of specs) {
      const el = chartRefs[key]
      if (!el || el.clientWidth === 0 || el.clientHeight === 0) continue
      const chart = echarts.getInstanceByDom(el) || echarts.init(el)
      chart.setOption(gaugeOption(percent, name, text), true)
    }
  }

  const load = async () => {
    const data = await api.monitor({})
    Object.assign(info.cpu, data.cpu || {})
    Object.assign(info.memory, data.memory || {})
    Object.assign(info.disk, data.disk || {})
    info.goroutines = data.goroutines ?? 0
    info.processes = data.processes ?? 0
    info.partitions = data.partitions ?? []
    Object.assign(info.system, data.system || {})
    Object.assign(info.runtime, data.runtime || {})
    await nextTick()
    await paint()
  }

  const onResize = () => {
    // ArtPageReady loading 结束后会 dispatch resize，此时兜底初始化被跳过的图表
    const specs: Array<[string, number, string, string]> = [
      ['cpu', info.cpu.percent, 'CPU', info.cpu.text],
      ['mem', info.memory.percent, '内存', info.memory.text],
      ['disk', info.disk.percent, '磁盘', info.disk.text]
    ]
    for (const [key, percent, name, text] of specs) {
      const el = chartRefs[key]
      if (!el) continue
      if (el.clientWidth > 0 && el.clientHeight > 0) {
        const chart = echarts.getInstanceByDom(el) || echarts.init(el)
        chart.setOption(gaugeOption(percent, name, text), true)
        chart.resize()
      }
    }
  }

  onMounted(() => {
    load().catch(() => undefined)
    timer = window.setInterval(() => {
      load().catch(() => undefined)
    }, 10000)
    window.addEventListener('resize', onResize)
  })

  onBeforeUnmount(() => {
    window.clearInterval(timer)
    window.removeEventListener('resize', onResize)
    for (const key of ['cpu', 'mem', 'disk']) {
      const el = chartRefs[key]
      if (el) echarts.getInstanceByDom(el)?.dispose()
    }
  })
</script>

<style lang="scss" scoped>
  .server-monitor {
    .mb {
      margin-bottom: 16px;
    }
  }

  .stat-card,
  .panel {
    background: var(--default-box-color, #fff);
    border: 1px solid var(--el-border-color-lighter, #ebeef5);
    border-radius: 10px;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
  }

  .stat-card {
    display: flex;
    flex-direction: column;
    gap: 8px;
    min-height: 88px;
    padding: 16px 18px;

    &.has-chart {
      min-height: 200px;
    }
  }

  .stat-header {
    display: flex;
    align-items: center;
    gap: 14px;
  }

  .stat-icon {
    display: flex;
    flex-shrink: 0;
    align-items: center;
    justify-content: center;
    width: 42px;
    height: 42px;
    border-radius: 10px;

    &.green {
      color: #22c55e;
      background: #e8f8ef;
    }

    &.gray {
      color: #909399;
      background: #f2f3f5;
    }
  }

  .stat-title {
    font-size: 14px;
    font-weight: 500;
    color: var(--el-text-color-primary, #303133);

    &.num {
      font-size: 22px;
      font-weight: 600;
      line-height: 1.2;
    }
  }

  .stat-sub {
    margin-top: 4px;
    font-size: 12px;
    color: var(--el-text-color-secondary, #909399);
  }

  .stat-chart {
    margin-top: 4px;
  }

  .gauge-mini {
    height: 130px;
  }

  .panel {
    padding: 0 20px 16px;
  }

  .panel-title {
    display: flex;
    gap: 8px;
    align-items: center;
    height: 48px;
    font-size: 14px;
    font-weight: 600;
    color: var(--el-text-color-primary, #303133);
    border-bottom: 1px solid var(--el-border-color-lighter, #ebeef5);
  }

  .info-row {
    display: flex;
    gap: 16px;
    justify-content: space-between;
    padding: 13px 0;
    font-size: 13px;
    border-bottom: 1px solid var(--el-border-color-extra-light, #f5f7fa);

    &:last-child {
      border-bottom: none;
    }

    .label {
      flex-shrink: 0;
      color: var(--el-text-color-secondary, #909399);
    }

    .value {
      color: var(--el-text-color-regular, #606266);
      text-align: right;
      word-break: break-all;
    }
  }

  .disk-usage {
    display: flex;
    align-items: center;
    gap: 10px;

    .el-progress {
      flex: 1;
    }

    .disk-percent {
      flex-shrink: 0;
      font-size: 12px;
      color: var(--el-text-color-secondary, #909399);
      min-width: 40px;
      text-align: right;
    }
  }
</style>
