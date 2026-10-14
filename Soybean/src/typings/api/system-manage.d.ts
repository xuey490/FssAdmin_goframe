declare namespace Api {
  /**
   * namespace SystemManage
   *
   * backend api module: "systemManage"
   */
  namespace SystemManage {
    type CommonSearchParams = Pick<Common.PaginatingCommonParams, 'page' | 'limit' | 'current' | 'size'>;

    /** role */
    type Role = Common.CommonRecord<{
      /** role name */
      name: string;
      roleName?: string;
      /** role code */
      code: string;
      roleCode?: string;
      /** role description */
      remark: string;
      roleDesc?: string;
      level?: number;
      sort?: number;
      data_scope?: number;
      dept_ids?: number[];
    }>;

    /** role search params */
    type RoleSearchParams = CommonType.RecordNullable<
      Pick<Api.SystemManage.Role, 'name' | 'code' | 'status'> & CommonSearchParams
    >;

    /** role list */
    type RoleList = Common.PaginatingQueryRecord<Role>;

    /** all role */
    type AllRole = Pick<Role, 'id' | 'name' | 'code'> & {
      roleName?: string;
      roleCode?: string;
    };

    /**
     * user gender
     *
     * - "1": "male"
     * - "2": "female"
     */
    type UserGender = 1 | 2;

    /** user */
    type User = Common.CommonRecord<{
      /** user name */
      username: string;
      userName?: string;
      /** user gender */
      gender: UserGender | undefined;
      userGender?: UserGender | undefined;
      /** user nick name */
      realname: string;
      nickName?: string;
      /** user phone */
      phone: string;
      userPhone?: string;
      /** user email */
      email: string;
      userEmail?: string;
      /** user role code collection */
      roles?: string[];
      userRoles?: string[];
      role_ids?: number[];
      post_ids?: number[];
      menu_ids?: number[];
      dept_id?: number | null;
      dept?: {
        id: number;
        name: string;
      } | null;
      avatar?: string;
      remark?: string;
      password?: string;
    }>;

    /** user search params */
    type UserSearchParams = CommonType.RecordNullable<
      Pick<Api.SystemManage.User, 'username' | 'gender' | 'realname' | 'phone' | 'email' | 'status'> &
        CommonSearchParams & {
          userName?: string;
          userGender?: UserGender;
          nickName?: string;
          userPhone?: string;
          userEmail?: string;
          dept_id?: number;
        }
    >;

    /** user list */
    type UserList = Common.PaginatingQueryRecord<User>;

    /**
     * menu type
     *
     * - "1": directory
     * - "2": menu
     */
    type MenuType = '1' | '2' | 'M' | 'C' | 'B';

    type MenuButton = {
      /**
       * button code
       *
       * it can be used to control the button permission
       */
      code: string;
      /** button description */
      desc: string;
    };

    /**
     * icon type
     *
     * - "1": iconify icon
     * - "2": local icon
     */
    type IconType = '1' | '2';

    type MenuPropsOfRoute = Pick<
      import('vue-router').RouteMeta,
      | 'i18nKey'
      | 'keepAlive'
      | 'constant'
      | 'order'
      | 'href'
      | 'hideInMenu'
      | 'activeMenu'
      | 'multiTab'
      | 'fixedIndexInTab'
      | 'query'
    >;

    type Menu = Common.CommonRecord<{
      /** parent menu id */
      parent_id: number;
      parentId?: number;
      /** menu type */
      type: MenuType;
      menuType?: MenuType;
      /** menu name */
      name: string;
      menuName?: string;
      /** route name */
      code?: string;
      routeName?: string;
      /** route path */
      path: string;
      routePath?: string;
      /** component */
      component?: string;
      slug?: string;
      /** iconify icon name or local icon name */
      icon: string;
      /** icon type */
      iconType: IconType;
      /** buttons */
      buttons?: MenuButton[] | null;
      /** children menu */
      children?: Menu[] | null;
      sort?: number;
      order?: number;
      is_hidden?: number;
      hideInMenu?: boolean;
      is_iframe?: number;
      href?: string | null;
      is_keep_alive?: number;
      keepAlive?: boolean;
      is_fixed_tab?: number;
      fixedIndexInTab?: number | null;
      is_full_page?: number;
      link_url?: string;
      remark?: string;
    }> &
      MenuPropsOfRoute;

    /** menu list */
    type MenuList = Common.PaginatingQueryRecord<Menu>;

    type MenuTree = {
      id: number;
      label: string;
      parent_id?: number;
      pId?: number;
      children?: MenuTree[];
    };

    type MenuPermissionResp = {
      menus: Array<{
        id: number;
      }>;
    };
  }
}
