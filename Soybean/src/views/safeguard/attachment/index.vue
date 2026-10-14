<script setup lang="tsx">
import { onMounted, ref } from 'vue';
import { ElButton, ElImage, ElMessage, ElMessageBox } from 'element-plus';
import type { UploadProps, UploadRequestOptions } from 'element-plus';
import {
  fetchBatchDeleteAttachment,
  fetchDeleteCategory,
  fetchGetAttachmentList,
  fetchGetCategoryList,
  fetchUploadAttachment
} from '@/service/api';
import { defaultTransform, useTableOperate, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import CategoryDialog from './modules/category-dialog.vue';
import EditDialog from './modules/edit-dialog.vue';
import MoveDialog from './modules/move-dialog.vue';

defineOptions({ name: 'AttachmentManage' });

const treeData = ref<any[]>([]);

async function getCategoryList() {
  const { data } = await fetchGetCategoryList({ tree: true });
  treeData.value = (data as any) || [];
}

function handleNodeClick(data: any) {
  if (data.id === 1) {
    searchParams.value.category_id = undefined;
  } else {
    searchParams.value.category_id = data.id;
  }
  getDataByPage(1);
}

const categoryDialogVisible = ref(false);
const categoryDialogType = ref<'add' | 'edit'>('add');
const categoryDialogData = ref<any>(null);

function categoryShowDialog(type: 'add' | 'edit', data?: any) {
  categoryDialogType.value = type;
  categoryDialogData.value = data || null;
  categoryDialogVisible.value = true;
}

async function categoryDeleteRow(data: any) {
  const { error } = await fetchDeleteCategory(data.id);
  if (!error) {
    ElMessage.success($t('common.deleteSuccess'));
    getCategoryList();
  }
}

const moveDialogVisible = ref(false);

const dialogVisible = ref(false);
const dialogType = ref<'add' | 'edit'>('add');
const dialogData = ref<any>(null);

function showDialog(type: 'add' | 'edit', row?: any) {
  dialogType.value = type;
  dialogData.value = row || null;
  dialogVisible.value = true;
}

const searchParams = ref<Record<string, any>>({
  page: 1,
  limit: 10,
  origin_name: undefined,
  storage_mode: undefined,
  category_id: undefined
});

const storageModeMap = (): Record<string, string> => ({
  '1': $t('page.safeguard.attachment.storageLocal'),
  '2': $t('page.safeguard.attachment.storageAliOss'),
  '3': $t('page.safeguard.attachment.storageQiniu'),
  '4': $t('page.safeguard.attachment.storageTencentCos')
});

const {
  columns,
  data,
  loading,
  getData,
  getDataByPage,
  mobilePagination,
  handleCurrentPageChange,
  handlePageSizeChange
} = useUIPaginatedTable({
  paginationProps: {
    currentPage: 1,
    pageSize: 10
  },
  api: () => fetchGetAttachmentList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page = params.currentPage;
    searchParams.value.limit = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const },
    {
      prop: 'url',
      label: $t('page.safeguard.attachment.preview'),
      width: 80,
      formatter: (row: any) => <ElImage src={row.url} style="width:40px;height:40px" fit="cover" preview-teleported />
    },
    {
      prop: 'origin_name',
      label: $t('page.safeguard.attachment.originName'),
      minWidth: 160,
      showOverflowTooltip: true
    },
    {
      prop: 'storage_mode',
      label: $t('page.safeguard.attachment.storageMode'),
      width: 100,
      formatter: (row: any) => storageModeMap()[String(row.storage_mode)] || row.storage_mode
    },
    {
      prop: 'mime_type',
      label: $t('page.safeguard.attachment.mimeType'),
      width: 160,
      showOverflowTooltip: true
    },
    { prop: 'size_info', label: $t('page.safeguard.attachment.fileSize'), width: 100 },
    { prop: 'create_time', label: $t('page.safeguard.attachment.uploadTime'), width: 180, sortable: true },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 120,
      fixed: 'right' as const,
      formatter: (row: any) => (
        <div class="flex-center gap-4px">
          <ElButton type="primary" plain size="small" onClick={() => showDialog('edit', row)}>
            {$t('common.edit')}
          </ElButton>
          <ElButton type="danger" plain size="small" onClick={() => confirmDelete(row.id)}>
            {$t('common.delete')}
          </ElButton>
        </div>
      )
    }
  ]
});

const { checkedRowKeys, onDeleted } = useTableOperate(data, 'id', getData);

async function confirmDelete(id: number) {
  try {
    await ElMessageBox.confirm($t('common.confirmDelete'), $t('common.tip'), {
      confirmButtonText: $t('common.confirm'),
      cancelButtonText: $t('common.cancel'),
      type: 'warning'
    });
    await handleDelete(id);
  } catch {}
}

async function handleDelete(id: number) {
  const { error } = await fetchBatchDeleteAttachment([id]);
  if (!error) onDeleted();
}

async function handleBatchDelete() {
  if (checkedRowKeys.value.length === 0) return;
  try {
    await ElMessageBox.confirm(
      $t('page.safeguard.attachment.confirmBatchDelete', { count: checkedRowKeys.value.length }),
      $t('common.batchDelete'),
      { confirmButtonText: $t('common.confirm'), cancelButtonText: $t('common.cancel'), type: 'warning' }
    );
    const ids = checkedRowKeys.value.map(Number);
    const { error } = await fetchBatchDeleteAttachment(ids);
    if (!error) {
      ElMessage.success($t('common.deleteSuccess'));
      checkedRowKeys.value = [];
      await getData();
    }
  } catch {}
}

function handleSearch() {
  getDataByPage(1);
}

function refreshData() {
  getDataByPage(1);
}

