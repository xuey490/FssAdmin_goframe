<script setup lang="ts">
import drawImage from '@/assets/images/dashboard/draw/draw1.png';

defineOptions({ name: 'DashboardConsoleAboutProject' });

const systemName = import.meta.env.VITE_APP_TITLE;

const linkList = [
  { label: '项目官网', url: 'https://phpframe.org/' },
  { label: '文档', url: 'https://zread.ai/xuey490/project' },
  { label: 'Github', url: 'https://github.com/xuey490/project' },
  { label: 'Gitee', url: 'https://gitee.com/fsscms/NovaFrame' }
];

function goPage(url: string): void {
  window.open(url, '_blank', 'noopener,noreferrer');
}
</script>

<template>
  <ElCard class="card-wrapper about-project" shadow="never">
    <div class="about-project__content">
      <div>
        <h2 class="about-project__title">关于项目</h2>
        <p class="about-project__desc">{{ systemName }} 是一款兼具设计美学与高效开发的后台系统</p>
        <p class="about-project__desc">使用了 FSSPHP + Vue3 + Element Plus 高性能、高颜值技术栈</p>

        <div class="about-project__links">
          <div
            v-for="link in linkList"
            :key="link.label"
            class="about-project__link"
            @click="goPage(link.url)"
          >
            <span>{{ link.label }}</span>
            <SvgIcon icon="ri:arrow-right-s-line" class="text-lg" />
          </div>
        </div>
      </div>
      <img class="about-project__image max-md:hidden" :src="drawImage" alt="draw1" />
    </div>
  </ElCard>
</template>

<style scoped lang="scss">
.about-project {
  margin-bottom: 20px;
}

.about-project__content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
}

.about-project__title {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

.about-project__desc {
  margin: 8px 0 0;
  font-size: 14px;
  color: var(--el-text-color-secondary);
}

.about-project__links {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  max-width: 600px;
  margin-top: 36px;
}

.about-project__link {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 240px;
  height: 50px;
  padding: 0 14px;
  font-size: 14px;
  color: var(--el-text-color-regular);
  background: var(--el-fill-color-light);
  border: 1px solid var(--el-border-color);
  border-radius: 8px;
  cursor: pointer;
  transition: transform 0.3s;

  &:hover {
    transform: translateY(-4px);
  }
}

.about-project__image {
  width: 300px;
  flex-shrink: 0;
}

@media screen and (max-width: 768px) {
  .about-project__link {
    width: 100%;
  }
}
</style>
