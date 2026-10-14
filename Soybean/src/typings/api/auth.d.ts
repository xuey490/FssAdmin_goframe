declare namespace Api {
  /**
   * namespace Auth
   *
   * backend api module: "auth"
   */
  namespace Auth {
    interface LoginParams {
      username: string;
      password: string;
      tenant_id: number;
      code: string;
      uuid: string;
      rememberPassword?: boolean;
    }

    interface LoginToken {
      access_token: string;
      refresh_token: string;
      expires_in?: number;
      tenant_id?: number;
      tenant_name?: string;
      menus?: Api.SystemManage.Menu[];
      permissions?: string[];
    }

    /** `/api/core/system/user` response shape */
    interface UserProfileResponse {
      id: string | number;
      username: string;
      realname?: string;
      nickname?: string;
      roles: string[];
      buttons: string[];
      email?: string;
      phone?: string;
      avatar?: string;
      gender?: string | number;
      remark?: string;
      signed?: string;
      department?: {
        id?: number;
        name?: string;
      } | null;
      tenant?: {
        id?: number;
        name?: string;
        code?: string;
      } | null;
    }

    /** Normalized user info stored in auth store */
    interface UserInfo {
      userId: string | number;
      userName: string;
      realName?: string;
      roles: string[];
      buttons: string[];
      email?: string;
      phone?: string;
      avatar?: string;
      tenantId?: number;
      dashboard?: string;
      gender?: string | number;
      remark?: string;
      signed?: string;
      department?: {
        id?: number;
        name?: string;
      } | null;
    }

    /** Cached user profile snapshot in localStorage */
    interface UserProfileSnapshot {
      id: number;
      username: string;
      realname: string;
      nickname?: string;
      avatar?: string;
    }

    interface CaptchaData {
      uuid: string;
      image: string;
    }

    interface TenantItem {
      id: number;
      name: string;
      code?: string;
      is_default?: number;
      status?: number;
    }
  }
}
