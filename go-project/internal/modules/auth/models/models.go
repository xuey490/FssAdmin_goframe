package models

type User struct {
	Id       int    `json:"id"`
	Username string `json:"username"`
	Password string `json:"password"`
	Realname string `json:"realname"`
	IsSuper  int    `json:"is_super"`
	Status   int    `json:"status"`
	DeptId   int    `json:"dept_id"`
}
