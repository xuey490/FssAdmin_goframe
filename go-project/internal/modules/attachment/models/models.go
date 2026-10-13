package models

type Attachment struct {
	Id         int    `json:"id"`
	OriginName string `json:"origin_name"`
	Url        string `json:"url"`
}
