export const TASK_STATUS_FILTER_OPTIONS = [
  { label: '已同意', value: 2 },
  { label: '已驳回', value: 3 },
  { label: '退回修改', value: 4 }
] as const;

export const COPY_READ_FILTER_OPTIONS = [
  { label: '未读', value: 0 },
  { label: '已读', value: 1 }
] as const;

export const INSTANCE_STATUS_FILTER_OPTIONS = [
  { label: '审批中', value: 1 },
  { label: '通过', value: 2 },
  { label: '已驳回', value: 3 },
  { label: '终止', value: 4 },
  { label: '撤销', value: 5 },
  { label: '退回发起人待重提', value: 6 },
  { label: '退回上一节点待重提', value: 16 },
  { label: '退回当前节点待重提', value: 26 }
] as const;

export function instanceStatusText(status: number) {
  const map: Record<number, string> = {
    0: '草稿',
    1: '审批中',
    2: '通过',
    3: '驳回',
    4: '终止',
    5: '撤销',
    6: '退回发起人待重提',
    16: '退回上一节点待重提',
    26: '退回当前节点待重提'
  };
  return map[status] || '未知';
}

export function instanceStatusTagType(status: number): 'primary' | 'success' | 'danger' | 'warning' | 'info' {
  const map: Record<number, 'primary' | 'success' | 'danger' | 'warning' | 'info'> = {
    1: 'primary',
    2: 'success',
    3: 'danger',
    4: 'warning',
    5: 'info',
    6: 'warning',
    16: 'warning',
    26: 'warning'
  };
  return map[status] || 'info';
}

export function taskStatusText(status: number) {
  const map: Record<number, string> = {
    2: '已同意',
    3: '已驳回',
    4: '退回修改'
  };
  return map[status] || '未知';
}

export function taskStatusTagType(status: number): 'primary' | 'success' | 'danger' | 'warning' | 'info' {
  if (status === 2) return 'success';
  if (status === 3) return 'danger';
  if (status === 4) return 'warning';
  return 'info';
}
