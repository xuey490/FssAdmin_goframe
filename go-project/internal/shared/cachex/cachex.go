package cachex

import (
	"context"
	"encoding/json"
	"fmt"
	"sync"
	"time"

	"fssadmin/go-project/internal/shared/conf"
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gcache"
)

const (
	dictKey   = "dict:all"
	configKey = "config:all"

	// 用户级缓存 key 模板（参考 PHP user_menu_tree / user:permissions）
	menuTreeKey      = "menu_tree:%d:%d"       // user_id, tenant_id
	menuIDsKey       = "menu_ids:%d:%d"         // user_id, tenant_id
	permsKey         = "perms:%d:%d"            // user_id, tenant_id
	menuTreeVersionKey = "menu_tree_version"    // 版本号，变更时递增使旧 key 自然失效
	deptTreeKey      = "dept_tree:%d"           // tenant_id
)

const (
	menuTreeTTL    = 600  // 10 分钟，参考 PHP user_menu_tree 的 600s
	menuIDsTTL     = 600
	permsTTL       = 600
	deptTreeTTL    = 600
	versionTTL     = 86400 // 版本号 24h，参考 PHP
)

var (
	once sync.Once
	c    *gcache.Cache
)

// Cache is the process cache. Redis adapter when redis is up; TTL is per Set, not on the connection.
func Cache() *gcache.Cache {
	once.Do(func() {
		c = gcache.New()
		if g.Redis() != nil {
			c.SetAdapter(gcache.NewAdapterRedis(g.Redis()))
		}
	})
	return c
}

func ttl() time.Duration {
	sec := conf.CacheExpire()
	if sec <= 0 {
		return 0
	}
	return time.Duration(sec) * time.Second
}

func key(name string) string { return conf.CachePrefix() + ":" + name }

func Warm(ctx context.Context) {
	if err := RefreshDict(ctx); err != nil {
		g.Log().Warningf(ctx, "cache dict: %v", err)
	}
	if err := RefreshConfig(ctx); err != nil {
		g.Log().Warningf(ctx, "cache config: %v", err)
	}
}

func DictAll(ctx context.Context) (interface{}, error) {
	if raw, ok := getRaw(ctx, dictKey); ok {
		var out g.Map
		if json.Unmarshal([]byte(raw), &out) == nil {
			return out, nil
		}
	}
	data, err := loadDict(ctx)
	if err != nil {
		return nil, err
	}
	_ = setJSON(ctx, dictKey, data)
	return data, nil
}

func RefreshDict(ctx context.Context) error {
	data, err := loadDict(ctx)
	if err != nil {
		return err
	}
	return setJSON(ctx, dictKey, data)
}

func ConfigValue(ctx context.Context, k string) (string, bool) {
	data, ok := configMap(ctx)
	if !ok {
		loaded, err := loadConfig(ctx)
		if err != nil {
			return "", false
		}
		_ = setJSON(ctx, configKey, loaded)
		data = loaded
	}
	s, found := data[k]
	return s, found
}

func RefreshConfig(ctx context.Context) error {
	data, err := loadConfig(ctx)
	if err != nil {
		return err
	}
	return setJSON(ctx, configKey, data)
}

func setJSON(ctx context.Context, name string, val interface{}) error {
	b, err := json.Marshal(val)
	if err != nil {
		return err
	}
	return Cache().Set(ctx, key(name), string(b), ttl())
}

func getRaw(ctx context.Context, name string) (string, bool) {
	v, err := Cache().Get(ctx, key(name))
	if err != nil || v == nil || v.IsNil() || v.IsEmpty() {
		return "", false
	}
	return v.String(), true
}

func configMap(ctx context.Context) (map[string]string, bool) {
	raw, ok := getRaw(ctx, configKey)
	if !ok {
		return nil, false
	}
	var out map[string]string
	if json.Unmarshal([]byte(raw), &out) != nil || out == nil {
		return nil, false
	}
	return out, true
}

func Clear(ctx context.Context) int {
	pat := conf.CachePrefix() + ":*"
	v, err := g.Redis().Do(ctx, "KEYS", pat)
	if err != nil || v == nil {
		return 0
	}
	keys := v.Strings()
	if len(keys) == 0 {
		return 0
	}
	args := make([]interface{}, len(keys))
	for i, k := range keys {
		args[i] = k
	}
	_, _ = g.Redis().Do(ctx, "DEL", args...)
	return len(keys)
}

func loadDict(ctx context.Context) (g.Map, error) {
	types, err := dbx.Alive(dbx.Model("sa_system_dict_type")).Ctx(ctx).Where("status", 1).All()
	if err != nil {
		return nil, err
	}
	out := g.Map{}
	for _, t := range types {
		code := t["code"].String()
		if code == "" {
			continue
		}
		items, _ := dbx.Alive(dbx.Model("sa_system_dict_data")).Ctx(ctx).Where("code", code).Where("status", 1).Order("sort asc, id asc").All()
		arr := make([]g.Map, 0, len(items))
		for _, it := range items {
			arr = append(arr, g.Map{
				"id": it["id"].Int(), "label": it["label"].String(),
				"value": it["value"].String(), "color": it["color"].String(),
			})
		}
		out[code] = arr
	}
	return out, nil
}

func loadConfig(ctx context.Context) (map[string]string, error) {
	rows, err := dbx.Alive(dbx.Model("sa_system_config")).Ctx(ctx).All()
	if err != nil {
		return nil, err
	}
	out := map[string]string{}
	for _, row := range rows {
		k := row["key"].String()
		if k == "" {
			continue
		}
		out[k] = row["value"].String()
	}
	return out, nil
}

