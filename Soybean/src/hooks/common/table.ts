import { computed, effectScope, onScopeDispose, reactive, shallowRef, watch } from 'vue';
import type { Ref } from 'vue';
import { useBoolean, useTable } from '@sa/hooks';
import type { PaginationData, TableColumnCheck, UseTableOptions } from '@sa/hooks';
import type { FlatResponseData } from '@sa/axios';
import { jsonClone } from '@sa/utils';
import { useAppStore } from '@/store/modules/app';
import { $t } from '@/locales';

export type UseUITableOptions<ResponseData, ApiData, Pagination extends boolean> = Omit<
  UseTableOptions<ResponseData, ApiData, UI.TableColumn<ApiData>, Pagination>,
  'pagination' | 'getColumnChecks' | 'getColumns'
> & {
  /**
   * get column visible
   *
   * @param column
   *
   * @default true
   *
   * @returns true if the column is visible, false otherwise
   */
  getColumnVisible?: (column: UI.TableColumn<ApiData>) => boolean;
};

const SELECTION_KEY = '__selection__';

const EXPAND_KEY = '__expand__';

const INDEX_KEY = '__index__';

export function useUITable<ResponseData, ApiData>(options: UseUITableOptions<ResponseData, ApiData, false>) {
  const scope = effectScope();
  const appStore = useAppStore();

  const result = useTable<ResponseData, ApiData, UI.TableColumn<ApiData>, false>({
    ...options,
    getColumnChecks: cols => getColumnChecks(cols, options.getColumnVisible),
    getColumns
  });

  // calculate the total width of the table this is used for horizontal scrolling
  const scrollX = computed(() => {
    return result.columns.value.reduce((acc, column) => {
      return acc + Number(column.width ?? column.minWidth ?? 120);
    }, 0);
  });

  scope.run(() => {
    watch(
      () => appStore.locale,
      () => {
        result.reloadColumns();
      }
    );
  });

  onScopeDispose(() => {
    scope.stop();
  });

  return {
    ...result,
    scrollX
  };
}

type PaginationParams = { currentPage: number; pageSize: number };

type UseUIPaginatedTableOptions<ResponseData, ApiData> = UseUITableOptions<ResponseData, ApiData, true> & {
  paginationProps?: Record<string, unknown>;
  /**
   * whether to show the total count of the table
   *
   * @default true
   */
  showTotal?: boolean;
  onPaginationParamsChange?: (params: PaginationParams) => void | Promise<void>;
};

export function useUIPaginatedTable<ResponseData, ApiData>(options: UseUIPaginatedTableOptions<ResponseData, ApiData>) {
  const scope = effectScope();
  const appStore = useAppStore();

  const isMobile = computed(() => appStore.isMobile);

  // ponytail: PaginationProps is too deep for vue-tsc (TS2589); keep a writable bag.
  const pagination = reactive({
    currentPage: 1,
    pageSize: 10,
    total: 0,
    pageSizes: [10, 15, 20, 25, 30],
    ...(options.paginationProps as object)
  }) as {
    currentPage: number;
    pageSize: number;
    total: number;
    pageSizes: number[];
    pagerCount?: number;
  };

  function handleCurrentPageChange(page: number) {
    pagination.currentPage = page;
  }

  function handlePageSizeChange(pageSize: number) {
    pagination.currentPage = 1;
    pagination.pageSize = pageSize;
  }

  // this is for mobile, if the system does not support mobile, you can use `pagination` directly
  const mobilePagination = computed(() => {
    const p = {
      currentPage: pagination.currentPage,
      pageSize: pagination.pageSize,
      total: pagination.total,
      pageSizes: pagination.pageSizes,
      // Element Plus requires pagerCount >= 5 (and odd). Use 5 on mobile.
      pagerCount: isMobile.value ? 5 : 9
    };

    return p;
  });

  const paginationParams = computed(() => {
    const { currentPage, pageSize } = pagination;

    return {
      currentPage,
      pageSize
    };
  });

  const result = useTable<ResponseData, ApiData, UI.TableColumn<ApiData>, true>({
    ...options,
    pagination: true,
    // 首次请求需等待分页参数同步到 searchParams，避免不带 page/limit 拉全量
    immediate: false,
    getColumnChecks: cols => getColumnChecks(cols, options.getColumnVisible),
    getColumns,
    onFetched: data => {
      pagination.total = data.total;
    }
  });

  async function getDataByPage(page: number = 1) {
    if (page !== pagination.currentPage) {
      pagination.currentPage = page;

      return;
    }

    await result.getData();
  }

  scope.run(() => {
    watch(
      () => appStore.locale,
      () => {
        result.reloadColumns();
      }
    );

    watch(
      paginationParams,
      async newVal => {
        await options.onPaginationParamsChange?.(newVal);

        await result.getData();
      },
      { immediate: options.immediate !== false }
    );
  });

  onScopeDispose(() => {
    scope.stop();
  });

  return {
    ...result,
    getDataByPage,
    pagination,
    mobilePagination,
    handleCurrentPageChange,
    handlePageSizeChange
  };
}

