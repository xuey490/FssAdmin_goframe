<script setup lang="ts">
import { computed } from 'vue';

defineOptions({ name: 'DashboardEcommerceTransactionList' });

interface TransactionItem {
  title: string;
  status: string;
  time: string;
  class: string;
  icon: string;
}

const ITEM_HEIGHT = 66;
const maxCount = 4;

const dataList: TransactionItem[] = [
  {
    title: '新订单 #38291',
    status: '待处理',
    time: '5分钟',
    class: 'bg-theme/12 text-theme',
    icon: 'ri:shopping-bag-4-line'
  },
  {
    title: '退款申请 #12845',
    status: '处理中',
    time: '10分钟',
    class: 'bg-secondary/12 text-secondary',
    icon: 'ri:profile-line'
  },
  {
    title: '客户投诉处理',
    status: '待处理',
    time: '15分钟',
    class: 'bg-warning/12 text-warning',
    icon: 'ri:customer-service-2-line'
  },
  {
    title: '库存不足提醒',
    status: '紧急',
    time: '20分钟',
    class: 'bg-danger/12 text-danger',
    icon: 'ri:box-1-line'
  },
  {
    title: '订单 #29384 已发货',
    status: '已完成',
    time: '20分钟',
    class: 'bg-success/12 text-success',
    icon: 'ri:shopping-bag-3-line'
  }
];

const maxHeight = computed(() => `${ITEM_HEIGHT * maxCount}px`);

function handleMore(): void {
  // TODO: 添加查看更多逻辑
}
</script>

<template>
  <div class="art-card p-5 mb-5 max-sm:mb-4">
    <div class="pb-3.5">
      <p class="text-lg font-medium">最近活动</p>
      <p class="text-sm text-g-600">订单处理状态</p>
    </div>
    <ElScrollbar :style="{ height: maxHeight }">
      <div v-for="(item, index) in dataList" :key="index" class="flex-c py-3">
        <div v-if="item.icon" class="flex-cc mr-3 size-10 rounded-lg" :class="item.class">
          <SvgIcon :icon="item.icon" class="text-xl" />
        </div>
        <div class="flex-1">
          <div class="mb-1 text-sm">{{ item.title }}</div>
          <div class="text-xs text-g-500">{{ item.status }}</div>
        </div>
        <div class="ml-3 text-xs text-g-500">{{ item.time }}</div>
      </div>
    </ElScrollbar>
    <ElButton class="mt-[25px] w-full text-center" @click="handleMore">查看更多</ElButton>
  </div>
</template>
