<script setup lang="ts">
import { computed } from 'vue';

defineOptions({ name: 'DashboardEcommerceRecentTransaction' });

interface TimelineItem {
  time: string;
  status: string;
  content: string;
  code?: string;
}

const ITEM_HEIGHT = 65;
const maxCount = 5;

const timelineData: TimelineItem[] = [
  {
    time: '上午 09:30',
    status: 'rgb(73, 190, 255)',
    content: '收到订单 #38291 支付 ¥385.90'
  },
  {
    time: '上午 10:00',
    status: 'rgb(54, 158, 255)',
    content: '新商品上架',
    code: 'SKU-3467'
  },
  {
    time: '上午 12:00',
    status: 'rgb(103, 232, 207)',
    content: '向供应商支付了 ¥6495.00'
  },
  {
    time: '下午 14:30',
    status: 'rgb(255, 193, 7)',
    content: '促销活动开始',
    code: 'PROMO-2023'
  },
  {
    time: '下午 15:45',
    status: 'rgb(255, 105, 105)',
    content: '订单取消提醒',
    code: 'ORD-9876'
  },
  {
    time: '下午 17:00',
    status: 'rgb(103, 232, 207)',
    content: '完成日销售报表'
  }
];

const maxHeight = computed(() => `${ITEM_HEIGHT * maxCount}px`);
</script>

<template>
  <div class="art-card p-5 h-[27.8rem] mb-5 max-sm:mb-4">
    <div class="pb-3.5">
      <p class="text-lg font-medium">最近交易</p>
      <p class="text-sm text-g-600">今日订单动态</p>
    </div>
    <ElScrollbar :style="{ height: maxHeight }">
      <ElTimeline class="!pl-0.5">
        <ElTimelineItem
          v-for="item in timelineData"
          :key="item.time"
          :timestamp="item.time"
          placement="top"
          :color="item.status"
          :center="true"
        >
          <div class="flex-c gap-3">
            <div class="flex-c gap-2">
              <span class="text-sm">{{ item.content }}</span>
              <span v-if="item.code" class="text-sm text-theme"> #{{ item.code }} </span>
            </div>
          </div>
        </ElTimelineItem>
      </ElTimeline>
    </ElScrollbar>
  </div>
</template>
