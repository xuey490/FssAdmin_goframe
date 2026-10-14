declare namespace Api {
  namespace Tenant {
    type Tenant = Api.Common.CommonRecord<{
      tenant_name: string;
      tenant_code: string;
      contact_name?: string | null;
      contact_phone?: string | null;
      contact_email?: string | null;
      address?: string | null;
      logo_url?: string | null;
      expire_time?: string | null;
      max_users?: number;
      max_depts?: number;
      max_roles?: number;
      remark?: string | null;
    }>;

    type TenantSearchParams = CommonType.RecordNullable<
      Pick<Common.PaginatingCommonParams, 'page' | 'limit'> & {
        tenant_name?: string;
        tenant_code?: string;
        status?: Api.Common.EnableStatus;
      }
    >;

    type TenantList = Common.PaginatingQueryRecord<Tenant>;
  }
}
