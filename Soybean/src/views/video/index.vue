<script setup lang="tsx">
import { onBeforeUnmount, ref, watch } from 'vue';
import { ElDropdown, ElDropdownItem, ElDropdownMenu, ElImage, ElMessage, ElMessageBox, ElProgress, ElTag } from 'element-plus';
import {
  fetchDeleteVideo,
  fetchDownloadVideo,
  fetchGetVideoList,
  fetchGetVideoProgress,
  fetchPauseAllVideoJobs,
  fetchPauseVideoJob,
  fetchResumeAllVideoJobs,
  fetchResumeVideoJob,
  fetchStopVideoJob
} from '@/service/api';
import { defaultTransform, useTableOperate, useUIPaginatedTable } from '@/hooks/common/table';
import { $t } from '@/locales';
import TableSearch from './modules/table-search.vue';
import CreateDialog from './modules/create-dialog.vue';
import EditDialog from './modules/edit-dialog.vue';
import PreviewDialog from './modules/preview-dialog.vue';
import CustomDownloadDialog from './modules/custom-download-dialog.vue';
import FilesDialog from './modules/files-dialog.vue';

defineOptions({ name: 'VideoManage' });

const searchParams = ref<Record<string, any>>({
  page_no: 1,
  page_size: 10,
  title: undefined,
  uploader: undefined
});

const createVisible = ref(false);
const editVisible = ref(false);
const editData = ref<Record<string, any>>();
const previewVisible = ref(false);
const previewId = ref<number | null>(null);
const previewMeta = ref<{ title?: string | null; thumbnail?: string | null; url?: string | null } | null>(null);
const customVisible = ref(false);
const customId = ref<number | null>(null);
const filesVisible = ref(false);
const filesId = ref<number | null>(null);
const batchDownloading = ref(false);
let pollTimer: ReturnType<typeof setInterval> | null = null;
let polling = false;

const jobStatusText = (s: number) =>
  (({ 0: '排队', 1: '下载中', 2: '已暂停', 3: '完成', [-1]: '失败', [-2]: '已停止' }) as Record<number, string>)[s] ||
  String(s);

const activeJobStatus = (row: any) => Number(row.active_job_status ?? row.job_status);

const progressStatus = (row: any) => {
  if (Number(row.job_status) === -1) return 'exception';
  if (Number(row.job_status) === 2) return 'warning';
  if (Number(row.job_status) === 3) return 'success';
  return undefined;
};

const isJobActive = (row: any) =>
  Number(row.active_job_id) > 0 && [0, 1, 2].includes(Number(row.job_status ?? row.active_job_status));

