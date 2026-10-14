<template>
  <ElDrawer
    v-model="visible"
    :title="`编辑生成信息 - ${record?.table_comment}`"
    size="100%"
    destroy-on-close
    @close="handleClose"
  >
    <div v-loading="loading" element-loading-text="加载数据中...">
      <ElForm ref="formRef" :model="form">
        <ElTabs v-model="activeTab">
          <ElTabPane label="配置信息" name="base_config">
            <ElDivider content-position="left">基础信息</ElDivider>
            <ElRow :gutter="24">
              <ElCol :span="8">
                <ElFormItem label="表名称" prop="table_name" label-width="100px">
                  <ElInput v-model="form.table_name" disabled />
                  <div class="text-xs text-gray-400 mt-1">数据库表的名称，自动读取数据库表名称</div>
                </ElFormItem>
              </ElCol>
              <ElCol :span="8">
                <ElFormItem
                  label="表描述"
                  prop="table_comment"
                  label-width="100px"
                  :rules="[{ required: true, message: '表描述必填' }]"
                >
                  <ElInput v-model="form.table_comment" />
                  <div class="text-xs text-gray-400 mt-1">表的描述，自动读取数据库表注释</div>
                </ElFormItem>
              </ElCol>
              <ElCol :span="8">
                <ElFormItem
                  label="实体类"
                  prop="class_name"
                  label-width="100px"
                  :rules="[{ required: true, message: '实体类必填' }]"
                >
                  <ElInput v-model="form.class_name" />
                  <div class="text-xs text-gray-400 mt-1">生成的实体类名称，可以修改去掉前缀</div>
                </ElFormItem>
              </ElCol>
            </ElRow>

            <ElRow :gutter="24">
              <ElCol :span="8">
                <ElFormItem
                  label="业务名称"
                  prop="business_name"
                  label-width="100px"
                  :rules="[{ required: true, message: '业务名称必填' }]"
                >
                  <ElInput v-model="form.business_name" />
                  <div class="text-xs text-gray-400 mt-1">英文、业务名称、同一个分组包下唯一</div>
                </ElFormItem>
              </ElCol>
              <ElCol :span="8">
                <ElFormItem label="数据源" prop="source" label-width="100px">
                  <ElSelect v-model="form.source" placeholder="请选择数据源" style="width: 100%">
                    <ElOption
                      v-for="item in dataSourceList"
                      :key="item.value"
                      :label="item.label"
                      :value="item.value"
                    />
                  </ElSelect>
                  <div class="text-xs text-gray-400 mt-1">数据库配置文件中配置的数据源</div>
                </ElFormItem>
              </ElCol>
              <ElCol :span="8">
                <ElFormItem label="备注信息" prop="remark" label-width="100px">
                  <ElInput v-model="form.remark" />
                </ElFormItem>
              </ElCol>
            </ElRow>

            <ElDivider content-position="left">生成信息</ElDivider>
            <ElRow :gutter="24">
              <ElCol :xs="24" :md="8" :xl="8">
                <ElFormItem
                  label="应用类型"
                  prop="template"
                  label-width="100px"
                  :rules="[{ required: true, message: '应用类型必选' }]"
                >
                  <ElSelect v-model="form.template" placeholder="请选择生成模板" style="width: 100%" clearable>
                    <ElOption label="应用[app]" value="app" />
                    <ElOption label="插件[plugin]" value="plugin" />
                  </ElSelect>
                  <div class="text-xs text-gray-400 mt-1">
                    默认app模板,生成文件放app目录下，plugin应用需要先手动初始化
                  </div>
                </ElFormItem>
              </ElCol>
              <ElCol :xs="24" :md="8" :xl="8">
                <ElFormItem
                  label="应用名称"
                  prop="namespace"
                  label-width="100px"
                  :rules="[{ required: true, message: '应用名称必填' }]"
                >
                  <ElInput v-model="form.namespace" />
                  <div class="text-xs text-gray-400 mt-1">plugin插件名称, 或者app下应用名称</div>
                </ElFormItem>
              </ElCol>
              <ElCol :xs="24" :md="8" :xl="8">
                <ElFormItem
                  label="分组包名"
                  prop="package_name"
                  label-width="100px"
                  :rules="[{ required: true, message: '分组包名必填' }]"
                >
                  <ElInput v-model="form.package_name" placeholder="请输入分组包名" clearable />
                  <div class="text-xs text-gray-400 mt-1">生成的文件放在分组包名目录下，功能模块分组</div>
                </ElFormItem>
              </ElCol>
            </ElRow>

            <ElRow :gutter="24">
              <ElCol :xs="24" :md="8" :xl="8">
                <ElFormItem
                  label="生成类型"
                  prop="tpl_category"
                  label-width="100px"
                  :rules="[{ required: true, message: '生成类型必填' }]"
                >
                  <ElSelect v-model="form.tpl_category" placeholder="请选择所属模块" style="width: 100%" clearable>
                    <ElOption label="单表CRUD" value="single" />
                    <ElOption label="树表CRUD" value="tree" />
                  </ElSelect>
                  <div class="text-xs text-gray-400 mt-1">单表须有主键，树表须指定id、parent_id、name等字段</div>
                </ElFormItem>
              </ElCol>
              <ElCol :xs="24" :md="8" :xl="8">
                <ElFormItem
                  label="生成路径"
                  prop="generate_path"
                  label-width="100px"
                  :rules="[{ required: true, message: '生成路径必填' }]"
                >
                  <ElInput v-model="form.generate_path" />
                  <div class="text-xs text-gray-400 mt-1">前端根目录文件夹名称，必须与后端根目录同级</div>
                </ElFormItem>
              </ElCol>
              <ElCol :xs="24" :md="8" :xl="8">
                <ElFormItem label="模型类型" prop="stub" label-width="100px">
                  <div class="flex-col">
                    <ElRadioGroup v-model="form.stub">
                      <ElRadio value="eloquent">EloquentORM</ElRadio>
                    </ElRadioGroup>
                    <div class="text-xs text-gray-400 mt-1">生成不同驱动模型的代码</div>
                  </div>
                </ElFormItem>
              </ElCol>
            </ElRow>

            <ElRow :gutter="24">
              <ElCol :xs="24" :md="8" :xl="8">
                <ElFormItem label="所属菜单" prop="belong_menu_id" label-width="100px">
                  <ElCascader
                    v-model="form.belong_menu_id"
                    :options="menus"
                    :props="{
                      expandTrigger: 'hover',
                      checkStrictly: true,
                      value: 'id',
                      label: 'label'
                    }"
                    style="width: 100%"
                    placeholder="生成功能所属菜单"
                    clearable
                  />
                  <div class="text-xs text-gray-400 mt-1">默认为工具菜单栏目下的子菜单。不选择则为顶级菜单栏目</div>
                </ElFormItem>
              </ElCol>
              <ElCol :xs="24" :md="8" :xl="8">
                <ElFormItem
                  label="菜单名称"
                  prop="menu_name"
                  label-width="100px"
                  :rules="[{ required: true, message: '菜单名称必选' }]"
                >
                  <ElInput v-model="form.menu_name" placeholder="请输入菜单名称" clearable />
                  <div class="text-xs text-gray-400 mt-1">显示在菜单栏目上的菜单名称、以及代码中的业务功能名称</div>
                </ElFormItem>
              </ElCol>
            </ElRow>

            <ElRow :gutter="24">
              <ElCol :span="8">
                <ElFormItem label="表单效果" prop="component_type" label-width="100px">
                  <div class="flex-col">
                    <ElRadioGroup v-model="form.component_type">
                      <ElRadioButton :value="1">抽屉式</ElRadioButton>
                      <ElRadioButton :value="2">弹出框</ElRadioButton>
                    </ElRadioGroup>
                    <div class="text-xs text-gray-400 mt-1">表单显示方式</div>
                  </div>
                </ElFormItem>
              </ElCol>
              <ElCol :span="8">
                <ElFormItem label="表单宽度" prop="form_width" label-width="100px">
                  <div class="flex-col">
                    <ElInputNumber v-model="form.form_width" :min="200" :max="10000" />
                    <div class="text-xs text-gray-400 mt-1">表单组件的宽度，单位为px</div>
                  </div>
                </ElFormItem>
              </ElCol>
              <ElCol :span="8">
                <ElFormItem label="表单全屏" prop="is_full" label-width="100px">
                  <div class="flex-col">
                    <ElRadioGroup v-model="form.is_full">
                      <ElRadio :value="1">否</ElRadio>
                      <ElRadio :value="2">是</ElRadio>
                    </ElRadioGroup>
                    <div class="text-xs text-gray-400 mt-1">编辑表单是否全屏</div>
                  </div>
                </ElFormItem>
              </ElCol>
            </ElRow>

            <template v-if="form.tpl_category === 'tree'">
              <ElDivider content-position="left">树表配置</ElDivider>
              <ElRow :gutter="24">
                <ElCol :xs="24" :md="8" :xl="8">
                  <ElFormItem label="树主ID" prop="tree_id" label-width="100px">
                    <ElSelect
                      v-model="formOptions.tree_id"
                      placeholder="请选择树表的主ID"
                      style="width: 100%"
                      clearable
                      filterable
                    >
                      <ElOption
                        v-for="(item, index) in form.columns"
                        :key="index"
                        :label="`${item.column_name} - ${item.column_comment}`"
                        :value="item.column_name"
                      />
                    </ElSelect>
                    <div class="text-xs text-gray-400 mt-1">指定树表的主要ID，一般为主键</div>
                  </ElFormItem>
                </ElCol>
                <ElCol :xs="24" :md="8" :xl="8">
                  <ElFormItem label="树父ID" prop="tree_parent_id" label-width="100px">
                    <ElSelect
                      v-model="formOptions.tree_parent_id"
                      placeholder="请选择树表的父ID"
                      style="width: 100%"
                      clearable
                      filterable
                    >
                      <ElOption
                        v-for="(item, index) in form.columns"
                        :key="index"
                        :label="`${item.column_name} - ${item.column_comment}`"
                        :value="item.column_name"
                      />
                    </ElSelect>
                    <div class="text-xs text-gray-400 mt-1">指定树表的父ID，比如：parent_id</div>
                  </ElFormItem>
                </ElCol>
                <ElCol :xs="24" :md="8" :xl="8">
                  <ElFormItem label="树名称" prop="tree_name" label-width="100px">
                    <ElSelect
                      v-model="formOptions.tree_name"
                      placeholder="请选择树表的名称字段"
                      style="width: 100%"
                      clearable
                      filterable
                    >
                      <ElOption
                        v-for="(item, index) in form.columns"
                        :key="index"
                        :label="`${item.column_name} - ${item.column_comment}`"
                        :value="item.column_name"
                      />
                    </ElSelect>
                    <div class="text-xs text-gray-400 mt-1">指定树显示的名称字段，比如：name</div>
                  </ElFormItem>
                </ElCol>
              </ElRow>
            </template>
          </ElTabPane>

          <ElTabPane label="字段配置" name="field_config">
            <ElTable :data="form.columns" max-height="750">
              <ElTableColumn prop="sort" label="排序" width="150">
                <template #default="{ row }">
                  <ElInputNumber v-model="row.sort" style="width: 100px" controls-position="right" />
                </template>
              </ElTableColumn>
              <ElTableColumn prop="column_name" label="字段名称" width="160" show-overflow-tooltip />
              <ElTableColumn prop="column_comment" label="字段描述" width="160">
                <template #default="{ row }">
                  <ElInput v-model="row.column_comment" clearable />
                </template>
              </ElTableColumn>
              <ElTableColumn prop="column_type" label="物理类型" width="100" />
              <ElTableColumn prop="is_required" label="必填" width="80" align="center">
                <template #header>
                  <div class="flex items-center justify-center gap-1">
                    <span>必填</span>
                    <ElCheckbox @change="(val: any) => handlerAll(val, 'required')" />
                  </div>
                </template>
                <template #default="{ row }">
                  <ElCheckbox v-model="row.is_required" />
                </template>
              </ElTableColumn>
              <ElTableColumn prop="is_insert" label="表单" width="80" align="center">
                <template #header>
                  <div class="flex items-center justify-center gap-1">
                    <span>表单</span>
                    <ElCheckbox @change="(val: any) => handlerAll(val, 'insert')" />
                  </div>
                </template>
                <template #default="{ row }">
                  <ElCheckbox v-model="row.is_insert" />
                </template>
              </ElTableColumn>
              <ElTableColumn prop="is_list" label="列表" width="80" align="center">
                <template #header>
                  <div class="flex items-center justify-center gap-1">
                    <span>列表</span>
                    <ElCheckbox @change="(val: any) => handlerAll(val, 'list')" />
                  </div>
                </template>
                <template #default="{ row }">
                  <ElCheckbox v-model="row.is_list" />
                </template>
              </ElTableColumn>
              <ElTableColumn prop="is_query" label="查询" width="80" align="center">
                <template #header>
                  <div class="flex items-center justify-center gap-1">
                    <span>查询</span>
                    <ElCheckbox @change="(val: any) => handlerAll(val, 'query')" />
                  </div>
                </template>
                <template #default="{ row }">
                  <ElCheckbox v-model="row.is_query" />
                </template>
              </ElTableColumn>
              <ElTableColumn prop="is_sort" label="排序" width="80" align="center">
                <template #header>
                  <div class="flex items-center justify-center gap-1">
                    <span>排序</span>
                    <ElCheckbox @change="(val: any) => handlerAll(val, 'sort')" />
                  </div>
                </template>
                <template #default="{ row }">
                  <ElCheckbox v-model="row.is_sort" />
                </template>
              </ElTableColumn>
              <ElTableColumn prop="query_type" label="查询方式" width="150">
                <template #default="{ row }">
                  <ElSelect v-model="row.query_type" clearable>
                    <ElOption
                      v-for="item in queryType"
                      :key="item.value"
                      :label="item.label"
                      :value="item.value"
                    />
                  </ElSelect>
                </template>
              </ElTableColumn>
              <ElTableColumn prop="view_type" label="页面控件">
                <template #default="{ row }">
                  <div class="flex items-center gap-2">
                    <ElSelect
                      v-model="row.view_type"
                      style="width: 140px"
                      clearable
                      @change="changeViewType(row)"
                    >
                      <ElOption
                        v-for="item in viewComponent"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"
                      />
                    </ElSelect>
                    <ElLink
                      v-if="notNeedSettingComponents.includes(row.view_type)"
                      @click="settingComponentRef.open(row)"
                    >
                      设置
                    </ElLink>
                  </div>
                </template>
              </ElTableColumn>
              <ElTableColumn prop="dict_type" label="数据字典">
                <template #default="{ row }">
                  <ElSelect
                    v-model="row.dict_type"
                    clearable
                    placeholder="选择数据字典"
                    :disabled="!['saSelect', 'radio', 'checkbox'].includes(row.view_type)"
                  >
                    <ElOption
                      v-for="(item, key) in dictStore.dictList"
                      :key="key"
                      :label="key"
                      :value="key"
                    />
                  </ElSelect>
                </template>
              </ElTableColumn>
            </ElTable>
          </ElTabPane>

          <ElTabPane label="关联配置" name="relation_config">
            <ElAlert type="info" :closable="false">
              模型关联支持：一对一、一对多、一对一（反向）、多对多。
            </ElAlert>

            <ElButton type="primary" class="mt-4 mb-4" @click="addRelation">
              <template #icon>
                <SvgIcon icon="ri:add-line" />
              </template>
              新增关联
            </ElButton>

            <div v-for="(item, index) in formOptions.relations" :key="index">
              <ElDivider content-position="left">
                {{ item.name ? item.name : '定义新关联' }}
                <ElLink type="danger" class="ml-5" @click="delRelation(index)">
                  <SvgIcon icon="ri:delete-bin-line" class="mr-1" />
                  删除定义
                </ElLink>
              </ElDivider>
              <ElRow :gutter="24">
                <ElCol :span="8">
                  <ElFormItem label="关联类型" label-width="100px">
                    <ElSelect v-model="item.type" placeholder="请选择关联类型" clearable filterable>
                      <ElOption
                        v-for="types in relationsType"
                        :key="types.value"
                        :label="types.name"
                        :value="types.value"
                      />
                    </ElSelect>
                    <div class="text-xs text-gray-400 mt-1">指定关联类型</div>
                  </ElFormItem>
                </ElCol>
                <ElCol :span="8">
                  <ElFormItem label="关联名称" label-width="100px">
                    <ElInput v-model="item.name" placeholder="设置关联名称" clearable />
                    <div class="text-xs text-gray-400 mt-1">属性名称，代码中with调用的名称</div>
                  </ElFormItem>
                </ElCol>
                <ElCol :span="8">
                  <ElFormItem label="关联模型" label-width="100px">
                    <ElInput v-model="item.model" placeholder="设置关联模型" clearable />
                    <div class="text-xs text-gray-400 mt-1">选择要关联的实体模型</div>
                  </ElFormItem>
                </ElCol>
                <ElCol :span="8">
                  <ElFormItem
                    :label="
                      item.type === 'belongsTo'
                        ? '外键'
                        : item.type === 'belongsToMany'
                          ? '外键'
                          : '当前模型主键'
                    "
                    label-width="100px"
                  >
                    <ElInput v-model="item.localKey" placeholder="设置键名" clearable />
                    <div class="text-xs text-gray-400 mt-1">
                      {{
                        item.type === 'belongsTo'
                          ? '关联模型_id'
                          : item.type === 'belongsToMany'
                            ? '关联模型_id'
                            : '当前模型主键'
                      }}
                    </div>
                  </ElFormItem>
                </ElCol>
                <ElCol v-show="item.type === 'belongsToMany'" :span="8">
                  <ElFormItem label="中间模型" label-width="100px">
                    <ElInput v-model="item.table" placeholder="请输入中间模型" clearable />
                    <div class="text-xs text-gray-400 mt-1">多对多关联的中间模型</div>
                  </ElFormItem>
                </ElCol>
                <ElCol :span="8">
                  <ElFormItem
                    :label="item.type === 'belongsTo' ? '关联主键' : '外键'"
                    label-width="100px"
                  >
                    <ElInput v-model="item.foreignKey" placeholder="设置键名" clearable />
                    <div class="text-xs text-gray-400 mt-1">
                      {{ item.type === 'belongsTo' ? '关联模型主键' : '当前模型_id' }}
                    </div>
                  </ElFormItem>
                </ElCol>
              </ElRow>
            </div>
          </ElTabPane>
        </ElTabs>
      </ElForm>
    </div>

    <SettingComponent ref="settingComponentRef" @confirm="confirmSetting" />

    <template #footer>
      <ElButton @click="handleClose">取消</ElButton>
      <ElButton type="primary" :loading="submitLoading" @click="save">保存</ElButton>
    </template>
  </ElDrawer>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { ElMessage } from 'element-plus';
