declare namespace Api {
  namespace Flow {
    type FlowPageParams = CommonType.RecordNullable<{
      page: number;
      limit: number;
      keyword?: string;
      instance_status?: number;
      task_status?: number;
      is_read?: number;
      status?: number;
      category_id?: number;
      template_id?: number;
      templateId?: number | string;
      type?: string;
    }>;

    type FlowPage<T = any> = {
      list: T[];
      total: number;
      page: number;
      limit: number;
      [key: string]: any;
    };

    /** @deprecated flow 模块实际返回 FlowPage，保留兼容别名 */
    type LaravelPage<T = any> = FlowPage<T>;

    type Category = Api.Common.ApiData & {
      id: number;
      parent_id?: number;
      category_name: string;
      status?: number;
      sort?: number;
    };

    type CategoryNode = Category & {
      children?: CategoryNode[];
    };

    type Template = Api.Common.ApiData & {
      id: number;
      template_name: string;
      template_code: string;
      category_id?: number;
      category_name?: string;
      status?: number;
      version?: string | number;
      icon?: string;
      form_type?: number;
      fixed_form_key?: string;
      create_time?: string;
    };

    type TemplateDetail = Template & {
      base_setting_json?: Api.Common.ApiData;
      form_json?: Api.Common.ApiData;
      process_json?: Api.Common.ApiData;
    };

    type TemplatePayload = Api.Common.ApiData;

    type FixedFormOption = Api.Common.ApiData & {
      id: number | string;
      name?: string;
      label?: string;
      value?: string | number;
      fixed_form_key?: string;
    };

    type TemplateOption = Api.Common.ApiData & {
      id: number | string;
      template_name?: string;
      name?: string;
    };

    type FixedForm = Api.Common.ApiData & {
      id: number;
      form_name?: string;
      form_key?: string;
      form_route?: string;
      condition_fields_json?: string;
      status?: number;
      create_time?: string;
    };

    type FixedFormPayload = Api.Common.ApiData;

    type Approver = Api.Common.ApiData & {
      id: number | string;
      realname?: string;
      nickname?: string;
      username?: string;
      avatar?: string;
    };

    type Instance = Api.Common.ApiData & {
      id: number | string;
      template_id?: number | string;
      template_name?: string;
      instance_name?: string;
      instance_no?: string;
      instance_status?: number;
      start_time?: string;
      start_user?: number | string;
      start_user_id?: number | string;
      start_user_name?: string;
      is_current_user_pending?: number;
      create_time?: string;
    };

    type InstanceDetail = Instance & {
      form_data?: Api.Common.ApiData;
      process_json?: Api.Common.ApiData;
      trace?: TaskTraceNode[];
    };

    type InstanceStartMeta = Api.Common.ApiData;

    type InstanceResubmitMeta = Api.Common.ApiData;

    type InstanceStartPayload = Api.Common.ApiData;

    type InstanceResubmitPayload = Api.Common.ApiData;

    type InstanceSignerPayload = Api.Common.ApiData;

    type InstanceCopyPayload = Api.Common.ApiData;

    type Task = Api.Common.ApiData & {
      id: number | string;
      instance_id?: number | string;
      template_id?: number | string;
      template_name?: string;
      instance_name?: string;
      instance_no?: string;
      node_name?: string;
      task_status?: number;
      approve_time?: string;
      start_time?: string;
      start_user_name?: string;
      is_read?: number;
      create_time?: string;
    };

    type PendingTemplateCount = Api.Common.ApiData & {
      template_id?: number | string;
      count?: number;
    };

    type TaskApprovePayload = Api.Common.ApiData;

    type TaskAddSignPayload = Api.Common.ApiData;

    type TaskTransferPayload = Api.Common.ApiData;

    type TaskTraceNode = Api.Common.ApiData;

    type Delegate = Api.Common.ApiData & {
      id: number | string;
      template_id?: number | string;
      trustee_user_id?: number | string;
      start_time?: string;
      end_time?: string;
      status?: number;
      create_time?: string;
    };

    type DelegatePayload = Api.Common.ApiData;

    type UserOption = Api.Common.ApiData & {
      id: number | string;
      realname?: string;
      nickname?: string;
      username?: string;
    };

    type Message = Api.Common.ApiData & {
      id: number | string;
      message_type?: string;
      title?: string;
      content?: string;
      is_read?: number;
      create_time?: string;
    };

    type MessageGrouped = Api.Common.ApiData;

    type MessageUnreadCount = Api.Common.ApiData;
  }
}

