package service

import (
	"context"
	"time"

	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

func pingDB() error {
	_, err := g.DB().Raw("SELECT 1").One()
	return err
}

func pingRedis() error {
	_, err := g.Redis().Do(context.Background(), "PING")
	return err
}

func Health(r *ghttp.Request) (interface{}, error) {
	return g.Map{"status": "ok", "time": time.Now().Format("2006-01-02 15:04:05")}, nil
}

func Live(r *ghttp.Request) (interface{}, error) {
	return g.Map{"status": "alive"}, nil
}

func Ready(r *ghttp.Request) (interface{}, error) {
	dbOK, redisOK := pingDB() == nil, pingRedis() == nil
	status := "ready"
	if !dbOK {
		status = "degraded"
	}
	return g.Map{
		"status": status,
		"mysql":  dbOK,
		"redis":  redisOK,
	}, nil
}
