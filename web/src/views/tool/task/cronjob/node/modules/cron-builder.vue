<!-- 定时规则构建器：用「每天/N小时/每周…」等口语化规则生成 cron 表达式，避免手写 cron -->
<template>
  <div class="cron-builder">
    <div class="cron-builder__row">
      <ElSelect
        v-model="rule.task_style"
        class="cron-builder__style"
        :disabled="disabled"
        placeholder="请选择定时规则"
      >
        <ElOption
          v-for="item in CRON_STYLE_OPTIONS"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        />
      </ElSelect>

      <template v-if="rule.task_style === 8">
        <ElInputNumber
          v-model="rule.month"
          :min="1"
          :max="12"
          :disabled="disabled"
          controls-position="right"
          class="cron-builder__num"
        />
        <span class="cron-builder__unit">月</span>
      </template>

      <template v-if="rule.task_style === 7 || rule.task_style === 8">
        <ElInputNumber
          v-model="rule.day"
          :min="1"
          :max="31"
          :disabled="disabled"
          controls-position="right"
          class="cron-builder__num"
        />
        <span class="cron-builder__unit">日</span>
      </template>

      <ElSelect
        v-if="rule.task_style === 6"
        v-model="rule.week"
        class="cron-builder__week"
        :disabled="disabled"
      >
        <ElOption
          v-for="item in CRON_WEEK_OPTIONS"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        />
      </ElSelect>

      <template v-if="showHour">
        <ElInputNumber
          v-model="rule.hour"
          :min="isIntervalHour ? 1 : 0"
          :max="isIntervalHour ? 23 : 23"
          :disabled="disabled"
          controls-position="right"
          class="cron-builder__num"
        />
        <span class="cron-builder__unit">{{ isIntervalHour ? '小时' : '时' }}</span>
      </template>

      <template v-if="rule.task_style !== 5">
        <ElInputNumber
          v-model="rule.minute"
          :min="isIntervalMinute ? 1 : 0"
          :max="59"
          :disabled="disabled"
          controls-position="right"
          class="cron-builder__num"
        />
        <span class="cron-builder__unit">{{ isIntervalMinute ? '分钟' : '分' }}</span>
      </template>

      <template v-if="rule.task_style === 5">
        <ElInputNumber
          v-model="rule.second"
          :min="1"
          :max="59"
          :disabled="disabled"
          controls-position="right"
          class="cron-builder__num"
        />
        <span class="cron-builder__unit">秒</span>
      </template>
    </div>

    <ElInput
      v-if="rule.task_style === 0"
      v-model="custom"
      class="cron-builder__custom"
      :disabled="disabled"
      placeholder="秒 分 时 日 月 周，如 0 0 2 * * *"
    />

    <div class="cron-builder__preview">
      <code class="cron-builder__code">{{ expression || '—' }}</code>
      <span class="cron-builder__desc">{{ description }}</span>
      <ElTag v-if="expression && !valid" type="danger" size="small">表达式格式不正确</ElTag>
    </div>
    <div v-if="isIntervalStyle" class="cron-builder__hint">
      按间隔执行：从调度开始时刻起算，不会卡在整分整秒（与 Cron 的步长写法不同）。
    </div>
  </div>
</template>

<script lang="ts" setup>
import {
  CRON_STYLE_OPTIONS,
  CRON_WEEK_OPTIONS,
  DEFAULT_CRON_RULE,
  buildCronExpression,
  describeCron,
  isValidCron,
  normalizeCron,
  parseCronExpression,
  type CronRuleState
} from '@/utils/cron'
import { computed, reactive, ref, watch } from 'vue'

defineOptions({ name: 'CronBuilder', inheritAttrs: false })

const props = withDefaults(
  defineProps<{
    /** cron 表达式（秒 分 时 日 月 周） */
    modelValue?: string
    disabled?: boolean
  }>(),
  { modelValue: '', disabled: false }
)

const emit = defineEmits<{ (e: 'update:modelValue', value: string): void }>()

const rule = reactive<CronRuleState>({ ...DEFAULT_CRON_RULE })
/** task_style = 0（自定义）时手工输入的表达式 */
const custom = ref('')

const showHour = computed(() => [1, 3, 6, 7, 8].includes(rule.task_style))
/** 「N小时」样式里 hour 表示间隔小时数 */
const isIntervalHour = computed(() => rule.task_style === 3)
/** 「N分钟」样式里 minute 表示间隔分钟数 */
const isIntervalMinute = computed(() => rule.task_style === 4)
/** N小时/N分钟/N秒 使用 @every 真间隔 */
const isIntervalStyle = computed(() => [3, 4, 5].includes(rule.task_style))

// 任务调度统一用 @every 表达「每 N 秒/分/时」：
// cron 的步长写法只在字段起点对齐（如秒位步长 59 实际是第 0 秒与第 59 秒各跑一次），无法表达任意间隔。
const INTERVAL_MODE = 'every' as const

const expression = computed(() =>
  rule.task_style === 0 ? custom.value.trim() : buildCronExpression(rule, INTERVAL_MODE)
)
const description = computed(() => describeCron(rule, custom.value))
const valid = computed(() => !expression.value || isValidCron(expression.value))

/** 外部表达式 -> 规则；复杂表达式自动落到「自定义」，不做静默改写 */
function applyIncoming(value?: string) {
  const expr = (value ?? '').trim()
  if (!expr) {
    Object.assign(rule, DEFAULT_CRON_RULE)
    custom.value = ''
    return
  }
  Object.assign(rule, parseCronExpression(expr))
  custom.value = normalizeCron(expr) || expr
}

// 初始化：编辑已有节点时先解析原表达式，避免挂载瞬间被默认值覆盖。
// 若表达式能被规则识别但与规则生成的结果不一致（如历史数据里的步长写法），
// 统一按当前规则规范化，保证界面预览与保存值一致。
applyIncoming(props.modelValue)
if (expression.value !== (props.modelValue ?? '').trim()) {
  emit('update:modelValue', expression.value)
}

// 规则变化 -> 向外同步表达式
watch(expression, (value) => {
  if (value !== (props.modelValue ?? '').trim()) {
    emit('update:modelValue', value)
  }
})

// 外部表达式变化 -> 反解析
watch(
  () => props.modelValue,
  (value) => {
    if ((value ?? '').trim() === expression.value) return
    applyIncoming(value)
  }
)
</script>

<style scoped>
.cron-builder {
  width: 100%;
}

.cron-builder__row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
}

.cron-builder__style {
  width: 130px;
}

.cron-builder__week {
  width: 92px;
}

.cron-builder__num {
  width: 96px;
}

.cron-builder__unit {
  font-size: 13px;
  color: var(--el-text-color-regular);
}

.cron-builder__custom {
  margin-top: 8px;
}

.cron-builder__preview {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
  margin-top: 8px;
  font-size: 12px;
}

.cron-builder__code {
  padding: 2px 6px;
  font-family: var(--el-font-family-mono, monospace);
  color: var(--el-color-primary);
  background: var(--el-fill-color-light);
  border-radius: 4px;
}

.cron-builder__desc {
  color: var(--el-text-color-secondary);
}

.cron-builder__hint {
  margin-top: 6px;
  font-size: 12px;
  line-height: 1.5;
  color: var(--el-text-color-secondary);
}
</style>
