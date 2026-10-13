package models

type User struct {
	Id       int    `json:"id"`
	Username string `json:"username"`
	Realname string `json:"realname"`
	Status   int    `json:"status"`
}
