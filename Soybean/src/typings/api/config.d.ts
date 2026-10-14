declare namespace Api {
  namespace Config {
    type ConfigGroup = Api.Common.CommonRecord<{
      name: string;
      code: string;
      sort?: number;
      remark?: string;
    }>;

    type ConfigGroupSearchParams = CommonType.RecordNullable<
      Pick<Common.PaginatingCommonParams, 'page' | 'limit'> & {
        name?: string;
        code?: string;
      }
    >;

    type ConfigGroupList = Common.PaginatingQueryRecord<ConfigGroup>;

    type ConfigSelectOption = {
      label: string;
      value: string | number;
      disabled?: boolean;
    };

    type ConfigItem = Api.Common.CommonRecord<{
      group_id: number;
      key: string;
      value: any;
      name: string;
      input_type: string;
      config_select_data?: ConfigSelectOption[];
      sort?: number;
      remark?: string;
      status?: number;
    }>;

    type ConfigItemWithDisplay = ConfigItem & {
      display?: boolean;
    };

    type ConfigItemSearchParams = CommonType.RecordNullable<
      Pick<Common.PaginatingCommonParams, 'page' | 'limit'> & {
        group_id?: number;
        key?: string;
        name?: string;
        status?: string | number;
      }
    >;

    type ConfigItemList = Common.PaginatingQueryRecord<ConfigItem>;
  }
}
