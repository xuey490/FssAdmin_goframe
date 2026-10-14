/**
 * 可视化定时规则 <-> 6 位 cron 表达式（秒 分 时 日 月 周）。
 *
 * 表达式字段顺序与后端 GoFrame gcron 一致：
 *   秒 分 时 日 月 周
 * 也兼容 5 段标准 crontab（补 0 秒）与 7 段 Quartz（忽略年份），
 * 与后端 internal/modules/cronjob/service/trigger.go 的 normalizeCron 保持同一套语义。
 */

/** 定时规则类型：0 表示自定义表达式 */
export type CronStyle = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8

export interface CronRuleState {
  /** 0=自定义，1=每天，2=每小时，3=N小时，4=N分钟，5=N秒，6=每周，7=每月，8=每年 */
  task_style: CronStyle
  second: number
  minute: number
  hour: number
  day: number
  month: number
  /** 0=周日，1=周一 … 6=周六（与 cron 周字段一致） */
  week: number
}

export const DEFAULT_CRON_RULE: CronRuleState = {
  task_style: 1,
  second: 0,
  minute: 0,
  hour: 0,
  day: 1,
  month: 1,
  week: 1
}

/** 定时规则下拉项 */
export const CRON_STYLE_OPTIONS: Array<{ value: CronStyle; label: string }> = [
  { value: 1, label: '每天' },
  { value: 2, label: '每小时' },
  { value: 3, label: 'N小时' },
  { value: 4, label: 'N分钟' },
  { value: 5, label: 'N秒' },
  { value: 6, label: '每周' },
  { value: 7, label: '每月' },
  { value: 8, label: '每年' },
  { value: 0, label: '自定义表达式' }
]

/** 星期选项（与 cron 周字段一致：0=周日） */
export const CRON_WEEK_OPTIONS: Array<{ value: number; label: string }> = [
  { value: 1, label: '周一' },
  { value: 2, label: '周二' },
  { value: 3, label: '周三' },
  { value: 4, label: '周四' },
  { value: 5, label: '周五' },
  { value: 6, label: '周六' },
  { value: 0, label: '周日' }
]

/**
 * 把 5~7 段表达式规范化为 6 段（秒 分 时 日 月 周）。
 * 与后端 normalizeCron 行为一致：5 段补 0 秒，7 段丢弃年份，@ 宏原样透传。
 */
export function normalizeCron(expression?: string) {
  const expr = String(expression ?? '').trim()
  if (!expr) return ''
  if (expr.startsWith('@')) return expr
  const parts = expr.split(/\s+/).filter(Boolean)
  if (parts.length === 5) return `0 ${parts.join(' ')}`
  if (parts.length === 6) return parts.join(' ')
  if (parts.length === 7) return parts.slice(0, 6).join(' ')
  return ''
}

/** gcron 支持的预定义宏 */
const CRON_MACROS = [
  '@yearly',
  '@annually',
  '@monthly',
  '@weekly',
  '@daily',
  '@midnight',
  '@hourly'
]

/** @every 的时长写法，如 59s / 10m / 6h / 1h30m */
const EVERY_DURATION_RE =
  /^\d+(\.\d+)?(ns|us|µs|ms|s|m|h)(\d+(\.\d+)?(ns|us|µs|ms|s|m|h))*$/i

const MONTH_NAMES = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']
const WEEK_NAMES = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']
/** 各字段允许的名称缩写：秒/分/时/日 不支持，月/周支持 */
const FIELD_NAMES = [[], [], [], [], MONTH_NAMES, WEEK_NAMES]

// 单个字段：支持通配（星号、问号）、单值、区间 a-b、列表 a,b、步长、区间步长，以及月/周缩写
function isValidCronField(field: string, names: string[]) {
  if (!field) return false
  return field.split(',').every((item) => {
    if (!item) return false
    const parts = item.split('/')
    if (parts.length > 2) return false
    const [base, step] = parts
    if (step !== undefined && !/^\d+$/.test(step)) return false
    // # 是 GoFrame gcron 用于「忽略秒字段」的占位
    if (base === '*' || base === '?' || base === '#') return true
    return base!
      .split('-')
      .every((v) => /^\d+$/.test(v) || (v !== '' && names.includes(v.toLowerCase())))
  })
}

/**
 * 基础校验：段数（5~7）、字段结构与月/周缩写。
 * 更严格的取值范围由后端 ParseSchedule 负责，这里只做即时提示。
 */
