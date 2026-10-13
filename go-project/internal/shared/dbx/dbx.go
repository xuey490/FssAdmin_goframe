package dbx

import (
	"strings"
	"time"

	"fssadmin/go-project/internal/shared/ctxuser"
	"fssadmin/go-project/internal/shared/snowflake"
	"fssadmin/go-project/internal/shared/tenant"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gtime"
	"github.com/gogf/gf/v2/util/gconv"
)

func DB() gdb.DB { return g.DB() }

func Model(table string) *gdb.Model {
	return DB().Model(table).Safe()
}

func Alive(m *gdb.Model) *gdb.Model {
	return m.WhereNull("delete_time")
}

// Tenant 对 model 追加租户隔离条件。
// 统一为严格模式：WHERE col = ?（对标 PHP WHERE tenant_id = ?）。
// 当 tenantID <= 0 时不追加条件（未登录或无租户上下文）。
// col 为空时默认 "tenant_id"。
func Tenant(m *gdb.Model, tenantID int, col string) *gdb.Model {
	if tenantID <= 0 {
		return m
	}
	if col == "" {
		col = "tenant_id"
	}
	return m.Where(col+"=?", tenantID)
}

// ScopedModel 返回带软删除 + 租户隔离的 model。
// 从请求上下文自动提取当前登录用户的 tenantID。
// 所有用户（含超管）都按 tenant_id 隔离，除非显式调用 tenant.WithIgnore。
// 适用于任何带 tenant_id 字段的业务表。
func ScopedModel(r *ghttp.Request, table string) *gdb.Model {
	m := Alive(Model(table))
	// 检查 TenantContext 是否设置了 Ignore（仅 WithIgnore 闭包内才会为 true）
	if tenant.IsIgnoreRequest(r) {
		return m
	}
	u := ctxuser.Get(r)
	if u != nil && u.TenantID > 0 {
		m = Tenant(m, u.TenantID, "tenant_id")
	}
	return m
}

// ScopedModelBy 构建一个受限 model（带租户+软删），再附带 Where 条件。
// 用于关联表等没有 tenant_id 的场景：先限定主表的租户范围，再操作关联数据。
func ScopedModelBy(r *ghttp.Request, table string, where ...interface{}) *gdb.Model {
	m := ScopedModel(r, table)
	if len(where) > 0 {
		m = m.Where(where[0], where[1:]...)
	}
	return m
}

// AssertTenantOwned 校验某个主表记录是否属于当前租户。
// 返回该记录是否存在（归属当前租户）。
// 所有用户（含超管）都校验，除非显式 WithIgnore。
func AssertTenantOwned(r *ghttp.Request, table string, id int) bool {
	// 检查 TenantContext 是否设置了 Ignore（仅 WithIgnore 闭包内才会为 true）
	if tenant.IsIgnoreRequest(r) {
		return true
	}
	u := ctxuser.Get(r)
	if u == nil {
		return false
	}
	m := Alive(Model(table)).Where("id", id)
	if u.TenantID > 0 {
		m = Tenant(m, u.TenantID, "tenant_id")
	}
	rec, _ := m.One()
	return !rec.IsEmpty()
}

func Now() *gtime.Time { return gtime.Now() }

// SoftDelete 软删除单条记录（设置 delete_time）。
// 注意：此函数不带租户校验，仅用于已通过租户验证的场景。
// 如需租户校验，请使用 SoftDeleteScoped 或在调用前使用 AssertTenantOwned。
func SoftDelete(table string, id int, extra ...interface{}) error {
	data := g.Map{"delete_time": Now()}
	m := Alive(Model(table)).Where("id", id)
	if len(extra) > 0 {
		m = m.Where(extra[0], extra[1:]...)
	}
	_, err := m.Data(data).Update()
	return err
}

// SoftDeleteScoped 带租户校验的软删除单条记录。
// 当 tenantID > 0 时追加 WHERE tenant_id = ? 条件，防止跨租户删除。
// 超管模式下 tenantID <= 0 时不追加条件。
func SoftDeleteScoped(table string, id int, tenantID int, extra ...interface{}) error {
	data := g.Map{"delete_time": Now()}
	m := Alive(Model(table)).Where("id", id)
	if tenantID > 0 {
		m = m.Where("tenant_id", tenantID)
	}
	if len(extra) > 0 {
		m = m.Where(extra[0], extra[1:]...)
	}
	_, err := m.Data(data).Update()
	return err
}

