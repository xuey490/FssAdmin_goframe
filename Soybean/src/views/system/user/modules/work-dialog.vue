<script setup lang="ts">
import { computed, reactive, ref, watch } from 'vue';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchSetUserHomePage } from '@/service/api';
import { useDictStore } from '@/store/modules/dict';

defineOptions({ name: 'UserWorkDialog' });

interface Props {
  modelValue: boolean;
  dialogType?: 'add' | 'edit';
  data?: Api.SystemManage.User | null;
}

const props = withDefaults(defineProps<Props>(), {
  dialogType: 'edit',
  data: null
});

interface Emits {
  (e: 'update:modelValue', value: boolean): void;
  (e: 'success'): void;
}

const emit = defineEmits<Emits>();

const dictStore = useDictStore();
const formRef = ref<FormInstance>();

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
});

const rules = reactive<FormRules>({
  dashboard: [{ required: true, message: '请选择工作台', trigger: 'change' }]
});

const formData = reactive({
  id: null as number | null,
  dashboard: ''
});

const dashboardOptions = computed(() => dictStore.getByCode('dashboard'));

function initForm() {
  formData.id = props.data?.id ? Number(props.data.id) : null;
  formData.dashboard = String((props.data as any)?.dashboard || 'workbench');
}

function handleClose() {
  visible.value = false;
  formRef.value?.resetFields();
}

async function handleSubmit() {
  if (!formRef.value || !formData.id) return;

  try {
    await formRef.value.validate();
    const { error } = await fetchSetUserHomePage(formData.id, formData.dashboard);
    if (error) return;
    window.$message?.success('操作成功');
    emit('success');
    handleClose();
  } catch {
    // validation failed
  }
}

watch(
  () => props.modelValue,
  val => {
    if (val) {
      void dictStore.ensureLoaded();
      initForm();
    }
  }
);
</script>

<template>
  <ElDialog v-model="visible" title="设置工作台" width="600px" align-center @close="handleClose">
    <ElForm ref="formRef" :model="formData" :rules="rules" label-width="120px">
      <ElFormItem label="工作台" prop="dashboard">
        <ElSelect v-model="formData.dashboard" placeholder="请选择工作台" style="width: 100%">
          <ElOption v-for="item in dashboardOptions" :key="item.value" :label="item.label" :value="String(item.value)" />
        </ElSelect>
      </ElFormItem>
    </ElForm>
    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" @click="handleSubmit">提交</ElButton>
    </template>
  </ElDialog>
</template>
