import type { RouteMeta } from 'vue-router';
import ElegantVueRouter from '@elegant-router/vue/vite';
import type { RouteKey } from '@elegant-router/types';

export function setupElegantRouter() {
  return ElegantVueRouter({
    layouts: {
      base: 'src/layouts/base-layout/index.vue',
      blank: 'src/layouts/blank-layout/index.vue'
    },
    customRoutes: {
      names: [
        'exception_403',
        'exception_404',
        'exception_500',
        'document_project',
        'document_project-link',
        'document_vue',
        'document_vite',
        'document_unocss',
        'document_naive',
        'document_antd',
        'document_element-plus',
        'document_alova',
        'flow',
        'flow_center',
        'flow_category',
        'flow_template',
        'flow_template_design',
        'flow_template_form-design',
        'flow_instance_start-entry',
        'flow_instance_start_template',
        'flow_instance_resubmit',
        'flow_instance_start-legacy',
        'flow_instance_start-legacy_template',
        'flow_instance_start-fixed',
        'flow_instance_start-fixed_template',
        'flow_delegate',
        'flow_message',
        'flow_fixed-form',
        'flow_instance_my-started',
        'flow_instance_template-list',
        'flow_instance_detail',
        'flow_task_pending',
        'flow_task_completed',
        'flow_task_reverted-canceled',
        'flow_task_copy-me',
        'flow_form_leave-request',
        'flow_form_expense-claim',
        'flow_form_purchase-request',
        'flow_form_buy'
      ]
    },
    routePathTransformer(routeName, routePath) {
      const key = routeName as RouteKey;

      if (key === 'login') {
        const modules: UnionKey.LoginModule[] = ['pwd-login', 'code-login', 'register', 'reset-pwd', 'bind-wechat'];

        const moduleReg = modules.join('|');

        return `/login/:module(${moduleReg})?`;
      }

      return routePath;
    },
    onRouteMetaGen(routeName) {
      const key = routeName as RouteKey;

      const constantRoutes: RouteKey[] = ['login', '403', '404', '500'];

      const meta: Partial<RouteMeta> = {
        title: key,
        i18nKey: `route.${key}` as App.I18n.I18nKey
      };

      if (constantRoutes.includes(key)) {
        meta.constant = true;
      }

      return meta;
    }
  });
}
