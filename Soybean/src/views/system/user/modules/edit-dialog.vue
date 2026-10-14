<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { enableStatusOptions, userGenderOptions } from '@/constants/business';
import {
  fetchCreateUser,
  fetchGetAccessDeptTree,
  fetchGetAccessPostList,
  fetchGetAllRoles,
  fetchGetUserDetail,
  fetchUpdateUser
} from '@/service/api';
import { useForm, useFormRules } from '@/hooks/common/form';
import { $t } from '@/locales';

defineOptions({ name: 'UserEditDialog' });

interface Props {
  modelValue: boolean;
  dialogType: 'add' | 'edit';
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

const { formRef, validate, restoreValidation } = useForm();
const { defaultRequiredRule } = useFormRules();

const title = computed(() =>
  props.dialogType === 'add' ? $t('page.manage.user.addUser') : $t('page.manage.user.editUser')
);

type Model = Pick<
  Api.SystemManage.User,
  'username' | 'gender' | 'realname' | 'phone' | 'email' | 'status' | 'remark'
> & {
  password: string;
  confirmPassword: string;
  avatar?: string;
  dept_id?: number | null;
  role_ids: number[];
  post_ids: number[];
};

const model = ref(createDefaultModel());

function createDefaultModel(): Model {
  return {
    username: '',
    password: '',
    confirmPassword: '',
    avatar: '',
    gender: undefined,
    realname: '',
    phone: '',
    email: '',
    dept_id: undefined,
    role_ids: [],
    post_ids: [],
    remark: '',
    status: '1'
  };
}

type RuleKey = Extract<keyof Model, 'username' | 'password' | 'confirmPassword' | 'dept_id' | 'role_ids' | 'status'>;

const rules: Record<RuleKey, App.Global.FormRule> = {
  username: defaultRequiredRule,
  password: {
    validator: (_rule, value, callback) => {
      if (props.dialogType === 'add' && !value) {
        callback(new Error('请输入密码'));
        return;
      }
      if (value && String(value).length < 6) {
        callback(new Error('密码长度不能少于6位'));
        return;
      }
      callback();
    },
    trigger: 'blur'
  },
  confirmPassword: {
    validator: (_rule, value, callback) => {
      if (props.dialogType === 'add' && !value) {
        callback(new Error('请确认密码'));
        return;
      }
      if (value && value !== model.value.password) {
        callback(new Error('两次输入密码不一致'));
        return;
      }
      callback();
    },
    trigger: 'blur'
  },
  dept_id: defaultRequiredRule,
  role_ids: defaultRequiredRule,
  status: defaultRequiredRule
};

const roleOptions = ref<CommonType.Option<number>[]>([]);
const deptTree = ref<Api.SystemManage.MenuTree[]>([]);
const postOptions = ref<CommonType.Option<number>[]>([]);

async function getRoleOptions() {
  const { error, data } = await fetchGetAllRoles();
  if (!error) {
    roleOptions.value = data.map(item => ({
      label: item.name,
      value: Number(item.id)
    }));
  }
}

async function getDeptOptions() {
  const { error, data } = await fetchGetAccessDeptTree();
  if (!error) {
    deptTree.value = data;
  }
}

async function getPostOptions() {
  const { error, data } = await fetchGetAccessPostList();
  if (!error) {
    postOptions.value = (data || []).map(item => ({ label: item.name, value: item.id }));
  }
}

async function initForm() {
  model.value = createDefaultModel();

  if (props.dialogType === 'edit' && props.data?.id) {
    const { error, data } = await fetchGetUserDetail(props.data.id);
    if (!error && data) {
      Object.assign(model.value, {
        ...data,
        role_ids: data.role_ids || [],
        post_ids: data.post_ids || [],
        status: String(data.status ?? '1') as Api.Common.EnableStatus,
        password: '',
        confirmPassword: ''
      });
    }
  }
}

function handleClose() {
  visible.value = false;
  formRef.value?.resetFields();
}

async function handleSubmit() {
  await validate();
  const payload = {
    username: model.value.username,
    password: model.value.password || undefined,
    avatar: model.value.avatar || '',
    realname: model.value.realname,
    phone: model.value.phone,
    email: model.value.email,
    gender: model.value.gender,
    dept_id: model.value.dept_id,
    status: model.value.status,
    role_ids: model.value.role_ids,
    post_ids: model.value.post_ids,
    remark: model.value.remark
  };

  const request =
    props.dialogType === 'add'
      ? fetchCreateUser(payload)
      : fetchUpdateUser(Number(props.data!.id), payload);

  const { error } = await request;
  if (error) return;

  window.$message?.success(
    props.dialogType === 'add' ? $t('common.addSuccess') : $t('common.updateSuccess')
  );
  emit('success');
  handleClose();
}

watch(
  () => props.modelValue,
  val => {
    if (val) {
      restoreValidation();
      void Promise.all([getRoleOptions(), getDeptOptions(), getPostOptions()]).then(() => initForm());
    }
  }
);
</script>

<template>
  <ElDialog v-model="visible" :title="title" width="960px" align-center :close-on-click-modal="false" @close="handleClose">
    <ElForm ref="formRef" :model="model" :rules="rules" label-width="90px">
      <ElFormItem label="头像" prop="avatar">
        <SaImagePicker v-model="model.avatar" round />
      </ElFormItem>
      <ElRow :gutter="16">
        <ElCol :span="12">
          <ElFormItem :label="$t('page.manage.user.userName')" prop="username">
            <ElInput
              v-model="model.username"
              :disabled="dialogType === 'edit'"
              :placeholder="$t('page.manage.user.form.userName')"
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem :label="$t('page.manage.user.nickName')" prop="realname">
            <ElInput v-model="model.realname" :placeholder="$t('page.manage.user.form.nickName')" />
          </ElFormItem>
        </ElCol>
        <template v-if="dialogType === 'add'">
          <ElCol :span="12">
            <ElFormItem label="密码" prop="password">
              <ElInput v-model="model.password" type="password" show-password placeholder="请输入密码" />
            </ElFormItem>
          </ElCol>
          <ElCol :span="12">
            <ElFormItem label="确认密码" prop="confirmPassword">
              <ElInput v-model="model.confirmPassword" type="password" show-password placeholder="请确认密码" />
            </ElFormItem>
          </ElCol>
        </template>
        <ElCol :span="12">
          <ElFormItem :label="$t('page.manage.user.userEmail')" prop="email">
            <ElInput v-model="model.email" :placeholder="$t('page.manage.user.form.userEmail')" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem :label="$t('page.manage.user.userPhone')" prop="phone">
            <ElInput v-model="model.phone" :placeholder="$t('page.manage.user.form.userPhone')" />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="所在部门" prop="dept_id">
            <ElTreeSelect
              v-model="model.dept_id"
              :data="deptTree"
              node-key="id"
              :props="{ label: 'label', children: 'children' }"
              check-strictly
              clearable
            />
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem :label="$t('page.manage.user.userRole')" prop="role_ids">
            <ElSelect v-model="model.role_ids" multiple :placeholder="$t('page.manage.user.form.userRole')">
              <ElOption v-for="{ label, value } in roleOptions" :key="value" :label="label" :value="value" />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem label="岗位" prop="post_ids">
            <ElSelect v-model="model.post_ids" multiple placeholder="请选择岗位">
              <ElOption v-for="{ label, value } in postOptions" :key="value" :label="label" :value="value" />
            </ElSelect>
          </ElFormItem>
        </ElCol>
        <ElCol :span="12">
          <ElFormItem :label="$t('page.manage.user.userGender')" prop="gender">
            <ElRadioGroup v-model="model.gender">
              <ElRadio
                v-for="item in userGenderOptions"
                :key="item.value"
                :value="item.value"
                :label="$t(item.label)"
              />
            </ElRadioGroup>
          </ElFormItem>
        </ElCol>
        <ElCol :span="24">
          <ElFormItem :label="$t('page.manage.user.userStatus')" prop="status">
            <ElRadioGroup v-model="model.status">
              <ElRadio
                v-for="item in enableStatusOptions"
                :key="item.value"
                :value="item.value"
                :label="$t(item.label)"
              />
            </ElRadioGroup>
          </ElFormItem>
        </ElCol>
        <ElCol :span="24">
          <ElFormItem :label="$t('page.manage.dept.remark')" prop="remark">
            <ElInput v-model="model.remark" type="textarea" placeholder="请输入备注" />
          </ElFormItem>
        </ElCol>
      </ElRow>
    </ElForm>
    <template #footer>
      <ElSpace :size="16">
        <ElButton @click="handleClose">{{ $t('common.cancel') }}</ElButton>
        <ElButton type="primary" @click="handleSubmit">{{ $t('common.confirm') }}</ElButton>
      </ElSpace>
    </template>
  </ElDialog>
</template>
