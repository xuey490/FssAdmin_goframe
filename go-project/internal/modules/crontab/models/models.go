package models

type Crontab struct {
	Id     int    `json:"id"`
	Name   string `json:"name"`
	Target string `json:"target"`
}
