<script setup lang="ts">
import TodaySales from './modules/today-sales.vue';
import VisitorInsights from './modules/visitor-insights.vue';
import TotalRevenue from './modules/total-revenue.vue';
import CustomerSatisfaction from './modules/customer-satisfaction.vue';
import TargetVsReality from './modules/target-vs-reality.vue';
import TopProducts from './modules/top-products.vue';
import SalesMappingByCountry from './modules/sales-mapping-by-country.vue';
import VolumeServiceLevel from './modules/volume-service-level.vue';

defineOptions({ name: 'DashboardAnalysis' });
</script>

<template>
  <div class="analysis-dashboard">
    <ElRow :gutter="20" class="analysis-row analysis-row--top">
      <ElCol :xl="14" :lg="15" :xs="24" class="analysis-col analysis-col--top">
        <TodaySales />
      </ElCol>
      <ElCol :xl="10" :lg="9" :xs="24" class="analysis-col analysis-col--top">
        <VisitorInsights />
      </ElCol>
    </ElRow>

    <ElRow :gutter="20" class="analysis-row">
      <ElCol :xl="10" :lg="10" :xs="24" class="analysis-col">
        <TotalRevenue />
      </ElCol>
      <ElCol :xl="7" :lg="7" :xs="24" class="analysis-col">
        <CustomerSatisfaction />
      </ElCol>
      <ElCol :xl="7" :lg="7" :xs="24" class="analysis-col">
        <TargetVsReality />
      </ElCol>
    </ElRow>

    <ElRow :gutter="20" class="analysis-row">
      <ElCol :xl="10" :lg="10" :xs="24" class="analysis-col">
        <TopProducts />
      </ElCol>
      <ElCol :xl="7" :lg="7" :xs="24" class="analysis-col">
        <SalesMappingByCountry />
      </ElCol>
      <ElCol :xl="7" :lg="7" :xs="24" class="analysis-col">
        <VolumeServiceLevel />
      </ElCol>
    </ElRow>
  </div>
</template>

<style scoped lang="scss">
.analysis-dashboard {
  .analysis-row {
    display: flex;
    flex-wrap: wrap;
    align-items: stretch;
    margin-bottom: 20px;

    &:last-child {
      margin-bottom: 0;
    }
  }

  .analysis-row--top {
    align-items: flex-start;
  }

  :deep(.analysis-col--top) {
    > * {
      flex: none;
    }
  }

  :deep(.analysis-col) {
    display: flex;
    margin-bottom: 20px;

    @media (width >= 992px) {
      margin-bottom: 0;
    }

    > * {
      flex: 1;
      width: 100%;
    }
  }
}
</style>