export function useTableOperate<TableData>(
  data: Ref<TableData[]>,
  idKey: keyof TableData,
  getData: () => Promise<void>
) {
  const { bool: drawerVisible, setTrue: openDrawer, setFalse: closeDrawer } = useBoolean();

  const operateType = shallowRef<UI.TableOperateType>('add');

  function handleAdd() {
    operateType.value = 'add';
    openDrawer();
  }

  /** the editing row data */
  const editingData = shallowRef<TableData | null>(null);

  function handleEdit(id: TableData[keyof TableData]) {
    operateType.value = 'edit';
    const findItem = data.value.find(item => item[idKey] === id) || null;
    editingData.value = jsonClone(findItem);

    openDrawer();
  }

  /** the checked row keys of table */
  const checkedRowKeys = shallowRef<string[]>([]);

  /** the hook after the batch delete operation is completed */
  async function onBatchDeleted() {
    window.$message?.success($t('common.deleteSuccess'));

    checkedRowKeys.value = [];

    await getData();
  }

  /** the hook after the delete operation is completed */
  async function onDeleted() {
    window.$message?.success($t('common.deleteSuccess'));

    await getData();
  }

  return {
    drawerVisible,
    openDrawer,
    closeDrawer,
    operateType,
    handleAdd,
    editingData,
    handleEdit,
    checkedRowKeys,
    onBatchDeleted,
    onDeleted
  };
}

export function defaultTransform<ApiData>(
  response: FlatResponseData<any, Api.Common.PaginatingQueryRecord<ApiData>>
): PaginationData<ApiData> {
  const { data, error } = response;

  if (!error) {
    const list = data.list ?? data.records ?? data.items ?? [];
    const page = data.page ?? data.current ?? 1;
    const limit = data.limit ?? data.size ?? 10;
    const { total } = data;

    return {
      data: list,
      pageNum: page,
      pageSize: limit,
      total
    };
  }

  return {
    data: [],
    pageNum: 1,
    pageSize: 10,
    total: 0
  };
}

function getColumnChecks<Column extends UI.TableColumn<any>>(
  cols: Column[],
  getColumnVisible?: (column: Column) => boolean
) {
  const checks: TableColumnCheck[] = [];

  cols.forEach(column => {
    if (column.type === 'selection') {
      checks.push({
        prop: SELECTION_KEY,
        label: $t('common.check'),
        checked: true,
        visible: getColumnVisible?.(column) ?? false
      });
    } else if (column.type === 'expand') {
      checks.push({
        prop: EXPAND_KEY,
        label: $t('common.expandColumn'),
        checked: true,
        visible: getColumnVisible?.(column) ?? false
      });
    } else if (column.type === 'index') {
      checks.push({
        prop: INDEX_KEY,
        label: $t('common.index'),
        checked: true,
        visible: getColumnVisible?.(column) ?? false
      });
    } else {
      checks.push({
        prop: column.prop as string,
        label: column.label as string,
        checked: true,
        visible: getColumnVisible?.(column) ?? true
      });
    }
  });

  return checks;
}

function getColumns<Column extends UI.TableColumn<any>>(cols: Column[], checks: TableColumnCheck[]) {
  const columnMap = new Map<string, Column>();

  cols.forEach(column => {
    if (column.type === 'selection') {
      columnMap.set(SELECTION_KEY, column);
    } else if (column.type === 'expand') {
      columnMap.set(EXPAND_KEY, column);
    } else if (column.type === 'index') {
      columnMap.set(INDEX_KEY, column);
    } else {
      columnMap.set(column.prop as string, column);
    }
  });

  const filteredColumns = checks.filter(item => item.checked).map(check => columnMap.get(check.prop) as Column);

  return filteredColumns;
}
