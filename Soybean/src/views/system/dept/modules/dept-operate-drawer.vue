<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { fetchCreateDept, fetchGetDeptDetail, fetchGetDeptTree, fetchUpdateDept } from '@/service/api';
import { useForm, useFormRules } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({ name: 'DeptOperateDrawer' });

interface Props {
  operateType: UI.TableOperateType;
  rowData?: Api.Dept.Dept | null;
}

const props = defineProps<Props>();
const emit = defineEmits<{ (e: 'submitted'): void }>();

const visible = defineModel<boolean>('visible', {
  default: false
});

const { formRef, validate, restoreValidation } = useForm();
const { defaultRequiredRule } = useFormRules();

const title = computed(() => {
  const map: Record<UI.TableOperateType, string> = {
    add: $t('page.manage.dept.addDept'),
    edit: $t('page.manage.dept.editDept')
  };
  return map[props.operateType];
});

type Model = Pick<Api.Dept.Dept, 'name' | 'code' | 'parent_id' | 'status' | 'phone' | 'email' | 'sort' | 'remark'>;
type LeaderOption = {
  id: number;
  email: string;
  phone: string;
  status: string;
  realname: string;
  username: string;
  avatar?: string;
};
type DeptModel = Model & {
  leader_id?: number | null | number[] | LeaderOption;
};

const model = ref<DeptModel>({
  name: '',
  code: '',
  parent_id: 0,
  leader_id: null,
  status: '1',
  phone: '',
  email: '',
  sort: 0,
  remark: ''
});

const rules: Record<'name' | 'code' | 'status', App.Global.FormRule> = {
  name: defaultRequiredRule,
  code: defaultRequiredRule,
  status: defaultRequiredRule
};

const deptTree = ref<Api.SystemManage.MenuTree[]>([]);

async function getDeptTree() {
  const { error, data } = await fetchGetDeptTree();
  if (!error) {
    const rootNode: Api.SystemManage.MenuTree = {
      id: 0,
      label: '无上级部门',
      children: data || []
    };
    deptTree.value = [rootNode];
  }
}

async function handleInitModel() {
  model.value = {
    name: '',
    code: '',
    parent_id: 0,
    leader_id: null,
    status: '1',
    phone: '',
    email: '',
    sort: 0,
    remark: ''
  };

  if (props.operateType === 'edit' && props.rowData) {
    const { error, data } = await fetchGetDeptDetail(props.rowData.id);
	console.log(error);
    if (!error && data) {
      const normalizedParentId = Number(data.parent_id || 0);
      Object.assign(model.value, {
        ...data,
        parent_id: Number.isNaN(normalizedParentId) ? 0 : normalizedParentId,
        leader_id: buildLeaderValue(data, props.rowData),
        status: normalizeStatus(data.status)
      });
      return;
    }
    const normalizedParentId = Number(props.rowData.parent_id || 0);
    Object.assign(model.value, {
      ...props.rowData,
      parent_id: Number.isNaN(normalizedParentId) ? 0 : normalizedParentId,
      leader_id: buildLeaderValue(props.rowData, props.rowData),
      status: normalizeStatus(props.rowData.status)
    });
  }
}

function normalizeStatus(status: unknown): Api.Common.EnableStatus {
  const value = String(status ?? '1');
  if (value === '0' || value === '2') return '0';
  return '1';
}

function buildLeaderValue(primary: any, fallback: any): LeaderOption | null {
  const source = primary || fallback || {};
  const fallbackSource = fallback || {};
  const leaderId = Number(source.leader_id || fallbackSource.leader_id || 0);
  if (!leaderId) return null;
  const leader = source.leader || fallbackSource.leader || {};
  return {
    id: leaderId,
    email: String(leader.email || ''),
    phone: String(leader.phone || ''),
    status: String(leader.status ?? '1'),
    realname: String(source.leader_name || leader.realname || fallbackSource.leader_name || leader.username || ''),
    username: String(leader.username || source.leader_name || fallbackSource.leader_name || '')
  };
}

function resolveLeaderId(leader: DeptModel['leader_id']): number {
  if (Array.isArray(leader)) return Number(leader[0] || 0);
  if (!leader) return 0;
  if (typeof leader === 'number') return Number(leader);
  if (typeof leader === 'object' && 'id' in leader) {
    return Number((leader as LeaderOption).id || 0);
  }
  return Number(leader || 0);
}

function closeDrawer() {
  visible.value = false;
}

async function handleSubmit() {
  await validate();
  const normalizedLeaderId = resolveLeaderId(model.value.leader_id);
  const payload: Partial<Api.Dept.Dept> = {
    ...model.value,
    parent_id: Number(model.value.parent_id || 0),
    leader_id: normalizedLeaderId > 0 ? normalizedLeaderId : null,
    status: (String(model.value.status || '1') as Api.Common.EnableStatus)
  };
  const request =
    props.operateType === 'add'
      ? fetchCreateDept(payload)
      : fetchUpdateDept(Number(props.rowData?.id), payload);
  const { error } = await request;
  if (error) return;
  window.$message?.success($t('common.updateSuccess'));
  closeDrawer();
  emit('submitted');
}

watch(visible, val => {
  if (val) {
    void handleInitModel();
    restoreValidation();
    void getDeptTree();
  }
});
</script>

<template>
  <ElDialog v-model="visible" :title="title" width="760px" align-center :close-on-click-modal="false">
    <ElForm ref="formRef" :model="model" :rules="rules" label-width="96px" class="pr-4">
      <ElFormItem :label="$t('page.manage.dept.parentDept')" prop="parent_id" required>
        <ElTreeSelect
          v-model="model.parent_id"
          :data="deptTree"
          node-key="id"
          :props="{ label: 'label', children: 'children' }"
          check-strictly
          clearable
        />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.dept.deptName')" prop="name">
        <ElInput v-model="model.name" :placeholder="$t('page.manage.dept.form.deptName')" />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.dept.deptCode')" prop="code">
        <ElInput v-model="model.code" :placeholder="$t('page.manage.dept.form.deptCode')" />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.dept.leader')" prop="leader_id">
        <SaUser
          v-model="model.leader_id"
          clearable
          value-type="object"
          :placeholder="$t('page.manage.dept.form.leader')"
        />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.dept.remark')" prop="remark">
        <ElInput v-model="model.remark" type="textarea" :rows="3" />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.dept.sort')" prop="sort">
        <ElInputNumber v-model="model.sort" class="w-[190px]" />
      </ElFormItem>
      <ElFormItem :label="$t('page.manage.dept.deptStatus')" prop="status">
        <ElRadioGroup v-model="model.status">
          <ElRadio value="1">启用</ElRadio>
          <ElRadio value="0">禁用</ElRadio>
        </ElRadioGroup>
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElSpace>
        <ElButton @click="closeDrawer">{{ $t('common.cancel') }}</ElButton>
        <ElButton type="primary" @click="handleSubmit">提交</ElButton>
      </ElSpace>
    </template>
  </ElDialog>
</template>