const {
  columns,
  columnChecks,
  data,
  loading,
  getData,
  getDataByPage,
  mobilePagination,
  handleCurrentPageChange,
  handlePageSizeChange
} = useUIPaginatedTable({
  paginationProps: { currentPage: 1, pageSize: 10 },
  api: () => fetchGetVideoList(searchParams.value),
  transform: response => defaultTransform(response),
  onPaginationParamsChange: params => {
    searchParams.value.page_no = params.currentPage;
    searchParams.value.page_size = params.pageSize;
  },
  columns: () => [
    { type: 'selection' as const, width: 48 },
    { prop: 'id', label: 'ID', width: 70 },
    {
      prop: 'thumbnail',
      label: '缩略图',
      width: 96,
      formatter: (row: any) =>
        row.thumbnail ? (
          <ElImage
            src={row.thumbnail}
            preview-src-list={[row.thumbnail]}
            fit="cover"
            class="video-thumb"
            preview-teleported
          />
        ) : (
          <span class="muted">—</span>
        )
    },
    { prop: 'title', label: '标题', minWidth: 180 },
    { prop: 'source', label: '来源', width: 100 },
    { prop: 'uploader', label: '作者', minWidth: 120 },
    { prop: 'best_resolution', label: '分辨率', width: 110 },
    {
      prop: 'duration',
      label: '时长',
      width: 90,
      formatter: (row: any) => {
        const d = Number(row.duration || 0);
        if (!d) return '—';
        const m = Math.floor(d / 60);
        const s = d % 60;
        return `${m}:${String(s).padStart(2, '0')}`;
      }
    },
    {
      prop: 'status',
      label: '信息',
      width: 90,
      formatter: (row: any) =>
        row.status === 1 ? (
          <ElTag type="success">已获取</ElTag>
        ) : row.status === -1 ? (
          <ElTag type="danger">失败</ElTag>
        ) : (
          <ElTag type="info">未获取</ElTag>
        )
    },
    {
      prop: 'job',
      label: '下载进度',
      minWidth: 180,
      formatter: (row: any) =>
        Number(row.active_job_id) > 0 ? (
          <div class="job-cell">
            <ElProgress
              percentage={Math.min(100, Math.round(Number(row.job_progress || 0)))}
              stroke-width={10}
              status={progressStatus(row)}
            />
            <div class="job-meta">
              {Number(row.job_status) === 3 ? (
                <span>已完成{Math.min(100, Math.round(Number(row.job_progress || 0)))}%</span>
              ) : (
                <>
                  <span>{jobStatusText(row.job_status)}</span>
                  <span class="muted">{Math.round(Number(row.job_progress || 0))}%</span>
                  {row.job_speed ? <span class="muted">{row.job_speed}</span> : null}
                </>
              )}
            </div>
            {row.job_error_msg ? <div class="muted err">{row.job_error_msg}</div> : null}
          </div>
        ) : (
          <span class="muted">—</span>
        )
    },
    {
      prop: 'operate',
      label: $t('common.operate'),
      width: 220,
      fixed: 'right' as const,
      formatter: (row: any) => (
        <div class="flex flex-wrap gap-2">
          <SaButton type="secondary" onClick={() => openEdit(row)} />
          <SaButton type="success" icon="ri:video-add-line" tool-tip="预览" onClick={() => openPreview(row)} />
          <SaButton type="error" onClick={() => handleDelete(row)} />
          <ElDropdown trigger="click" onCommand={(cmd: string) => handleCommand(cmd, row)}>
            {{
              default: () => <SaButton type="info" tool-tip="更多" />,
              dropdown: () => (
                <ElDropdownMenu>
                  <ElDropdownItem command="best">下载最佳画质</ElDropdownItem>
                  <ElDropdownItem command="custom">自定义下载</ElDropdownItem>
                  <ElDropdownItem command="audio">仅下载音频</ElDropdownItem>
                  <ElDropdownItem command="subs">仅字幕和缩略图</ElDropdownItem>
                  <ElDropdownItem command="files" divided>
                    查看已下载文件
                  </ElDropdownItem>
                  {row.active_job_id && [0, 1].includes(activeJobStatus(row)) ? (
                    <ElDropdownItem command="pause" divided>
                      暂停任务
                    </ElDropdownItem>
                  ) : null}
                  {row.active_job_id && [2, -1, -2].includes(activeJobStatus(row)) ? (
                    <ElDropdownItem command="resume">继续任务</ElDropdownItem>
                  ) : null}
                  {row.active_job_id && [0, 1, 2].includes(activeJobStatus(row)) ? (
                    <ElDropdownItem command="stop">停止任务</ElDropdownItem>
                  ) : null}
                </ElDropdownMenu>
              )
            }}
          </ElDropdown>
        </div>
      )
    }
  ]
});

const { checkedRowKeys } = useTableOperate(data, 'id', getData);

const needPoll = () => (data.value || []).some((r: any) => Number(r.status) === 0 || isJobActive(r));

