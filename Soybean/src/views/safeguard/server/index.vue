<script setup lang="ts">
import { onMounted, reactive, ref } from 'vue';
import { fetchGetServerMonitor } from '@/service/api';

defineOptions({ name: 'ServerMonitor' });

const emptyUsage = (): Api.Safeguard.ServerUsage => ({ percent: 0, text: '—', detail: '—' });

const loading = ref(false);
const info = reactive<Api.Safeguard.ServerInfo>({
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
});

const toSafePercentage = (value: unknown): number => {
  const num = Number.parseFloat(String(value ?? '').replace('%', '').trim());
  if (Number.isNaN(num)) return 0;
  return Math.min(100, Math.max(0, Number(num.toFixed(2))));
};

async function updateServer() {
  loading.value = true;
  try {
    const { data, error } = await fetchGetServerMonitor();
    if (!error && data) {
      Object.assign(info, data);
      info.partitions = data.partitions || [];
    }
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  updateServer();
});
</script>

<template>
  <div v-loading="loading" class="mb-20px">
    <ElRow :gutter="20">
      <ElCol :xs="24" :sm="8" class="mb-16px">
        <ElCard shadow="never">
          <div class="text-center">
            <div class="pb-12px text-base font-medium">CPU {{ info.cpu.text }}</div>
            <ElProgress type="dashboard" :percentage="toSafePercentage(info.cpu.percent)" />
            <div class="mt-8px text-#909399">{{ info.cpu.detail }}</div>
          </div>
        </ElCard>
      </ElCol>
      <ElCol :xs="24" :sm="8" class="mb-16px">
        <ElCard shadow="never">
          <div class="text-center">
            <div class="pb-12px text-base font-medium">内存 {{ info.memory.text }}</div>
            <ElProgress type="dashboard" :percentage="toSafePercentage(info.memory.percent)" />
            <div class="mt-8px text-#909399">{{ info.memory.detail }}</div>
          </div>
        </ElCard>
      </ElCol>
      <ElCol :xs="24" :sm="8" class="mb-16px">
        <ElCard shadow="never">
          <div class="text-center">
            <div class="pb-12px text-base font-medium">磁盘 {{ info.disk.text }}</div>
            <ElProgress type="dashboard" :percentage="toSafePercentage(info.disk.percent)" />
            <div class="mt-8px text-#909399">{{ info.disk.detail }}</div>
          </div>
        </ElCard>
      </ElCol>

      <ElCol :span="24" :md="12" class="mb-16px">
        <ElCard shadow="never">
          <template #header>
            <span class="text-lg font-medium">系统信息</span>
          </template>
          <ElDescriptions :column="1" border class="server-descriptions">
            <ElDescriptionsItem label="主机名">{{ info.system.hostname }}</ElDescriptionsItem>
            <ElDescriptionsItem label="操作系统">{{ info.system.os }}</ElDescriptionsItem>
            <ElDescriptionsItem label="系统架构">{{ info.system.arch }}</ElDescriptionsItem>
            <ElDescriptionsItem label="CPU 型号">{{ info.system.cpuModel }}</ElDescriptionsItem>
            <ElDescriptionsItem label="系统运行时长">{{ info.system.uptime }}</ElDescriptionsItem>
            <ElDescriptionsItem label="应用运行时长">{{ info.system.appUptime }}</ElDescriptionsItem>
            <ElDescriptionsItem label="进程数量">{{ info.system.processes || info.processes }}</ElDescriptionsItem>
          </ElDescriptions>
        </ElCard>
      </ElCol>

      <ElCol :span="24" :md="12" class="mb-16px">
        <ElCard shadow="never">
          <template #header>
            <span class="text-lg font-medium">Go 运行时</span>
          </template>
          <ElDescriptions :column="1" border class="server-descriptions">
            <ElDescriptionsItem label="Go 版本">{{ info.runtime.version }}</ElDescriptionsItem>
            <ElDescriptionsItem label="Goroutine 数量">{{ info.runtime.goroutines || info.goroutines }}</ElDescriptionsItem>
            <ElDescriptionsItem label="堆内存分配">{{ info.runtime.heapAlloc }}</ElDescriptionsItem>
            <ElDescriptionsItem label="堆内存总共">{{ info.runtime.heapSys }}</ElDescriptionsItem>
            <ElDescriptionsItem label="栈内存使用">{{ info.runtime.stackInUse }}</ElDescriptionsItem>
            <ElDescriptionsItem label="GC 次数">{{ info.runtime.numGC }}</ElDescriptionsItem>
            <ElDescriptionsItem label="上次 GC">{{ info.runtime.lastGC }}</ElDescriptionsItem>
          </ElDescriptions>
        </ElCard>
      </ElCol>

      <ElCol :span="24" class="mb-16px">
        <ElCard shadow="never">
          <template #header>
            <span class="text-lg font-medium">硬件分区</span>
          </template>
          <ElTable :data="info.partitions" style="width: 100%" empty-text="暂无分区数据">
            <ElTableColumn prop="device" label="盘符/设备" min-width="120" />
            <ElTableColumn prop="mountpoint" label="挂载点" min-width="140" show-overflow-tooltip />
            <ElTableColumn prop="fstype" label="文件系统" min-width="100" />
            <ElTableColumn prop="total" label="总大小" min-width="100" />
            <ElTableColumn prop="used" label="已使用" min-width="100" />
            <ElTableColumn prop="free" label="可用" min-width="100" />
            <ElTableColumn label="使用情况" min-width="200">
              <template #default="{ row }">
                <ElProgress :percentage="toSafePercentage(row.usedPercent)" :stroke-width="12" :show-text="true" />
              </template>
            </ElTableColumn>
          </ElTable>
        </ElCard>
      </ElCol>
    </ElRow>
  </div>
</template>

<style scoped lang="scss">
.server-descriptions {
  :deep(.el-descriptions__label) {
    width: 160px;
  }
}
</style>
