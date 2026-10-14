<script setup lang="ts">
defineOptions({ name: 'ArtPageReady' });
defineProps<{ variant?: string }>();
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <slot />
  </div>
</template>