const beforeUpload: UploadProps['beforeUpload'] = file => {
  const isImage = file.type.startsWith('image/');
  if (!isImage) {
    ElMessage.error($t('page.safeguard.attachment.imageOnly'));
    return false;
  }
  const isLt5M = file.size / 1024 / 1024 < 5;
  if (!isLt5M) {
    ElMessage.error($t('page.safeguard.attachment.imageSizeLimit'));
    return false;
  }
  return true;
};

const handleUpload = async (options: UploadRequestOptions) => {
  const { file } = options;
  const formData = new FormData();
  formData.append('file', file);

  if (searchParams.value.category_id) {
    formData.append('category_id', String(searchParams.value.category_id));
  }

  const { error } = await fetchUploadAttachment(formData);
  if (error) return;

  ElMessage.success($t('page.safeguard.attachment.uploadSuccess'));
  refreshData();
};

onMounted(() => {
  getCategoryList();
});
</script>

<template>
  <div class="min-h-500px flex gap-16px h-full lt-sm:flex-col lt-sm:h-auto">
    <div class="flex-shrink-0 w-260px h-full lt-sm:w-full lt-sm:h-auto lt-sm:mb-16px">
      <ElCard class="h-full" shadow="never">
        <template #header>
          <div class="flex justify-between items-center">
            <b>{{ $t('page.safeguard.attachment.categoryTitle') }}</b>
            <ElButton type="primary" plain size="small" @click="categoryShowDialog('add')">
              {{ $t('common.add') }}
            </ElButton>
          </div>
        </template>
        <ElScrollbar>
          <ElTree
            :data="treeData"
            :props="{ children: 'children', label: 'label' }"
            node-key="id"
            default-expand-all
            highlight-current
            :expand-on-click-node="false"
            @node-click="handleNodeClick"
          >
            <template #default="{ node, data: nodeData }">
              <div v-if="nodeData.id > 1" class="flex items-center justify-between w-full">
                <span>{{ node.label }}</span>
                <div class="tree-node-actions flex gap-4px">
                  <ElButton type="primary" plain size="small" @click="categoryShowDialog('edit', nodeData)">
                    {{ $t('common.edit') }}
                  </ElButton>
                  <ElButton type="danger" plain size="small" @click="categoryDeleteRow(nodeData)">
                    {{ $t('common.delete') }}
                  </ElButton>
                </div>
              </div>
            </template>
          </ElTree>
        </ElScrollbar>
      </ElCard>
    </div>

    <div class="flex flex-col flex-1 min-w-0">
      <ElCard shadow="never">
        <div class="flex justify-between items-center mb-16px">
          <ElSpace wrap>
            <ElUpload
              class="upload-btn"
              :show-file-list="false"
              :http-request="handleUpload"
              :before-upload="beforeUpload"
              accept="image/*"
            >
              <ElButton type="primary" plain>{{ $t('page.safeguard.attachment.uploadImage') }}</ElButton>
            </ElUpload>
            <ElButton type="danger" plain :disabled="checkedRowKeys.length === 0" @click="handleBatchDelete">
              {{ $t('common.delete') }}
            </ElButton>
            <ElButton type="warning" plain :disabled="checkedRowKeys.length === 0" @click="moveDialogVisible = true">
              {{ $t('page.safeguard.attachment.move') }}
            </ElButton>
          </ElSpace>
          <ElSpace wrap>
            <ElSelect
              v-model="searchParams.storage_mode"
              :placeholder="$t('page.safeguard.attachment.selectStorageMode')"
              clearable
              style="width: 160px"
              @change="handleSearch"
            >
              <ElOption :label="$t('page.safeguard.attachment.storageLocal')" value="1" />
              <ElOption :label="$t('page.safeguard.attachment.storageAliOss')" value="2" />
              <ElOption :label="$t('page.safeguard.attachment.storageQiniu')" value="3" />
              <ElOption :label="$t('page.safeguard.attachment.storageTencentCos')" value="4" />
            </ElSelect>
            <ElInput
              v-model="searchParams.origin_name"
              :placeholder="$t('page.safeguard.attachment.inputFileName')"
              clearable
              style="width: 240px"
              @keyup.enter="handleSearch"
              @clear="handleSearch"
            >
              <template #suffix>
                <icon-ic-round-search class="text-icon" />
              </template>
            </ElInput>
          </ElSpace>
        </div>

        <ElTable
          v-loading="loading"
          border
          :data="data"
          row-key="id"
          @selection-change="(rows: any) => (checkedRowKeys = rows.map((r: any) => String(r.id)))"
        >
          <ElTableColumn v-for="col in columns" :key="col.prop as string" v-bind="col" />
        </ElTable>
        <div class="mt-20px flex justify-end">
          <ElPagination
            v-if="mobilePagination.total"
            layout="total,prev,pager,next,sizes"
            v-bind="mobilePagination"
            @current-change="handleCurrentPageChange"
            @size-change="handlePageSizeChange"
          />
        </div>
      </ElCard>
    </div>

    <CategoryDialog
      v-model="categoryDialogVisible"
      :dialog-type="categoryDialogType"
      :data="categoryDialogData"
      @success="getCategoryList"
    />
    <MoveDialog
      v-model="moveDialogVisible"
      :selected-rows="checkedRowKeys.map(id => ({ id: Number(id) }))"
      @success="refreshData"
    />
    <EditDialog v-model="dialogVisible" :dialog-type="dialogType" :data="dialogData" @success="refreshData" />
  </div>
</template>

<style lang="scss" scoped>
.tree-node-actions {
  opacity: 0;
  transition: opacity 0.2s;
}
.el-tree-node__content:hover .tree-node-actions {
  opacity: 1;
}
:deep(.el-tree-node__content) {
  height: 32px;
}
</style>
