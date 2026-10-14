<script setup lang="ts">

import { ref } from 'vue';



defineOptions({ name: 'DashboardTodaySales' });



interface SalesDataItem {

  label: string;

  value: number;

  change: string;

  icon: string;

  iconClass: string;

}



/** 今日销售数据统计 */

const salesData = ref<SalesDataItem[]>([

  {

    label: '总销售额',

    value: 999,

    change: '+10%',

    icon: 'ri:money-cny-circle-line',

    iconClass: 'text-[var(--el-color-primary)] bg-[var(--el-color-primary-light-9)]'

  },

  {

    label: '总订单量',

    value: 300,

    change: '+15%',

    icon: 'ri:file-list-3-line',

    iconClass: 'text-[var(--el-color-warning)] bg-[var(--el-color-warning-light-9)]'

  },

  {

    label: '产品销售量',

    value: 56,

    change: '-5%',

    icon: 'ri:shopping-bag-3-line',

    iconClass: 'text-[var(--el-color-danger)] bg-[var(--el-color-danger-light-9)]'

  },

  {

    label: '新客户数',

    value: 68,

    change: '+8%',

    icon: 'ri:user-add-line',

    iconClass: 'text-[var(--el-color-success)] bg-[var(--el-color-success-light-9)]'

  }

]);

</script>



<template>

  <ElCard class="card-wrapper today-sales-card" shadow="never">

    <template #header>

      <div class="flex items-center justify-between pr-0">

        <div>

          <h4 class="font-600 m-0">今日销售</h4>

          <p class="text-sm text-gray-500 mt-4px mb-0">销售总结</p>

        </div>

        <div

          class="flex items-center justify-center h-30px min-w-68px border border-gray-300 rounded-lg text-gray-500 cursor-pointer"

        >

          <SvgIcon icon="ri:upload-2-line" class="text-base mr-6px" />

          <span class="text-xs">导出</span>

        </div>

      </div>

    </template>



    <div class="today-sales-card__body">

      <ElRow :gutter="20" class="today-sales-card__grid">

        <ElCol v-for="(item, index) in salesData" :key="index" :span="6" :xs="24" class="today-sales-card__col">

          <div class="today-sales-card__item">

            <div class="today-sales-card__icon" :class="item.iconClass">

              <SvgIcon :icon="item.icon" class="text-22px" />

            </div>



            <div class="today-sales-card__meta max-sm:ml-16px max-sm:mt-0 max-sm:text-end">

              <CountTo class="text-2xl font-medium" :end-value="item.value" :duration="1500" />

              <p class="mt-8px text-base text-gray-600 max-sm:mt-4px">{{ item.label }}</p>

              <small class="text-gray-500 mt-4px max-sm:mt-2px block">

                较昨天

                <span

                  class="font-medium"

                  :class="[item.change.indexOf('+') === -1 ? 'text-[var(--el-color-danger)]' : 'text-[var(--el-color-success)]']"

                >

                  {{ item.change }}

                </span>

              </small>

            </div>

          </div>

        </ElCol>

      </ElRow>

    </div>

  </ElCard>

</template>



<style scoped lang="scss">

.today-sales-card {
  height: 328px;
  overflow: hidden;

  :deep(.el-card__body) {
    padding-top: 8px;
  }

  &__col {
    margin-bottom: 16px;

    @media (width >= 992px) {
      margin-bottom: 0;
    }
  }

  &__item {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 220px;
    padding: 0 20px;
    border: 1px solid rgb(209 213 219 / 85%);
    border-radius: 12px;

    @media (width <= 640px) {
      flex-direction: row;
      align-items: center;
      justify-content: space-between;
      height: 160px;
    }
  }

  &__icon {
    display: flex;
    flex-shrink: 0;
    align-items: center;
    justify-content: center;
    width: 48px;
    height: 48px;
    border-radius: 8px;
  }

  &__meta {
    margin-top: 14px;

    @media (width <= 640px) {
      margin-top: 0;
    }
  }
}

</style>


