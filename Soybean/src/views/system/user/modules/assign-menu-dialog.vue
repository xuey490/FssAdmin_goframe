<script setup lang="ts">
import { computed, nextTick, ref, watch } from 'vue';
import { fetchGetAssignableMenuTree, fetchGetUserMenus, fetchSaveUserMenus } from '@/service/api';

defineOptions({ name: 'UserAssignMenuDialog' });

interface Props {
  modelValue: boolean;
  data?: Api.SystemManage.User | null;
}

const props = withDefaults(defineProps<Props>(), {
  data: null
});

interface Emits {
  (e: 'update:modelValue', value: boolean): void;
  (e: 'success'): void;
}

const emit = defineEmits<Emits>();

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
});

const menuTree = ref<any[]>([]);
const treeRef = ref();
const loading = ref(false);
const saving = ref(false);

function collectLeafIds(nodes: any[], ids: Set<number>) {
  for (const node of nodes) {
    if (!node.children || node.children.length === 0) {
      ids.add(Number(node.id));
    } else {
      collectLeafIds(node.children, ids);
    }
  }
}

async function initPage() {
  const userId = Number(props.data?.id);
  if (!userId) return;

  loading.value = true;
  try {
    const [treeRes, menuIdsRes] = await Promise.all([
      fetchGetAssignableMenuTree(),
      fetchGetUserMenus(userId)
    ]);

    menuTree.value = !treeRes.error && treeRes.data ? treeRes.data : [];
    const menuIds: number[] = !menuIdsRes.error && Array.isArray(menuIdsRes.data) ? menuIdsRes.data : [];

    const leafIds = new Set<number>();
    collectLeafIds(menuTree.value, leafIds);
    const checkedLeafIds = menuIds.map(Number).filter(id => leafIds.has(id));

    await nextTick();
    treeRef.value?.setCheckedKeys(checkedLeafIds, false);
  } finally {
    loading.value = false;
  }
}

async function handleSubmit() {
  const userId = Number(props.data?.id);
  if (!userId || !treeRef.value) return;

  saving.value = true;
  try {
    const checkedKeys = treeRef.value.getCheckedKeys(false) as number[];
    const halfCheckedKeys = treeRef.value.getHalfCheckedKeys() as number[];
    const allKeys = [...new Set([...checkedKeys, ...halfCheckedKeys])];
    const { error } = await fetchSaveUserMenus(userId, allKeys);
    if (error) return;
    window.$message?.success('分配菜单成功');
    emit('success');
    handleClose();
  } finally {
    saving.value = false;
  }
}

function handleClose() {
  menuTree.value = [];
  treeRef.value?.setCheckedKeys([]);
  visible.value = false;
}

watch(
  () => props.modelValue,
  val => {
    if (val) {
      void initPage();
    }
  }
);
</script>

<template>
  <ElDialog
    v-model="visible"
    title="分配菜单"
    width="500px"
    align-center
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElScrollbar max-height="420px">
      <ElTree
        ref="treeRef"
        v-loading="loading"
        :data="menuTree"
        :props="{ label: 'label', children: 'children' }"
        node-key="id"
        show-checkbox
        default-expand-all
        :check-strictly="false"
      />
    </ElScrollbar>
    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="saving" @click="handleSubmit">保存</ElButton>
    </template>
  </ElDialog>
</template>