export function isValidCron(expression?: string) {
  const expr = String(expression ?? '').trim()
  if (!expr) return false
  if (expr.startsWith('@')) {
    if (CRON_MACROS.includes(expr.toLowerCase())) return true
    const every = expr.match(/^@every\s+(.+)$/i)
    if (!every) return false
    const duration = every[1]!.trim()
    if (!EVERY_DURATION_RE.test(duration)) return false
    // 0 秒这类无效间隔后端会拒绝，这里先拦一次
    const first = duration.match(/^(\d+(?:\.\d+)?)/)
    return !!first && Number(first[1]) > 0
  }
  const parts = expr.split(/\s+/).filter(Boolean)
  if (parts.length < 5 || parts.length > 7) return false
  const fields = parts.length === 6 ? parts : parts.length === 5 ? ['0', ...parts] : parts.slice(0, 6)
  return fields.every((field, index) => isValidCronField(field!, FIELD_NAMES[index] ?? []))
}

/**
 * 解析 @every 写法（单单位），返回对应的规则样式与数值。
 * 前端表单只产出单单位（59s / 10m / 6h），多单位（后端 interval 生成的 6h0m0s）不参与回填。
 */
function parseEveryRule(expression: string): { style: CronStyle; value: number } | null {
  const m = expression.match(/^@every\s+(\d+)(s|m|h)$/i)
  if (!m) return null
  const value = Number(m[1])
  if (!value) return null
  const unit = m[2]!.toLowerCase()
  if (unit === 's') return { style: 5, value }
  if (unit === 'm') return { style: 4, value }
  return { style: 3, value }
}

/**
 * 将可视化配置转为 cron 表达式（秒 分 时 日 月 周）。
 *
 * intervalMode 决定「N秒/N分钟/N小时」的表达方式：
 * - `step`（默认，保持旧行为）：`*\/N`，按字段起点对齐，例如 `*\/59` 其实是第 0 秒与第 59 秒各执行一次；
 * - `every`：`@every Ns/Nm/Nh`，gcron 原生支持的「真正每 N 秒/分/时」，任务调度使用该模式。
 */
export function buildCronExpression(
  config: {
    task_style: number
    second?: number
    minute?: number
    hour?: number
    day?: number
    month?: number
    week?: number
  },
  intervalMode: 'step' | 'every' = 'step'
) {
  const every = intervalMode === 'every'
  const second = config.second ?? 0
  const minute = config.minute ?? 0
  const hour = config.hour ?? 0
  const day = config.day ?? 1
  const month = config.month ?? 1
  const week = config.week ?? 1

  switch (config.task_style) {
    case 1:
      return `0 ${minute} ${hour} * * *`
    case 2:
      return `0 ${minute} * * * *`
    case 3:
      return every ? `@every ${Math.max(hour, 1)}h` : `0 ${minute} */${Math.max(hour, 1)} * * *`
    case 4:
      return every ? `@every ${Math.max(minute, 1)}m` : `0 */${Math.max(minute, 1)} * * * *`
    case 5:
      return every ? `@every ${Math.max(second, 1)}s` : `*/${Math.max(second, 1)} * * * * *`
    case 6:
      return `0 ${minute} ${hour} * * ${week}`
    case 7:
      return `0 ${minute} ${hour} ${day} * *`
    case 8:
      return `0 ${minute} ${hour} ${day} ${month} *`
    default:
      return `0 ${minute} ${hour} * * *`
  }
}

/**
 * 从 cron 表达式反解析可视化配置（尽力匹配，无法匹配时 task_style=0 表示自定义）
 */
export function parseCronExpression(expression?: string): CronRuleState {
  const defaults: CronRuleState = { ...DEFAULT_CRON_RULE }
  const raw = String(expression ?? '').trim()

  // @every 写法：直接映射为 N秒 / N分钟 / N小时 规则
  const everyRule = parseEveryRule(raw)
  if (everyRule) {
    const state: CronRuleState = { ...DEFAULT_CRON_RULE, task_style: everyRule.style }
    if (everyRule.style === 5) state.second = everyRule.value
    else if (everyRule.style === 4) state.minute = everyRule.value
    else state.hour = everyRule.value
    if (buildCronExpression(state, 'every') === raw) return state
    return { ...DEFAULT_CRON_RULE, task_style: 0 }
  }

  const normalized = normalizeCron(expression)
  if (!normalized) return defaults

  const parts = normalized.split(' ')
  if (parts.length !== 6) return defaults

  const [secondPart, minutePart, hourPart, dayPart, monthPart, weekPart] = parts
  const extractNumber = (value: string, fallback = 0) => {
    if (value === '*') return fallback
    const stepMatch = value.match(/^\*\/(\d+)$/)
    if (stepMatch) return Number(stepMatch[1])
    const numMatch = value.match(/(\d+)/)
    return numMatch ? Number(numMatch[1]) : fallback
  }

  defaults.second = extractNumber(secondPart!, 0)
  defaults.minute = extractNumber(minutePart!, 0)
  defaults.hour = extractNumber(hourPart!, 0)
  defaults.day = extractNumber(dayPart!, 1)
  defaults.month = extractNumber(monthPart!, 1)
  defaults.week = extractNumber(weekPart!, 1)

  if (secondPart!.startsWith('*/')) {
    defaults.task_style = 5
  } else if (minutePart!.startsWith('*/')) {
    defaults.task_style = 4
  } else if (hourPart!.startsWith('*/')) {
    defaults.task_style = 3
  } else if (weekPart !== '*') {
    defaults.task_style = 6
  } else if (dayPart !== '*' && monthPart !== '*') {
    defaults.task_style = 8
  } else if (dayPart !== '*') {
    defaults.task_style = 7
  } else if (hourPart === '*' && minutePart !== '*') {
    defaults.task_style = 2
  } else {
    defaults.task_style = 1
  }

  // 规则能还原出原表达式才算匹配成功，否则交给「自定义表达式」处理，
  // 避免可视化表单把用户的复杂表达式静默改成另一种计划。
  if (
    buildCronExpression(defaults) !== normalized &&
    buildCronExpression(defaults, 'every') !== raw
  ) {
    defaults.task_style = 0
  }
  return defaults
}

