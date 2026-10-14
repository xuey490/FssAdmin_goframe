<script setup lang="ts">
import { onBeforeUnmount, ref, watch } from 'vue';
import Player from 'xgplayer';
import 'xgplayer/dist/index.min.css';
import { ElMessage } from 'element-plus';
import { fetchPreviewVideo } from '@/service/api';
import { localStg } from '@/utils/storage';

defineOptions({ name: 'VideoPreviewDialog' });

const visible = defineModel<boolean>({ default: false });
const props = defineProps<{
  videoId?: number | null;
  meta?: {
    title?: string | null;
    thumbnail?: string | null;
    url?: string | null;
  } | null;
}>();

const loading = ref(false);
const streamUrl = ref('');
const pageUrl = ref('');
const posterUrl = ref('');
const title = ref('');
const playerEl = ref<HTMLElement>();
let player: Player | null = null;
const qualities = ref<Array<{ label: string; height?: number | null; url: string; format_id?: string | null }>>([]);

function buildProxyUrl(formatId?: string | null) {
  const token = encodeURIComponent(localStg.get('token') || '');
  const base = `/api/platform/video/stream/${props.videoId}`;
  const qs = formatId
    ? `format_id=${encodeURIComponent(formatId)}&access_token=${token}`
    : `access_token=${token}`;
  return `${base}?${qs}`;
}

function destroyPlayer() {
  player?.destroy();
  player = null;
}

function renderPlayer(url: string) {
  destroyPlayer();
  if (!playerEl.value || !url) return;
  player = new Player({
    el: playerEl.value,
    url,
    poster: posterUrl.value || undefined,
    autoplay: true,
    playbackRate: [0.5, 0.75, 1, 1.5, 2]
  });
}

watch(streamUrl, url => {
  if (visible.value && url) renderPlayer(url);
});

watch(visible, async val => {
  if (!val || !props.videoId) {
    streamUrl.value = '';
    pageUrl.value = '';
    qualities.value = [];
    destroyPlayer();
    return;
  }
  title.value = props.meta?.title || '预览';
  posterUrl.value = props.meta?.thumbnail || '';
  pageUrl.value = props.meta?.url || '';
  streamUrl.value = buildProxyUrl();
  qualities.value = [{ label: '最高清', url: streamUrl.value, format_id: null }];
  loading.value = true;
  try {
    const { data, error } = await fetchPreviewVideo(props.videoId);
    if (error) {
      ElMessage.error(error.message || '预览失败');
      return;
    }
    title.value = data?.title || title.value || '预览';
    posterUrl.value = data?.thumbnail || posterUrl.value;
    pageUrl.value = data?.page_url || pageUrl.value;
    const defaultUrl = buildProxyUrl();
    const list = (data?.qualities || [])
      .filter(q => q.format_id)
      .map(q => ({
        label: q.label,
        height: q.height,
        format_id: q.format_id,
        url: buildProxyUrl(q.format_id)
      }));
    qualities.value = [{ label: '最高清', url: defaultUrl, format_id: null }, ...list];
    if (!streamUrl.value) streamUrl.value = defaultUrl;
  } finally {
    loading.value = false;
  }
});

onBeforeUnmount(destroyPlayer);
</script>

<template>
  <ElDialog v-model="visible" :title="title || '预览'" width="860px" align-center destroy-on-close>
    <div class="preview-toolbar mb-12px flex flex-wrap items-center gap-12px">
      <div v-if="pageUrl" class="min-w-0 flex flex-1 items-center gap-8px">
        <span class="text-13px text-gray-500">原地址</span>
        <ElLink :href="pageUrl" target="_blank" type="primary" :underline="false" class="truncate">{{ pageUrl }}</ElLink>
      </div>
      <div v-if="qualities.length" class="flex items-center gap-8px">
        <span class="text-13px text-gray-500">清晰度</span>
        <ElSelect v-model="streamUrl" size="small" style="width: 140px" :disabled="loading">
          <ElOption v-for="q in qualities" :key="q.format_id || q.url" :label="q.label" :value="q.url" />
        </ElSelect>
      </div>
    </div>
    <div class="min-h-360px overflow-hidden rounded bg-black">
      <div v-if="visible && streamUrl" ref="playerEl" class="h-auto w-full" />
    </div>
    <ElAlert
      v-if="!streamUrl && pageUrl"
      class="mt-12px"
      type="warning"
      :closable="false"
      title="未能获取播放地址，请点击上方原地址在源站观看"
    />
    <p v-if="streamUrl" class="mt-10px text-12px text-gray-500">
      部分站点（如 B 站）格式浏览器可能无法播放，可切换清晰度或打开原地址。
    </p>
  </ElDialog>
</template>
