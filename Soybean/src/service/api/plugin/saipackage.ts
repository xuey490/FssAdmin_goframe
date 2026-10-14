import { request } from '../../request';

export interface SaipackageAppInfo {
  app: string;
  title: string;
  about: string;
  author: string;
  version: string;
  support?: string;
  website?: string;
  state: number;
  npm_dependent_wait_install?: number;
  composer_dependent_wait_install?: number;
}

export interface SaipackageVersionInfo {
  saiadmin_version?: {
    describe: string;
    notes: string;
    state: string;
  };
  saipackage_version?: {
    describe: string;
    notes: string;
    state: string;
  };
}

export interface SaipackageAppListResponse {
  data: SaipackageAppInfo[];
  version: SaipackageVersionInfo;
}

export interface SaipackageStoreApp {
  id: number;
  title: string;
  about: string;
  logo: string;
  version: string;
  price: string;
  avatar?: string;
  username: string;
  sales_num: number;
  content?: string;
  screenshots?: string[];
}

export interface SaipackageStoreUser {
  nickname?: string;
  username: string;
  avatar?: string;
}

export interface SaipackagePurchasedApp {
  id: number;
  app_id: number;
  appname?: string;
  title: string;
  logo: string;
  version: string;
  developer: string;
  about: string;
}

export interface SaipackageAppVersion {
  id: number;
  version: string;
  create_time: string;
  remark: string;
}

export function fetchGetSaipackageAppList() {
  return request<SaipackageAppListResponse>({
    url: '/app/saipackage/install/index',
    method: 'get'
  });
}

export function fetchUploadSaipackageApp(data: FormData) {
  return request<SaipackageAppInfo>({
    url: '/app/saipackage/install/upload',
    method: 'post',
    data
  });
}

export function fetchInstallSaipackageApp(data: { appName: string }) {
  return request<any>({
    url: '/app/saipackage/install/install',
    method: 'post',
    data
  });
}

export function fetchUninstallSaipackageApp(data: { appName: string }) {
  return request<any>({
    url: '/app/saipackage/install/uninstall',
    method: 'post',
    data
  });
}

export function fetchReloadSaipackageBackend() {
  return request<any>({
    url: '/app/saipackage/install/reload',
    method: 'post'
  });
}

export function fetchGetSaipackageOnlineAppList(params?: {
  page?: number;
  limit?: number;
  price?: string;
  type?: string | number;
  keywords?: string;
}) {
  return request<{ data: SaipackageStoreApp[]; total: number }>({
    url: '/tool/install/online/appList',
    method: 'get',
    params
  });
}

export function fetchGetSaipackageStoreCaptcha() {
  return request<{ image: string; uuid: string }>({
    url: '/tool/install/online/storeCaptcha',
    method: 'get'
  });
}

export function fetchSaipackageStoreLogin(data: {
  username: string;
  password: string;
  code: string;
  uuid: string;
}) {
  return request<{ access_token: string }>({
    url: '/tool/install/online/storeLogin',
    method: 'post',
    data
  });
}

export function fetchGetSaipackageStoreUserInfo(token: string) {
  return request<SaipackageStoreUser>({
    url: '/tool/install/online/storeUserInfo',
    method: 'get',
    params: { token }
  });
}

export function fetchGetSaipackagePurchasedApps(token: string) {
  return request<SaipackagePurchasedApp[]>({
    url: '/tool/install/online/storePurchasedApps',
    method: 'get',
    params: { token }
  });
}

export function fetchGetSaipackageAppVersions(token: string, app_id: number) {
  return request<SaipackageAppVersion[]>({
    url: '/tool/install/online/storeAppVersions',
    method: 'get',
    params: { token, app_id }
  });
}

export function fetchDownloadSaipackageApp(data: { token: string; id: number }) {
  return request<any>({
    url: '/tool/install/online/storeDownloadApp',
    method: 'post',
    data
  });
}
