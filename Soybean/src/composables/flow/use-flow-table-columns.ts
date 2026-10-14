import { ref } from 'vue';

export type FlowTableColumnDef = {
  prop: string;
  label: string;
  checked?: boolean;
};

export function useFlowTableColumns(items: FlowTableColumnDef[]) {
  const columnChecks = ref<UI.TableColumnCheck[]>(
    items.map(item => ({
      prop: item.prop,
      label: item.label,
      checked: item.checked !== false,
      visible: true
    }))
  );

  function isColumnVisible(prop: string) {
    return columnChecks.value.find(item => item.prop === prop)?.checked !== false;
  }

  return {
    columnChecks,
    isColumnVisible
  };
}
