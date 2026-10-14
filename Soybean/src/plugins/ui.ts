/** same text at center should merge instead of stacking */
;(['success', 'warning', 'info', 'error'] as const).forEach(type => {
  const orig = ElMessage[type];
  ElMessage[type] = (options => {
    const payload = typeof options === 'string' ? { message: options, grouping: true } : { grouping: true, ...options };
    return orig(payload as typeof options);
  }) as typeof orig;
});

/** global table column align */
(ElTable.TableColumn as Record<string, any>).props.align = {
  type: String,
  default: 'center'
};

/** global ElCard shadow */
ElCard.props.shadow = {
  type: String,
  default: 'never'
};

/** global ElForm require asterisk position */
ElForm.props.requireAsteriskPosition = {
  type: String,
  default: 'right'
};
