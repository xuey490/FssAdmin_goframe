declare namespace Api {
  namespace Post {
    type Post = Api.Common.CommonRecord<{
      code: string;
      name: string;
      sort?: number;
      remark?: string;
    }>;

    type PostSearchParams = CommonType.RecordNullable<
      Pick<Common.PaginatingCommonParams, 'page' | 'limit'> & {
        code?: string;
        name?: string;
        status?: Api.Common.EnableStatus;
      }
    >;

    type PostList = Common.PaginatingQueryRecord<Post>;
  }
}
