import type { ElegantConstRoute, ElegantRoute } from '@elegant-router/types';
import { generatedRoutes } from '../elegant/routes';
import { layouts, views } from '../elegant/imports';
import { flowViews } from '../elegant/flow-views';
import { transformElegantRoutesToVueRoutes } from '../elegant/transform';

/**
 * custom routes
 *
 * @link https://github.com/soybeanjs/elegant-router?tab=readme-ov-file#custom-route
 */
const customRoutes: ElegantConstRoute[] = [
  {
    name: 'exception',
    path: '/exception',
    component: 'layout.base',
    meta: {
      title: 'exception',
      i18nKey: 'route.exception',
      icon: 'ant-design:exception-outlined',
      order: 7
    },
    children: [
      {
        name: 'exception_403',
        path: '/exception/403',
        component: 'view.403',
        meta: {
          title: 'exception_403',
          i18nKey: 'route.exception_403',
          icon: 'ic:baseline-block'
        }
      },
      {
        name: 'exception_404',
        path: '/exception/404',
        component: 'view.404',
        meta: {
          title: 'exception_404',
          i18nKey: 'route.exception_404',
          icon: 'ic:baseline-web-asset-off'
        }
      },
      {
        name: 'exception_500',
        path: '/exception/500',
        component: 'view.500',
        meta: {
          title: 'exception_500',
          i18nKey: 'route.exception_500',
          icon: 'ic:baseline-wifi-off'
        }
      }
    ]
  },
  {
    name: 'document',
    path: '/document',
    component: 'layout.base',
    meta: {
      title: 'document',
      i18nKey: 'route.document',
      order: 2,
      icon: 'mdi:file-document-multiple-outline'
    },
    children: [
      {
        name: 'document_antd',
        path: '/document/antd',
        component: 'view.iframe-page',
        props: {
          url: 'https://antdv.com/components/overview-cn'
        },
        meta: {
          title: 'document_antd',
          i18nKey: 'route.document_antd',
          order: 7,
          icon: 'logos:ant-design'
        }
      },
      {
        name: 'document_naive',
        path: '/document/naive',
        component: 'view.iframe-page',
        props: {
          url: 'https://www.UI.com/zh-CN/os-theme/docs/introduction'
        },
        meta: {
          title: 'document_naive',
          i18nKey: 'route.document_naive',
          order: 6,
          icon: 'logos:naiveui'
        }
      },
      {
        name: 'document_element-plus',
        path: '/document/element-plus',
        component: 'view.iframe-page',
        props: {
          url: 'https://element-plus.org/zh-CN/'
        },
        meta: {
          title: 'document_element-plus',
          i18nKey: 'route.document_element-plus',
          order: 7,
          icon: 'ep:element-plus'
        }
      },
      {
        name: 'document_alova',
        path: '/document/alova',
        component: 'view.iframe-page',
        props: {
          url: 'https://alova.js.org'
        },
        meta: {
          title: 'document_alova',
          i18nKey: 'route.document_alova',
          order: 8,
          localIcon: 'alova'
        }
      },
      {
        name: 'document_project',
        path: '/document/project',
        component: 'view.iframe-page',
        props: {
          url: 'https://docs.soybeanjs.cn/zh'
        },
        meta: {
          title: 'document_project',
          i18nKey: 'route.document_project',
          order: 1,
          localIcon: 'logo'
        }
      },
      {
        name: 'document_project-link',
        path: '/document/project-link',
        component: 'view.iframe-page',
        meta: {
          title: 'document_project-link',
          i18nKey: 'route.document_project-link',
          order: 2,
          localIcon: 'logo',
          // use href to open the page, the routeName must be ends with '-link'
          href: 'https://docs.soybeanjs.cn/zh'
        }
      },
      {
        name: 'document_unocss',
        path: '/document/unocss',
        component: 'view.iframe-page',
        props: {
          url: 'https://unocss.dev/'
        },
        meta: {
          title: 'document_unocss',
          i18nKey: 'route.document_unocss',
          order: 5,
          icon: 'logos:unocss'
        }
      },
      {
        name: 'document_vite',
        path: '/document/vite',
        component: 'view.iframe-page',
        props: {
          url: 'https://cn.vitejs.dev/'
        },
        meta: {
          title: 'document_vite',
          i18nKey: 'route.document_vite',
          order: 4,
          icon: 'logos:vitejs'
        }
      },
      {
        name: 'document_vue',
        path: '/document/vue',
        component: 'view.iframe-page',
        props: {
          url: 'https://cn.vuejs.org/'
        },
        meta: {
          title: 'document_vue',
          i18nKey: 'route.document_vue',
          order: 3,
          icon: 'logos:vue'
        }
      }
    ]
  },
  {
    name: 'flow',
    path: '/flow',
    component: 'layout.base',
    meta: {
      title: '工作流管理',
      icon: 'ri:flow-chart',
      order: 8
    },
    children: [
      {
        name: 'flow_center',
        path: '/flow/center',
        component: 'view.flow_center',
        meta: {
          title: '流程中心'
        }
      },
      {
        name: 'flow_category',
        path: '/flow/category',
        component: 'view.flow_category',
        meta: {
          title: '流程分类'
        }
      },
      {
        name: 'flow_template',
        path: '/flow/template',
        component: 'view.flow_template',
        meta: {
          title: '流程模板'
        }
      },
      {
        name: 'flow_template_design',
        path: '/flow/template/design/:id',
        component: 'view.flow_template_design',
        meta: {
          title: '流程设计',
          hideInMenu: true
        }
      },
      {
        name: 'flow_template_form-design',
        path: '/flow/template/form-design/:id',
        component: 'view.flow_template_form-design',
        meta: {
          title: '表单设计',
          hideInMenu: true
        }
      },
      {
        name: 'flow_instance_start-entry',
        path: '/flow/instance/start',
        component: 'view.flow_instance_start-entry',
        meta: {
          title: '发起流程',
          hideInMenu: true,
          hideInTab: true
        }
      },
      {
        name: 'flow_instance_start_template',
        path: '/flow/instance/start/:templateId',
        component: 'view.flow_instance_start-entry',
        meta: {
          title: '发起流程',
          hideInMenu: true,
          hideInTab: true
        }
      },
      {
        name: 'flow_instance_resubmit',
        path: '/flow/instance/resubmit/:instanceId',
        component: 'view.flow_instance_start-entry',
        meta: {
          title: '修改并重提',
          hideInMenu: true,
          hideInTab: true
        }
      },
      {
        name: 'flow_instance_start-legacy',
        path: '/flow/instance/start-legacy',
        component: 'view.flow_instance_start',
        meta: {
          title: '发起流程',
          hideInMenu: true
        }
      },
      {
        name: 'flow_instance_start-legacy_template',
        path: '/flow/instance/start-legacy/:templateId',
        component: 'view.flow_instance_start',
        meta: {
          title: '发起流程',
          hideInMenu: true
        }
      },
      {
        name: 'flow_instance_start-fixed',
        path: '/flow/instance/start-fixed',
        component: 'view.flow_instance_start-fixed',
        meta: {
          title: '指定表单发起',
          hideInMenu: true
        }
      },
      {
        name: 'flow_instance_start-fixed_template',
        path: '/flow/instance/start-fixed/:templateId',
        component: 'view.flow_instance_start-fixed',
        meta: {
          title: '指定表单发起',
          hideInMenu: true
        }
      },
      {
        name: 'flow_delegate',
        path: '/flow/delegate',
        component: 'view.flow_delegate',
        meta: {
          title: '流程委托'
        }
      },
      {
        name: 'flow_message',
        path: '/flow/message',
        component: 'view.flow_message',
        meta: {
          title: '消息中心'
        }
      },
      {
        name: 'flow_fixed-form',
        path: '/flow/fixed-form',
        component: 'view.flow_fixed-form',
        meta: {
          title: '固定表单'
        }
      },
      {
        name: 'flow_instance_my-started',
        path: '/flow/instance/my-started',
        component: 'view.flow_instance_my-started',
        meta: {
          title: '我的发起'
        }
      },
      {
        name: 'flow_instance_template-list',
        path: '/flow/instance/template/:templateId',
        component: 'view.flow_instance_template-list',
        meta: {
          title: '模板流程实例',
          hideInMenu: true
        }
      },
      {
        name: 'flow_instance_detail',
        path: '/flow/instance/detail/:id',
        component: 'view.flow_instance_detail',
        meta: {
          title: '流程详情',
          hideInMenu: true
        }
      },
      {
        name: 'flow_task_pending',
        path: '/flow/task/pending',
        component: 'view.flow_task_pending',
        meta: {
          title: '待办审批'
        }
      },
      {
        name: 'flow_task_completed',
        path: '/flow/task/completed',
        component: 'view.flow_task_completed',
        meta: {
          title: '已办审批'
        }
      },
      {
        name: 'flow_task_reverted-canceled',
        path: '/flow/task/reverted-canceled',
        component: 'view.flow_task_reverted-canceled',
        meta: {
          title: '撤销退回'
        }
      },
      {
        name: 'flow_task_copy-me',
        path: '/flow/task/copy-me',
        component: 'view.flow_task_copy-me',
        meta: {
          title: '抄送给我'
        }
      },
      {
        name: 'flow_form_leave-request',
        path: '/flow/form/leave-request',
        component: 'view.flow_form_leave-request',
        meta: {
          title: '请假申请',
          hideInMenu: true
        }
      },
      {
        name: 'flow_form_expense-claim',
        path: '/flow/form/expense-claim',
        component: 'view.flow_form_expense-claim',
        meta: {
          title: '报销申请',
          hideInMenu: true
        }
      },
      {
        name: 'flow_form_purchase-request',
        path: '/flow/form/purchase-request',
        component: 'view.flow_form_purchase-request',
        meta: {
          title: '采购申请',
          hideInMenu: true
        }
      },
      {
        name: 'flow_form_buy',
        path: '/flow/form/buy',
        component: 'view.flow_form_buy',
        meta: {
          title: '采购（示例）',
          hideInMenu: true
        }
      }
    ]
  }
];

/** create routes when the auth route mode is static */
export function createStaticRoutes() {
  const constantRoutes: ElegantConstRoute[] = [];

  const authRoutes: ElegantConstRoute[] = [];

  const customTopLevelNames = new Set(customRoutes.map(item => item.name));
  const filteredGeneratedRoutes = generatedRoutes.filter(item => !customTopLevelNames.has(item.name));

  [...customRoutes, ...filteredGeneratedRoutes].forEach(item => {
    if (item.meta?.constant) {
      constantRoutes.push(item as ElegantConstRoute);
    } else {
      authRoutes.push(item as ElegantConstRoute);
    }
  });

  return {
    constantRoutes,
    authRoutes
  };
}

/**
 * Get auth vue routes
 *
 * @param routes Elegant routes
 */
export function getAuthVueRoutes(routes: ElegantConstRoute[]) {
  return transformElegantRoutesToVueRoutes(routes, layouts, { ...views, ...flowViews });
}
