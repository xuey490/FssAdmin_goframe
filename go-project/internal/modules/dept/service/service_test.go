package service

import "testing"

func TestPickLeaderID(t *testing.T) {
	if pickLeaderID(map[string]interface{}{"id": 100, "realname": "张三"}) != 100 {
		t.Fatal("object")
	}
	if pickLeaderID(10) != 10 {
		t.Fatal("int")
	}
	if pickLeaderID(0) != nil || pickLeaderID(nil) != nil {
		t.Fatal("empty")
	}
}
