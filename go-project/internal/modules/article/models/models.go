package models

type Article struct {
	Id         int    `json:"id"`
	Title      string `json:"title"`
	CategoryId int    `json:"category_id"`
}
