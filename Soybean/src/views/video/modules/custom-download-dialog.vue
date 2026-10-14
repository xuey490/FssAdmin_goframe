<script setup lang="ts">
import { computed, reactive, ref, watch } from 'vue';
import { ElMessage } from 'element-plus';
import { fetchDownloadVideo, fetchGetVideoFormats } from '@/service/api';

defineOptions({ name: 'VideoCustomDownloadDialog' });

const visible = defineModel<boolean>({ default: false });
const props = defineProps<{ videoId?: number | null }>();
const emit = defineEmits<{ success: [] }>();

const submitting = ref(false);
const formats = ref<Array<Record<string, any>>>([]);
const form = reactive({
  format_id: '' as string,
  audio_format: '' as string,
  height: undefined as number | undefined,
  sub_langs: ''
});

const videoFormats = computed(() => formats.value.filter(f => f.vcodec && f.vcodec !== 'none'));
const audioFormats = computed(() =>
  formats.value.filter(f => (!f.vcodec || f.vcodec === 'none') && f.acodec && f.acodec !== 'none')
);

function formatLabel(f: Record<string, any>) {
  return [f.format_id, f.ext, f.resolution || f.note, f.vcodec, f.acodec].filter(Boolean).join(' | ');
}

watch(visible, async val => {
  if (!val || !props.videoId) return;
  form.format_id = '';
  form.audio_format = '';
  form.height = undefined;
  form.sub_langs = '';
  const { data, error } = await fetchGetVideoFormats(props.videoId);
  formats.value = error ? [] : data || [];
  if (error) ElMessage.warning('获取格式列表失败');
});

async function handleSubmit() {
  if (!props.videoId) return;
  submitting.value = true;
  try {
    const { error } = await fetchDownloadVideo(props.videoId, {
      mode: 'custom',
      format_id: form.format_id || undefined,
      audio_format: form.audio_format || undefined,
      height: form.height || undefined,
      sub_langs: form.sub_langs || undefined
    });
    if (!error) {
      ElMessage.success('已加入下载队列');
      visible.value = false;
      emit('success');
    }
  } finally {
    submitting.value = false;
  }
}
</script>

<template>
  <ElDialog v-model="visible" title="自定义下载" width="720px" align-center :close-on-click-modal="false">
    <ElForm label-width="110px">
      <ElFormItem label="视频格式">
        <ElSelect v-model="form.format_id" filterable clearable placeholder="选择 format_id" style="width: 100%">
          <ElOption v-for="f in videoFormats" :key="'v-' + f.format_id" :label="formatLabel(f)" :value="f.format_id" />
        </ElSelect>
      </ElFormItem>
      <ElFormItem label="音频格式">
        <ElSelect v-model="form.audio_format" filterable clearable placeholder="音频 format_id 或 mp3" style="width: 100%">
          <ElOption label="mp3 (后处理)" value="mp3" />
          <ElOption v-for="f in audioFormats" :key="'a-' + f.format_id" :label="formatLabel(f)" :value="f.format_id" />
        </ElSelect>
      </ElFormItem>
      <ElFormItem label="最大高度">
        <ElSelect v-model="form.height" clearable placeholder="可选，如 1080" style="width: 100%">
          <ElOption v-for="h in [2160, 1440, 1080, 720, 480, 360]" :key="h" :label="h + 'p'" :value="h" />
        </ElSelect>
      </ElFormItem>
      <ElFormItem label="字幕语言">
        <ElInput v-model="form.sub_langs" placeholder="如 zh-Hans,en（可空）" />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="visible = false">取消</ElButton>
      <ElButton type="primary" :loading="submitting" @click="handleSubmit">开始下载</ElButton>
    </template>
  </ElDialog>
</template>
