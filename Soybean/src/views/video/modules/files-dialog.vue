<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { ElMessage } from 'element-plus';
import { fetchGetVideoFiles } from '@/service/api';

defineOptions({ name: 'VideoFilesDialog' });

const visible = defineModel<boolean>({ default: false });
const props = defineProps<{ videoId?: number | null }>();

const loading = ref(false);
const localDir = ref('');
const title = ref('');
const files = ref<Array<{ name: string; size: number; mtime?: string | null; ext?: string | null; url?: string | null }>>(
  []
);

const dialogTitle = computed(() => (title.value ? `已下载文件 — ${title.value}` : '已下载文件'));
const emptyText = computed(() => (localDir.value ? '目录为空或尚无文件' : '该视频尚未下载到本地'));

function formatSize(n: number) {
  const v = Number(n || 0);
  if (v < 1024) return `${v} B`;
  if (v < 1024 * 1024) return `${(v / 1024).toFixed(1)} KB`;
  if (v < 1024 * 1024 * 1024) return `${(v / 1024 / 1024).toFixed(1)} MB`;
  return `${(v / 1024 / 1024 / 1024).toFixed(2)} GB`;
}

function resolveStaticUrl(path?: string | null) {
  if (!path) return '';
  if (/^https?:\/\//i.test(path)) return path;
  const p = path.startsWith('/') ? path : `/${path}`;
  if (import.meta.env.DEV) {
    const base = String(import.meta.env.VITE_SERVICE_PROXY_TARGET || 'http://127.0.0.1:8181').replace(/\/$/, '');
    return `${base}${p}`;
  }
  return p;
}

watch(visible, async val => {
  if (!val || !props.videoId) {
    files.value = [];
    localDir.value = '';
    title.value = '';
    return;
  }
  loading.value = true;
  try {
    const { data, error } = await fetchGetVideoFiles(props.videoId);
    if (error) {
      ElMessage.error(error.message || '获取文件列表失败');
      files.value = [];
      return;
    }
    title.value = data?.title || '';
    localDir.value = data?.local_dir || '';
    files.value = data?.files || [];
  } finally {
    loading.value = false;
  }
});
</script>

<template>
  <ElDialog v-model="visible" :title="dialogTitle" width="720px" align-center destroy-on-close>
    <div v-loading="loading">
      <div v-if="localDir" class="mb-10px text-12px text-gray-500 break-all">目录：{{ localDir }}</div>
      <ElTable v-if="files.length" :data="files" size="small" stripe max-height="420">
        <ElTableColumn prop="name" label="文件名" min-width="220" show-overflow-tooltip />
        <ElTableColumn label="大小" width="100">
          <template #default="{ row }">{{ formatSize(row.size) }}</template>
        </ElTableColumn>
        <ElTableColumn prop="mtime" label="修改时间" width="170" />
        <ElTableColumn label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <ElLink v-if="row.url" :href="resolveStaticUrl(row.url)" target="_blank" type="primary" :underline="false">
              打开
            </ElLink>
            <span v-else class="text-gray-400">—</span>
          </template>
        </ElTableColumn>
      </ElTable>
      <ElEmpty v-else-if="!loading" :description="emptyText" />
    </div>
  </ElDialog>
</template>
