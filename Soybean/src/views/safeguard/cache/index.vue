<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { Refresh, Search, FolderOpened, Document, Delete } from '@element-plus/icons-vue';
import { useAppStore } from '@/store/modules/app';
import {
  fetchGetRedisLevel1,
  fetchGetRedisLevel2,
  fetchGetRedisLevel3,
  fetchGetRedisKeyInfo,
  fetchDeleteRedisKey,
  fetchDeleteRedisByPattern
} from '@/service/api';

defineOptions({ name: 'CacheManage' });

const appStore = useAppStore();

function normalizeList(data: unknown): any[] {
  if (Array.isArray(data)) return data;
  if (data && typeof data === 'object') {
    const record = data as Record<string, unknown>;
    if (Array.isArray(record.list)) return record.list;
    if (Array.isArray(record.data)) return record.data;
  }
  return [];
}

const searchPattern = ref('*');
const level1Keys = ref<any[]>([]);
const level2Keys = ref<any[]>([]);
const level3Keys = ref<any[]>([]);
const keyInfo = ref<any>(null);

const selectedLevel1 = ref('');
const selectedLevel2 = ref('');
const selectedKey = ref('');

const loading = reactive({
  level1: false,
  level2: false,
  level3: false,
  keyInfo: false
});

// Load Level 1
const loadLevel1 = async () => {
  loading.level1 = true;
  try {
    const { data, error } = await fetchGetRedisLevel1(searchPattern.value);
    if (error) {
      ElMessage.error(error.message || '加载失败');
      level1Keys.value = [];
      return;
    }
    level1Keys.value = normalizeList(data);
  } catch (error: any) {
    ElMessage.error(error.message || '加载失败');
  } finally {
    loading.level1 = false;
  }
};

// Load Level 2
const loadLevel2 = async (prefix: string) => {
  loading.level2 = true;
  try {
    const { data, error } = await fetchGetRedisLevel2(prefix);
    if (error) {
      ElMessage.error(error.message || '加载失败');
      level2Keys.value = [];
      return;
    }
    level2Keys.value = normalizeList(data);
  } catch (error: any) {
    ElMessage.error(error.message || '加载失败');
  } finally {
    loading.level2 = false;
  }
};

// Load Level 3
const loadLevel3 = async (prefix: string) => {
  loading.level3 = true;
  try {
    const { data, error } = await fetchGetRedisLevel3(prefix);
    if (error) {
      ElMessage.error(error.message || '加载失败');
      level3Keys.value = [];
      return;
    }
    level3Keys.value = normalizeList(data);
  } catch (error: any) {
    ElMessage.error(error.message || '加载失败');
  } finally {
    loading.level3 = false;
  }
};

// Load Key Info
const loadKeyInfo = async (key: string) => {
  loading.keyInfo = true;
  try {
    const { data, error } = await fetchGetRedisKeyInfo(key);
    if (error) {
      ElMessage.error(error.message || '加载失败');
      keyInfo.value = null;
      return;
    }
    keyInfo.value = (data as any) || null;
  } catch (error: any) {
    ElMessage.error(error.message || '加载失败');
  } finally {
    loading.keyInfo = false;
  }
};

// Handle Level 1 click
const handleLevel1Click = (item: any) => {
  selectedLevel1.value = item.key;
  selectedLevel2.value = '';
  selectedKey.value = '';
  level2Keys.value = [];
  level3Keys.value = [];
  keyInfo.value = null;
  loadLevel2(item.key);
};

// Handle Level 2 click
const handleLevel2Click = (item: any) => {
  selectedLevel2.value = item.key;
  selectedKey.value = '';
  level3Keys.value = [];
  keyInfo.value = null;

  if (item.type === 'prefix') {
    loadLevel3(item.key);
  } else {
    loadKeyInfo(item.fullKey || item.key);
  }
};

// Handle key click
const handleKeyClick = (key: string) => {
  selectedKey.value = key;
  loadKeyInfo(key);
};

// Delete single key
const handleDeleteKey = (key: string) => {
  ElMessageBox.confirm(`确定要删除键 "${key}" 吗？`, '删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const { error } = await fetchDeleteRedisKey(key);
      if (error) {
        ElMessage.error(error.message || '删除失败');
        return;
      }
      ElMessage.success('删除成功');
      await appStore.reloadPage();
    } catch (error: any) {
      ElMessage.error(error.message || '删除失败');
    }
  });
};

// Batch delete by pattern
const handleDeletePattern = (pattern: string) => {
  ElMessageBox.confirm(`确定要删除所有匹配 "${pattern}" 的键吗？`, '批量删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'error'
  }).then(async () => {
    try {
      const { error } = await fetchDeleteRedisByPattern(pattern);
      if (error) {
        ElMessage.error(error.message || '删除失败');
        return;
      }
      ElMessage.success('删除成功');
      await appStore.reloadPage();
    } catch (error: any) {
      ElMessage.error(error.message || '删除失败');
    }
  });
};

