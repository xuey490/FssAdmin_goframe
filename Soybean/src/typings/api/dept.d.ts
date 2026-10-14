declare namespace Api {
  namespace Dept {
    type Dept = Api.Common.CommonRecord<{
      parent_id: number;
      parent_name?: string;
      name: string;
      code: string;
      leader_id?: number | null;
      leader_name?: string;
      phone?: string;
      email?: string;
      sort: number;
      remark?: string;
      children?: Dept[];
    }>;

    type DeptSearchParams = CommonType.RecordNullable<{
      name?: string;
      code?: string;
      status?: Api.Common.EnableStatus;
    }>;
  }
}