import type { CheckboxValueType, FormInstance } from 'element-plus';
import { useDictStore } from '@/store/modules/dict';
import { fetchGetDatabaseDataSource, fetchGetMenuList } from '@/service/api';
import {
  fetchGetCodeTableColumns,
  fetchReadCodeGenerate,
  fetchUpdateCodeGenerate
} from '@/service/api/tool/code';
import SettingComponent from './settingComponent.vue';
import { relationsType, queryType, viewComponent } from '../js/vars';

interface Props {
  modelValue: boolean;
  data?: Record<string, any>;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  data: undefined
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'success'): void;
}>();

const dictStore = useDictStore();

const record = ref<any>({});
const loading = ref(true);
const submitLoading = ref(false);
const activeTab = ref('base_config');
const formRef = ref<FormInstance>();
const settingComponentRef = ref();

const notNeedSettingComponents = ref([
  'uploadFile',
  'uploadImage',
  'imagePicker',
  'chunkUpload',
  'editor',
  'date',
  'userSelect'
]);

const form = ref<any>({
  generate_menus: ['index', 'save', 'update', 'read', 'destroy'],
  columns: []
});

const formOptions = ref<any>({
  relations: []
});

const menus = ref<any[]>([]);
const dataSourceList = ref<{ label: string; value: string }[]>([]);

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
});

