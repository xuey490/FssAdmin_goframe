<script setup lang="ts">
import { ref, watch, nextTick, computed } from 'vue';
import { fetchGetDatabaseTableDetailed } from '@/service/api';

defineOptions({ name: 'TableDialog' });

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

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
});

const tableData = ref<any[]>([]);

watch(
  () => props.modelValue,
  async newVal => {
    if (newVal && props.data?.name) {
      await nextTick();
      const { data } = await fetchGetDatabaseTableDetailed({ table: props.data.name });
      tableData.value = Array.isArray(data) ? data : ((data as any)?.columns ?? []);
    }
  }
);

function handleClose() {
  visible.value = false;
}
</script>

<template>
  <ElDialog v-model="visible" title="表结构信息" width="800px" align-center @close="handleClose">
    <ElTable :data="tableData" style="width: 100%">
      <ElTableColumn prop="column_name" label="字段名称" width="180" />
      <ElTableColumn prop="column_type" label="字段类型" width="120" />
      <ElTableColumn prop="column_key" label="字段索引" width="100" />
      <ElTableColumn prop="column_default" label="默认值" width="100" />
      <ElTableColumn prop="column_comment" label="字段注释" min-width="200" showOverflowTooltip />
    </ElTable>
  </ElDialog>
</template>
