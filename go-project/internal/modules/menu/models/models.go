package models

type Menu struct {
	Id          int    `json:"id"`
	ParentId    int    `json:"parent_id"`
	Name        string `json:"name"`
	Code        string `json:"code"`
	Slug        string `json:"slug"`
	Type        int    `json:"type"`
	Path        string `json:"path"`
	Component   string `json:"component"`
	Icon        string `json:"icon"`
	Sort        int    `json:"sort"`
	LinkUrl     string `json:"link_url"`
	IsIframe    int    `json:"is_iframe"`
	IsKeepAlive int    `json:"is_keep_alive"`
	IsHidden    int    `json:"is_hidden"`
	IsFixedTab  int    `json:"is_fixed_tab"`
	Status      int    `json:"status"`
}
