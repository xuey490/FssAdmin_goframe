package models

type LoginLog struct {
	Id       int    `json:"id"`
	Username string `json:"username"`
}

type OperLog struct {
	Id     int    `json:"id"`
	Router string `json:"router"`
}

type EmailLog struct {
	Id      int    `json:"id"`
	Subject string `json:"subject"`
}
