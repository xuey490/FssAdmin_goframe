<script setup lang="ts">
defineOptions({ name: 'ArtTableHeader' });

defineProps<{
  columns?: any;
  loading?: boolean;
  layout?: string;
  showSearchBar?: boolean;
}>();

const emit = defineEmits<{
  refresh: [];
  'update:columns': [value: any];
  'update:showSearchBar': [value: boolean];
}>();

const showSearchBar = defineModel<boolean>('showSearchBar', { default: true });
</script>

<template>
  <div class="mb-12px flex flex-wrap items-center justify-between gap-8px">
    <div class="flex flex-wrap items-center gap-8px">
      <slot name="left" />
    </div>
    <div class="flex items-center gap-8px">
      <slot />
      <ElButton v-if="layout?.includes('search')" text @click="showSearchBar = !showSearchBar">
        {{ showSearchBar ? '隐藏搜索' : '显示搜索' }}
      </ElButton>
      <ElButton :loading="loading" @click="emit('refresh')">刷新</ElButton>
    </div>
  </div>
</template>
