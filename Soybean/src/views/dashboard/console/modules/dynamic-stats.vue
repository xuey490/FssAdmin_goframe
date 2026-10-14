<script setup lang="ts">
import { reactive } from 'vue';

defineOptions({ name: 'DashboardConsoleDynamicStats' });

interface DynamicItem {
  username: string;
  type: string;
  target: string;
}

const list = reactive<DynamicItem[]>([
  { username: '中小鱼', type: '关注了', target: '誶誶淰' },
  { username: '何小荷', type: '发表文章', target: 'Vue3 + Typescript + Vite 项目实战笔记' },
  { username: '中小鱼', type: '关注了', target: '誶誶淰' },
  { username: '何小荷', type: '发表文章', target: 'Vue3 + Typescript + Vite 项目实战笔记' },
  { username: '誶誶淰', type: '提出问题', target: '主题可以配置吗' },
  { username: '发呆草', type: '兑换了物品', target: '《奇特的一生》' },
  { username: '甜筒', type: '关闭了问题', target: '发呆草' },
  { username: '冷月呆呆', type: '兑换了物品', target: '《高效人士的七个习惯》' }
]);
</script>

<template>
  <ElCard class="card-wrapper dynamic-stats" shadow="never">
    <template #header>
      <div class="dynamic-stats__header">
        <h4 class="dynamic-stats__title">动态</h4>
        <p class="dynamic-stats__subtitle">
          新增<span class="text-success">+6</span>
        </p>
      </div>
    </template>

    <div class="dynamic-stats__body">
      <ElScrollbar>
        <div v-for="(item, index) in list" :key="index" class="dynamic-stats__item">
          <span class="dynamic-stats__username">{{ item.username }}</span>
          <span class="dynamic-stats__type">{{ item.type }}</span>
          <span class="dynamic-stats__target">{{ item.target }}</span>
        </div>
      </ElScrollbar>
    </div>
  </ElCard>
</template>

<style scoped lang="scss">
.dynamic-stats {
  height: 512px;
  margin-bottom: 20px;
}

.dynamic-stats__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.dynamic-stats__title {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
}

.dynamic-stats__subtitle {
  margin: 0;
  font-size: 13px;
  color: var(--el-text-color-secondary);
}

.dynamic-stats__body {
  height: calc(100% - 24px);
  overflow: hidden;
}

.dynamic-stats__item {
  height: 70px;
  line-height: 70px;
  overflow: hidden;
  font-size: 14px;
  border-bottom: 1px solid var(--el-border-color-lighter);
  white-space: nowrap;
  text-overflow: ellipsis;

  &:last-child {
    border-bottom: none;
  }
}

.dynamic-stats__username {
  font-weight: 500;
  color: var(--el-text-color-primary);
}

.dynamic-stats__type {
  margin: 0 8px;
  color: var(--el-text-color-secondary);
}

.dynamic-stats__target {
  color: var(--el-color-primary);
}
</style>
