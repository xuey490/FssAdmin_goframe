declare namespace Api {
  namespace Safeguard {
    // ==================== Common ====================
    type CommonSearchParams = CommonType.RecordNullable<{
      page: number;
      limit: number;
    }>;

    // ==================== Attachment ====================
    type Attachment = Common.CommonRecord<{
      name: string;
      url: string;
      path: string;
      size: number;
      mime_type: string;
      extension: string;
      category_id: number | null;
      category_name?: string;
      storage_mode: string;
      creator?: string;
    }>;

    type AttachmentSearchParams = CommonType.RecordNullable<
      Pick<Attachment, 'name' | 'mime_type'> & { category_id?: number | null } & CommonSearchParams
    >;

    type AttachmentList = Common.PaginatingQueryRecord<Attachment>;

    type AttachmentCategory = {
      id: number;
      name: string;
      parent_id: number;
      children?: AttachmentCategory[];
      status: string;
      create_time: string;
      update_time: string;
    };

    // ==================== Database ====================
    type DatabaseTable = {
      name: string;
      engine: string;
      rows: number;
      data_length: number;
      index_length: number;
      data_free: number;
      auto_increment: number;
      create_time: string;
      update_time: string;
      collation: string;
      comment: string;
    };

    type DatabaseTableSearchParams = CommonType.RecordNullable<
      { name?: string; engine?: string } & CommonSearchParams
    >;

    type DatabaseTableList = Common.PaginatingQueryRecord<DatabaseTable>;

    type DatabaseColumn = {
      field: string;
      type: string;
      collation: string | null;
      null: string;
      key: string;
      default: string | null;
      extra: string;
      comment: string;
    };

    type DatabaseRecycleItem = {
      id: number;
      table_name: string;
      data: Record<string, any>;
      deleted_at: string;
    };

    type DatabaseRecycleList = Common.PaginatingQueryRecord<DatabaseRecycleItem>;

    // ==================== Dict ====================
    type DictType = Common.CommonRecord<{
      name: string;
      code: string;
      remark: string;
    }>;

    type DictTypeSearchParams = CommonType.RecordNullable<
      Pick<DictType, 'name' | 'code' | 'status'> & CommonSearchParams
    >;

    type DictTypeList = Common.PaginatingQueryRecord<DictType>;

    type DictData = Common.CommonRecord<{
      dict_type_id: number;
      label: string;
      value: string;
      code: string;
      sort: number;
      remark: string;
      css_class?: string;
      list_class?: string;
      is_default?: number;
    }>;

    type DictDataSearchParams = CommonType.RecordNullable<
      Pick<DictData, 'label' | 'value' | 'status'> & { dict_type_id?: number } & CommonSearchParams
    >;

    type DictDataList = Common.PaginatingQueryRecord<DictData>;

    // ==================== Logs ====================
    type LoginLog = {
      id: number;
      username: string;
      ip: string;
      location: string;
      browser: string;
      os: string;
      status: number;
      message: string;
      login_time: string;
    };

    type LoginLogSearchParams = CommonType.RecordNullable<
      { username?: string; ip?: string; status?: number } & CommonSearchParams
    >;

    type LoginLogList = Common.PaginatingQueryRecord<LoginLog>;

    type OperLog = {
      id: number;
      username: string;
      method: string;
      route: string;
      ip: string;
      location: string;
      browser: string;
      os: string;
      request_data: string;
      response_code: string;
      duration: number;
      created_at: string;
    };

    type OperLogSearchParams = CommonType.RecordNullable<
      { username?: string; method?: string; route?: string } & CommonSearchParams
    >;

    type OperLogList = Common.PaginatingQueryRecord<OperLog>;

    type EmailLog = {
      id: number;
      subject: string;
      from: string;
      to: string;
      content: string;
      status: number;
      error: string;
      sent_time: string;
    };

    type EmailLogSearchParams = CommonType.RecordNullable<
      { subject?: string; from?: string; to?: string } & CommonSearchParams
    >;

    type EmailLogList = Common.PaginatingQueryRecord<EmailLog>;

    // ==================== Server ====================
    type ServerUsage = {
      percent: number;
      text: string;
      detail: string;
      cores?: number;
      model?: string;
    };

    type ServerPartition = {
      device: string;
      mountpoint: string;
      fstype: string;
      total: string;
      used: string;
      free: string;
      usedPercent: string;
    };

    type ServerInfo = {
      cpu: ServerUsage;
      memory: ServerUsage;
      disk: ServerUsage;
      goroutines: number;
      processes: number;
      partitions: ServerPartition[];
      system: {
        hostname: string;
        os: string;
        arch: string;
        cpuModel: string;
        uptime: string;
        appUptime: string;
        processes: number;
      };
      runtime: {
        version: string;
        goroutines: number;
        heapAlloc: string;
        heapSys: string;
        stackInUse: string;
        numGC: number;
        lastGC: string;
      };
    };

    // ==================== Cache ====================
    type CacheInfo = {
      name: string;
      key_count: number;
      hit_rate: string;
      miss_rate: string;
      used_memory: string;
      peak_memory: string;
    };

    // ==================== Redis ====================
    type RedisInfo = {
      version: string;
      mode: string;
      os: string;
      uptime: string;
      clients: string;
      memory: {
        used: string;
        total: string;
        peak: string;
        fragmentation: string;
      };
      stats: {
        connections: string;
        commands: string;
        hits: string;
        misses: string;
        hit_rate: string;
        keys: string;
        expires: string;
      };
      cpu: {
        used: string;
      };
      keyspace: Array<{
        db: string;
        keys: string;
        expires: string;
        avg_ttl: string;
      }>;
    };

    type RedisKeyItem = {
      key: string;
      type: string;
      ttl: number;
      size: number;
    };

    type RedisKeySearchParams = CommonType.RecordNullable<{
      pattern?: string;
    } & CommonSearchParams>;
  }
}
