<script setup lang="ts">
import { ElMessageBox } from 'element-plus';
import { $t } from '@/locales';

defineOptions({ name: 'TableHeaderOperation' });

interface Props {
  disabledDelete?: boolean;
  showAdd?: boolean;
  showDelete?: boolean;
  loading?: boolean;
  addAuth?: string;
  deleteAuth?: string;
}

const props = withDefaults(defineProps<Props>(), {
  showAdd: true,
  showDelete: true
});

interface Emits {
  (e: 'add'): void;
  (e: 'delete'): void;
  (e: 'refresh'): void;
}

const emit = defineEmits<Emits>();

const columns = defineModel<UI.TableColumnCheck[]>('columns', {
  default: () => []
});

function add() {
  emit('add');
}

async function batchDelete() {
  try {
    await ElMessageBox.confirm($t('common.confirmDelete'), '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    });
    emit('delete');
  } catch {}
}

function refresh() {
  emit('refresh');
}
</script>

<template>
  <div class="flex flex-wrap items-center justify-end gap-8px lt-sm:w-200px">
    <slot name="prefix"></slot>
    <slot name="default">
      <template v-if="props.addAuth">
        <ElButton v-if="props.showAdd" v-auth="props.addAuth" plain type="primary" @click="add">
          <template #icon>
            <icon-ic-round-plus class="text-icon" />
          </template>
          {{ $t('common.add') }}
        </ElButton>
      </template>
      <template v-else>
        <ElButton v-if="props.showAdd" plain type="primary" @click="add">
          <template #icon>
            <icon-ic-round-plus class="text-icon" />
          </template>
          {{ $t('common.add') }}
        </ElButton>
      </template>
      <template v-if="props.deleteAuth">
        <ElButton
          v-if="props.showDelete"
          v-auth="props.deleteAuth"
          type="danger"
          plain
          :disabled="disabledDelete"
          @click="batchDelete"
        >
          <template #icon>
            <icon-ic-round-delete class="text-icon" />
          </template>
          {{ $t('common.batchDelete') }}
        </ElButton>
      </template>
      <template v-else>
        <ElButton
          v-if="props.showDelete"
          type="danger"
          plain
          :disabled="disabledDelete"
          @click="batchDelete"
        >
          <template #icon>
            <icon-ic-round-delete class="text-icon" />
          </template>
          {{ $t('common.batchDelete') }}
        </ElButton>
      </template>
    </slot>
    <ElButton @click="refresh">
      <template #icon>
        <icon-mdi-refresh class="text-icon" :class="{ 'animate-spin': loading }" />
      </template>
      {{ $t('common.refresh') }}
    </ElButton>
    <TableColumnSetting v-model:columns="columns" />
    <slot name="suffix"></slot>
  </div>
</template>

<style scoped></style>
