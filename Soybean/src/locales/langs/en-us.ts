const local: App.I18n.Schema = {
  system: {
    title: 'FssAdmin',
    updateTitle: 'System Version Update Notification',
    updateContent: 'A new version of the system has been detected. Do you want to refresh the page immediately?',
    updateConfirm: 'Refresh immediately',
    updateCancel: 'Later'
  },
  common: {
    action: 'Action',
    add: 'Add',
    addSuccess: 'Add Success',
    backToHome: 'Back to home',
    batchDelete: 'Batch Delete',
    cancel: 'Cancel',
    close: 'Close',
    check: 'Check',
    expandColumn: 'Expand Column',
    columnSetting: 'Column Setting',
    config: 'Config',
    confirm: 'Confirm',
    delete: 'Delete',
    deleteSuccess: 'Delete Success',
    confirmDelete: 'Are you sure you want to delete?',
    edit: 'Edit',
    warning: 'Warning',
    error: 'Error',
    index: 'Index',
    keywordSearch: 'Please enter keyword',
    logout: 'Logout',
    logoutConfirm: 'Are you sure you want to log out?',
    lookForward: 'Coming soon',
    modify: 'Modify',
    modifySuccess: 'Modify Success',
    noData: 'No Data',
    operate: 'Operate',
    pleaseCheckValue: 'Please check whether the value is valid',
    refresh: 'Refresh',
    reset: 'Reset',
    search: 'Search',
    switch: 'Switch',
    tip: 'Tip',
    trigger: 'Trigger',
    update: 'Update',
    updateSuccess: 'Update Success',
    userCenter: 'User Center',
    yesOrNo: {
      yes: 'Yes',
      no: 'No'
    }
  },
  request: {
    logout: 'Logout user after request failed',
    logoutMsg: 'User status is invalid, please log in again',
    logoutWithModal: 'Pop up modal after request failed and then log out user',
    logoutWithModalMsg: 'User status is invalid, please log in again',
    refreshToken: 'The requested token has expired, refresh the token',
    tokenExpired: 'The requested token has expired'
  },
  theme: {
    themeSchema: {
      title: 'Theme Schema',
      light: 'Light',
      dark: 'Dark',
      auto: 'Follow System'
    },
    grayscale: 'Grayscale',
    colourWeakness: 'Colour Weakness',
    layoutMode: {
      title: 'Layout Mode',
      vertical: 'Vertical Menu Mode',
      horizontal: 'Horizontal Menu Mode',
      'vertical-mix': 'Vertical Mix Menu Mode',
      'horizontal-mix': 'Horizontal Mix menu Mode',
      reverseHorizontalMix: 'Reverse first level menus and child level menus position'
    },
    recommendColor: 'Apply Recommended Color Algorithm',
    recommendColorDesc: 'The recommended color algorithm refers to',
    themeColor: {
      title: 'Theme Color',
      primary: 'Primary',
      info: 'Info',
      success: 'Success',
      warning: 'Warning',
      error: 'Error',
      followPrimary: 'Follow Primary'
    },
    scrollMode: {
      title: 'Scroll Mode',
      wrapper: 'Wrapper',
      content: 'Content'
    },
    page: {
      animate: 'Page Animate',
      mode: {
        title: 'Page Animate Mode',
        fade: 'Fade',
        'fade-slide': 'Slide',
        'fade-bottom': 'Fade Zoom',
        'fade-scale': 'Fade Scale',
        'zoom-fade': 'Zoom Fade',
        'zoom-out': 'Zoom Out',
        none: 'None'
      }
    },
    fixedHeaderAndTab: 'Fixed Header And Tab',
    header: {
      height: 'Header Height',
      breadcrumb: {
        visible: 'Breadcrumb Visible',
        showIcon: 'Breadcrumb Icon Visible'
      },
      multilingual: {
        visible: 'Display multilingual button'
      },
      globalSearch: {
        visible: 'Display global search button'
      }
    },
    tab: {
      visible: 'Tab Visible',
      cache: 'Tag Bar Info Cache',
      height: 'Tab Height',
      mode: {
        title: 'Tab Mode',
        chrome: 'Chrome',
        button: 'Button'
      }
    },
    sider: {
      inverted: 'Dark Sider',
      width: 'Sider Width',
      collapsedWidth: 'Sider Collapsed Width',
      mixWidth: 'Mix Sider Width',
      mixCollapsedWidth: 'Mix Sider Collapse Width',
      mixChildMenuWidth: 'Mix Child Menu Width'
    },
    footer: {
      visible: 'Footer Visible',
      fixed: 'Fixed Footer',
      height: 'Footer Height',
      right: 'Right Footer'
    },
    watermark: {
      visible: 'Watermark Full Screen Visible',
      text: 'Watermark Text',
      enableUserName: 'Enable User Name Watermark'
    },
    themeDrawerTitle: 'Theme Configuration',
    pageFunTitle: 'Page Function',
    configOperation: {
      copyConfig: 'Copy Config',
      copySuccessMsg: 'Copy Success, Please replace the variable "themeSettings" in "src/theme/settings.ts"',
      resetConfig: 'Reset Config',
      resetSuccessMsg: 'Reset Success'
    }
  },
  route: {
    login: 'Login',
    403: 'No Permission',
    404: 'Page Not Found',
    500: 'Server Error',
    'iframe-page': 'Iframe',
    console: 'Console',
    dashboard: 'Dashboard',
    dashboard_analysis: 'Analysis',
    dashboard_console: 'Console',
    dashboard_ecommerce: 'E-commerce',
    dashboard_hrm: 'HRM',
    dashboard_sponsor: 'Sponsor',
    'dashboard_user-center': 'User Center',
    'demo-route': 'Demo Route',
    'demo-route_child': 'Demo Child',
    document: 'Document',
    document_project: 'Project Document',
    'document_project-link': 'Project Document(External Link)',
    document_vue: 'Vue Document',
    document_vite: 'Vite Document',
    document_unocss: 'UnoCSS Document',
    document_naive: 'Naive UI Document',
    document_antd: 'Ant Design Vue Document',
    'document_element-plus': 'Element Plus Document',
    document_alova: 'Alova Document',
    flow: 'Workflow',
    flow_center: 'Flow Center',
    flow_category: 'Flow Category',
    flow_template: 'Flow Template',
    flow_template_design: 'Template Design',
    'flow_template_form-design': 'Form Design',
    flow_delegate: 'Flow Delegate',
    flow_message: 'Message Center',
    'flow_fixed-form': 'Fixed Form',
    flow_instance: 'Flow Instance',
    flow_instance_start: 'Start Flow',
    'flow_instance_start-entry': 'Start Flow',
    flow_instance_start_template: 'Start Flow',
    flow_instance_resubmit: 'Resubmit',
    'flow_instance_start-legacy': 'Start Flow',
    'flow_instance_start-legacy_template': 'Start Flow',
    'flow_instance_start-fixed': 'Start (Fixed Form)',
    'flow_instance_start-fixed_template': 'Start (Fixed Form)',
    'flow_instance_my-started': 'My Started',
    'flow_instance_template-list': 'Template Instances',
    flow_instance_detail: 'Instance Detail',
    flow_task: 'Approval Tasks',
    flow_task_pending: 'Pending',
    flow_task_completed: 'Completed',
    'flow_task_reverted-canceled': 'Reverted/Canceled',
    'flow_task_copy-me': 'Copied To Me',
    flow_form: 'Sample Forms',
    'flow_form_leave-request': 'Leave Request',
    'flow_form_expense-claim': 'Expense Claim',
    'flow_form_purchase-request': 'Purchase Request',
    flow_form_buy: 'Buy (Sample)',
    'user-center': 'User Center',
    about: 'About',
    function: 'System Function',
    alova: 'Alova Example',
    alova_request: 'Alova Request',
    alova_user: 'User List',
    'article-manage': 'Article Manage',
    article: 'Article Manage',
    alova_scenes: 'Scenario Request',
    function_tab: 'Tab',
    'function_multi-tab': 'Multi Tab',
    'function_hide-child': 'Hide Child',
    'function_hide-child_one': 'Hide Child',
    'function_hide-child_two': 'Two',
    'function_hide-child_three': 'Three',
    function_request: 'Request',
    'function_toggle-auth': 'Toggle Auth',
    'function_super-page': 'Super Admin Visible',
    home: 'Home',
    system: 'System Manage',
    system_config: 'System Settings',
    system_dept: 'Department Manage',
    system_menu: 'Menu Manage',
    system_plugin: 'Plugin Manage',
    system_post: 'Post Manage',
    system_role: 'Role Manage',
    system_tenant: 'Tenant Manage',
    system_user: 'User Manage',
    'system_user-detail': 'User Detail',
    manage: 'System Manage',
    manage_user: 'User Manage',
    manage_dept: 'Dept Manage',
    manage_post: 'Post Manage',
    manage_tenant: 'Tenant Manage',
    manage_config: 'System Settings',
    'manage_user-detail': 'User Detail',
    manage_role: 'Role Manage',
    manage_menu: 'Menu Manage',
    'multi-menu': 'Multi Menu',
    'multi-menu_first': 'Menu One',
    'multi-menu_first_child': 'Menu One Child',
    'multi-menu_second': 'Menu Two',
    'multi-menu_second_child': 'Menu Two Child',
    'multi-menu_second_child_home': 'Menu Two Child Home',
    exception: 'Exception',
    exception_403: '403',
    exception_404: '404',
    exception_500: '500',
    example: 'Examples',
    example_forms: 'WinSelector Demo',
    plugin: 'Plugin',
    plugin_copy: 'Copy',
    plugin_charts: 'Charts',
    plugin_charts_echarts: 'ECharts',
    plugin_charts_antv: 'AntV',
    plugin_charts_vchart: 'VChart',
    plugin_editor: 'Editor',
    plugin_editor_quill: 'Quill',
    plugin_editor_markdown: 'Markdown',
    plugin_icon: 'Icon',
    plugin_map: 'Map',
    plugin_print: 'Print',
    plugin_swiper: 'Swiper',
    plugin_video: 'Video',
    plugin_barcode: 'Barcode',
    plugin_pinyin: 'pinyin',
    plugin_excel: 'Excel',
    plugin_pdf: 'PDF preview',
    plugin_gantt: 'Gantt Chart',
    plugin_gantt_dhtmlx: 'dhtmlxGantt',
    plugin_gantt_vtable: 'VTableGantt',
    plugin_typeit: 'Typeit',
    plugin_tables: 'Tables',
    plugin_tables_vtable: 'VTable',
    plugin_saipackage: 'Plugin Market',
    plugin_saipackage_install: 'Plugin Install',
    safeguard: 'Safeguard',
    safeguard_attachment: 'Attachment',
    safeguard_cache: 'Cache',
    safeguard_database: 'Database',
    safeguard_dict: 'Dictionary',
    'safeguard_email-log': 'Email Log',
    'safeguard_login-log': 'Login Log',
    'safeguard_oper-log': 'Operation Log',
    safeguard_redis: 'Redis',
    safeguard_server: 'Server',
    safeguard_online: 'Online Users',
    tool: 'System Tools',
    tool_task: 'Task Scheduler',
    tool_task_cronjob: 'Cronjob',
    tool_task_cronjob_job: 'Scheduler Jobs',
    tool_task_cronjob_node: 'Nodes',
    video: 'Video',
    tool_code: 'Code Generator',
    tool_crontab: 'Cron Jobs',
    ai: 'AI Models',
    'ai_article-category': 'Article Categories',
    'ai_article-tag': 'Article Tags',
    ai_provider: 'AI Providers',
    ai_model: 'AI Models',
    ai_log: 'AI Logs',
    ai_prompt: 'Prompt Tools',
    ai_workflow: 'Article Workflow'
  },
  page: {
    login: {
      common: {
        loginOrRegister: 'Login / Register',
        userNamePlaceholder: 'Please enter user name',
        phonePlaceholder: 'Please enter phone number',
        codePlaceholder: 'Please enter verification code',
        passwordPlaceholder: 'Please enter password',
        confirmPasswordPlaceholder: 'Please enter password again',
        codeLogin: 'Verification code login',
        confirm: 'Confirm',
        back: 'Back',
        validateSuccess: 'Verification passed',
        loginSuccess: 'Login successfully',
        welcomeBack: 'Welcome back, {userName} !'
      },
      pwdLogin: {
        title: 'Password Login',
        rememberMe: 'Remember me',
        forgetPassword: 'Forget password?',
        register: 'Register',
        otherAccountLogin: 'Other Account Login',
        otherLoginMode: 'Other Login Mode',
        superAdmin: 'Super Admin',
        admin: 'Admin',
        user: 'User'
      },
      codeLogin: {
        title: 'Verification Code Login',
        getCode: 'Get verification code',
        reGetCode: 'Reacquire after {time}s',
        sendCodeSuccess: 'Verification code sent successfully',
        imageCodePlaceholder: 'Please enter image verification code'
      },
      register: {
        title: 'Register',
        agreement: 'I have read and agree to',
        protocol: '《User Agreement》',
        policy: '《Privacy Policy》'
      },
      resetPwd: {
        title: 'Reset Password'
      },
      bindWeChat: {
        title: 'Bind WeChat'
      }
    },
    about: {
      title: 'About',
      introduction: `SoybeanAdmin is an elegant and powerful admin template, based on the latest front-end technology stack, including Vue3, Vite5, TypeScript, Pinia and UnoCSS. It has built-in rich theme configuration and components, strict code specifications, and an automated file routing system. In addition, it also uses the online mock data solution based on ApiFox. SoybeanAdmin provides you with a one-stop admin solution, no additional configuration, and out of the box. It is also a best practice for learning cutting-edge technologies quickly.`,
      projectInfo: {
        title: 'Project Info',
        version: 'Version',
        latestBuildTime: 'Latest Build Time',
        githubLink: 'Github Link',
        previewLink: 'Preview Link'
      },
      prdDep: 'Production Dependency',
      devDep: 'Development Dependency'
    },
    home: {
      branchDesc:
        'For the convenience of everyone in developing and updating the merge, we have streamlined the code of the main branch, only retaining the homepage menu, and the rest of the content has been moved to the example branch for maintenance. The preview address displays the content of the example branch.',
      greeting: 'Good morning, {userName}, today is another day full of vitality!',
      weatherDesc: 'Today is cloudy to clear, 20℃ - 25℃!',
      projectCount: 'Project Count',
      todo: 'Todo',
      message: 'Message',
      downloadCount: 'Download Count',
      registerCount: 'Register Count',
      schedule: 'Work and rest Schedule',
      study: 'Study',
      work: 'Work',
      rest: 'Rest',
      entertainment: 'Entertainment',
      visitCount: 'Visit Count',
      turnover: 'Turnover',
      dealCount: 'Deal Count',
      projectNews: {
        title: 'Project News',
        moreNews: 'More News',
        desc1: 'Soybean created the open source project soybean-admin on May 28, 2021!',
        desc2: 'Yanbowe submitted a bug to soybean-admin, the multi-tab bar will not adapt.',
        desc3: 'Soybean is ready to do sufficient preparation for the release of soybean-admin!',
        desc4: 'Soybean is busy writing project documentation for soybean-admin!',
        desc5: 'Soybean just wrote some of the workbench pages casually, and it was enough to see!'
      },
      creativity: 'Creativity'
    },
    function: {
      tab: {
        tabOperate: {
          title: 'Tab Operation',
          addTab: 'Add Tab',
          addTabDesc: 'To about page',
          closeTab: 'Close Tab',
          closeCurrentTab: 'Close Current Tab',
          closeAboutTab: 'Close "About" Tab',
          addMultiTab: 'Add Multi Tab',
          addMultiTabDesc1: 'To MultiTab page',
          addMultiTabDesc2: 'To MultiTab page(with query params)'
        },
        tabTitle: {
          title: 'Tab Title',
          changeTitle: 'Change Title',
          change: 'Change',
          resetTitle: 'Reset Title',
          reset: 'Reset'
        }
      },
      multiTab: {
        routeParam: 'Route Param',
        backTab: 'Back function_tab'
      },
      toggleAuth: {
        toggleAccount: 'Toggle Account',
        authHook: 'Auth Hook Function `hasAuth`',
        superAdminVisible: 'Super Admin Visible',
        adminVisible: 'Admin Visible',
        adminOrUserVisible: 'Admin and User Visible'
      },
      request: {
        repeatedErrorOccurOnce: 'Repeated Request Error Occurs Once',
        repeatedError: 'Repeated Request Error',
        repeatedErrorMsg1: 'Custom Request Error 1',
        repeatedErrorMsg2: 'Custom Request Error 2'
      }
    },
    alova: {
      scenes: {
        captchaSend: 'Captcha Send',
        autoRequest: 'Auto Request',
        visibilityRequestTips: 'Automatically request when switching browser window',
        pollingRequestTips: 'It will request every 3 seconds',
        networkRequestTips: 'Automatically request after network reconnecting',
        refreshTime: 'Refresh Time',
        startRequest: 'Start Request',
        stopRequest: 'Stop Request',
        requestCrossComponent: 'Request Cross Component',
        triggerAllRequest: 'Manually Trigger All Automated Requests'
      }
    },
    manage: {
      common: {
        status: {
          enable: 'Enable',
          disable: 'Disable'
        }
      },
      role: {
        title: 'Role List',
        roleName: 'Role Name',
        roleCode: 'Role Code',
        roleStatus: 'Role Status',
        roleDesc: 'Role Description',
        dataScope: 'Data Scope',
        customDept: 'Custom Departments',
        menuAuth: 'Menu Auth',
        buttonAuth: 'Button Auth',
        dataScopeOptions: {
          all: 'All Data',
          dept: 'Department Data',
          deptAndChild: 'Department + Children',
          self: 'Self Data',
          deptAndSelf: 'Department + Children + Self',
          custom: 'Custom Departments'
        },
        form: {
          roleName: 'Please enter role name',
          roleCode: 'Please enter role code',
          roleStatus: 'Please select role status',
          roleDesc: 'Please enter role description'
        },
        addRole: 'Add Role',
        editRole: 'Edit Role'
      },
      user: {
        title: 'User List',
        userName: 'User Name',
        userGender: 'Gender',
        nickName: 'Nick Name',
        userPhone: 'Phone Number',
        userEmail: 'Email',
        userStatus: 'User Status',
        userRole: 'User Role',
        form: {
          userName: 'Please enter user name',
          userGender: 'Please select gender',
          nickName: 'Please enter nick name',
          userPhone: 'Please enter phone number',
          userEmail: 'Please enter email',
          userStatus: 'Please select user status',
          userRole: 'Please select user role'
        },
        addUser: 'Add User',
        editUser: 'Edit User',
        homePage: 'Home Page',
        lastLogin: 'Last Login',
        setHomePage: 'Set Home Page',
        changePassword: 'Change Password',
        clearCache: 'Clear Cache',
        assignMenu: 'Assign Menu',
        sysUserNoDelete: 'Built-in admin cannot be deleted',
        passwordChanged: 'Password changed successfully',
        cacheCleared: 'Cache cleared successfully',
        promptNewPassword: 'Please enter new password',
        passwordLengthError: 'Password length must be between 6 and 20 characters',
        confirmClearCache: 'Clear cache for user "{username}"?',
        gender: {
          male: 'Male',
          female: 'Female'
        }
      },
      menu: {
        home: 'Home',
        title: 'Menu List',
        id: 'ID',
        parentId: 'Parent ID',
        menuType: 'Menu Type',
        menuName: 'Menu Name',
        routeName: 'Route Name',
        routePath: 'Route Path',
        pathParam: 'Path Param',
        layout: 'Layout Component',
        page: 'Page Component',
        i18nKey: 'I18n Key',
        icon: 'Icon',
        localIcon: 'Local Icon',
        iconTypeTitle: 'Icon Type',
        order: 'Order',
        constant: 'Constant',
        keepAlive: 'Keep Alive',
        href: 'Href',
        hideInMenu: 'Hide In Menu',
        activeMenu: 'Active Menu',
        multiTab: 'Multi Tab',
        fixedIndexInTab: 'Fixed Index In Tab',
        query: 'Query Params',
        button: 'Button',
        buttonCode: 'Button Code',
        buttonDesc: 'Button Desc',
        menuStatus: 'Menu Status',
        form: {
          home: 'Please select home',
          menuType: 'Please select menu type',
          menuName: 'Please enter menu name',
          routeName: 'Please enter route name',
          routePath: 'Please enter route path',
          pathParam: 'Please enter path param',
          page: 'Please select page component',
          layout: 'Please select layout component',
          i18nKey: 'Please enter i18n key',
          icon: 'Please enter iconify name',
          localIcon: 'Please enter local icon name',
          order: 'Please enter order',
          keepAlive: 'Please select whether to cache route',
          href: 'Please enter href',
          hideInMenu: 'Please select whether to hide menu',
          activeMenu: 'Please select route name of the highlighted menu',
          multiTab: 'Please select whether to support multiple tabs',
          fixedInTab: 'Please select whether to fix in the tab',
          fixedIndexInTab: 'Please enter the index fixed in the tab',
          queryKey: 'Please enter route parameter Key',
          queryValue: 'Please enter route parameter Value',
          button: 'Please select whether it is a button',
          buttonCode: 'Please enter button code',
          buttonDesc: 'Please enter button description',
          menuStatus: 'Please select menu status'
        },
        addMenu: 'Add Menu',
        editMenu: 'Edit Menu',
        addChildMenu: 'Add Child Menu',
        type: {
          directory: 'Directory',
          menu: 'Menu',
          button: 'Button'
        },
        iconType: {
          iconify: 'Iconify Icon',
          local: 'Local Icon'
        }
      },
      dept: {
        title: 'Department List',
        deptName: 'Department Name',
        deptCode: 'Department Code',
        parentDept: 'Parent Department',
        parentDeptName: 'Parent Department Name',
        leader: 'Department Leader',
        deptStatus: 'Department Status',
        phone: 'Phone',
        email: 'Email',
        sort: 'Sort',
        remark: 'Remark',
        form: {
          deptName: 'Please enter department name',
          deptCode: 'Please enter department code',
          deptStatus: 'Please select department status',
          leader: 'Please select department leader',
          phone: 'Please enter phone',
          email: 'Please enter email'
        },
        addDept: 'Add Department',
        editDept: 'Edit Department'
      },
      tenant: {
        title: 'Tenant List',
        addTenant: 'Add Tenant',
        editTenant: 'Edit Tenant',
        id: 'ID',
        tenantName: 'Tenant Name',
        tenantCode: 'Tenant Code',
        contactName: 'Contact',
        contactPhone: 'Phone',
        maxUsers: 'Max Users',
        userCount: 'User Count',
        expireTime: 'Expire Time',
        tenantStatus: 'Status',
        viewUsers: 'Users'
      },
      post: {
        title: 'Post Manage',
        postName: 'Post Name',
        postCode: 'Post Code',
        postStatus: 'Status',
        form: {
          postName: 'Please enter post name',
          postCode: 'Please enter post code',
          postStatus: 'Please select status'
        },
        addPost: 'Add Post',
        editPost: 'Edit Post'
      },
      config: {
        title: 'Config Management',
        key: 'Config Key',
        name: 'Config Title',
        inputType: 'Input Type',
        sort: 'Sort',
        remark: 'Remark'
      }
    },
    safeguard: {
      emailLog: {
        gateway: 'Gateway Host',
        from: 'Sender',
        email: 'Recipient',
        code: 'Verification Code',
        status: 'Send Status',
        response: 'Send Result',
        createTime: 'Send Time',
        success: 'Success',
        failure: 'Failure',
        confirmBatchDelete: 'Delete {count} selected email log(s)?',
        form: {
          from: 'Sender',
          email: 'Recipient',
          status: 'Send Status',
          createTime: 'Send Time',
          fromPlaceholder: 'Please enter sender',
          emailPlaceholder: 'Please enter recipient',
          statusPlaceholder: 'Please select send status',
          rangeSeparator: 'to',
          startTime: 'Start time',
          endTime: 'End time'
        }
      },
      loginLog: {
        id: 'ID',
        username: 'Username',
        status: 'Login Status',
        ip: 'Login IP',
        ipLocation: 'Location',
        os: 'OS',
        browser: 'Browser',
        message: 'Login Message',
        loginTime: 'Login Time',
        success: 'Success',
        failure: 'Failure',
        confirmBatchDelete: 'Delete {count} selected login log(s)?',
        form: {
          username: 'Username',
          ip: 'Login IP',
          status: 'Login Status',
          loginTime: 'Login Time',
          usernamePlaceholder: 'Please enter username',
          ipPlaceholder: 'Please enter IP',
          statusPlaceholder: 'Please select login status',
          rangeSeparator: 'to',
          startTime: 'Start time',
          endTime: 'End time'
        }
      },
      attachment: {
        categoryTitle: 'Attachment Category',
        preview: 'Preview',
        originName: 'File Name',
        storageMode: 'Storage Mode',
        mimeType: 'File Type',
        fileSize: 'File Size',
        uploadTime: 'Upload Time',
        uploadImage: 'Upload Image',
        move: 'Move',
        storageLocal: 'Local',
        storageAliOss: 'Aliyun OSS',
        storageQiniu: 'Qiniu Cloud',
        storageTencentCos: 'Tencent COS',
        selectStorageMode: 'Please select storage mode',
        inputFileName: 'Please enter file name',
        imageOnly: 'Only image files are allowed!',
        imageSizeLimit: 'Image size cannot exceed 5MB!',
        uploadSuccess: 'Upload successful',
        confirmBatchDelete: 'Delete {count} selected attachment(s)?',
        moveSuccess: 'Moved {count} file(s) successfully'
      },
      database: {
        recycle: {
          title: 'Recycle Bin',
          drawerTitle: 'Recycle Bin - {name}',
          deleteTime: 'Delete Time',
          dataDetail: 'Data Detail',
          destroy: 'Destroy',
          restore: 'Restore',
          selectDestroyRows: 'Please select rows to destroy',
          selectRestoreRows: 'Please select rows to restore',
          confirmDestroy: 'Destroy {count} selected row(s)?',
          confirmRestore: 'Restore {count} selected row(s)?',
          destroyTitle: 'Destroy Selected Data',
          restoreTitle: 'Restore Selected Data',
          operateSuccess: 'Operation successful'
        }
      }
    },
    tool: {
      code: {
        title: 'Code Generator',
        tableName: 'Table Name',
        tableComment: 'Table Comment',
        template: 'App Type',
        namespace: 'App Name',
        stub: 'Template Type',
        tplCategory: 'Generate Type',
        singleCrud: 'Single Table CRUD',
        treeCrud: 'Tree Table CRUD',
        updateTime: 'Update Time',
        load: 'Load',
        generate: 'Generate',
        preview: 'Preview',
        sync: 'Sync',
        more: 'More',
        generateToProject: 'Generate to Project',
        codeDownload: 'Download Code',
        codeGenerating: 'Generating code, please wait',
        codeGenerateSuccess: 'Code generated, download started',
        downloadFailed: 'File download failed',
        selectAtLeastOne: 'Please select at least one row',
        syncConfirm: 'Sync will overwrite the configured table structure. Continue?',
        syncSuccess: 'Sync successful',
        generateFileConfirm: 'Generating to project will overwrite existing files. Continue?',
        generateFileSuccess: 'Generated to project successfully',
        confirmBatchDelete: 'Delete {count} selected record(s)?',
        form: {
          tableName: 'Table Name',
          source: 'Data Source',
          tableNamePlaceholder: 'Please enter table name',
          sourcePlaceholder: 'Please enter data source name'
        }
      },
      crontab: {
        title: 'Scheduled Tasks',
        id: 'ID',
        name: 'Task Name',
        type: 'Task Type',
        rule: 'Cron Rule',
        target: 'Target',
        status: 'Status',
        updateTime: 'Update Time',
        runTask: 'Run Task',
        runLog: 'Run Log',
        confirmRun: 'Run task [{name}] now?',
        runSuccess: 'Task started successfully',
        form: {
          name: 'Task Name',
          type: 'Task Type',
          status: 'Status',
          namePlaceholder: 'Please enter task name',
          typePlaceholder: 'Please select task type',
          statusPlaceholder: 'Please select status'
        },
        log: {
          title: 'Task Execution Log',
          listTitle: 'Execution Log',
          executeTime: 'Execute Time',
          target: 'Target',
          parameter: 'Task Parameter',
          executeStatus: 'Execute Status',
          success: 'Success',
          failure: 'Failure',
          selectTaskFirst: 'Please select a task first',
          selectAtLeastOne: 'Please select at least one row',
          confirmBatchDelete: 'Delete {count} selected row(s)?',
          deleteTitle: 'Delete Selected Data',
          rangeSeparator: 'to',
          startTime: 'Start time',
          endTime: 'End time'
        }
      }
    },
    article: {
      title: 'Article List',
      articleTitle: 'Article Title',
      author: 'Author',
      coverImage: 'Cover Image',
      views: 'Views',
      isLink: 'External Link',
      isHot: 'Hot Article',
      sort: 'Sort',
      status: 'Status',
      createTime: 'Create Time',
      hot: 'Hot',
      normal: 'Normal',
      statusUpdateFailed: 'Failed to update status',
      statusUpdateSuccess: 'Status updated successfully',
      selectAtLeastOne: 'Please select at least one row',
      form: {
        title: 'Article Title',
        author: 'Author',
        status: 'Status',
        titlePlaceholder: 'Please enter article title',
        authorPlaceholder: 'Please enter author',
        statusPlaceholder: 'Please select status'
      }
    }
  },
  form: {
    required: 'Cannot be empty',
    userName: {
      required: 'Please enter user name',
      invalid: 'User name format is incorrect'
    },
    phone: {
      required: 'Please enter phone number',
      invalid: 'Phone number format is incorrect'
    },
    pwd: {
      required: 'Please enter password',
      invalid: '6-18 characters, including letters, numbers, and underscores'
    },
    confirmPwd: {
      required: 'Please enter password again',
      invalid: 'The two passwords are inconsistent'
    },
    code: {
      required: 'Please enter verification code',
      invalid: 'Verification code format is incorrect'
    },
    email: {
      required: 'Please enter email',
      invalid: 'Email format is incorrect'
    }
  },
  dropdown: {
    closeCurrent: 'Close Current',
    closeOther: 'Close Other',
    closeLeft: 'Close Left',
    closeRight: 'Close Right',
    closeAll: 'Close All'
  },
  icon: {
    themeConfig: 'Theme Configuration',
    themeSchema: 'Theme Schema',
    lang: 'Switch Language',
    fullscreen: 'Fullscreen',
    fullscreenExit: 'Exit Fullscreen',
    reload: 'Reload Page',
    collapse: 'Collapse Menu',
    expand: 'Expand Menu',
    pin: 'Pin',
    unpin: 'Unpin'
  },
  table: {
    searchBar: {
      reset: 'Reset',
      search: 'Search',
      expand: 'Expand',
      collapse: 'Collapse',
      searchInputPlaceholder: 'Please enter',
      searchSelectPlaceholder: 'Please select'
    }
  },
  datatable: {
    itemCount: 'Total {total} items'
  }
};

export default local;
