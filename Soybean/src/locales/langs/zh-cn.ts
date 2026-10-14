const local: App.I18n.Schema = {
  system: {
    title: 'FssAdmin',
    updateTitle: '系统版本更新通知',
    updateContent: '检测到系统有新版本发布，是否立即刷新页面？',
    updateConfirm: '立即刷新',
    updateCancel: '稍后再说'
  },
  common: {
    action: '操作',
    add: '新增',
    addSuccess: '添加成功',
    backToHome: '返回首页',
    batchDelete: '批量删除',
    cancel: '取消',
    close: '关闭',
    check: '勾选',
    expandColumn: '展开列',
    columnSetting: '列设置',
    config: '配置',
    confirm: '确认',
    delete: '删除',
    deleteSuccess: '删除成功',
    confirmDelete: '确认删除吗？',
    edit: '编辑',
    warning: '警告',
    error: '错误',
    index: '序号',
    keywordSearch: '请输入关键词搜索',
    logout: '退出登录',
    logoutConfirm: '确认退出登录吗？',
    lookForward: '敬请期待',
    modify: '修改',
    modifySuccess: '修改成功',
    noData: '无数据',
    operate: '操作',
    pleaseCheckValue: '请检查输入的值是否合法',
    refresh: '刷新',
    reset: '重置',
    search: '搜索',
    switch: '切换',
    tip: '提示',
    trigger: '触发',
    update: '更新',
    updateSuccess: '更新成功',
    userCenter: '个人中心',
    yesOrNo: {
      yes: '是',
      no: '否'
    }
  },
  request: {
    logout: '请求失败后登出用户',
    logoutMsg: '用户状态失效，请重新登录',
    logoutWithModal: '请求失败后弹出模态框再登出用户',
    logoutWithModalMsg: '用户状态失效，请重新登录',
    refreshToken: '请求的token已过期，刷新token',
    tokenExpired: 'token已过期'
  },
  theme: {
    themeSchema: {
      title: '主题模式',
      light: '亮色模式',
      dark: '暗黑模式',
      auto: '跟随系统'
    },
    grayscale: '灰色模式',
    colourWeakness: '色弱模式',
    layoutMode: {
      title: '布局模式',
      vertical: '左侧菜单模式',
      'vertical-mix': '左侧菜单混合模式',
      horizontal: '顶部菜单模式',
      'horizontal-mix': '顶部菜单混合模式',
      reverseHorizontalMix: '一级菜单与子级菜单位置反转'
    },
    recommendColor: '应用推荐算法的颜色',
    recommendColorDesc: '推荐颜色的算法参照',
    themeColor: {
      title: '主题颜色',
      primary: '主色',
      info: '信息色',
      success: '成功色',
      warning: '警告色',
      error: '错误色',
      followPrimary: '跟随主色'
    },
    scrollMode: {
      title: '滚动模式',
      wrapper: '外层滚动',
      content: '主体滚动'
    },
    page: {
      animate: '页面切换动画',
      mode: {
        title: '页面切换动画类型',
        'fade-slide': '滑动',
        fade: '淡入淡出',
        'fade-bottom': '底部消退',
        'fade-scale': '缩放消退',
        'zoom-fade': '渐变',
        'zoom-out': '闪现',
        none: '无'
      }
    },
    fixedHeaderAndTab: '固定头部和标签栏',
    header: {
      height: '头部高度',
      breadcrumb: {
        visible: '显示面包屑',
        showIcon: '显示面包屑图标'
      },
      multilingual: {
        visible: '显示多语言按钮'
      },
      globalSearch: {
        visible: '显示全局搜索按钮'
      }
    },
    tab: {
      visible: '显示标签栏',
      cache: '标签栏信息缓存',
      height: '标签栏高度',
      mode: {
        title: '标签栏风格',
        chrome: '谷歌风格',
        button: '按钮风格'
      }
    },
    sider: {
      inverted: '深色侧边栏',
      width: '侧边栏宽度',
      collapsedWidth: '侧边栏折叠宽度',
      mixWidth: '混合布局侧边栏宽度',
      mixCollapsedWidth: '混合布局侧边栏折叠宽度',
      mixChildMenuWidth: '混合布局子菜单宽度'
    },
    footer: {
      visible: '显示底部',
      fixed: '固定底部',
      height: '底部高度',
      right: '底部局右'
    },
    watermark: {
      visible: '显示全屏水印',
      text: '水印文本',
      enableUserName: '启用用户名水印'
    },
    themeDrawerTitle: '主题配置',
    pageFunTitle: '页面功能',
    configOperation: {
      copyConfig: '复制配置',
      copySuccessMsg: '复制成功，请替换 src/theme/settings.ts 中的变量 themeSettings',
      resetConfig: '重置配置',
      resetSuccessMsg: '重置成功'
    }
  },
  route: {
    login: '登录',
    403: '无权限',
    404: '页面不存在',
    500: '服务器错误',
    'iframe-page': '外链页面',
    console: '工作台',
    dashboard: '仪表盘',
    dashboard_analysis: '分析页',
    dashboard_console: '控制台',
    dashboard_ecommerce: '电子商务',
    dashboard_hrm: '人事管理',
    dashboard_sponsor: '赞助',
    'dashboard_user-center': '个人中心',
    'demo-route': '演示路由',
    'demo-route_child': '演示子页面',
    document: '文档',
    document_project: '项目文档',
    'document_project-link': '项目文档(外链)',
    document_vue: 'Vue文档',
    document_vite: 'Vite文档',
    document_unocss: 'UnoCSS文档',
    document_naive: 'Naive UI文档',
    document_antd: 'Ant Design Vue文档',
    'document_element-plus': 'Element Plus文档',
    document_alova: 'Alova文档',
    flow: '工作流管理',
    flow_center: '流程中心',
    flow_category: '流程分类',
    flow_template: '流程模板',
    flow_template_design: '流程设计',
    'flow_template_form-design': '表单设计',
    flow_delegate: '流程委托',
    flow_message: '消息中心',
    'flow_fixed-form': '固定表单',
    flow_instance: '流程实例',
    flow_instance_start: '发起流程',
    'flow_instance_start-entry': '发起流程',
    flow_instance_start_template: '发起流程',
    flow_instance_resubmit: '修改并重提',
    'flow_instance_start-legacy': '发起流程',
    'flow_instance_start-legacy_template': '发起流程',
    'flow_instance_start-fixed': '指定表单发起',
    'flow_instance_start-fixed_template': '指定表单发起',
    'flow_instance_my-started': '我的发起',
    'flow_instance_template-list': '模板流程实例',
    flow_instance_detail: '流程详情',
    flow_task: '审批任务',
    flow_task_pending: '待办审批',
    flow_task_completed: '已办审批',
    'flow_task_reverted-canceled': '撤销退回',
    'flow_task_copy-me': '抄送给我',
    flow_form: '示例表单',
    'flow_form_leave-request': '请假申请',
    'flow_form_expense-claim': '报销申请',
    'flow_form_purchase-request': '采购申请',
    flow_form_buy: '采购（示例）',
    'user-center': '个人中心',
    about: '关于',
    function: '系统功能',
    alova: 'alova示例',
    alova_request: 'alova请求',
    alova_user: '用户列表',
    'article-manage': '文章管理',
    article: '文章管理',
    alova_scenes: '场景化请求',
    function_tab: '标签页',
    'function_multi-tab': '多标签页',
    'function_hide-child': '隐藏子菜单',
    'function_hide-child_one': '隐藏子菜单',
    'function_hide-child_two': '菜单二',
    'function_hide-child_three': '菜单三',
    function_request: '请求',
    'function_toggle-auth': '切换权限',
    'function_super-page': '超级管理员可见',
    home: '首页',
    system: '系统管理',
    system_config: '系统设置',
    system_dept: '部门管理',
    system_menu: '菜单管理',
    system_plugin: '插件管理',
    system_post: '岗位管理',
    system_role: '角色管理',
    system_tenant: '租户管理',
    system_user: '用户管理',
    'system_user-detail': '用户详情',
    manage: '系统管理',
    manage_user: '用户管理',
    manage_dept: '部门管理',
    manage_post: '岗位管理',
    manage_tenant: '租户管理',
    manage_config: '系统设置',
    'manage_user-detail': '用户详情',
    manage_role: '角色管理',
    manage_menu: '菜单管理',
    'multi-menu': '多级菜单',
    'multi-menu_first': '菜单一',
    'multi-menu_first_child': '菜单一子菜单',
    'multi-menu_second': '菜单二',
    'multi-menu_second_child': '菜单二子菜单',
    'multi-menu_second_child_home': '菜单二子菜单首页',
    exception: '异常页',
    exception_403: '403',
    exception_404: '404',
    exception_500: '500',
    example: '组件示例',
    example_forms: '弹窗测试',
    plugin: '插件示例',
    plugin_copy: '剪贴板',
    plugin_charts: '图表',
    plugin_charts_echarts: 'ECharts',
    plugin_charts_antv: 'AntV',
    plugin_charts_vchart: 'VChart',
    plugin_editor: '编辑器',
    plugin_editor_quill: '富文本编辑器',
    plugin_editor_markdown: 'MD 编辑器',
    plugin_icon: '图标',
    plugin_map: '地图',
    plugin_print: '打印',
    plugin_swiper: 'Swiper',
    plugin_video: '视频',
    plugin_barcode: '条形码',
    plugin_pinyin: '拼音',
    plugin_excel: 'Excel',
    plugin_pdf: 'PDF 预览',
    plugin_gantt: '甘特图',
    plugin_gantt_dhtmlx: 'dhtmlxGantt',
    plugin_gantt_vtable: 'VTableGantt',
    plugin_typeit: '打字机',
    plugin_tables: '表格',
    plugin_tables_vtable: 'VTable',
    plugin_saipackage: '插件市场',
    plugin_saipackage_install: '插件安装',
    safeguard: '运维监控',
    safeguard_attachment: '附件管理',
    safeguard_cache: '缓存管理',
    safeguard_database: '数据库管理',
    safeguard_dict: '字典管理',
    'safeguard_email-log': '邮件日志',
    'safeguard_login-log': '登录日志',
    'safeguard_oper-log': '操作日志',
    safeguard_redis: 'Redis监控',
    safeguard_server: '服务监控',
    safeguard_online: '在线用户',
    tool: '系统工具',
    tool_task: '任务调度',
    tool_task_cronjob: '定时调度',
    tool_task_cronjob_job: '调度任务',
    tool_task_cronjob_node: '节点管理',
    video: '视频管理',
    tool_code: '代码生成',
    tool_crontab: '定时任务',
    ai: 'AI 大模型',
    'ai_article-category': '文章分类',
    'ai_article-tag': '文章标签',
    ai_provider: 'AI 供应商',
    ai_model: 'AI 模型',
    ai_log: 'AI 日志',
    ai_prompt: 'Prompt 工具',
    ai_workflow: '文章工作流'
  },
  page: {
    login: {
      common: {
        loginOrRegister: '登录 / 注册',
        userNamePlaceholder: '请输入用户名',
        phonePlaceholder: '请输入手机号',
        codePlaceholder: '请输入验证码',
        passwordPlaceholder: '请输入密码',
        confirmPasswordPlaceholder: '请再次输入密码',
        codeLogin: '验证码登录',
        confirm: '确定',
        back: '返回',
        validateSuccess: '验证成功',
        loginSuccess: '登录成功',
        welcomeBack: '欢迎回来，{userName} ！'
      },
      pwdLogin: {
        title: '密码登录',
        rememberMe: '记住我',
        forgetPassword: '忘记密码？',
        register: '注册账号',
        otherAccountLogin: '其他账号登录',
        otherLoginMode: '其他登录方式',
        superAdmin: '超级管理员',
        admin: '管理员',
        user: '普通用户'
      },
      codeLogin: {
        title: '验证码登录',
        getCode: '获取验证码',
        reGetCode: '{time}秒后重新获取',
        sendCodeSuccess: '验证码发送成功',
        imageCodePlaceholder: '请输入图片验证码'
      },
      register: {
        title: '注册账号',
        agreement: '我已经仔细阅读并接受',
        protocol: '《用户协议》',
        policy: '《隐私权政策》'
      },
      resetPwd: {
        title: '重置密码'
      },
      bindWeChat: {
        title: '绑定微信'
      }
    },
    about: {
      title: '关于',
      introduction: `SoybeanAdmin 是一个优雅且功能强大的后台管理模板，基于最新的前端技术栈，包括 Vue3, Vite5, TypeScript, Pinia 和 UnoCSS。它内置了丰富的主题配置和组件，代码规范严谨，实现了自动化的文件路由系统。此外，它还采用了基于 ApiFox 的在线Mock数据方案。SoybeanAdmin 为您提供了一站式的后台管理解决方案，无需额外配置，开箱即用。同样是一个快速学习前沿技术的最佳实践。`,
      projectInfo: {
        title: '项目信息',
        version: '版本',
        latestBuildTime: '最新构建时间',
        githubLink: 'Github 地址',
        previewLink: '预览地址'
      },
      prdDep: '生产依赖',
      devDep: '开发依赖'
    },
    home: {
      branchDesc:
        '为了方便大家开发和更新合并，我们对main分支的代码进行了精简，只保留了首页菜单，其余内容已移至example分支进行维护。预览地址显示的内容即为example分支的内容。',
      greeting: '早安，{userName}, 今天又是充满活力的一天!',
      weatherDesc: '今日多云转晴，20℃ - 25℃!',
      projectCount: '项目数',
      todo: '待办',
      message: '消息',
      downloadCount: '下载量',
      registerCount: '注册量',
      schedule: '作息安排',
      study: '学习',
      work: '工作',
      rest: '休息',
      entertainment: '娱乐',
      visitCount: '访问量',
      turnover: '成交额',
      dealCount: '成交量',
      projectNews: {
        title: '项目动态',
        moreNews: '更多动态',
        desc1: 'Soybean 在2021年5月28日创建了开源项目 soybean-admin!',
        desc2: 'Yanbowe 向 soybean-admin 提交了一个bug，多标签栏不会自适应。',
        desc3: 'Soybean 准备为 soybean-admin 的发布做充分的准备工作!',
        desc4: 'Soybean 正在忙于为soybean-admin写项目说明文档！',
        desc5: 'Soybean 刚才把工作台页面随便写了一些，凑合能看了！'
      },
      creativity: '创意'
    },
    function: {
      tab: {
        tabOperate: {
          title: '标签页操作',
          addTab: '添加标签页',
          addTabDesc: '跳转到关于页面',
          closeTab: '关闭标签页',
          closeCurrentTab: '关闭当前标签页',
          closeAboutTab: '关闭"关于"标签页',
          addMultiTab: '添加多标签页',
          addMultiTabDesc1: '跳转到多标签页页面',
          addMultiTabDesc2: '跳转到多标签页页面(带有查询参数)'
        },
        tabTitle: {
          title: '标签页标题',
          changeTitle: '修改标题',
          change: '修改',
          resetTitle: '重置标题',
          reset: '重置'
        }
      },
      multiTab: {
        routeParam: '路由参数',
        backTab: '返回 function_tab'
      },
      toggleAuth: {
        toggleAccount: '切换账号',
        authHook: '权限钩子函数 `hasAuth`',
        superAdminVisible: '超级管理员可见',
        adminVisible: '管理员可见',
        adminOrUserVisible: '管理员和用户可见'
      },
      request: {
        repeatedErrorOccurOnce: '重复请求错误只出现一次',
        repeatedError: '重复请求错误',
        repeatedErrorMsg1: '自定义请求错误 1',
        repeatedErrorMsg2: '自定义请求错误 2'
      }
    },
    alova: {
      scenes: {
        captchaSend: '发送验证码',
        autoRequest: '自动请求',
        visibilityRequestTips: '浏览器窗口切换自动请求数据',
        pollingRequestTips: '每3秒自动请求一次',
        networkRequestTips: '网络重连后自动请求',
        refreshTime: '更新时间',
        startRequest: '开始请求',
        stopRequest: '停止请求',
        requestCrossComponent: '跨组件触发请求',
        triggerAllRequest: '手动触发所有自动请求'
      }
    },
    manage: {
      common: {
        status: {
          enable: '启用',
          disable: '禁用'
        }
      },
      role: {
        title: '角色列表',
        roleName: '角色名称',
        roleCode: '角色编码',
        roleStatus: '角色状态',
        roleDesc: '角色描述',
        dataScope: '数据权限',
        customDept: '自定义部门',
        menuAuth: '菜单权限',
        buttonAuth: '按钮权限',
        dataScopeOptions: {
          all: '全部数据',
          dept: '本部门数据',
          deptAndChild: '本部门及子部门',
          self: '仅本人数据',
          deptAndSelf: '本部门及子部门+本人',
          custom: '自定义部门'
        },
        form: {
          roleName: '请输入角色名称',
          roleCode: '请输入角色编码',
          roleStatus: '请选择角色状态',
          roleDesc: '请输入角色描述'
        },
        addRole: '新增角色',
        editRole: '编辑角色'
      },
      user: {
        title: '用户列表',
        userName: '用户名',
        userGender: '性别',
        nickName: '昵称',
        userPhone: '手机号',
        userEmail: '邮箱',
        userStatus: '用户状态',
        userRole: '用户角色',
        form: {
          userName: '请输入用户名',
          userGender: '请选择性别',
          nickName: '请输入昵称',
          userPhone: '请输入手机号',
          userEmail: '请输入邮箱',
          userStatus: '请选择用户状态',
          userRole: '请选择用户角色'
        },
        addUser: '新增用户',
        editUser: '编辑用户',
        homePage: '首页',
        lastLogin: '上次登录',
        setHomePage: '设置首页',
        changePassword: '修改密码',
        clearCache: '清理缓存',
        assignMenu: '分配菜单',
        sysUserNoDelete: '系统内置管理员不可删除',
        passwordChanged: '密码修改成功',
        cacheCleared: '清理缓存成功',
        promptNewPassword: '请输入新密码',
        passwordLengthError: '密码长度需在 6 到 20 位之间',
        confirmClearCache: '确定要清理用户「{username}」的缓存吗？',
        gender: {
          male: '男',
          female: '女'
        }
      },
      menu: {
        home: '首页',
        title: '菜单列表',
        id: 'ID',
        parentId: '父级菜单ID',
        menuType: '菜单类型',
        menuName: '菜单名称',
        routeName: '路由名称',
        routePath: '路由路径',
        pathParam: '路径参数',
        layout: '布局',
        page: '页面组件',
        i18nKey: '国际化key',
        icon: '图标',
        localIcon: '本地图标',
        iconTypeTitle: '图标类型',
        order: '排序',
        constant: '常量路由',
        keepAlive: '缓存路由',
        href: '外链',
        hideInMenu: '隐藏菜单',
        activeMenu: '高亮的菜单',
        multiTab: '支持多页签',
        fixedIndexInTab: '固定在页签中的序号',
        query: '路由参数',
        button: '按钮',
        buttonCode: '按钮编码',
        buttonDesc: '按钮描述',
        menuStatus: '菜单状态',
        form: {
          home: '请选择首页',
          menuType: '请选择菜单类型',
          menuName: '请输入菜单名称',
          routeName: '请输入路由名称',
          routePath: '请输入路由路径',
          pathParam: '请输入路径参数',
          page: '请选择页面组件',
          layout: '请选择布局组件',
          i18nKey: '请输入国际化key',
          icon: '请输入图标',
          localIcon: '请选择本地图标',
          order: '请输入排序',
          keepAlive: '请选择是否缓存路由',
          href: '请输入外链',
          hideInMenu: '请选择是否隐藏菜单',
          activeMenu: '请选择高亮的菜单的路由名称',
          multiTab: '请选择是否支持多标签',
          fixedInTab: '请选择是否固定在页签中',
          fixedIndexInTab: '请输入固定在页签中的序号',
          queryKey: '请输入路由参数Key',
          queryValue: '请输入路由参数Value',
          button: '请选择是否按钮',
          buttonCode: '请输入按钮编码',
          buttonDesc: '请输入按钮描述',
          menuStatus: '请选择菜单状态'
        },
        addMenu: '新增菜单',
        editMenu: '编辑菜单',
        addChildMenu: '新增子菜单',
        type: {
          directory: '目录',
          menu: '菜单',
          button: '按钮'
        },
        iconType: {
          iconify: 'iconify图标',
          local: '本地图标'
        }
      },
      dept: {
        title: '部门列表',
        deptName: '部门名称',
        deptCode: '部门编码',
        parentDept: '上级部门',
        parentDeptName: '上级部门名称',
        leader: '部门领导',
        deptStatus: '部门状态',
        phone: '联系电话',
        email: '邮箱',
        sort: '排序',
        remark: '备注',
        form: {
          deptName: '请输入部门名称',
          deptCode: '请输入部门编码',
          deptStatus: '请选择部门状态',
          leader: '请选择部门领导',
          phone: '请输入联系电话',
          email: '请输入邮箱'
        },
        addDept: '新增部门',
        editDept: '编辑部门'
      },
      tenant: {
        title: '租户列表',
        addTenant: '新增租户',
        editTenant: '编辑租户',
        id: '编号',
        tenantName: '租户名称',
        tenantCode: '租户编码',
        contactName: '联系人',
        contactPhone: '联系电话',
        maxUsers: '最大用户数',
        userCount: '当前用户数',
        expireTime: '到期时间',
        tenantStatus: '状态',
        viewUsers: '用户'
      },
      post: {
        title: '岗位管理',
        postName: '岗位名称',
        postCode: '岗位编码',
        postStatus: '状态',
        form: {
          postName: '请输入岗位名称',
          postCode: '请输入岗位编码',
          postStatus: '请选择状态'
        },
        addPost: '新增岗位',
        editPost: '编辑岗位'
      },
      config: {
        title: '配置管理',
        key: '配置标识',
        name: '配置标题',
        inputType: '组件类型',
        sort: '排序',
        remark: '备注'
      }
    },
    safeguard: {
      emailLog: {
        gateway: '服务Host',
        from: '发件人',
        email: '收件人',
        code: '验证码',
        status: '发送状态',
        response: '发送结果',
        createTime: '发送时间',
        success: '成功',
        failure: '失败',
        confirmBatchDelete: '确定要删除选中的 {count} 条邮件日志吗？',
        form: {
          from: '发件人',
          email: '收件人',
          status: '发送状态',
          createTime: '发送时间',
          fromPlaceholder: '请输入发件人',
          emailPlaceholder: '请输入收件人',
          statusPlaceholder: '请选择发送状态',
          rangeSeparator: '至',
          startTime: '开始时间',
          endTime: '结束时间'
        }
      },
      loginLog: {
        id: '编号',
        username: '登录用户',
        status: '登录状态',
        ip: '登录IP',
        ipLocation: '登录地点',
        os: '操作系统',
        browser: '浏览器',
        message: '登录信息',
        loginTime: '登录时间',
        success: '成功',
        failure: '失败',
        confirmBatchDelete: '确定要删除选中的 {count} 条登录日志吗？',
        form: {
          username: '登录用户',
          ip: '登录IP',
          status: '登录状态',
          loginTime: '登录时间',
          usernamePlaceholder: '请输入登录用户',
          ipPlaceholder: '请输入登录IP',
          statusPlaceholder: '请选择登录状态',
          rangeSeparator: '至',
          startTime: '开始时间',
          endTime: '结束时间'
        }
      },
      attachment: {
        categoryTitle: '附件分类',
        preview: '预览',
        originName: '文件名称',
        storageMode: '存储模式',
        mimeType: '文件类型',
        fileSize: '文件大小',
        uploadTime: '上传时间',
        uploadImage: '上传图片',
        move: '移动',
        storageLocal: '本地',
        storageAliOss: '阿里云OSS',
        storageQiniu: '七牛云',
        storageTencentCos: '腾讯云COS',
        selectStorageMode: '请选择存储模式',
        inputFileName: '请输入文件名称',
        imageOnly: '只能上传图片文件!',
        imageSizeLimit: '图片大小不能超过 5MB!',
        uploadSuccess: '上传成功',
        confirmBatchDelete: '确定要删除选中的 {count} 个附件吗？',
        moveSuccess: '成功移动 {count} 个文件'
      },
      database: {
        recycle: {
          title: '回收站',
          drawerTitle: '回收站 - {name}',
          deleteTime: '删除时间',
          dataDetail: '数据详情',
          destroy: '销毁',
          restore: '恢复',
          selectDestroyRows: '请选择要销毁的行',
          selectRestoreRows: '请选择要恢复的行',
          confirmDestroy: '确定要销毁选中的 {count} 条数据吗？',
          confirmRestore: '确定要恢复选中的 {count} 条数据吗？',
          destroyTitle: '销毁选中数据',
          restoreTitle: '恢复选中数据',
          operateSuccess: '操作成功'
        }
      }
    },
    tool: {
      code: {
        title: '代码生成',
        tableName: '表名称',
        tableComment: '表描述',
        template: '应用类型',
        namespace: '应用名称',
        stub: '模板类型',
        tplCategory: '生成类型',
        singleCrud: '单表CRUD',
        treeCrud: '树表CRUD',
        updateTime: '更新时间',
        load: '装载',
        generate: '生成',
        preview: '预览',
        sync: '同步',
        more: '更多',
        generateToProject: '生成到项目',
        codeDownload: '代码下载',
        codeGenerating: '代码生成下载中，请稍后',
        codeGenerateSuccess: '代码生成成功，开始下载',
        downloadFailed: '文件下载失败',
        selectAtLeastOne: '至少要选择一条数据',
        syncConfirm: '执行同步操作将会覆盖已经设置的表结构，确定要同步吗？',
        syncSuccess: '同步成功',
        generateFileConfirm: '生成到项目将会覆盖原有文件，确定要生成吗？',
        generateFileSuccess: '生成到项目成功',
        confirmBatchDelete: '确定要删除选中的 {count} 条记录吗？',
        form: {
          tableName: '表名称',
          source: '数据源',
          tableNamePlaceholder: '请输入数据表名称',
          sourcePlaceholder: '请输入数据源名称'
        }
      },
      crontab: {
        title: '定时任务',
        id: '编号',
        name: '任务名称',
        type: '任务类型',
        rule: '定时规则',
        target: '调用目标',
        status: '状态',
        updateTime: '更新日期',
        runTask: '运行任务',
        runLog: '运行日志',
        confirmRun: '确定要运行任务【{name}】吗？',
        runSuccess: '任务运行成功',
        form: {
          name: '任务名称',
          type: '任务类型',
          status: '状态',
          namePlaceholder: '请输入任务名称',
          typePlaceholder: '请选择任务类型',
          statusPlaceholder: '请选择状态'
        },
        log: {
          title: '任务执行日志',
          listTitle: '执行日志',
          executeTime: '执行时间',
          target: '调用目标',
          parameter: '任务参数',
          executeStatus: '执行状态',
          success: '成功',
          failure: '失败',
          selectTaskFirst: '请先选择一个任务',
          selectAtLeastOne: '至少要选择一条数据',
          confirmBatchDelete: '确定要删除选中的 {count} 条数据吗？',
          deleteTitle: '删除选中数据',
          rangeSeparator: '至',
          startTime: '开始时间',
          endTime: '结束时间'
        }
      }
    },
    article: {
      title: '文章列表',
      articleTitle: '文章标题',
      author: '作者',
      coverImage: '封面图片',
      views: '浏览次数',
      isLink: '是否外链',
      isHot: '是否热门',
      sort: '排序',
      status: '状态',
      createTime: '创建时间',
      hot: '热门',
      normal: '普通',
      statusUpdateFailed: '状态更新失败',
      statusUpdateSuccess: '状态更新成功',
      selectAtLeastOne: '请至少选择一条数据',
      form: {
        title: '文章标题',
        author: '作者',
        status: '状态',
        titlePlaceholder: '请输入文章标题',
        authorPlaceholder: '请输入作者',
        statusPlaceholder: '请选择状态'
      }
    }
  },
  form: {
    required: '不能为空',
    userName: {
      required: '请输入用户名',
      invalid: '用户名格式不正确'
    },
    phone: {
      required: '请输入手机号',
      invalid: '手机号格式不正确'
    },
    pwd: {
      required: '请输入密码',
      invalid: '密码格式不正确，6-18位字符，包含字母、数字、下划线'
    },
    confirmPwd: {
      required: '请输入确认密码',
      invalid: '两次输入密码不一致'
    },
    code: {
      required: '请输入验证码',
      invalid: '验证码格式不正确'
    },
    email: {
      required: '请输入邮箱',
      invalid: '邮箱格式不正确'
    }
  },
  dropdown: {
    closeCurrent: '关闭',
    closeOther: '关闭其它',
    closeLeft: '关闭左侧',
    closeRight: '关闭右侧',
    closeAll: '关闭所有'
  },
  icon: {
    themeConfig: '主题配置',
    themeSchema: '主题模式',
    lang: '切换语言',
    fullscreen: '全屏',
    fullscreenExit: '退出全屏',
    reload: '刷新页面',
    collapse: '折叠菜单',
    expand: '展开菜单',
    pin: '固定',
    unpin: '取消固定'
  },
  table: {
    searchBar: {
      reset: '重置',
      search: '查询',
      expand: '展开',
      collapse: '收起',
      searchInputPlaceholder: '请输入',
      searchSelectPlaceholder: '请选择'
    }
  },
  datatable: {
    itemCount: '共 {total} 条'
  }
};

export default local;
