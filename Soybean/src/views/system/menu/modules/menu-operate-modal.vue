<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import SaIconPicker from '@/components/sai/sa-icon-picker/index.vue';
import { fetchCreateMenu, fetchGetMenuDetail, fetchGetMenuList, fetchUpdateMenu } from '@/service/api';
import { useForm, useFormRules } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({ name: 'MenuOperateModal' });

export type OperateType = UI.TableOperateType | 'addChild';

interface Props {
  operateType: OperateType;
  rowData?: Api.SystemManage.Menu | null;
}

const props = defineProps<Props>();

interface Emits {
  (e: 'submitted'): void;
}

const emit = defineEmits<Emits>();

const visible = defineModel<boolean>('visible', { default: false });

const { formRef, validate, restoreValidation } = useForm();
const { defaultRequiredRule } = useFormRules();

const title = computed(() => {
  const titles: Record<OperateType, string> = {
    add: $t('page.manage.menu.addMenu'),
    addChild: $t('page.manage.menu.addChildMenu'),
    edit: $t('page.manage.menu.editMenu')
  };
  return titles[props.operateType];
});

const menuTypeOptions = [
  { label: '目录', value: 1 },
  { label: '菜单', value: 2 },
  { label: '按钮', value: 3 },
  { label: '外链', value: 4 }
];

type Model = {
  parent_id: number;
  type: number;
  name: string;
  path: string;
  code: string;
  component: string;
  slug: string;
  icon: string;
  link_url: string;
  sort: number;
  status: number;
  is_hidden: number;
  is_iframe: number;
  is_keep_alive: number;
  is_fixed_tab: number;
  is_full_page: number;
  remark: string;
};

const model = ref<Model>(createDefaultModel());

function createDefaultModel(): Model {
  return {
    parent_id: 0,
    type: 1,
    name: '',
    path: '',
    code: '',
    component: '',
    slug: '',
    icon: '',
    link_url: '',
    sort: 100,
    status: 1,
    is_hidden: 2,
    is_iframe: 2,
    is_keep_alive: 2,
    is_fixed_tab: 2,
    is_full_page: 2,
    remark: ''
  };
}

const parentMenuTree = ref<any[]>([]);

async function loadParentMenuTree() {
  const { error, data } = await fetchGetMenuList();
  if (!error) {
    parentMenuTree.value = [
      {
        id: 0,
        value: 0,
        label: '无上级菜单',
        children: Array.isArray(data) ? data : []
      }
    ];
  } else {
    parentMenuTree.value = [{ id: 0, value: 0, label: '无上级菜单', children: [] }];
  }
}

type RuleKey = 'name' | 'path' | 'code' | 'slug';

const rules = computed<Partial<Record<RuleKey, App.Global.FormRule>>>(() => {
  const base: Partial<Record<RuleKey, App.Global.FormRule>> = {
    name: defaultRequiredRule
  };

  if (model.value.type < 3) {
    base.path = defaultRequiredRule;
    base.code = defaultRequiredRule;
  }

  if (model.value.type === 3) {
    base.slug = defaultRequiredRule;
  }

  return base;
});

const disabledMenuType = computed(() => props.operateType === 'edit');

async function handleInitModel() {
  model.value = createDefaultModel();

  if (!props.rowData) return;

  if (props.operateType === 'addChild') {
    model.value.parent_id = Number(props.rowData.id);
    model.value.type = Number(props.rowData.type) === 2 ? 3 : 1;
    return;
  }

  if (props.operateType === 'edit') {
    const { error, data } = await fetchGetMenuDetail(Number(props.rowData.id));
    const src = (!error && data) ? data : props.rowData;
    const row = src as any;
    Object.assign(model.value, {
      parent_id: Number(row.parent_id ?? row.parentId ?? 0),
      type: Number(row.type ?? 1),
      name: row.name || row.menuName || '',
      path: row.path || row.routePath || '',
      code: row.code || row.routeName || '',
      component: row.component || '',
      slug: row.slug || '',
      icon: row.icon || '',
      link_url: row.link_url || row.href || '',
      sort: Number(row.sort ?? row.order ?? 100),
      status: Number(row.status) === 0 ? 0 : 1,
      is_hidden: Number(row.is_hidden) === 1 ? 1 : 2,
      is_iframe: Number(row.is_iframe) === 1 ? 1 : 2,
      is_keep_alive: Number(row.is_keep_alive) === 1 ? 1 : 2,
      is_fixed_tab: Number(row.is_fixed_tab) === 1 ? 1 : 2,
      is_full_page: Number(row.is_full_page) === 1 ? 1 : 2,
      remark: row.remark || ''
    });
  }
}

function closeModal() {
  visible.value = false;
}

async function handleSubmit() {
  await validate();

  const payload: Record<string, any> = { ...model.value };

  const request =
    props.operateType === 'edit'
      ? fetchUpdateMenu(Number(props.rowData!.id), payload)
      : fetchCreateMenu(payload);

  const { error } = await request;
  if (error) return;

  window.$message?.success($t('common.updateSuccess'));
  closeModal();
  emit('submitted');
}

watch(visible, val => {
  if (val) {
    void handleInitModel();
    restoreValidation();
    void loadParentMenuTree();
  }
});
</script>

