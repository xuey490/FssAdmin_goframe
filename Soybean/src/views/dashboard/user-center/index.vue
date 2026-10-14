<script setup lang="ts">
import { computed, onMounted, reactive, ref, watch } from 'vue';
import type { FormInstance, FormRules } from 'element-plus';
import userBg from '@/assets/images/user/user-bg.jpg';
import { fetchGetLogin, fetchGetOperate, fetchGetUserInfo, modifyPassword, updateUserInfo } from '@/api/auth';
import { useAuthStore } from '@/store/modules/auth';

defineOptions({ name: 'UserCenter' });

type UserProfile = Api.Auth.UserProfileResponse;

function normalizeLogList(payload: Record<string, any> | null | undefined) {
  if (!payload) return [];
  if (Array.isArray(payload.data)) return payload.data;
  if (Array.isArray(payload.list)) return payload.list;
  if (Array.isArray(payload.records)) return payload.records;
  return [];
}

const authStore = useAuthStore();
const profile = ref<UserProfile | null>(null);

const userInfo = computed(() => {
  const current = profile.value;
  return {
    id: current?.id ?? authStore.userInfo.userId,
    username: current?.username ?? authStore.userInfo.userName,
    realname: current?.realname ?? authStore.userInfo.realName ?? '',
    email: current?.email ?? authStore.userInfo.email ?? '',
    phone: current?.phone ?? authStore.userInfo.phone ?? '',
    gender: current?.gender ?? authStore.userInfo.gender ?? '',
    avatar: current?.avatar ?? authStore.userInfo.avatar ?? '',
    signed: current?.signed ?? authStore.userInfo.signed ?? '',
    department: current?.department ?? authStore.userInfo.department ?? null
  };
});

const isEdit = ref(false);
const isEditPwd = ref(false);
const ruleFormRef = ref<FormInstance>();
const pwdFormRef = ref<FormInstance>();
const passwordSafePercent = ref(0);
const avatar = ref('');

const form = reactive({
  id: '' as string | number,
  realname: '',
  gender: '',
  email: '',
  phone: '',
  signed: ''
});

const pwdForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
});

const rules = reactive<FormRules>({
  realname: [
    { required: true, message: '请输入姓名', trigger: 'blur' },
    { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }],
  phone: [{ required: true, message: '请输入手机号码', trigger: 'blur' }],
  gender: [{ required: true, message: '请选择性别', trigger: 'blur' }]
});

const pwdRules = reactive<FormRules>({
  oldPassword: [{ required: true, message: '请输入当前密码', trigger: 'blur' }],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  confirmPassword: [{ required: true, message: '请确认新密码', trigger: 'blur' }]
});

const loginLogList = ref<Record<string, any>[]>([]);
const operationLogList = ref<Record<string, any>[]>([]);
const logType = ref(1);

function syncFormFromProfile(data: UserProfile) {
  form.id = data.id;
  form.realname = data.realname ?? '';
  form.gender = data.gender != null ? String(data.gender) : '';
  form.email = data.email ?? '';
  form.phone = data.phone ?? '';
  form.signed = data.signed ?? '';
}

async function loadProfile() {
  const { data, error } = await fetchGetUserInfo();
  if (error || !data) {
    return;
  }
  profile.value = data as UserProfile;
  syncFormFromProfile(data as UserProfile);
  avatar.value = (data as UserProfile).avatar ?? '';
}

async function loadLogin() {
  const { data, error } = await fetchGetLogin({
    page: 1,
    limit: 5,
    username: userInfo.value.username
  });
  if (error) {
    return;
  }
  loginLogList.value = normalizeLogList(data as Record<string, any>);
}

async function loadOperate() {
  const { data, error } = await fetchGetOperate({
    page: 1,
    limit: 5,
    username: userInfo.value.username
  });
  if (error) {
    return;
  }
  operationLogList.value = normalizeLogList(data as Record<string, any>);
}

watch(logType, newVal => {
  if (newVal === 1 && loginLogList.value.length === 0) {
    loadLogin();
  } else if (newVal === 2 && operationLogList.value.length === 0) {
    loadOperate();
  }
});

onMounted(async () => {
  await loadProfile();
  avatar.value = userInfo.value.avatar || '';
  await Promise.all([loadLogin(), loadOperate()]);
});

const handleAvatarChange = async (val: string | string[]) => {
  if (!val || Array.isArray(val)) {
    return;
  }
  const { error } = await updateUserInfo({
    id: form.id,
    avatar: val
  });
  if (error) {
    return;
  }
  authStore.userInfo.avatar = val;
  if (profile.value) {
    profile.value.avatar = val;
  }
  ElMessage.success('修改头像成功');
};

const edit = async () => {
  if (isEdit.value) {
    try {
      await ruleFormRef.value?.validate();
      const { error } = await updateUserInfo({ ...form });
      if (error) {
        return;
      }
      await authStore.initUserInfo();
      await loadProfile();
      ElMessage.success('修改成功');
      isEdit.value = false;
    } catch {
      // validation failed
    }
  } else {
    isEdit.value = true;
  }
};

