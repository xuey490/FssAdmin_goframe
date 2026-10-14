declare namespace Api {
  namespace Dashboard {
    interface StatisticsData {
      user?: number;
      attach?: number;
      login?: number;
      operate?: number;
    }

    interface LoginChartData {
      login_count?: number[];
      login_date?: string[];
    }

    interface LoginBarChartData {
      login_count?: number[];
      login_date?: string[];
    }

    type LogSearchParams = CommonType.RecordNullable<
      {
        username?: string;
        page?: number;
        limit?: number;
      } & CommonSearchParams
    >;

    type LogList = Common.PaginatingQueryRecord<Record<string, any>>;

    interface UpdateUserInfoParams {
      realname?: string;
      gender?: string | number;
      phone?: string;
      email?: string;
      remark?: string;
      avatar?: string;
      signed?: string;
    }

    interface ModifyPasswordParams {
      oldPassword: string;
      newPassword: string;
      rePassword: string;
    }
  }
}
