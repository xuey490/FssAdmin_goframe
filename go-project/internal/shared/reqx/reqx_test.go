package reqx

import "testing"

func TestIntsCSV(t *testing.T) {
	got := Ints(map[string]interface{}{"ids": "1,2,3"}, "ids")
	if len(got) != 3 || got[1] != 2 {
		t.Fatalf("%v", got)
	}
}

// 前端 request.del({ data: [1,2] }) 发送数组体，必须能解析出 id，
// 否则批量删除会静默无操作（只返回成功）。
func TestDecodeBodyArray(t *testing.T) {
	body, ok := decodeBody("[6,7]")
	if !ok {
		t.Fatal("数组体应被识别为 JSON")
	}
	got := Ints(body, "ids")
	if len(got) != 2 || got[0] != 6 || got[1] != 7 {
		t.Fatalf("数组体解析异常: %#v", got)
	}
}

func TestDecodeBodyObject(t *testing.T) {
	body, ok := decodeBody(`{"ids":[4,5],"name":"x"}`)
	if !ok {
		t.Fatal("对象体应被识别为 JSON")
	}
	if body["name"] != "x" {
		t.Fatalf("字段未展开: %#v", body)
	}
	got := Ints(body, "ids")
	if len(got) != 2 || got[0] != 4 {
		t.Fatalf("对象体解析异常: %#v", got)
	}
}

func TestIntsJSONNumbers(t *testing.T) {
	body, ok := decodeBody(`{"role_ids":[2,3],"post_ids":[1]}`)
	if !ok {
		t.Fatal("json")
	}
	if got := Ints(body, "role_ids"); len(got) != 2 || got[0] != 2 || got[1] != 3 {
		t.Fatalf("role_ids %#v", got)
	}
	if got := Ints(body, "post_ids"); len(got) != 1 || got[0] != 1 {
		t.Fatalf("post_ids %#v", got)
	}
}

func TestDecodeBodyFallback(t *testing.T) {
	for _, raw := range []string{"", "name=x&age=1", "[not-json", "{oops"} {
		if _, ok := decodeBody(raw); ok {
			t.Fatalf("非 JSON 请求体应回退表单解析: %q", raw)
		}
	}
}