async function pollProgressOnly() {
  if (polling) return;
  const rows = (data.value || []) as any[];
  const watchIds = rows.filter(r => Number(r.status) === 0 || isJobActive(r)).map(r => r.id);
  if (!watchIds.length) {
    if (pollTimer) {
      clearInterval(pollTimer);
      pollTimer = null;
    }
    return;
  }
  polling = true;
  try {
    const { data: items } = await fetchGetVideoProgress(watchIds);
    const map = new Map((items || []).map(i => [i.video_id, i]));
    let needFullRefresh = false;
    for (const row of rows) {
      const p = map.get(row.id);
      if (!p) continue;
      const prevStatus = Number(row.status);
      if (p.status != null) row.status = p.status;
      if (p.title != null) row.title = p.title;
      if (p.uploader != null) row.uploader = p.uploader;
      if (p.source != null) row.source = p.source;
      if (p.best_resolution != null) row.best_resolution = p.best_resolution;
      if (p.thumbnail != null) row.thumbnail = p.thumbnail;
      if (p.duration != null) row.duration = p.duration;
      if (p.error_msg != null) row.error_msg = p.error_msg;
      row.active_job_id = p.active_job_id;
      row.active_job_status = p.active_job_status;
      row.job_status = p.job_status;
      row.job_progress = p.job_progress;
      row.job_speed = p.job_speed;
      row.job_mode = p.job_mode;
      row.job_error_msg = p.job_error_msg;
      row.job_local_dir = p.job_local_dir;
      if (p.local_dir) row.local_dir = p.local_dir;
      if (prevStatus === 0 && Number(p.status) !== 0) needFullRefresh = true;
      if (p.job_status != null && ![0, 1, 2].includes(Number(p.job_status))) needFullRefresh = true;
    }
    if (needFullRefresh) await getData();
  } finally {
    polling = false;
  }
}

function setupPoll() {
  if (pollTimer) {
    clearInterval(pollTimer);
    pollTimer = null;
  }
  if (needPoll()) {
    pollProgressOnly();
    pollTimer = setInterval(pollProgressOnly, 2000);
  }
}

watch(
  () => (data.value || []).map((r: any) => `${r.id}:${r.status}:${r.job_status}`).join(','),
  () => setupPoll()
);

onBeforeUnmount(() => {
  if (pollTimer) clearInterval(pollTimer);
});

function openEdit(row: any) {
  editData.value = row;
  editVisible.value = true;
}

function openPreview(row: any) {
  previewId.value = row.id;
  previewMeta.value = { title: row.title, thumbnail: row.thumbnail, url: row.url };
  previewVisible.value = true;
}

async function handleDelete(row: any) {
  try {
    await ElMessageBox.confirm(`确认删除「${row.title || row.url}」及其下载文件？`, '提示', { type: 'warning' });
    const { error } = await fetchDeleteVideo(row.id);
    if (!error) {
      ElMessage.success('已删除');
      await getData();
    }
  } catch {}
}

async function handleDownloadSelected() {
  const ids = checkedRowKeys.value.map(Number);
  const rows = (data.value || []).filter((r: any) => ids.includes(Number(r.id)));
  if (!rows.length) {
    ElMessage.warning('请先勾选视频');
    return;
  }
  const ready = rows.filter((r: any) => Number(r.status) === 1);
  const skipped = rows.length - ready.length;
  if (!ready.length) {
    ElMessage.warning('选中项尚未获取到视频信息，请稍后再试');
    return;
  }
  batchDownloading.value = true;
  let ok = 0;
  let fail = 0;
  try {
    for (const row of ready) {
      const { error } = await fetchDownloadVideo(row.id, { mode: 'best' });
      if (error) fail += 1;
      else ok += 1;
    }
    const parts = [`已加入下载队列 ${ok} 条`];
    if (skipped) parts.push(`跳过未获取信息 ${skipped} 条`);
    if (fail) parts.push(`失败 ${fail} 条`);
    ElMessage[fail ? 'warning' : 'success'](parts.join('，'));
    await getData();
  } finally {
    batchDownloading.value = false;
  }
}

async function handleCommand(cmd: string, row: any) {
  const run = async (fn: () => Promise<any>, okMsg: string) => {
    const { error } = await fn();
    if (!error) {
      ElMessage.success(okMsg);
      await getData();
    }
  };
  if (cmd === 'best') return run(() => fetchDownloadVideo(row.id, { mode: 'best' }), '已加入队列');
  if (cmd === 'custom') {
    customId.value = row.id;
    customVisible.value = true;
    return;
  }
  if (cmd === 'files') {
    filesId.value = row.id;
    filesVisible.value = true;
    return;
  }
  if (cmd === 'audio') return run(() => fetchDownloadVideo(row.id, { mode: 'audio', audio_format: 'mp3' }), '已加入队列');
  if (cmd === 'subs') return run(() => fetchDownloadVideo(row.id, { mode: 'subs' }), '已加入队列');
  if (cmd === 'pause' && row.active_job_id) return run(() => fetchPauseVideoJob(row.active_job_id), '已暂停');
  if (cmd === 'resume' && row.active_job_id) return run(() => fetchResumeVideoJob(row.active_job_id), '已继续');
  if (cmd === 'stop' && row.active_job_id) return run(() => fetchStopVideoJob(row.active_job_id), '已停止');
}

