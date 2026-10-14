import { computed, ref } from 'vue';
import { defineStore } from 'pinia';
import { SetupStoreId } from '@/enum';
import { fetchGetDictList } from '@/api/auth';

type DictItem = {
  label: string;
  value: string | number;
  color?: string;
  disabled?: boolean;
};

type DictMap = Record<string, DictItem[]>;

const defaultDictMap: DictMap = {
  data_status: [
    { label: '启用', value: '1', color: '#67C23A' },
    { label: '停用', value: '0', color: '#F56C6C' }
  ],
  crontab_task_type: [
    { label: 'URL任务GET', value: '1', color: '#5d87ff' },
    { label: 'URL任务POST', value: '2', color: '#00ced1' },
    { label: '类任务', value: '3', color: '#ff8c00' }
  ],
  gender: [
    { label: '男', value: '1', color: '#409EFF' },
    { label: '女', value: '2', color: '#F56C6C' }
  ],
  yes_or_no: [
    { label: '是', value: 1, color: '#67C23A' },
    { label: '否', value: 2, color: '#909399' }
  ],
  dashboard: [
    { label: '工作台', value: 'workbench' },
    { label: '数据大屏', value: 'dashboard' },
    { label: '首页', value: 'home' }
  ],
  menu_type: [
    { label: '目录', value: 1, color: '#909399' },
    { label: '菜单', value: 2, color: '#409EFF' },
    { label: '按钮', value: 3, color: '#E6A23C' },
    { label: '外链', value: 4, color: '#67C23A' }
  ]
};

export const useDictStore = defineStore(SetupStoreId.App + '_dict', () => {
  const initialized = ref(false);
  const loading = ref(false);
  const dictList = ref<DictMap>({});

  const dictMap = computed(() => {
    // backend-first: if api data exists, use it; otherwise fallback to local defaults
    const hasRemote = Object.keys(dictList.value || {}).length > 0;
    return hasRemote ? dictList.value : defaultDictMap;
  });

  async function refresh() {
    if (loading.value) return;

    loading.value = true;
    try {
      const { data, error } = await fetchGetDictList();
      if (!error && data) {
        dictList.value = (data || {}) as DictMap;
        initialized.value = true;
      } else {
        initialized.value = false;
      }
    } catch (error) {
      initialized.value = false;
      // keep fallback behavior for local/dev environments
      console.warn('[dict-store] fetch dictAll failed, using local fallback', error);
    } finally {
      loading.value = false;
    }
  }

  async function ensureLoaded() {
    if (initialized.value || loading.value) return;
    await refresh();
  }

  function setDictList(list: DictMap) {
    dictList.value = list || {};
    initialized.value = true;
  }

  function getByCode(code: string): DictItem[] {
    return dictMap.value[code] || [];
  }

  function getDataByValue(code: string, value: string | number) {
    return getByCode(code).find(item => item.value == value);
  }

  return {
    initialized,
    loading,
    dictList,
    refresh,
    ensureLoaded,
    setDictList,
    getByCode,
    getDataByValue
  };
});

