package models

type Plugin struct {
	Name        string `json:"name"`
	Title       string `json:"title"`
	Version     string `json:"version"`
	Author      string `json:"author"`
	Installed   bool   `json:"installed"`
	Enabled     bool   `json:"enabled"`
	StatusText  string `json:"status_text"`
	Description string `json:"description"`
}
