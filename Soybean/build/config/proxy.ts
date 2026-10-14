import type { ProxyOptions } from 'vite';
import { bgRed, bgYellow, green, lightBlue } from 'kolorist';
import { consola } from 'consola';
import { createServiceConfig } from '../../src/utils/service';

const DEFAULT_PROXY_TARGET = 'http://127.0.0.1:8000';

/**
 * Set http proxy
 *
 * @param env - The current env
 * @param enable - If enable http proxy
 */
export function createViteProxy(env: Env.ImportMeta, enable: boolean) {
  const isEnableHttpProxy = enable && env.VITE_HTTP_PROXY === 'Y';

  if (!isEnableHttpProxy) return undefined;

  const isEnableProxyLog = env.VITE_PROXY_LOG === 'Y';

  const { baseURL, proxyPattern, other } = createServiceConfig(env);

  const proxy: Record<string, ProxyOptions> = createProxyItem({ baseURL, proxyPattern }, isEnableProxyLog, env);

  other.forEach(item => {
    Object.assign(proxy, createProxyItem(item, isEnableProxyLog, env));
  });

  return proxy;
}

function resolveProxyTarget(baseURL: string | undefined, env: Env.ImportMeta): string {
  const proxyTarget = String(env.VITE_SERVICE_PROXY_TARGET || '').trim();
  const target = String(baseURL || '').trim();

  // Relative baseURL (e.g. /proxy-default) is for browser same-origin requests only.
  if (!target || target.startsWith('/')) {
    if (proxyTarget) return proxyTarget;
    consola.warn(`[proxy] relative VITE_SERVICE_BASE_URL, fallback target ${DEFAULT_PROXY_TARGET}`);
    return DEFAULT_PROXY_TARGET;
  }

  return target;
}

function createProxyItem(item: App.Service.ServiceConfigItem, enableLog: boolean, env: Env.ImportMeta) {
  const proxy: Record<string, ProxyOptions> = {};
  const target = resolveProxyTarget(item.baseURL, env);

  proxy[item.proxyPattern] = {
    target,
    changeOrigin: true,
    configure: (_proxy, options) => {
      _proxy.on('proxyReq', (_proxyReq, req, _res) => {
        if (!enableLog) return;

        const requestUrl = `${lightBlue('[proxy url]')}: ${bgYellow(` ${req.method} `)} ${green(
          `${item.proxyPattern}${req.url}`
        )}`;

        const proxyUrl = `${lightBlue('[real request url]')}: ${green(`${options.target}${req.url}`)}`;

        consola.log(`${requestUrl}\n${proxyUrl}`);
      });
      _proxy.on('error', (_err, req, _res) => {
        if (!enableLog) return;
        consola.log(bgRed(`Error: ${req.method} `), green(`${options.target}${req.url}`));
      });
    },
    rewrite: path => path.replace(new RegExp(`^${item.proxyPattern}`), '')
  };

  return proxy;
}
