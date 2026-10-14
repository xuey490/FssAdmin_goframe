import { createApp } from 'vue';
import ElementPlus from 'element-plus';
import './plugins/assets';
import './plugins/ui';
import { setupAppVersionNotification, setupDayjs, setupIconifyOffline, setupLoading, setupNProgress } from './plugins';
import { setupStore } from './store';
import { setupAuthDirective } from './directives/auth';
import { setupRouter } from './router';
import { setupI18n } from './locales';
import App from './App.vue';


import VForm3 from '@/Lib/vForm/designer.es.js';
import '@/Lib/vForm/designer.style.css';

async function setupApp() {
  setupLoading();

  setupNProgress();

  setupIconifyOffline();

  setupDayjs();

  const app = createApp(App);

  setupStore(app);

  await setupRouter(app);

  setupI18n(app);

  setupAppVersionNotification();

  // VForm3 内部通过 resolveComponent 引用 el-dropdown 等组件，按需导入无法覆盖
  app.use(ElementPlus);
  //app.component('nodeWrap', nodeWrap);
  //app.component('addNode', addNode);
  app.directive('focus', {
    mounted(el: HTMLElement) {
      el.focus();
    }
  });
  app.use(VForm3);

  setupAuthDirective(app);

  app.mount('#app');
}

setupApp();