// Refresh Level 1
const refreshLevel1 = () => {
  selectedLevel1.value = '';
  selectedLevel2.value = '';
  selectedKey.value = '';
  level2Keys.value = [];
  level3Keys.value = [];
  keyInfo.value = null;
  loadLevel1();
};

// Search change
const handleSearchChange = () => {
  refreshLevel1();
};

// Get short key name
const getShortKey = (key: string) => {
  const parts = key.split(':');
  return parts[parts.length - 1] || key;
};

// Format TTL
const formatTTL = (seconds: number) => {
  if (seconds < 60) return `${seconds}秒`;
  if (seconds < 3600) return `${Math.floor(seconds / 60)}分钟`;
  if (seconds < 86400) return `${Math.floor(seconds / 3600)}小时`;
  return `${Math.floor(seconds / 86400)}天`;
};

onMounted(() => {
  loadLevel1();
});
</script>

<template>
  <div class="cache-page">
    <ElRow :gutter="20" class="browser-panels">
      <!-- Panel 1: Prefix groups -->
      <ElCol :xs="24" :sm="24" :md="8" :lg="8" class="panel-col">
        <ElCard class="panel-card" shadow="never">
          <template #header>
            <div class="panel-header">
              <span class="text-lg font-medium">缓存分组</span>
              <ElButton size="small" :loading="loading.level1" @click="refreshLevel1">
                <template #icon>
                  <ElIcon><Refresh /></ElIcon>
                </template>
              </ElButton>
            </div>
          </template>
          <div class="panel-content">
            <ElInput
              v-model="searchPattern"
              placeholder="搜索键前缀..."
              clearable
              @change="handleSearchChange"
              class="mb-12px"
            >
              <template #prefix>
                <ElIcon><Search /></ElIcon>
              </template>
            </ElInput>
            <ElScrollbar class="panel-scrollbar panel-scrollbar--level1">
              <div
                v-for="item in level1Keys"
                :key="item.key"
                class="key-item"
                :class="{ active: selectedLevel1 === item.key }"
                @click="handleLevel1Click(item)"
              >
                <div class="key-info">
                  <ElIcon class="key-icon"><FolderOpened /></ElIcon>
                  <span class="key-name">{{ item.key }}</span>
                </div>
                <ElTag size="small" type="info">{{ item.count }}</ElTag>
              </div>
              <ElEmpty v-if="!loading.level1 && level1Keys.length === 0" description="暂无数据" />
            </ElScrollbar>
          </div>
        </ElCard>
      </ElCol>

      <!-- Panel 2: Level 2 keys -->
      <ElCol :xs="24" :sm="24" :md="8" :lg="8" class="panel-col">
        <ElCard class="panel-card" shadow="never">
          <template #header>
            <div class="panel-header">
              <span class="text-lg font-medium">
                {{ selectedLevel1 || '选择分组' }}
              </span>
              <ElButton v-if="selectedLevel1" size="small" type="danger" @click="handleDeletePattern(selectedLevel1 + ':*')">
                <template #icon><ElIcon><Delete /></ElIcon></template>
                批量删除
              </ElButton>
            </div>
          </template>
          <div class="panel-content">
            <ElScrollbar class="panel-scrollbar panel-scrollbar--level2">
              <div
                v-for="item in level2Keys"
                :key="item.key"
                class="key-item"
                :class="{ active: selectedLevel2 === item.key }"
                @click="handleLevel2Click(item)"
              >
                <div class="key-info">
                  <ElIcon class="key-icon">
                    <component :is="item.type === 'prefix' ? FolderOpened : Document" />
                  </ElIcon>
                  <span class="key-name">{{ getShortKey(item.key) }}</span>
                </div>
                <div class="key-actions">
                  <ElTag v-if="item.count > 1" size="small" type="info">{{ item.count }}</ElTag>
                  <ElButton size="small" type="danger" text @click.stop="handleDeleteKey(item.key)">
                    <ElIcon><Delete /></ElIcon>
                  </ElButton>
                </div>
              </div>
              <ElEmpty v-if="!loading.level2 && level2Keys.length === 0" description="请选择左侧分组" />
            </ElScrollbar>
          </div>
        </ElCard>
      </ElCol>

      <!-- Panel 3: Key detail -->
      <ElCol :xs="24" :sm="24" :md="8" :lg="8" class="panel-col">
        <ElCard class="panel-card" shadow="never">
          <template #header>
            <div class="panel-header">
              <span class="text-lg font-medium">
                {{ selectedLevel2 ? getShortKey(selectedLevel2) : '键详情' }}
              </span>
              <ElButton
                v-if="selectedLevel2 && level3Keys.length > 0"
                size="small"
                type="danger"
                @click="handleDeletePattern(selectedLevel2 + ':*')"
              >
                <template #icon><ElIcon><Delete /></ElIcon></template>
                批量删除
              </ElButton>
            </div>
          </template>
          <div class="panel-content">
            <!-- Level 3 keys -->
            <ElScrollbar v-if="level3Keys.length > 0" class="panel-scrollbar panel-scrollbar--level3">
              <div
                v-for="item in level3Keys"
                :key="item.key"
                class="key-item"
                :class="{ active: selectedKey === item.key }"
                @click="handleKeyClick(item.key)"
              >
                <div class="key-info">
                  <ElIcon class="key-icon"><Document /></ElIcon>
                  <span class="key-name">{{ getShortKey(item.key) }}</span>
                </div>
                <div class="key-actions">
                  <ElTag v-if="item.ttl > 0" size="small">{{ formatTTL(item.ttl) }}</ElTag>
                  <ElTag size="small" type="info">{{ item.size }}</ElTag>
                  <ElButton size="small" type="danger" text @click.stop="handleDeleteKey(item.key)">
                    <ElIcon><Delete /></ElIcon>
                  </ElButton>
                </div>
              </div>
            </ElScrollbar>

            <!-- Key detail -->
            <div v-else-if="keyInfo" class="key-detail">
              <ElDescriptions :column="1" border class="mb-12px">
                <ElDescriptionsItem label="键名">
                  <div class="key-name-full">{{ keyInfo.key }}</div>
                </ElDescriptionsItem>
                <ElDescriptionsItem label="类型">
                  <ElTag size="small">{{ keyInfo.type }}</ElTag>
                </ElDescriptionsItem>
                <ElDescriptionsItem label="TTL">
                  <ElTag v-if="keyInfo.ttl === -1" type="success" size="small">永不过期</ElTag>
                  <ElTag v-else-if="keyInfo.ttl === -2" type="danger" size="small">键不存在</ElTag>
                  <ElTag v-else type="warning" size="small">{{ formatTTL(keyInfo.ttl) }}</ElTag>
                </ElDescriptionsItem>
                <ElDescriptionsItem label="大小">
                  {{ keyInfo.size }}
                </ElDescriptionsItem>
              </ElDescriptions>

              <div class="key-value">
                <div class="value-header">
                  <span class="text-base font-medium">值内容</span>
                  <ElButton size="small" type="danger" @click="handleDeleteKey(keyInfo.key)">
                    <template #icon><ElIcon><Delete /></ElIcon></template>
                    删除
                  </ElButton>
                </div>
                <ElInput
                  v-if="keyInfo.type === 'string'"
                  v-model="keyInfo.value"
                  type="textarea"
                  :rows="12"
                  readonly
                  class="mt-12px"
                />
                <pre v-else class="value-content">{{ JSON.stringify(keyInfo.value, null, 2) }}</pre>
              </div>
            </div>

            <ElEmpty v-else description="请选择键查看详情" />
          </div>
        </ElCard>
      </ElCol>
    </ElRow>
  </div>