const pad = (n: number) => String(n).padStart(2, '0')

/** 生成人类可读的执行计划说明 */
export function describeCron(rule: CronRuleState, rawExpression?: string): string {
  const time = `${pad(rule.hour)}:${pad(rule.minute)}`
  switch (rule.task_style) {
    case 1:
      return `每天 ${time} 执行`
    case 2:
      return `每小时第 ${rule.minute} 分执行`
    case 3:
      return `每 ${Math.max(rule.hour, 1)} 小时执行一次`
    case 4:
      return `每 ${Math.max(rule.minute, 1)} 分钟执行一次`
    case 5:
      return `每 ${Math.max(rule.second, 1)} 秒执行一次`
    case 6:
      return `每${CRON_WEEK_OPTIONS.find((w) => w.value === rule.week)?.label ?? '周一'} ${time} 执行`
    case 7:
      return `每月 ${rule.day} 日 ${time} 执行`
    case 8:
      return `每年 ${rule.month} 月 ${rule.day} 日 ${time} 执行`
    default:
      return rawExpression ? `自定义表达式：${rawExpression}` : '请设置定时规则'
  }
}

/** 把「秒 分 时 天 周」的时间间隔参数转成可读文案，如「每 6 小时」 */
export function describeInterval(args?: string): string {
  const parts = String(args ?? '')
    .trim()
    .split(/\s+/)
    .filter(Boolean)
  if (parts.length !== 5) return parts.length ? `间隔：${parts.join(' ')}` : '间隔未设置'
  const [sec, min, hour, day, week] = parts.map((v) => Number(v) || 0)
  const units: string[] = []
  if (week) units.push(`${week} 周`)
  if (day) units.push(`${day} 天`)
  if (hour) units.push(`${hour} 小时`)
  if (min) units.push(`${min} 分钟`)
  if (sec) units.push(`${sec} 秒`)
  if (!units.length) return '间隔未设置'
  return `每 ${units.join(' ')}`
}

/**
 * 把 @every 的 Go duration 写法转成「每 5 分钟」这类文案（兼容 5m0s、1h30m、59s）。
 */
export function describeEvery(pattern?: string): string {
  const raw = String(pattern ?? '').trim()
  const m = raw.match(/^@every\s+(.+)$/i)
  if (!m) return raw || '间隔未设置'
  const text = m[1]!.trim()
  const parts = text.match(/(\d+(?:\.\d+)?)(h|m|s)/gi) ?? []
  const units: string[] = []
  for (const part of parts) {
    const n = Number(part.slice(0, -1))
    if (!n) continue
    const unit = part.slice(-1).toLowerCase()
    units.push(unit === 'h' ? `${n} 小时` : unit === 'm' ? `${n} 分钟` : `${n} 秒`)
  }
  return units.length ? `每 ${units.join(' ')}` : `每 ${text}`
}

/**
 * 触发器一句话说明，列表/卡片直接展示，替代裸露的表达式。
 */
export function describeTrigger(trigger?: string, args?: string): string {
  const t = String(trigger ?? '').trim()
  if (!t) return '不启用'
  if (t === 'cron') {
    if (!args) return 'Cron 未设置'
    if (/^@every\s/i.test(args.trim())) return describeEvery(args)
    return describeCron(parseCronExpression(args), args)
  }
  if (t === 'interval') return describeInterval(args)
  if (t === 'date') return args ? `固定时间：${args}` : '固定时间未设置'
  if (t === 'now') return '立即执行'
  return t
}
