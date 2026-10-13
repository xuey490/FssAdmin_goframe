package service

import (
	"encoding/json"
	"time"

	"fssadmin/go-project/internal/authkit"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

type envelope struct {
	Event     string      `json:"event"`
	RequestID string      `json:"request_id,omitempty"`
	Data      interface{} `json:"data"`
}

func Handle(r *ghttp.Request) {
	ws, err := r.WebSocket()
	if err != nil {
		r.Response.WriteStatus(400)
		return
	}
	authed := false
	_ = ws.SetReadDeadline(time.Now().Add(20 * time.Second))
	for {
		_, msg, err := ws.ReadMessage()
		if err != nil {
			return
		}
		var env envelope
		if json.Unmarshal(msg, &env) != nil {
			continue
		}
		switch env.Event {
		case "auth":
			token := extractToken(env.Data)
			if _, err := authkit.ParseAccess(token); err != nil {
				_ = writeWS(ws, "auth.error", g.Map{"message": "unauthorized"})
				return
			}
			authed = true
			_ = ws.SetReadDeadline(time.Time{})
			_ = writeWS(ws, "auth.ok", g.Map{"ok": true})
		case "ping":
			_ = writeWS(ws, "pong", g.Map{"t": time.Now().Unix()})
		case "chat.send":
			if !authed {
				_ = writeWS(ws, "auth.error", g.Map{"message": "unauthorized"})
				continue
			}
			_ = writeWS(ws, "chat.message_start", g.Map{"request_id": env.RequestID})
			_ = writeWS(ws, "chat.token", g.Map{"delta": "Go 后端已连接。当前为最小完整实现，未接入外部大模型。"})
			_ = writeWS(ws, "chat.message_done", g.Map{"request_id": env.RequestID})
		case "chat.stop":
			_ = writeWS(ws, "chat.message_done", g.Map{"stopped": true})
		}
	}
}

func extractToken(data interface{}) string {
	switch t := data.(type) {
	case map[string]interface{}:
		if s, ok := t["token"].(string); ok {
			return s
		}
	}
	raw, _ := json.Marshal(data)
	var d struct {
		Token string `json:"token"`
	}
	_ = json.Unmarshal(raw, &d)
	return d.Token
}

func writeWS(ws *ghttp.WebSocket, event string, data interface{}) error {
	b, _ := json.Marshal(envelope{Event: event, Data: data})
	return ws.WriteMessage(1, b)
}