<template>
  <ElDialog v-model="visible" :title="title" width="1080px" align-center :close-on-click-modal="false">
    <ElScrollbar max-height="70vh" class="pr-4">
      <ElForm ref="formRef" :model="model" :rules="rules" label-width="110px">
        <ElFormItem label="菜单类型" prop="type">
          <ElRadioGroup v-model="model.type" :disabled="disabledMenuType">
            <ElRadioButton v-for="item in menuTypeOptions" :key="item.value" :value="item.value">
              {{ item.label }}
            </ElRadioButton>
          </ElRadioGroup>
        </ElFormItem>

        <ElFormItem label="上级菜单" prop="parent_id">
          <ElTreeSelect
            v-model="model.parent_id"
            :data="parentMenuTree"
            node-key="id"
            :props="{ label: 'label', children: 'children' }"
            check-strictly
            clearable
            :render-after-expand="false"
            style="width: 100%"
          />
        </ElFormItem>

        <ElRow :gutter="16">
          <ElCol :span="12">
            <ElFormItem label="菜单名称" prop="name">
              <ElInput v-model="model.name" placeholder="请输入菜单名称" />
            </ElFormItem>
          </ElCol>

          <ElCol v-if="model.type < 3" :span="12">
            <ElFormItem prop="path">
              <template #label>
                <span title="一级菜单以 / 开头，二级及以下填相对路径">路由地址</span>
              </template>
              <ElInput v-model="model.path" placeholder="如：/dashboard 或 console" />
            </ElFormItem>
          </ElCol>

          <ElCol v-if="model.type !== 3" :span="12">
            <ElFormItem label="组件名称" prop="code">
              <ElInput v-model="model.code" placeholder="如：manage_user" />
            </ElFormItem>
          </ElCol>

          <ElCol v-if="model.type === 2" :span="12">
            <ElFormItem prop="component">
              <template #label>
                <span title="views 目录下的相对路径，目录菜单留空">组件路径</span>
              </template>
              <ElInput v-model="model.component" placeholder="如：/manage/user" />
            </ElFormItem>
          </ElCol>

          <ElCol v-if="model.type !== 3" :span="12">
            <ElFormItem label="菜单图标" prop="icon">
              <SaIconPicker v-model="model.icon" placeholder="请选择菜单图标" />
            </ElFormItem>
          </ElCol>

          <ElCol v-if="model.type === 3" :span="12">
            <ElFormItem label="权限标识" prop="slug">
              <ElInput v-model="model.slug" placeholder="如：core:user:save" />
            </ElFormItem>
          </ElCol>

          <ElCol v-if="model.type === 4" :span="24">
            <ElFormItem label="外链地址" prop="link_url">
              <ElInput v-model="model.link_url" placeholder="如：https://www.baidu.com" />
            </ElFormItem>
          </ElCol>

          <ElCol :span="12">
            <ElFormItem label="排序" prop="sort">
              <ElInputNumber v-model="model.sort" class="w-full" controls-position="right" />
            </ElFormItem>
          </ElCol>

          <ElCol :span="12">
            <ElFormItem label="状态" prop="status">
              <ElRadioGroup v-model="model.status">
                <ElRadio :value="1">正常</ElRadio>
                <ElRadio :value="0">停用</ElRadio>
              </ElRadioGroup>
            </ElFormItem>
          </ElCol>

          <ElCol :span="12">
            <ElFormItem label="是否内嵌" prop="is_iframe">
              <ElRadioGroup v-model="model.is_iframe">
                <ElRadio :value="1">是</ElRadio>
                <ElRadio :value="2">否</ElRadio>
              </ElRadioGroup>
            </ElFormItem>
          </ElCol>

          <ElCol :span="12">
            <ElFormItem label="是否缓存" prop="is_keep_alive">
              <ElRadioGroup v-model="model.is_keep_alive">
                <ElRadio :value="1">是</ElRadio>
                <ElRadio :value="2">否</ElRadio>
              </ElRadioGroup>
            </ElFormItem>
          </ElCol>

          <ElCol :span="12">
            <ElFormItem label="是否隐藏" prop="is_hidden">
              <ElRadioGroup v-model="model.is_hidden">
                <ElRadio :value="1">是</ElRadio>
                <ElRadio :value="2">否</ElRadio>
              </ElRadioGroup>
            </ElFormItem>
          </ElCol>

          <ElCol :span="12">
            <ElFormItem label="是否固定Tab" prop="is_fixed_tab">
              <ElRadioGroup v-model="model.is_fixed_tab">
                <ElRadio :value="1">是</ElRadio>
                <ElRadio :value="2">否</ElRadio>
              </ElRadioGroup>
            </ElFormItem>
          </ElCol>

          <ElCol :span="12">
            <ElFormItem label="是否全屏" prop="is_full_page">
              <ElRadioGroup v-model="model.is_full_page">
                <ElRadio :value="1">是</ElRadio>
                <ElRadio :value="2">否</ElRadio>
              </ElRadioGroup>
            </ElFormItem>
          </ElCol>
        </ElRow>
      </ElForm>
    </ElScrollbar>
    <template #footer>
      <ElSpace :size="16" class="float-right">
        <ElButton @click="closeModal">{{ $t('common.cancel') }}</ElButton>
        <ElButton type="primary" @click="handleSubmit">{{ $t('common.confirm') }}</ElButton>
      </ElSpace>
    </template>
  </ElDialog>
</template>

<style scoped>
:deep(.el-input-number) {
  width: 100%;
}
</style>
