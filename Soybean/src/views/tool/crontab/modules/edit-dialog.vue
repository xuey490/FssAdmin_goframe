<script setup lang="ts">
import { ref, watch, nextTick, reactive, computed } from 'vue';
import { ElMessage } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchCreateCrontab, fetchUpdateCrontab } from '@/service/api';

defineOptions({ name: 'CrontabEditDialog' });

interface Props {
  modelValue: boolean;
  dialogType: string;
  data?: Record<string, any>;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  dialogType: 'add',
  data: undefined
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'success'): void;
}>();

const formRef = ref<FormInstance>();

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
});

const rules: FormRules = {
  name: [{ required: true, message: '任务名称不能为空', trigger: 'blur' }],
  type: [{ required: true, message: '任务类型不能为空', trigger: 'blur' }],
  task_style: [{ required: true, message: '定时规则不能为空', trigger: 'blur' }],
  target: [{ required: true, message: '调用目标不能为空', trigger: 'blur' }]
};

const initialFormData = {
  id: null,
  name: '',
  type: '',
  rule: '',
  task_style: 1,
  month: 1,
  day: 1,
  week: 1,
  hour: 1,
  minute: 1,
  second: 1,
  target: '',
  parameter: '',
  status: 1,
  remark: ''
};

const formData = reactive({ ...initialFormData });

watch(
  () => props.modelValue,
  newVal => {
    if (newVal) initPage();
  }
);

const extractNumber = (str: string) => {
  const match = str.match(/\d+/);
  return match ? Number.parseInt(match[0]) : 0;
};

const initPage = async () => {
  Object.assign(formData, initialFormData);
  if (props.data) {
    await nextTick();
    initForm();
  }
};

const initForm = () => {
  if (!props.data) return;
  for (const key in formData) {
    if (props.data[key] != null && props.data[key] != undefined) {
      (formData as any)[key] = props.data[key];
    }
  }
  const words = formData.rule.split(' ');
  formData.second = extractNumber(words[0]);
  formData.minute = extractNumber(words[1]);
  formData.hour = extractNumber(words[2]);
  formData.day = extractNumber(words[3]);
  formData.month = extractNumber(words[4]);
  formData.week = extractNumber(words[5]);
};

const handleClose = () => {
  visible.value = false;
  formRef.value?.resetFields();
};

const handleSubmit = async () => {
  if (!formRef.value) return;
  try {
    await formRef.value.validate();
    if (props.dialogType === 'add') {
      const { error } = await fetchCreateCrontab(formData);
      if (!error) {
        ElMessage.success('新增成功');
        emit('success');
        handleClose();
      }
    } else if (formData.id !== null) {
      const { error } = await fetchUpdateCrontab(formData.id, formData);
      if (!error) {
        ElMessage.success('修改成功');
        emit('success');
        handleClose();
      }
    }
  } catch (error) {
    console.log('表单验证失败:', error);
  }
};
</script>

<template>
  <ElDialog
    v-model="visible"
    :title="dialogType === 'add' ? '新增定时任务' : '编辑定时任务'"
    width="800px"
    align-center
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
      <ElFormItem label="任务名称" prop="name">
        <ElInput v-model="formData.name" placeholder="请输入任务名称" />
      </ElFormItem>
      <ElFormItem label="任务类型" prop="type">
        <SaSelect v-model="formData.type" dict="crontab_task_type" />
      </ElFormItem>
      <ElFormItem label="定时规则" prop="task_style">
        <ElSpace>
          <ElSelect v-model="formData.task_style" :style="{ width: '100px' }">
            <ElOption :value="1" label="每天" />
            <ElOption :value="2" label="每小时" />
            <ElOption :value="3" label="N小时" />
            <ElOption :value="4" label="N分钟" />
            <ElOption :value="5" label="N秒" />
            <ElOption :value="6" label="每周" />
            <ElOption :value="7" label="每月" />
            <ElOption :value="8" label="每年" />
          </ElSelect>
          <template v-if="formData.task_style == 8">
            <ElInputNumber
              v-model="formData.month"
              :precision="0"
              :min="1"
              :max="12"
              controls-position="right"
              :style="{ width: '100px' }"
            />
            <span>月</span>
          </template>
          <template v-if="formData.task_style > 6">
            <ElInputNumber
              v-model="formData.day"
              :precision="0"
              :min="1"
              :max="31"
              controls-position="right"
              :style="{ width: '100px' }"
            />
            <span>日</span>
          </template>
          <ElSelect v-if="formData.task_style == 6" v-model="formData.week" :style="{ width: '100px' }">
            <ElOption :value="1" label="周一" />
            <ElOption :value="2" label="周二" />
            <ElOption :value="3" label="周三" />
            <ElOption :value="4" label="周四" />
            <ElOption :value="5" label="周五" />
            <ElOption :value="6" label="周六" />
            <ElOption :value="0" label="周日" />
          </ElSelect>
          <template v-if="[1, 3, 6, 7, 8].includes(formData.task_style)">
            <ElInputNumber
              v-model="formData.hour"
              :precision="0"
              :min="0"
              :max="23"
              controls-position="right"
              :style="{ width: '100px' }"
            />
            <span>时</span>
          </template>
          <template v-if="formData.task_style != 5">
            <ElInputNumber
              v-model="formData.minute"
              :precision="0"
              :min="0"
              :max="59"
              controls-position="right"
              :style="{ width: '100px' }"
            />
            <span>分</span>
          </template>
          <template v-if="formData.task_style == 5">
            <ElInputNumber
              v-model="formData.second"
              :precision="0"
              :min="0"
              :max="59"
              controls-position="right"
              :style="{ width: '100px' }"
            />
            <span>秒</span>
          </template>
        </ElSpace>
      </ElFormItem>
      <ElFormItem label="调用目标" prop="target">
        <ElInput v-model="formData.target" type="textarea" :rows="3" placeholder="请输入调用目标" />
      </ElFormItem>
      <ElFormItem label="任务参数" prop="params">
        <ElInput v-model="formData.parameter" type="textarea" :rows="3" placeholder="请输入任务参数" />
      </ElFormItem>
      <ElFormItem label="状态" prop="status">
        <SaRadio v-model="formData.status" dict="data_status" />
      </ElFormItem>
      <ElFormItem label="备注" prop="remark">
        <ElInput v-model="formData.remark" type="textarea" :rows="2" placeholder="请输入备注" />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" @click="handleSubmit">提交</ElButton>
    </template>
  </ElDialog>
</template>
