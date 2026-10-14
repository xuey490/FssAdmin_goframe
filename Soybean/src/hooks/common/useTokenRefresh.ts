import { onMounted, onUnmounted } from 'vue';
import { localStg } from '@/utils/storage';
import { fetchRefreshToken } from '@/service/api';

/**
 * Token 自动续期 Hook
 *
 * 每 1 分钟检查一次 access_token 是否将于 5 分钟内过期，
 * 若是则提前调用 /api/core/refresh 静默刷新 token。
 * 控制台每秒打印倒计时。
 * 包含空闲检测：用户 30 分钟无操作则跳过续期。
 */
export function useTokenRefresh() {
  let refreshTimer: ReturnType<typeof setInterval> | null = null;
  let countdownTimer: ReturnType<typeof setInterval> | null = null;
  let isRefreshing = false;

  // === 空闲检测 ===
  const IDLE_TIMEOUT = 30 * 60 * 1000; // 30 分钟无操作视为挂机
  let lastActiveTime = Date.now();

  const updateActiveTime = () => {
    const now = Date.now();
    if (now - lastActiveTime > 1000) {
      lastActiveTime = now;
    }
  };

  const activityEvents = ['mousemove', 'keydown', 'mousedown', 'touchstart', 'wheel'];
  // =================

  /**
   * 解析 JWT 的 payload（base64 → object）
   */
  function parseJwt(token: string): Record<string, unknown> | null {
    try {
      const base64Url = token.split('.')[1];
      if (!base64Url) return null;

      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
      const jsonPayload = decodeURIComponent(
        window
          .atob(base64)
          .split('')
          .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
          .join('')
      );
      return JSON.parse(jsonPayload);
    } catch {
      return null;
    }
  }

  /**
   * 获取当前 token 距离过期的秒数
   */
  function getExpiresIn(): number | null {
    const token = localStg.get('token');
    if (!token) return null;

    const payload = parseJwt(token);
    if (!payload || !payload.exp) return null;

    const currentTime = Math.floor(Date.now() / 1000);
    const exp = Number(payload.exp);

    return exp - currentTime;
  }

  /**
   * 每 1 分钟打印倒计时
   */
  function startCountdown() {
    if (countdownTimer) {
      clearInterval(countdownTimer);
    }

    // 先立即打印一次
    const expiresIn = getExpiresIn();
    if (expiresIn !== null && expiresIn > 0) {
      console.log(`距离 Token 过期还有 ${expiresIn} 秒`);
    }

    countdownTimer = setInterval(() => {
      const expiresIn = getExpiresIn();
      if (expiresIn !== null && expiresIn > 0) {
        console.log(`距离 Token 过期还有 ${expiresIn} 秒`);
      }
    }, 60000);
  }

  function stopCountdown() {
    if (countdownTimer) {
      clearInterval(countdownTimer);
      countdownTimer = null;
    }
  }

  async function checkTokenRefresh() {
    const token = localStg.get('token');
    if (!token) return;

    // 空闲检测：用户长时间无操作不续期
    if (Date.now() - lastActiveTime > IDLE_TIMEOUT) {
      return;
    }

    const payload = parseJwt(token);
    if (!payload || !payload.exp) return;

    const currentTime = Math.floor(Date.now() / 1000);
    const exp = Number(payload.exp);

    // 距离过期不足 5 分钟（300 秒）且未在刷新中
    if (exp - currentTime <= 300 && !isRefreshing) {
      isRefreshing = true;
      try {
        const { error, data } = await fetchRefreshToken();
        if (!error && data?.access_token) {
          localStg.set('token', data.access_token);
          if (data.refresh_token) {
            localStg.set('refreshToken', data.refresh_token);
          }
          console.log('Token 已自动续期');
        }
      } catch {
        // 静默失败 — 下次检查会重试
      } finally {
        isRefreshing = false;
      }
    }
  }

  onMounted(() => {
    // 监听用户活跃事件
    activityEvents.forEach((event) => {
      window.addEventListener(event, updateActiveTime, { passive: true });
    });

    // 立即检查一次
    checkTokenRefresh();

    // 启动倒计时
    startCountdown();

    // 之后每分钟检查一次续期
    refreshTimer = setInterval(checkTokenRefresh, 60000);
  });

  onUnmounted(() => {
    activityEvents.forEach((event) => {
      window.removeEventListener(event, updateActiveTime);
    });

    if (refreshTimer) {
      clearInterval(refreshTimer);
      refreshTimer = null;
    }

    stopCountdown();
  });
}
