<script setup lang="ts">
import { computed, reactive, ref, watch } from 'vue';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchCreateConfig, fetchUpdateConfig } from '@/service/api';

defineOptions({ name: 'ConfigItemEditDialog' });

interface Props {
  visible: boolean;
  dialogType: 'add' | 'edit';
  data?: Partial<Api.Config.ConfigItem> | null;
}

const props = withDefaults(defineProps<Props>(), {
  data: null
});

interface Emits {
  (e: 'update:visible', value: boolean): void;
  (e: 'success'): void;
}

const emit = defineEmits<Emits>();

const show = computed({
  get: () => props.visible,
  set: value => emit('update:visible', value)
});

const formRef = ref<FormInstance>();

type ConfigSelectData = {
  label: string;
  value: string;
};

const inputComponent = [
  { label: '文本框', value: 'input' },
  { label: '文本域', value: 'textarea' },
  { label: '下拉选择框', value: 'select' },
  { label: '单选框', value: 'radio' },
  { label: '图片上传', value: 'uploadImage' },
  { label: '文件上传', value: 'uploadFile' },
  { label: '富文本编辑器', value: 'wangEditor' }
];

const rules: FormRules = {
  key: [{ required: true, message: '请输入配置标识', trigger: 'blur' }],
  name: [{ required: true, message: '请输入配置标题', trigger: 'blur' }],
  input_type: [{ required: true, message: '请选择组件类型', trigger: 'change' }]
};

const initialFormData = {
  id: null as number | null,
  group_id: null as number | null,
  key: '',
  value: '',
  name: '',
  input_type: 'input',
  config_select_data: [] as ConfigSelectData[],
  sort: 100,
  remark: ''
};

const formData = reactive({ ...initialFormData });

watch(
  () => props.visible,
  value => {
    if (!value) return;
    Object.assign(formData, initialFormData);
    formData.config_select_data = [];
    if (props.data) {
      Object.assign(formData, props.data);
      formData.config_select_data = (props.data.config_select_data || []) as any;
    }
  }
);

function close() {
  show.value = false;
  formRef.value?.resetFields();
}

function addConfigSelectData() {
  formData.config_select_data.push({ label: '', value: '' });
}

function removeConfigSelectData(index: number) {
  formData.config_select_data.splice(index, 1);
}

async function submit() {
  if (!formRef.value) return;
  await formRef.value.validate();

  const payload: any = {
    group_id: formData.group_id,
    key: formData.key,
    value: formData.value,
    name: formData.name,
    input_type: formData.input_type,
    config_select_data: formData.config_select_data,
    sort: formData.sort,
    remark: formData.remark
  };

  if (props.dialogType === 'add') {
    const { error } = await fetchCreateConfig(payload);
    if (error) return;
    window.$message?.success('新增成功');
  } else {
    const id = Number(formData.id || props.data?.id || 0);
    if (!id) return;
    const { error } = await fetchUpdateConfig(id, payload);
    if (error) return;
    window.$message?.success('修改成功');
  }

  emit('success');
  close();
}
</script>

<template>
  <ElDialog
    v-model="show"
    :title="props.dialogType === 'add' ? '新增配置' : '编辑配置'"
    width="600px"
    align-center
    :close-on-click-modal="false"
    @close="close"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
      <ElFormItem label="配置标识" prop="key">
        <ElInput v-model="formData.key" placeholder="请输入配置标识" />
      </ElFormItem>
      <ElFormItem label="配置标题" prop="name">
        <ElInput v-model="formData.name" placeholder="请输入配置标题" />
      </ElFormItem>
      <ElFormItem label="组件类型" prop="input_type">
        <ElSelect v-model="formData.input_type" class="w-full">
          <ElOption v-for="item in inputComponent" :key="item.value" :label="item.label" :value="item.value" />
        </ElSelect>
      </ElFormItem>
      <ElFormItem v-if="['select', 'radio'].includes(formData.input_type)" label="组件数据" prop="config_select_data">
        <ElRow v-for="(item, index) in formData.config_select_data" :key="index" :gutter="10" class="mb-8px">
          <ElCol :span="10">
            <ElInput v-model="item.label" placeholder="请输入label" />
          </ElCol>
          <ElCol :span="10">
            <ElInput v-model="item.value" placeholder="请输入value" />
          </ElCol>
          <ElCol :span="4">
            <ElButton type="danger" @click="removeConfigSelectData(index)">删除</ElButton>
          </ElCol>
        </ElRow>
        <ElButton type="primary" @click="addConfigSelectData">新增一行</ElButton>
      </ElFormItem>
      <ElFormItem label="排序" prop="sort">
        <ElInputNumber v-model="formData.sort" class="w-full" />
      </ElFormItem>
      <ElFormItem label="描述" prop="remark">
        <ElInput v-model="formData.remark" type="textarea" :rows="3" placeholder="请输入配置描述" />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="close">取消</ElButton>
      <ElButton type="primary" @click="submit">提交</ElButton>
    </template>
  </ElDialog>
</template>