async function handlePauseAll() {
  const { error } = await fetchPauseAllVideoJobs();
  if (!error) {
    ElMessage.success('已全局暂停');
    await getData();
  }
}

async function handleResumeAll() {
  const { error } = await fetchResumeAllVideoJobs();
  if (!error) {
    ElMessage.success('已全局继续');
    await getData();
  }
}

function handleSearch() {
  getDataByPage(1);
}

function resetSearchParams() {
  searchParams.value = {
    page_no: 1,
    page_size: searchParams.value.page_size ?? 10,
    title: undefined,
    uploader: undefined
  };
}
</script>

<template>
  <div class="min-h-500px flex-col-stretch gap-16px overflow-hidden lt-sm:overflow-auto">
    <TableSearch v-model:model="searchParams" @reset="resetSearchParams" @search="handleSearch" />
    <ElCard class="card-wrapper sm:flex-1-hidden">
      <template #header>
        <div class="flex items-center justify-between">
          <p>{{ $t('route.video') }}</p>
          <div class="flex items-center gap-8px">
            <ElButton v-auth="'module_platform:video:create'" @click="createVisible = true">
              <template #icon><SvgIcon icon="ri:add-fill" /></template>
              新建
            </ElButton>
            <ElButton
              v-auth="'module_platform:video:download'"
              type="primary"
              :disabled="!checkedRowKeys.length"
              :loading="batchDownloading"
              @click="handleDownloadSelected"
            >
              <template #icon><SvgIcon icon="ri:download-line" /></template>
              下载选中
            </ElButton>
            <ElButton v-auth="'module_platform:video:download'" @click="handlePauseAll">
              <template #icon><SvgIcon icon="ri:pause-fill" /></template>
              全局暂停
            </ElButton>
            <ElButton v-auth="'module_platform:video:download'" @click="handleResumeAll">
              <template #icon><SvgIcon icon="ri:play-fill" /></template>
              全局继续
            </ElButton>
            <TableHeaderOperation
              v-model:columns="columnChecks"
              :loading="loading"
              :show-add="false"
              :show-delete="false"
              @refresh="getData"
            />
          </div>
        </div>
      </template>
      <div class="h-[calc(100%-52px)]">
        <ElTable
          v-loading="loading"
          height="100%"
          border
          class="sm:h-full"
          :data="data"
          row-key="id"
          @selection-change="(rows: any) => (checkedRowKeys = rows.map((r: any) => String(r.id)))"
        >
          <ElTableColumn v-for="col in columns" :key="(col.prop as string) || col.type" v-bind="col" />
        </ElTable>
      </div>
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
    <CreateDialog v-model="createVisible" @success="getData" />
    <EditDialog v-model="editVisible" :data="editData" @success="getData" />
    <PreviewDialog v-model="previewVisible" :video-id="previewId" :meta="previewMeta" />
    <CustomDownloadDialog v-model="customVisible" :video-id="customId" @success="getData" />
    <FilesDialog v-model="filesVisible" :video-id="filesId" />
  </div>
</template>

<style scoped>
.video-thumb {
  width: 72px;
  height: 40px;
  border-radius: 4px;
  display: block;
}
.job-cell {
  min-width: 140px;
}
.job-meta {
  display: flex;
  gap: 8px;
  font-size: 12px;
  margin-bottom: 4px;
}
.muted {
  color: var(--el-text-color-secondary);
  font-size: 12px;
}
.err {
  margin-top: 2px;
  color: var(--el-color-danger);
}
</style>
