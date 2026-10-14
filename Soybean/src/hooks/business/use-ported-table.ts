import { computed, onMounted, reactive, ref } from 'vue';

export interface ColumnOption<T = any> {
  type?: string;
  prop?: string;
  label?: string;
  width?: number | string;
  minWidth?: number | string;
  fixed?: boolean | 'left' | 'right';
  useSlot?: boolean;
  showOverflowTooltip?: boolean;
  formatter?: (row: T) => any;
  [key: string]: any;
}

function pickList(res: any): { list: any[]; total: number } {
  if (Array.isArray(res)) return { list: res, total: res.length };
  const body = res?.data && typeof res.data === 'object' && !Array.isArray(res.data) ? res.data : res;
  const list = body?.items ?? body?.list ?? body?.records ?? body?.data ?? [];
  const rows = Array.isArray(list) ? list : [];
  return { list: rows, total: Number(body?.total ?? rows.length) };
}

export function useTable<TApiFn extends (params: any) => Promise<any>>(config: {
  core: {
    apiFn: TApiFn;
    apiParams?: Record<string, any>;
    immediate?: boolean;
    columnsFactory?: () => ColumnOption[];
    paginationKey?: { current?: string; size?: string };
  };
}) {
  const { apiFn, apiParams = {}, immediate = true, columnsFactory, paginationKey } = config.core;
  const pageKey = paginationKey?.current || 'page';
  const sizeKey = paginationKey?.size || 'limit';

  const data = ref<any[]>([]);
  const loading = ref(false);
  const pagination = reactive({ current: 1, size: 10, total: 0 });
  const searchParams = reactive({ ...apiParams });
  const columns = computed(() => columnsFactory?.() || []);
  const columnChecks = ref(columns.value);

  async function fetchData() {
    loading.value = true;
    try {
      const res = await apiFn({
        ...searchParams,
        [pageKey]: pagination.current,
        [sizeKey]: pagination.size
      });
      const { list, total } = pickList(res);
      data.value = list;
      pagination.total = total;
    } catch (error) {
      console.error(error);
      data.value = [];
      pagination.total = 0;
    } finally {
      loading.value = false;
    }
  }

  function getData() {
    return fetchData();
  }

  function replaceSearchParams(params: Record<string, any>) {
    Object.assign(searchParams, params);
  }

  async function resetSearchParams() {
    Object.keys(searchParams).forEach(key => {
      delete (searchParams as Record<string, any>)[key];
    });
    Object.assign(searchParams, apiParams);
    pagination.current = 1;
    await fetchData();
  }

  async function handleSizeChange(size: number) {
    pagination.size = size;
    pagination.current = 1;
    await fetchData();
  }

  async function handleCurrentChange(current: number) {
    pagination.current = current;
    await fetchData();
  }

  const refreshData = fetchData;
  const refreshCreate = fetchData;
  const refreshUpdate = fetchData;
  const refreshRemove = fetchData;

  if (immediate) {
    onMounted(fetchData);
  }

  return {
    columns,
    columnChecks,
    data,
    loading,
    pagination,
    searchParams,
    getData,
    replaceSearchParams,
    resetSearchParams,
    handleSizeChange,
    handleCurrentChange,
    refreshData,
    refreshCreate,
    refreshUpdate,
    refreshRemove
  };
}