</template>

<style lang="scss" scoped>
.cache-page {
  .browser-panels {
    min-height: calc(100vh - 180px);
  }

  .panel-scrollbar {
    height: 320px;
  }

  @media (min-width: 992px) {
    .panel-scrollbar--level1 { height: calc(100vh - 300px); }
    .panel-scrollbar--level2,
    .panel-scrollbar--level3 { height: calc(100vh - 260px); }
  }

  @media (max-width: 991px) {
    .browser-panels { min-height: auto; }
    .panel-col { margin-bottom: 20px; &:last-child { margin-bottom: 0; } }
    .panel-card { height: auto; }
  }

  .panel-card {
    height: 100%;
    :deep(.el-card__body) { padding: 0; }
  }

  .panel-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .panel-content { padding: 20px; }

  .key-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 14px;
    margin-bottom: 10px;
    background: var(--el-fill-color-light);
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s;
    border: 1px solid transparent;

    &:hover { background: var(--el-fill-color); transform: translateX(2px); }
    &.active {
      background: var(--el-color-primary-light-9);
      border-color: var(--el-color-primary);
      box-shadow: 0 2px 8px rgba(64, 158, 255, 0.15);
    }

    .key-info {
      display: flex;
      align-items: center;
      flex: 1;
      min-width: 0;
      .key-icon { margin-right: 10px; color: var(--el-color-primary); flex-shrink: 0; font-size: 18px; }
      .key-name { font-size: 14px; color: var(--el-text-color-primary); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-weight: 500; }
    }
    .key-actions { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
  }

  .key-detail {
    .detail-label { width: 100px; font-weight: 500; }
    .key-name-full { word-break: break-all; font-size: 13px; color: var(--el-text-color-regular); }

    .key-value {
      .value-header {
        display: flex; justify-content: space-between; align-items: center;
        margin-bottom: 12px; padding-bottom: 12px;
        border-bottom: 1px solid var(--el-border-color-lighter);
      }
      .value-content {
        padding: 16px; background: var(--el-fill-color-light);
        border-radius: 8px; font-size: 13px; line-height: 1.8;
        max-height: 500px; overflow: auto; margin-top: 12px;
        font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
        color: var(--el-text-color-regular);
        border: 1px solid var(--el-border-color-light);
      }
      :deep(.el-textarea__inner) {
        font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
        font-size: 13px; line-height: 1.8;
      }
    }
  }

  :deep(.el-scrollbar__view) { padding-right: 10px; }
  :deep(.el-empty) { padding: 40px 0; }
}
</style>