watch(
  () => props.modelValue,
  newVal => {
    if (newVal) {
      initPage();
    }
  }
);

watch(
  () => form.value.class_name,
  newVal => {
    form.value.package_name = newVal;
  }
);

async function initPage() {
  loading.value = true;

  const { data: sources, error: sourceError } = await fetchGetDatabaseDataSource();
  if (!sourceError) {
    dataSourceList.value = (sources || []).map((item: string) => ({
      label: item,
      value: item
    }));
  }

  const { data: readData, error: readError } = await fetchReadCodeGenerate({ id: props.data?.id });
  loading.value = false;

  if (readError) {
    handleClose();
    return;
  }

  record.value = readData;
  initForm();
}

function confirmSetting(name: string, value: any) {
  form.value.columns.find((item: any, idx: number) => {
    if (item.column_name === name) {
      form.value.columns[idx].options = value;
    }
  });
  ElMessage.success('组件设置成功');
}

function changeViewType(record: any) {
  if (
    record.view_type === 'uploadImage' ||
    record.view_type === 'imagePicker' ||
    record.view_type === 'uploadFile' ||
    record.view_type === 'chunkUpload'
  ) {
    record.options = { multiple: false, limit: 1 };
  } else if (record.view_type === 'editor') {
    record.options = { height: 400 };
  } else if (record.view_type === 'date') {
    record.options = { mode: 'date' };
  } else if (record.view_type === 'userSelect') {
    record.options = { multiple: false };
  } else {
    record.options = {};
  }
}

