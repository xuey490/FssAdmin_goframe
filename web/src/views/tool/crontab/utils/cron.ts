/**
 * 兼容保留：实现已上移到 `@/utils/cron`，供任务调度与定时任务配置共用。
 * 这里只做再导出，保证原有引用路径与行为不变（默认仍是步长写法）。
 */
export {
  buildCronExpression,
  parseCronExpression,
  normalizeCron,
  isValidCron,
  describeCron,
  describeInterval,
  describeEvery,
  describeTrigger,
  DEFAULT_CRON_RULE,
  CRON_STYLE_OPTIONS,
  CRON_WEEK_OPTIONS
} from '@/utils/cron'
export type { CronRuleState, CronStyle } from '@/utils/cron'
