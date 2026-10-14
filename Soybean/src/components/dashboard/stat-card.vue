<script setup lang="ts">
defineOptions({ name: 'DashboardStatCard' });

interface Props {
  title: string;
  value: string | number;
  desc?: string;
  trend?: string;
  icon?: string;
  theme?: 'blue' | 'green' | 'orange' | 'purple';
}

withDefaults(defineProps<Props>(), {
  desc: '',
  trend: '',
  icon: 'mdi:chart-line',
  theme: 'blue'
});
</script>

<template>
  <ElCard shadow="never" class="stat-card" :class="`stat-card--${theme}`">
    <div class="stat-card__content">
      <div class="stat-card__text">
        <div class="stat-card__title">{{ title }}</div>
        <div class="stat-card__value">
          <CountTo v-if="typeof value === 'number'" :start-value="0" :end-value="value" :duration="1300" />
          <span v-else>{{ value }}</span>
        </div>
        <div v-if="desc || trend" class="stat-card__desc">
          <span v-if="desc">{{ desc }}</span>
          <span v-if="trend" class="stat-card__trend">{{ trend }}</span>
        </div>
      </div>
      <div class="stat-card__icon">
        <SvgIcon :icon="icon" class="text-24px" />
      </div>
    </div>
  </ElCard>
</template>

<style scoped lang="scss">
.stat-card {
  height: 120px;
  margin-bottom: 20px;
  border: none;

  :deep(.el-card__body) {
    display: flex;
    align-items: center;
    height: 100%;
    padding: 18px;
  }

  &__content {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
  }

  &__text {
    flex: 1;
    min-width: 0;
  }

  &__title {
    margin-bottom: 6px;
    font-size: 14px;
    color: var(--el-text-color-secondary);
  }

  &__value {
    margin-bottom: 4px;
    font-size: 22px;
    font-weight: bold;
    color: var(--el-text-color-primary);
  }

  &__desc {
    font-size: 12px;
    color: var(--el-text-color-secondary);
  }

  &__trend {
    margin-left: 4px;
    color: var(--el-color-success);
    font-weight: 600;
  }

  &__icon {
    display: flex;
    flex-shrink: 0;
    align-items: center;
    justify-content: center;
    width: 48px;
    height: 48px;
    border-radius: 10px;
  }

  &--blue {
    background: var(--el-color-primary-light-9);

    .stat-card__icon {
      color: var(--el-color-primary);
      background: var(--el-color-primary-light-8);
    }
  }

  &--green {
    background: var(--el-color-success-light-9);

    .stat-card__icon {
      color: var(--el-color-success);
      background: var(--el-color-success-light-8);
    }
  }

  &--orange {
    background: var(--el-color-warning-light-9);

    .stat-card__icon {
      color: var(--el-color-warning);
      background: var(--el-color-warning-light-8);
    }
  }

  &--purple {
    background: #f4f0ff;

    .stat-card__icon {
      color: #7c3aed;
      background: #ebe4ff;
    }
  }
}
</style>
