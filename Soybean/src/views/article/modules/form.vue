<script setup lang="ts">
import { computed, nextTick, reactive, ref, watch } from 'vue';
import { ElMessage } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { fetchCreateArticle, fetchUpdateArticle } from '@/service/api';
import './form.css';

defineOptions({ name: 'ArticleFormDialog' });

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
const submitLoading = ref(false);

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
});

const title = computed(() => (props.dialogType === 'add' ? '新增文章' : '编辑文章'));

const initialFormData = {
  id: null as number | null,
  title: '',
  category_id: null as number | null,
  author: '',
  image: '',
  describe: '',
  content: '',
  is_link: 2,
  link_url: '',
  is_hot: 2,
  sort: 100,
  status: 1
};

const form = reactive({ ...initialFormData });

const rules = computed<FormRules>(() => {
  const baseRules: FormRules = {
    title: [{ required: true, message: '请输入文章标题', trigger: 'blur' }],
    category_id: [{ required: true, message: '请选择文章分类', trigger: 'change' }],
    describe: [{ required: true, message: '请输入文章简介', trigger: 'blur' }]
  };

  if (form.is_link === 1) {
    baseRules.link_url = [
      { required: true, message: '请输入外链地址', trigger: 'blur' },
      { type: 'url', message: '请输入正确的URL格式', trigger: 'blur' }
    ];
  }

  if (form.is_link === 2) {
    baseRules.content = [{ required: true, message: '请输入文章内容', trigger: 'blur' }];
  }

  return baseRules;
});

watch(
  () => props.modelValue,
  newVal => {
    if (newVal) {
      initPage();
    }
  }
);

const initPage = async () => {
  Object.assign(form, initialFormData);
  if (props.data) {
    await nextTick();
    initForm();
  }
};

const initForm = () => {
  if (props.data) {
    for (const key in form) {
      if (props.data[key] != null && props.data[key] !== undefined) {
        (form as any)[key] = props.data[key];
      }
    }
  }
};

const handleClose = () => {
  visible.value = false;
  formRef.value?.resetFields();
};

const handleSubmit = async () => {
  if (!formRef.value) return;
  try {
    await formRef.value.validate();
    submitLoading.value = true;

    if (props.dialogType === 'add') {
      const { error } = await fetchCreateArticle({ ...form, id: undefined, category_id: form.category_id ?? undefined });
      if (error) return;
      ElMessage.success('创建成功');
    } else if (form.id != null) {
      const { error } = await fetchUpdateArticle(form.id, { ...form, id: form.id, category_id: form.category_id ?? undefined });
      if (error) return;
      ElMessage.success('更新成功');
    }

    emit('success');
    handleClose();
  } catch (error) {
    console.log('表单验证失败:', error);
  } finally {
    submitLoading.value = false;
  }
};
</script>

<template>
  <ElDialog
    v-model="visible"
    :title="title"
    width="min(840px, calc(100vw - 32px))"
    top="4vh"
    destroy-on-close
    :close-on-click-modal="false"
    body-class="article-form-dialog__body"
    header-class="article-form-dialog__header"
    footer-class="article-form-dialog__footer"
    class="article-form-dialog"
    @close="handleClose"
  >
    <div class="article-form-dialog__content">
      <ElForm ref="formRef" :model="form" :rules="rules" label-width="100px">
        <ElFormItem label="文章标题" prop="title">
          <ElInput v-model="form.title" placeholder="请输入文章标题" clearable />
        </ElFormItem>

        <ElFormItem label="文章分类" prop="category_id">
          <ElInputNumber
            v-model="form.category_id"
            placeholder="请输入分类ID"
            :min="1"
            style="width: 100%"
          />
        </ElFormItem>

        <ElFormItem label="作者" prop="author">
          <ElInput v-model="form.author" placeholder="请输入作者" clearable />
        </ElFormItem>

        <ElFormItem label="封面图片" prop="image">
          <SaImagePicker v-model="form.image" :limit="1" :multiple="false" />
        </ElFormItem>

        <ElFormItem label="文章简介" prop="describe">
          <ElInput
            v-model="form.describe"
            type="textarea"
            :rows="3"
            placeholder="请输入文章简介"
            clearable
          />
        </ElFormItem>

        <ElFormItem label="是否外链" prop="is_link">
          <ElRadioGroup v-model="form.is_link">
            <ElRadio :value="2">否</ElRadio>
            <ElRadio :value="1">是</ElRadio>
          </ElRadioGroup>
        </ElFormItem>

        <ElFormItem v-if="form.is_link === 1" label="外链地址" prop="link_url">
          <ElInput v-model="form.link_url" placeholder="请输入外链地址" clearable />
        </ElFormItem>

        <ElFormItem v-if="form.is_link === 2" label="文章内容" prop="content">
          <SaEditor v-model="form.content" height="320px" />
        </ElFormItem>

        <ElFormItem label="是否热门" prop="is_hot">
          <ElRadioGroup v-model="form.is_hot">
            <ElRadio :value="2">否</ElRadio>
            <ElRadio :value="1">是</ElRadio>
          </ElRadioGroup>
        </ElFormItem>

        <ElFormItem label="排序" prop="sort">
          <ElInputNumber v-model="form.sort" :min="0" placeholder="请输入排序" style="width: 100%" />
        </ElFormItem>

        <ElFormItem label="状态" prop="status">
          <SaRadio v-model="form.status" dict="data_status" />
        </ElFormItem>
      </ElForm>
    </div>

    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="submitLoading" @click="handleSubmit">确定</ElButton>
    </template>
  </ElDialog>
</template>
