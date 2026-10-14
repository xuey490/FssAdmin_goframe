<script setup lang="ts">
import { computed, ref, useSlots } from 'vue';

defineOptions({ name: 'ArtTable' });

const props = defineProps<{
  columns?: any[];
  data?: any[];
  loading?: boolean;
  pagination?: { current?: number; size?: number; total?: number };
  rowKey?: string | ((row: any) => string);
}>();

const emit = defineEmits<{
  'selection-change': [rows: any[]];
  'pagination:size-change': [size: number];
  'pagination:current-change': [page: number];
  'sort-change': [payload: any];
}>();

const slots = useSlots();
const elTableRef = ref();

const visibleColumns = computed(() => (props.columns || []).filter(Boolean));

function getGlobalIndex(index: number) {
  const current = props.pagination?.current || 1;
  const size = props.pagination?.size || 10;
  return (current - 1) * size + index + 1;
}

function hasSlot(name?: string) {
  return Boolean(name && slots[name]);
}

defineExpose({ elTableRef });
</script>

<template>
  <div>
    <ElTable
      ref="elTableRef"
      v-loading="loading"
      :data="data || []"
      :row-key="rowKey || 'id'"
      border
      @selection-change="(rows: any[]) => emit('selection-change', rows)"
      @sort-change="(payload: any) => emit('sort-change', payload)"
    >
      <template v-for="col in visibleColumns" :key="col.prop || col.type">
        <ElTableColumn v-if="col.type === 'selection'" type="selection" :width="col.width || 48" :fixed="col.fixed" />
        <ElTableColumn v-else-if="col.type === 'index' || col.type === 'globalIndex'" :label="col.label || '序号'" :width="col.width || 56">
          <template #default="{ $index }">{{ getGlobalIndex($index) }}</template>
        </ElTableColumn>
        <ElTableColumn
          v-else
          :prop="col.prop"
          :label="col.label"
          :width="col.width"
          :min-width="col.minWidth"
          :fixed="col.fixed"
          :show-overflow-tooltip="col.showOverflowTooltip"
        >
          <template v-if="col.useSlot && hasSlot(col.prop)" #default="scope">
            <slot :name="col.prop" v-bind="scope" />
          </template>
        </ElTableColumn>
      </template>
    </ElTable>
    <div v-if="pagination" class="mt-16px flex justify-end">
      <ElPagination
        layout="total,prev,pager,next,sizes"
        :current-page="pagination.current || 1"
        :page-size="pagination.size || 10"
        :total="pagination.total || 0"
        :page-sizes="[10, 15, 20, 50]"
        @current-change="(page: number) => emit('pagination:current-change', page)"
        @size-change="(size: number) => emit('pagination:size-change', size)"
      />
    </div>
  </div>
</template>