// --- 菜单树缓存（移植自 PHP user_menu_tree） ---

// MenuTreeVersion 获取菜单树版本号；版本号变更后旧 key 自然失效（参考 PHP clearAllMenuTreeCache）。
func MenuTreeVersion(ctx context.Context) int {
	v, err := Cache().Get(ctx, key(menuTreeVersionKey))
	if err != nil || v == nil || v.IsNil() {
		return 0
	}
	n := v.Int()
	if n < 0 {
		return 0
	}
	return n
}

// bumpMenuTreeVersion 递增版本号，写操作后调用使所有用户旧 key 失效。
func bumpMenuTreeVersion(ctx context.Context) {
	cur := MenuTreeVersion(ctx)
	_ = Cache().Set(ctx, key(menuTreeVersionKey), cur+1, time.Duration(versionTTL)*time.Second)
}

// userCacheKey 拼带版本号的用户级缓存 key，版本号变更后旧 key 自动失效。
func userCacheKey(ctx context.Context, pattern string, userID, tenantID int) string {
	v := MenuTreeVersion(ctx)
	return fmt.Sprintf(pattern, userID, tenantID) + fmt.Sprintf(":v%d", v)
}

// SetMenuTree 缓存用户菜单树。
func SetMenuTree(ctx context.Context, userID, tenantID int, data []map[string]interface{}) {
	b, err := json.Marshal(data)
	if err != nil {
		return
	}
	_ = Cache().Set(ctx, key(userCacheKey(ctx, menuTreeKey, userID, tenantID)), string(b), time.Duration(menuTreeTTL)*time.Second)
}

// GetMenuTree 读取用户菜单树缓存，miss 返回 nil, false。
func GetMenuTree(ctx context.Context, userID, tenantID int) ([]map[string]interface{}, bool) {
	raw, ok := getRaw(ctx, userCacheKey(ctx, menuTreeKey, userID, tenantID))
	if !ok {
		return nil, false
	}
	var out []map[string]interface{}
	if json.Unmarshal([]byte(raw), &out) != nil || out == nil {
		return nil, false
	}
	return out, true
}

// SetMenuIDs 缓存用户合并后的菜单 ID 集合。
func SetMenuIDs(ctx context.Context, userID, tenantID int, ids []int) {
	b, err := json.Marshal(ids)
	if err != nil {
		return
	}
	_ = Cache().Set(ctx, key(userCacheKey(ctx, menuIDsKey, userID, tenantID)), string(b), time.Duration(menuIDsTTL)*time.Second)
}

// GetMenuIDs 读取用户菜单 ID 集合缓存。
func GetMenuIDs(ctx context.Context, userID, tenantID int) ([]int, bool) {
	raw, ok := getRaw(ctx, userCacheKey(ctx, menuIDsKey, userID, tenantID))
	if !ok {
		return nil, false
	}
	var ids []int
	if json.Unmarshal([]byte(raw), &ids) != nil || ids == nil {
		return nil, false
	}
	return ids, true
}

// SetPerms 缓存用户权限列表。
func SetPerms(ctx context.Context, userID, tenantID int, perms []string) {
	b, err := json.Marshal(perms)
	if err != nil {
		return
	}
	_ = Cache().Set(ctx, key(userCacheKey(ctx, permsKey, userID, tenantID)), string(b), time.Duration(permsTTL)*time.Second)
}

// GetPerms 读取用户权限列表缓存。
func GetPerms(ctx context.Context, userID, tenantID int) ([]string, bool) {
	raw, ok := getRaw(ctx, userCacheKey(ctx, permsKey, userID, tenantID))
	if !ok {
		return nil, false
	}
	var perms []string
	if json.Unmarshal([]byte(raw), &perms) != nil || perms == nil {
		return nil, false
	}
	return perms, true
}

// InvalidateUserMenuTree 删除指定用户的菜单树/菜单ID/权限缓存（参考 PHP clearMenuTreeCache）。
func InvalidateUserMenuTree(ctx context.Context, userID, tenantID int) {
	for _, pat := range []string{menuTreeKey, menuIDsKey, permsKey} {
		_, _ = Cache().Remove(ctx, key(userCacheKey(ctx, pat, userID, tenantID)))
	}
}

// InvalidateAllMenuTree 全局失效所有用户菜单树缓存（参考 PHP clearAllMenuTreeCache）。
// 通过递增版本号，使所有旧版本的 userCacheKey 自然失效。
func InvalidateAllMenuTree(ctx context.Context) {
	bumpMenuTreeVersion(ctx)
}

// --- 部门树缓存 ---

// SetDeptTree 缓存租户部门树。
func SetDeptTree(ctx context.Context, tenantID int, data []map[string]interface{}) {
	b, err := json.Marshal(data)
	if err != nil {
		return
	}
	_ = Cache().Set(ctx, key(fmt.Sprintf(deptTreeKey, tenantID)), string(b), time.Duration(deptTreeTTL)*time.Second)
}

// GetDeptTree 读取租户部门树缓存。
func GetDeptTree(ctx context.Context, tenantID int) ([]map[string]interface{}, bool) {
	raw, ok := getRaw(ctx, fmt.Sprintf(deptTreeKey, tenantID))
	if !ok {
		return nil, false
	}
	var out []map[string]interface{}
	if json.Unmarshal([]byte(raw), &out) != nil || out == nil {
		return nil, false
	}
	return out, true
}

// InvalidateDeptTree 失效租户部门树缓存。
func InvalidateDeptTree(ctx context.Context, tenantID int) {
	_, _ = Cache().Remove(ctx, key(fmt.Sprintf(deptTreeKey, tenantID)))
}
