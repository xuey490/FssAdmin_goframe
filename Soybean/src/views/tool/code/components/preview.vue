<template>
  <ElDrawer v-model="visible" title="预览代码" size="100%" destroy-on-close @close="handleClose">
    <ElTabs v-model="activeTab" type="card">
      <ElTabPane
        v-for="item in previewCode"
        :key="item.name"
        :label="item.tab_name"
        :name="item.name"
      >
        <div class="relative">
          <SaCode :code="item.code" :language="item.lang" />
          <ElButton class="copy-button" type="primary" @click="handleCopy(item.code)">
            <template #icon>
              <SvgIcon icon="ri:file-copy-line" />
            </template>
            复制
          </ElButton>
        </div>
      </ElTabPane>
    </ElTabs>
  </ElDrawer>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { useClipboard } from '@vueuse/core';
import { ElMessage } from 'element-plus';
import { fetchPreviewCodeGenerate } from '@/service/api/tool/code';

interface Props {
  modelValue: boolean;
  data?: Record<string, any>;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  data: undefined
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
}>();

const activeTab = ref('controller');
const previewCode = ref<any[]>([]);

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
});

watch(
  () => props.modelValue,
  newVal => {
    if (newVal) {
      initPage();
    }
  }
);

async function initPage() {
  const { data, error } = await fetchPreviewCodeGenerate({ id: props.data?.id });
  if (error) {
    handleClose();
    return;
  }
  previewCode.value = data || [];
  activeTab.value = previewCode.value[0]?.name || 'controller';
}

function handleClose() {
  visible.value = false;
}

const { copy } = useClipboard();

async function handleCopy(code: string) {
  try {
    await copy(code);
    ElMessage.success('代码已复制到剪贴板');
  } catch {
    ElMessage.error('复制失败，请手动复制');
  }
}
</script>

<style lang="scss" scoped>
.copy-button {
  position: absolute;
  right: 15px;
  top: 0;
  z-index: 999;
}
</style>