// SoftDeleteScopedRequest 与 SoftDeleteScoped 相同，但从请求上下文自动提取租户ID。
// 所有用户（含超管）都追加租户条件，除非显式 WithIgnore。
func SoftDeleteScopedRequest(r *ghttp.Request, table string, id int, extra ...interface{}) error {
	tid := tenant.TenantIDFromRequest(r)
	if tenant.IsIgnoreRequest(r) {
		tid = 0 // 仅 WithIgnore 闭包内才跳过
	}
	return SoftDeleteScoped(table, id, tid, extra...)
}

// SoftDeleteIDs 批量软删除（设置 delete_time）。
// 注意：此函数不带租户校验，仅用于已通过租户验证的场景。
// 如需租户校验，请使用 SoftDeleteIDsScoped。
func SoftDeleteIDs(table string, ids []int) error {
	if len(ids) == 0 {
		return nil
	}
	_, err := Alive(Model(table)).WhereIn("id", ids).Data(g.Map{"delete_time": Now()}).Update()
	return err
}

// SoftDeleteIDsScoped 带租户校验的批量软删除。
// 当 tenantID > 0 时追加 WHERE tenant_id = ? 条件，防止跨租户删除。
func SoftDeleteIDsScoped(table string, ids []int, tenantID int) error {
	if len(ids) == 0 {
		return nil
	}
	m := Alive(Model(table)).WhereIn("id", ids)
	if tenantID > 0 {
		m = m.Where("tenant_id", tenantID)
	}
	_, err := m.Data(g.Map{"delete_time": Now()}).Update()
	return err
}

// SoftDeleteIDsScopedRequest 与 SoftDeleteIDsScoped 相同，但从请求上下文自动提取租户ID。
// 所有用户（含超管）都追加租户条件，除非显式 WithIgnore。
func SoftDeleteIDsScopedRequest(r *ghttp.Request, table string, ids []int) error {
	tid := tenant.TenantIDFromRequest(r)
	if tenant.IsIgnoreRequest(r) {
		tid = 0
	}
	return SoftDeleteIDsScoped(table, ids, tid)
}

func ToMap(rec gdb.Record) map[string]interface{} {
	if rec == nil {
		return nil
	}
	out := map[string]interface{}{}
	for k, v := range rec.Map() {
		out[k] = normalize(v)
	}
	return out
}

func ToMaps(list gdb.Result) []map[string]interface{} {
	out := make([]map[string]interface{}, 0, len(list))
	for _, rec := range list {
		out = append(out, ToMap(rec))
	}
	return out
}

func normalize(v interface{}) interface{} {
	switch t := v.(type) {
	case []byte:
		return string(t)
	case time.Time:
		if t.IsZero() {
			return nil
		}
		if t.Hour() == 0 && t.Minute() == 0 && t.Second() == 0 && t.Nanosecond() == 0 {
			return t.Format("2006-01-02 15:04:05")
		}
		return t.Format("2006-01-02 15:04:05")
	case *gtime.Time:
		if t == nil || t.IsZero() {
			return nil
		}
		return t.Layout("2006-01-02 15:04:05")
	case *time.Time:
		if t == nil || t.IsZero() {
			return nil
		}
		return t.Format("2006-01-02 15:04:05")
	default:
		return v
	}
}

func Pick(src map[string]interface{}, keys ...string) g.Map {
	out := g.Map{}
	for _, k := range keys {
		if v, ok := src[k]; ok {
			out[k] = v
		}
	}
	return out
}

func FilterLike(m *gdb.Model, col, val string) *gdb.Model {
	val = strings.TrimSpace(val)
	if val == "" {
		return m
	}
	return m.WhereLike(col, "%"+val+"%")
}

func IntIDs(v interface{}) []int {
	return gconv.Ints(v)
}

// InsertWithID 插入记录并返回主键 ID。
// 对标 PHP BaseLaORMModel 中 creating 事件的主键生成逻辑。
//
// pkType 取值:
//   - "auto"（默认）: 使用数据库自增主键，InsertAndGetId 返回自增 ID
//   - "snowflake": 使用雪花 ID 作为主键，自动填充 id 字段后插入并返回雪花 ID
//
// 当 pkType 为 "snowflake" 时，如果 data 中已包含 "id" 字段则不覆盖。
func InsertWithID(table string, data g.Map, pkType string) (int64, error) {
	if pkType == "snowflake" {
		if _, ok := data["id"]; !ok {
			data["id"] = snowflake.Next()
		}
		_, err := Model(table).Data(data).Insert()
		if err != nil {
			return 0, err
		}
		return gconv.Int64(data["id"]), nil
	}
	// 默认自增
	return Model(table).Data(data).InsertAndGetId()
}