async function save() {
  if (form.value.namespace === 'saiadmin') {
    ElMessage.error('应用名称不能为saiadmin');
    return;
  }

  const validResult = await formRef.value?.validate().catch(err => err);
  if (validResult !== true) {
    return;
  }

  submitLoading.value = true;
  form.value.options = formOptions.value;

  const { error } = await fetchUpdateCodeGenerate({ ...form.value });
  submitLoading.value = false;

  if (!error) {
    ElMessage.success('更新成功');
    emit('success');
    handleClose();
  }
}

function handlerAll(value: CheckboxValueType, type: string) {
  form.value.columns.forEach((item: any) => {
    item[`is_${type}`] = value;
  });
}

function addRelation() {
  formOptions.value.relations.push({
    name: '',
    type: 'hasOne',
    model: '',
    foreignKey: '',
    localKey: '',
    table: ''
  });
}

function delRelation(idx: number | string) {
  formOptions.value.relations.splice(idx, 1);
}

function initForm() {
  for (const name in record.value) {
    if (name === 'generate_menus') {
      form.value[name] = record.value[name] ? record.value[name].split(',') : [];
    } else {
      form.value[name] = record.value[name];
    }
  }

  if (!form.value.template) {
    form.value.template = 'app';
  }

  form.value.stub = 'eloquent';

  if (!form.value.package_name && form.value.class_name) {
    form.value.package_name = form.value.class_name;
  }

  if (record.value.options && record.value.options.relations) {
    formOptions.value.relations = record.value.options.relations;
  } else {
    formOptions.value.relations = [];
  }

  if (record.value.tpl_category === 'tree') {
    formOptions.value.tree_id = record.value.options.tree_id;
    formOptions.value.tree_name = record.value.options.tree_name;
    formOptions.value.tree_parent_id = record.value.options.tree_parent_id;
  }

  fetchGetCodeTableColumns({ table_id: record.value.id }).then(({ data: columns, error }) => {
    if (error) return;
    form.value.columns = [];
    (columns || []).forEach((item: any) => {
      item.is_required = item.is_required === 2;
      item.is_insert = item.is_insert === 2;
      item.is_edit = item.is_edit === 2;
      item.is_list = item.is_list === 2;
      item.is_query = item.is_query === 2;
      item.is_sort = item.is_sort === 2;
      form.value.columns.push(item);
    });
  });

  fetchGetMenuList({ tree: true, menu: true }).then(({ data: menuData, error }) => {
    if (error) return;
    menus.value = menuData || [];
    menus.value.unshift({ id: 0, value: 0, label: '顶级菜单' });
  });
}

function handleClose() {
  visible.value = false;
  formRef.value?.resetFields();
}
</script>
