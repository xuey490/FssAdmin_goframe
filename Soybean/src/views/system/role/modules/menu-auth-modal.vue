<script setup lang="ts">
import { computed, nextTick, ref, watch } from 'vue';
import { fetchGetAssignableMenuTree, fetchGetRoleMenuByRole, fetchSaveRoleMenuPermission } from '@/service/api';
import { $t } from '@/locales';

defineOptions({ name: 'MenuAuthModal' });

interface Props {
  roleId: number;
  roleName?: string;
}

const props = defineProps<Props>();

const visible = defineModel<boolean>('visible', { default: false });

function closeModal() {
  visible.value = false;
}

const title = computed(() => `菜单权限 - ${props.roleName || ''}`);
const menuTree = ref<any[]>([]);
const treeRef = ref();
const isExpandAll = ref(false);

const getMenuTypeTag = (type: number | string): UI.ThemeColor => {
  const t = Number(type);
  if (t === 1) return 'info';
  if (t === 2) return 'primary';
  if (t === 3) return 'warning';
  if (t === 4) return 'success';
  return 'info';
};

const getMenuTypeText = (type: number | string): string => {
  const t = Number(type);
  if (t === 1) return '目录';
  if (t === 2) return '菜单';
  if (t === 3) return '按钮';
  if (t === 4) return '外链';
  return '未知';
};

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
  menuTree.value = [];
  isExpandAll.value = false;

  const [treeRes, menuRes] = await Promise.all([
    fetchGetAssignableMenuTree(),
    fetchGetRoleMenuByRole(props.roleId)
  ]);

  if (!treeRes.error) {
    menuTree.value = treeRes.data || [];
  }

  const menuIds: number[] = (!menuRes.error ? menuRes.data?.menus || [] : []).map((m: any) => Number(m.id));

  await nextTick();

  if (treeRef.value && menuIds.length) {
    const leafIds = new Set<number>();
    collectLeafIds(menuTree.value, leafIds);
    const checkedLeafIds = menuIds.filter(id => leafIds.has(id));
    treeRef.value.setCheckedKeys(checkedLeafIds, false);
  }
}

async function savePermission() {
  if (!treeRef.value) return;
  const checkedKeys = treeRef.value.getCheckedKeys(false) as number[];
  const halfCheckedKeys = treeRef.value.getHalfCheckedKeys() as number[];
  const allKeys = [...new Set([...checkedKeys, ...halfCheckedKeys])];

  const { error } = await fetchSaveRoleMenuPermission(props.roleId, allKeys);
  if (error) return;

  window.$message?.success($t('common.updateSuccess'));
  closeModal();
}

function toggleExpandAll() {
  const tree = treeRef.value;
  if (!tree) return;
  const nodes = tree.store.nodesMap;
  Object.values(nodes).forEach((node: any) => {
    node.expanded = !isExpandAll.value;
  });
  isExpandAll.value = !isExpandAll.value;
}

watch(visible, val => {
  if (val) {
    void initPage();
  } else {
    treeRef.value?.setCheckedKeys([]);
  }
});
</script>

<template>
  <ElDialog v-model="visible" :title="title" width="620px" align-center class="el-dialog-border">
    <ElScrollbar height="60vh">
      <ElTree
        ref="treeRef"
        :data="menuTree"
        show-checkbox
        node-key="id"
        :default-expand-all="false"
        :check-strictly="false"
      >
        <template #default="{ data: node }">
          <div class="flex items-center gap-2">
            <span>{{ node.label || node.name }}</span>
            <ElTag :type="getMenuTypeTag(node.type)" size="small">
              {{ getMenuTypeText(node.type) }}
            </ElTag>
          </div>
        </template>
      </ElTree>
    </ElScrollbar>
    <template #footer>
      <ElButton @click="toggleExpandAll">
        {{ isExpandAll ? '收起' : '展开' }}
      </ElButton>
      <ElButton @click="closeModal">{{ $t('common.cancel') }}</ElButton>
      <ElButton type="primary" @click="savePermission">保存</ElButton>
    </template>
  </ElDialog>
</template>
