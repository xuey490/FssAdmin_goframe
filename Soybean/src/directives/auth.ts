import type { App, Directive } from 'vue';
import { useAuthStore } from '@/store/modules/auth';

/**
 * v-auth 权限指令
 *
 * 根据当前用户的按钮权限列表控制元素显示/隐藏。
 * 超级管理员（buttons 包含 '*'）始终可见。
 *
 * @example
 * <el-button v-auth="'core:user:save'">新增</el-button>
 * <el-button v-auth="['core:user:save', 'core:user:update']">操作</el-button>
 */
const authDirective: Directive = {
  mounted(el, binding) {
    const authStore = useAuthStore();
    const { buttons } = authStore.userInfo;

    // 超级管理员拥有所有权限
    if (buttons.includes('*')) return;

    const codes = binding.value;

    let hasPermission = false;

    if (typeof codes === 'string') {
      hasPermission = buttons.includes(codes);
    } else if (Array.isArray(codes)) {
      hasPermission = codes.some((code: string) => buttons.includes(code));
    }

    if (!hasPermission) {
      el.parentNode?.removeChild(el);
    }
  }
};

export function setupAuthDirective(app: App) {
  app.directive('auth', authDirective);
}
