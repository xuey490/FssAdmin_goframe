package models

type Video struct {
	Id     int    `json:"id"`
	URL    string `json:"url"`
	Title  string `json:"title"`
	Status int    `json:"status"`
}
