import { request } from '../../request';

/** 获取插件列表 */
export function fetchGetPluginList() {
  return request<Api.System.PluginItem[]>({
    url: '/api/system/plugin/list',
    method: 'get'
  });
}

/** 获取插件详情 */
export function fetchGetPluginDetail(name: string) {
  return request<Record<string, any>>({
    url: `/api/system/plugin/detail/${name}`
  });
}

/** 新建插件 */
export function fetchCreatePlugin(data: Api.System.PluginCreateParams) {
  return request<any>({
    url: '/api/system/plugin/create',
    method: 'post',
    data
  });
}

/** 安装插件 */
export function fetchInstallPlugin(data: Api.System.PluginInstallParams) {
  return request<any>({
    url: '/api/system/plugin/install',
    method: 'post',
    data
  });
}

/** 卸载插件 */
export function fetchUninstallPlugin(data: Api.System.PluginUninstallParams) {
  return request<any>({
    url: '/api/system/plugin/uninstall',
    method: 'post',
    data
  });
}

/** 启用插件 */
export function fetchEnablePlugin(name: string) {
  return request<any>({
    url: `/api/system/plugin/enable/${name}`,
    method: 'put'
  });
}

/** 禁用插件 */
export function fetchDisablePlugin(name: string) {
  return request<any>({
    url: `/api/system/plugin/disable/${name}`,
    method: 'put'
  });
}

/** 获取插件配置 */
export function fetchGetPluginConfig(name: string) {
  return request<Record<string, any>>({
    url: `/api/system/plugin/config/${name}`
  });
}

/** 更新插件配置 */
export function fetchUpdatePluginConfig(name: string, config: Record<string, any>) {
  return request<any>({
    url: `/api/system/plugin/config/${name}`,
    method: 'put',
    data: { config }
  });
}

/** 插件诊断 */
export function fetchPluginDoctor(params?: { name?: string }) {
  return request<Record<string, any>>({
    url: '/api/system/plugin/doctor',
    method: 'get',
    params
  });
}
