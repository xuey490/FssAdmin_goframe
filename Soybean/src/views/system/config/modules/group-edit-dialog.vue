<script setup lang="ts">
import { computed, reactive, ref, watch } from 'vue';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchCreateConfigGroup, fetchUpdateConfigGroup } from '@/service/api';

defineOptions({ name: 'ConfigGroupEditDialog' });

interface Props {
  visible: boolean;
  dialogType: 'add' | 'edit';
  data?: Partial<Api.Config.ConfigGroup> | null;
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

const rules: FormRules = {
  name: [{ required: true, message: '请输入配置名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入配置标识', trigger: 'blur' }]
};

const initialFormData = {
  id: null as number | null,
  name: '',
  code: '',
  remark: ''
};

const formData = reactive({ ...initialFormData });

watch(
  () => props.visible,
  value => {
    if (!value) return;
    Object.assign(formData, initialFormData);
    if (props.data) {
      Object.assign(formData, props.data);
    }
  }
);

function close() {
  show.value = false;
  formRef.value?.resetFields();
}

async function submit() {
  if (!formRef.value) return;

  await formRef.value.validate();

  if (props.dialogType === 'add') {
    const { error } = await fetchCreateConfigGroup({
      name: formData.name,
      code: formData.code,
      remark: formData.remark
    });
    if (error) return;
    window.$message?.success('新增成功');
  } else {
    const id = Number(formData.id || props.data?.id || 0);
    if (!id) return;
    const { error } = await fetchUpdateConfigGroup(id, {
      name: formData.name,
      code: formData.code,
      remark: formData.remark
    });
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
    :title="props.dialogType === 'add' ? '新增配置分组' : '编辑配置分组'"
    width="600px"
    align-center
    :close-on-click-modal="false"
    @close="close"
  >
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="100px">
      <ElFormItem label="配置名称" prop="name">
        <ElInput v-model="formData.name" placeholder="请输入配置名称" />
      </ElFormItem>
      <ElFormItem label="配置标识" prop="code">
        <ElInput v-model="formData.code" placeholder="请输入配置标识" />
      </ElFormItem>
      <ElFormItem label="备注" prop="remark">
        <ElInput v-model="formData.remark" type="textarea" :rows="3" placeholder="请输入备注" />
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="close">取消</ElButton>
      <ElButton type="primary" @click="submit">提交</ElButton>
    </template>
  </ElDialog>
</template>
