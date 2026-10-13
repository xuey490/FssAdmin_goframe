package models

// OnlineRow 在线用户行，字段与前端 safeguard/online 表格列一一对应（camelCase）。
// 同时保留 user_id / tenant_id 供补全部门名使用（json:"-" 不下发）。
type OnlineRow struct {
	TokenID       string `json:"tokenId"`
	UserName      string `json:"userName"`
	DeptName      string `json:"deptName"`
	IPAddr        string `json:"ipaddr"`
	LoginLocation string `json:"loginLocation"`
	OS            string `json:"os"`
	Browser       string `json:"browser"`
	LoginTime     string `json:"loginTime"`

	UserID   int `json:"-"`
	TenantID int `json:"-"`
}
