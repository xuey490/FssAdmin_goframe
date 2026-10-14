declare namespace Api {
  namespace Article {
    type Article = {
      id: number;
      title: string;
      category_id: number;
      author: string;
      image: string;
      describe: string;
      content: string;
      is_link: number;
      link_url: string;
      is_hot: number;
      sort: number;
      status: number;
      views: number;
      create_time: string;
      update_time?: string;
    };

    type ArticleSearchParams = CommonType.RecordNullable<{
      title?: string;
      author?: string;
      status?: number;
      category_id?: number;
      is_hot?: number;
      page?: number;
      limit?: number;
      page_size?: number;
    }>;

    type ArticleList = Common.PaginatingQueryRecord<Article>;

    type ArticleForm = Partial<
      Pick<
        Article,
        | 'id'
        | 'title'
        | 'category_id'
        | 'author'
        | 'image'
        | 'describe'
        | 'content'
        | 'is_link'
        | 'link_url'
        | 'is_hot'
        | 'sort'
        | 'status'
      >
    >;
  }
}