const editPwd = async () => {
  if (isEditPwd.value) {
    try {
      await pwdFormRef.value?.validate();
      if (pwdForm.newPassword !== pwdForm.confirmPassword) {
        ElMessage.error('确认密码与新密码不一致');
        return;
      }
      const { error } = await modifyPassword({
        oldPassword: pwdForm.oldPassword,
        newPassword: pwdForm.newPassword
      });
      if (error) {
        return;
      }
      ElMessage.success('修改成功');
      Object.assign(pwdForm, { oldPassword: '', newPassword: '', confirmPassword: '' });
      isEditPwd.value = false;
    } catch {
      // validation failed
    }
  } else {
    isEditPwd.value = true;
  }
};

const checkSafe = (password: string) => {
  if (password.length < 1) {
    passwordSafePercent.value = 0;
    return;
  }
  if (!(password.length >= 6)) {
    passwordSafePercent.value = 0;
    return;
  }
  passwordSafePercent.value = 10;
  if (/\d/.test(password)) {
    passwordSafePercent.value += 10;
  }
  if (/[a-z]/.test(password)) {
    passwordSafePercent.value += 10;
  }
  if (/[A-Z]/.test(password)) {
    passwordSafePercent.value += 30;
  }
  if (/[`~!@#$%^&*()_+<>?:"{},./;'[\]]/.test(password)) {
    passwordSafePercent.value += 40;
  }
};
</script>

<template>
  <div class="user-center-page">
    <div class="user-center-page__layout">
      <div class="user-center-page__sidebar">
        <ElCard class="card-wrapper user-center-page__profile-card" shadow="never">
          <img class="user-center-page__bg" :src="userBg" alt="" />
          <SaImageUpload
            v-model="avatar"
            class="user-center-page__avatar"
            :width="80"
            :height="80"
            :show-tips="false"
            round
            @change="handleAvatarChange"
          />
          <h2 class="user-center-page__username">{{ userInfo.username }}</h2>
          <div class="user-center-page__meta">
            <div class="user-center-page__meta-item">
              <SvgIcon icon="ri:user-line" class="user-center-page__meta-icon" />
              <span>{{ userInfo.realname }}</span>
            </div>
            <div class="user-center-page__meta-item">
              <SvgIcon
                :icon="userInfo.gender === '1' || userInfo.gender === 1 ? 'ri:men-line' : 'ri:women-line'"
                class="user-center-page__meta-icon"
              />
              <span>{{ userInfo.gender === '1' || userInfo.gender === 1 ? '男' : '女' }}</span>
            </div>
            <div class="user-center-page__meta-item">
              <SvgIcon icon="ri:mail-line" class="user-center-page__meta-icon" />
              <span>{{ userInfo.email }}</span>
            </div>
            <div class="user-center-page__meta-item">
              <SvgIcon icon="ri:phone-line" class="user-center-page__meta-icon" />
              <span>{{ userInfo.phone }}</span>
            </div>
            <div class="user-center-page__meta-item">
              <SvgIcon icon="ri:dribbble-fill" class="user-center-page__meta-icon" />
              <span>{{ userInfo.department?.name }}</span>
            </div>
          </div>
        </ElCard>

        <ElCard class="card-wrapper user-center-page__log-card" shadow="never">
          <div class="user-center-page__log-header">
            <h3 class="user-center-page__section-title">日志信息</h3>
            <ElRadioGroup v-model="logType">
              <ElRadioButton :value="1" label="登录日志" />
              <ElRadioButton :value="2" label="操作日志" />
            </ElRadioGroup>
          </div>
          <div class="user-center-page__timeline-wrap">
            <ElTimeline v-if="logType === 1 && loginLogList.length > 0" class="user-center-page__timeline">
              <ElTimelineItem
                v-for="(item, idx) in loginLogList"
                :key="idx"
                :timestamp="`${item.username}，您于 ${item.login_time} 登录系统`"
                placement="top"
              >
                <div class="user-center-page__timeline-detail">
                  <span>地理位置：{{ item.ip_location || '未知' }}</span>
                  <span>操作系统：{{ item.os }}</span>
                </div>
              </ElTimelineItem>
            </ElTimeline>

            <ElTimeline v-if="logType === 2 && operationLogList.length > 0" class="user-center-page__timeline">
              <ElTimelineItem
                v-for="(item, idx) in operationLogList"
                :key="idx"
                :timestamp="`${item.username}，您于 ${item.create_time} 执行了 ${item.service_name}`"
                placement="top"
              >
                <div class="user-center-page__timeline-detail">
                  <span>地理位置：{{ item.ip_location || '未知' }}</span>
                  <span>路由：{{ item.router }}</span>
                </div>
              </ElTimelineItem>
            </ElTimeline>

            <ElEmpty
              v-if="(logType === 1 && loginLogList.length === 0) || (logType === 2 && operationLogList.length === 0)"
              description="暂无日志"
            />
          </div>
        </ElCard>
      </div>

      <div class="user-center-page__main">
        <ElCard class="card-wrapper" shadow="never">
          <h3 class="user-center-page__section-title user-center-page__section-title--border">基本设置</h3>
          <ElForm
            ref="ruleFormRef"
            :model="form"
            :rules="rules"
            class="user-center-page__form"
            label-width="86px"
            label-position="top"
          >
            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="姓名" prop="realname">
                  <ElInput v-model="form.realname" :disabled="!isEdit" />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="性别" prop="gender">
                  <SaSelect
                    v-model="form.gender"
                    placeholder="请选择性别"
                    dict="gender"
                    value-type="string"
                    :disabled="!isEdit"
                  />
                </ElFormItem>
              </ElCol>
            </ElRow>

            <ElRow :gutter="20">
              <ElCol :span="12">
                <ElFormItem label="邮箱" prop="email">
                  <ElInput v-model="form.email" :disabled="!isEdit" />
                </ElFormItem>
              </ElCol>
              <ElCol :span="12">
                <ElFormItem label="手机" prop="phone">
                  <ElInput v-model="form.phone" :disabled="!isEdit" />
                </ElFormItem>
              </ElCol>
            </ElRow>

            <ElFormItem label="个人介绍" prop="signed" class="user-center-page__signed-item">
              <ElInput v-model="form.signed" type="textarea" :rows="4" :disabled="!isEdit" />
            </ElFormItem>

            <div class="user-center-page__actions">
              <ElButton type="primary" @click="edit">
                {{ isEdit ? '保存' : '编辑' }}
              </ElButton>
            </div>
          </ElForm>
        </ElCard>

        <ElCard class="card-wrapper user-center-page__pwd-card" shadow="never">
          <h3 class="user-center-page__section-title user-center-page__section-title--border">更改密码</h3>
          <ElForm
            ref="pwdFormRef"
            :model="pwdForm"
            :rules="pwdRules"
            class="user-center-page__form"
            label-width="86px"
            label-position="top"
          >
            <ElFormItem label="当前密码" prop="oldPassword">
              <ElInput v-model="pwdForm.oldPassword" type="password" :disabled="!isEditPwd" show-password />
            </ElFormItem>

            <ElFormItem label="新密码" prop="newPassword">
              <ElInput
                v-model="pwdForm.newPassword"
                type="password"
                :disabled="!isEditPwd"
                show-password
                @input="checkSafe"
              />
            </ElFormItem>

            <ElFormItem label="密码安全度" prop="passwordSafePercent">
              <ElProgress
                :percentage="passwordSafePercent"
                :show-text="false"
                class="w-full"
                status="success"
                :stroke-width="12"
              />
            </ElFormItem>

            <ElFormItem label="确认新密码" prop="confirmPassword">
              <ElInput v-model="pwdForm.confirmPassword" type="password" :disabled="!isEditPwd" show-password />
            </ElFormItem>

            <div class="user-center-page__actions">
              <ElButton type="primary" @click="editPwd">
                {{ isEditPwd ? '保存' : '编辑' }}
              </ElButton>
            </div>
          </ElForm>
        </ElCard>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.user-center-page {
  padding: 0;
}

.user-center-page__layout {
  display: flex;
  gap: 20px;
  margin-top: 10px;

  @media (max-width: 768px) {
    flex-direction: column;
  }
}

.user-center-page__sidebar {
  width: 448px;
  flex-shrink: 0;

  @media (max-width: 768px) {
    width: 100%;
  }
}

.user-center-page__main {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.user-center-page__profile-card {
  position: relative;
  overflow: hidden;
  text-align: center;
  padding: 36px 24px 24px !important;
}

.user-center-page__bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.user-center-page__avatar {
  position: relative;
  z-index: 1;
  width: 80px;
  height: 80px;
  margin: 120px auto 0;
}

.user-center-page__username {
  position: relative;
  z-index: 1;
  margin-top: 20px;
  font-size: 20px;
  font-weight: 400;
}

.user-center-page__meta {
  position: relative;
  z-index: 1;
  width: 300px;
  max-width: 100%;
  margin: 10px auto 0;
  text-align: left;
}

.user-center-page__meta-item {
  display: flex;
  align-items: center;
  margin-top: 10px;
  font-size: 14px;
}

.user-center-page__meta-icon {
  font-size: 16px;
  color: var(--el-text-color-secondary);
}

.user-center-page__meta-item span {
  margin-left: 8px;
}

.user-center-page__log-card {
  margin-top: 20px;
  min-height: 512px;
}

.user-center-page__log-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--el-border-color-lighter);
}

.user-center-page__section-title {
  margin: 0;
  font-size: 20px;
  font-weight: 400;
}

.user-center-page__section-title--border {
  padding: 16px 0;
  border-bottom: 1px solid var(--el-border-color-lighter);
}

.user-center-page__timeline-wrap {
  margin-top: 24px;
}

.user-center-page__timeline {
  padding-left: 20px;
}

.user-center-page__timeline-detail {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding: 8px 0;
  font-size: 12px;
}

.user-center-page__form {
  padding: 20px;
}

.user-center-page__signed-item :deep(.el-textarea__inner) {
  min-height: 96px;
}

.user-center-page__actions {
  display: flex;
  justify-content: flex-end;
}

.user-center-page__pwd-card {
  min-height: 512px;
}
</style>
