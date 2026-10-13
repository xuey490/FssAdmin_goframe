package models

type Tenant struct {
	Id         int    `json:"id"`
	TenantName string `json:"tenant_name"`
	TenantCode string `json:"tenant_code"`
}
