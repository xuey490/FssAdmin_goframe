import process from 'node:process';
import { URL, fileURLToPath } from 'node:url';
import { defineConfig, loadEnv } from 'vite';
import { setupVitePlugins } from './build/plugins';
import { createViteProxy, getBuildTime } from './build/config';

export default defineConfig(configEnv => {
  const viteEnv = loadEnv(configEnv.mode, process.cwd()) as unknown as Env.ImportMeta;
  const buildTime = getBuildTime();
  const enableProxy = configEnv.command === 'serve' && !configEnv.isPreview;

  return {
    base: viteEnv.VITE_BASE_URL,
    resolve: {
      alias: {
        '~': fileURLToPath(new URL('./', import.meta.url)),
        '@': fileURLToPath(new URL('./src', import.meta.url)),
        'vuedraggable-original': fileURLToPath(
          new URL('./node_modules/vuedraggable/src/vuedraggable.js', import.meta.url)
        ),
        vuedraggable: fileURLToPath(new URL('./src/Lib/vuedraggable/index.ts', import.meta.url))
      },
      dedupe: ['vue', 'sortablejs']
    },
    optimizeDeps: {
      include: ['sortablejs', 'vuedraggable-original']
    },
    css: {
      preprocessorOptions: {
        scss: {
          api: 'modern-compiler',
          additionalData: `@use "@/styles/scss/global.scss" as *;`,
        },
      },
    },
    plugins: setupVitePlugins(viteEnv, buildTime),
    define: {
      BUILD_TIME: JSON.stringify(buildTime),
    },
    server: {
      host: '0.0.0.0',
      port: 9527,
      open: true,
      proxy: createViteProxy(viteEnv, enableProxy),
    },
    preview: {
      port: 9725,
    },
    build: {
      reportCompressedSize: false,
      sourcemap: false,
      commonjsOptions: {
        ignoreTryCatch: false,
      },
      rollupOptions: {
      // ✅ 完全删除 external（生产环境必备）
      
        output: {
          // 🔥 超精准体积优化分包（按你的 package.json 定制）
          manualChunks: {
            // 核心框架（极小，合并）
            'vue-core': ['vue', 'vue-router', 'pinia'],

            // UI 超大库（必须单独拆）
            'element-plus': ['element-plus'],

            // 图表超大体积包（单独拆）
            'charts': ['echarts', '@visactor/vchart', '@visactor/vue-vtable'],

            // 富文本/编辑器（大）
            'editors': ['@wangeditor/editor', '@wangeditor/editor-for-vue', 'vditor', 'md-editor-v3'],

            // 工具库（中等）
            'utils': ['dayjs', 'clipboard', 'nprogress', 'print-js', 'spark-md5', 'xlsx'],

            // 动画/拖拽
            'draggable': ['vuedraggable', 'vue-draggable-plus', 'sortablejs'],

            // 流程/甘特图（大）
            'flow-gantt': ['@vue-flow/core', 'dhtmlx-gantt'],

            // 其他第三方
            'vendor': [
              '@vueuse/core',
              '@iconify/vue',
              'vue-i18n',
              'swiper',
              'xgplayer',
              'highlight.js'
            ]
          },

          // 业务代码自动拆分（保持原逻辑）
          manualChunks(id) {
            if (id.includes('/src/views/')) {
              return 'view-' + id.split('/src/views/')[1].split('/')[0];
            }
            if (id.includes('/src/components/')) {
              return 'comp-' + id.split('/src/components/')[1].split('/')[0];
            }
            if (id.includes('/src/api/')) return 'api';
            if (id.includes('/src/stores/')) return 'stores';
            if (id.includes('/src/hooks/')) return 'hooks';
            if (id.includes('/src/utils/')) return 'utils-business';
          },

          // 输出结构统一
          chunkFileNames: 'assets/js/[name]-[hash].js',
          entryFileNames: 'assets/js/[name]-[hash].js',
          assetFileNames: 'assets/[ext]/[name]-[hash].[ext]',
        },
      },
    },
  };
});