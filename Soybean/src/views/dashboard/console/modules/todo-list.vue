<script setup lang="ts">
import { reactive } from 'vue';

defineOptions({ name: 'DashboardConsoleTodoList' });

interface TodoItem {
  username: string;
  date: string;
  complate: boolean;
}

const list = reactive<TodoItem[]>([
  { username: '查看今天工作内容', date: '上午 09:30', complate: true },
  { username: '回复邮件', date: '上午 10:30', complate: true },
  { username: '工作汇报整理', date: '上午 11:00', complate: true },
  { username: '产品需求会议', date: '下午 02:00', complate: false },
  { username: '整理会议内容', date: '下午 03:30', complate: false },
  { username: '明天工作计划', date: '下午 06:30', complate: false }
]);
</script>

<template>
  <ElCard class="card-wrapper todo-list" shadow="never">
    <template #header>
      <div class="todo-list__header">
        <h4 class="todo-list__title">代办事项</h4>
        <p class="todo-list__subtitle">
          待处理<span class="text-danger">3</span>
        </p>
      </div>
    </template>

    <div class="todo-list__body">
      <ElScrollbar>
        <div v-for="(item, index) in list" :key="index" class="todo-list__item">
          <div>
            <p class="todo-list__name">{{ item.username }}</p>
            <p class="todo-list__date">{{ item.date }}</p>
          </div>
          <ElCheckbox v-model="item.complate" />
        </div>
      </ElScrollbar>
    </div>
  </ElCard>
</template>

<style scoped lang="scss">
.todo-list {
  height: 512px;
  margin-bottom: 20px;
}

.todo-list__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.todo-list__title {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
}

.todo-list__subtitle {
  margin: 0;
  font-size: 13px;
  color: var(--el-text-color-secondary);
}

.todo-list__body {
  height: calc(100% - 24px);
  overflow: auto;
}

.todo-list__item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 70px;
  font-size: 14px;
  border-bottom: 1px solid var(--el-border-color-lighter);

  &:last-child {
    border-bottom: none;
  }
}

.todo-list__name {
  margin: 0;
  font-size: 14px;
}

.todo-list__date {
  margin: 4px 0 0;
  font-size: 13px;
  color: var(--el-text-color-secondary);
}
</style>
