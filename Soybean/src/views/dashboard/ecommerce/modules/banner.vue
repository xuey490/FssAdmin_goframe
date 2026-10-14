<script setup lang="ts">
import { computed } from 'vue';
import bannerCover from '@/assets/images/dashboard/login/lf_icon2.webp';
import { useAuthStore } from '@/store/modules/auth';

defineOptions({ name: 'DashboardEcommerceBanner' });

const authStore = useAuthStore();
const userInfo = computed(() => authStore.userInfo);

function handleBannerClick(): void {
  // TODO: 添加横幅点击处理逻辑
}
</script>

<template>
  <div
    class="art-card basic-banner justify-center !h-53 mb-5 max-sm:!pt-8 max-sm:!h-48 max-sm:mb-4"
    @click="handleBannerClick"
  >
    <div class="basic-banner__content">
      <p class="basic-banner__title">欢迎回来 {{ userInfo.realName || userInfo.userName }}</p>

      <div class="flex mt-6">
        <div class="mr-8 pr-8 border-r border-g-400 dark:border-g-300/60">
          <p class="text-3xl">
            <CountTo
              class="number box-title"
              :end-value="2340"
              :duration="1500"
              prefix="¥"
              separator=","
            />
            <SvgIcon icon="ri:arrow-right-up-line" class="text-xl text-success relative -top-2" />
          </p>
          <p class="mt-1 text-sm text-g-700">今日销售额</p>
        </div>
        <div class="mr-8">
          <p class="text-3xl">
            <CountTo class="number box-title" :end-value="35" :duration="1500" suffix="%" />
            <SvgIcon icon="ri:arrow-right-up-line" class="text-xl text-success relative -top-2" />
          </p>
          <p class="mt-1 text-sm text-g-700">较昨日</p>
        </div>
      </div>

      <img
        class="basic-banner__background-image"
        :src="bannerCover"
        style="width: 18rem; bottom: -7.5rem"
        loading="lazy"
        alt="背景图片"
      />
    </div>
  </div>
</template>

<style scoped lang="scss">
@media (width <= 640px) {
  .basic-banner {
    justify-content: flex-start;
    padding: 16px;

    &__background-image {
      display: none;
    }
  }
}
</style>
