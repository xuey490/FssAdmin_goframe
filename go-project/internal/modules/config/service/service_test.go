package service

import "testing"

func TestDecodeSelectJSON(t *testing.T) {
	raw := "[\r\n    {\"label\":\"ssl\",\"value\":\"ssl\"},\r\n    {\"label\":\"tsl\",\"value\":\"tsl\"}\r\n]"
	got := decodeSelect(raw)
	if len(got) != 2 {
		t.Fatalf("%v", got)
	}
	m, _ := got[0].(map[string]interface{})
	if m["value"] != "ssl" {
		t.Fatalf("%v", m)
	}
}

func TestDecodeSelectEmpty(t *testing.T) {
	if len(decodeSelect("")) != 0 || len(decodeSelect(nil)) != 0 {
		t.Fatal("empty")
	}
}

func TestEncodeSelectRoundTrip(t *testing.T) {
	s := encodeSelect([]map[string]string{{"label": "关闭", "value": "0"}})
	got := decodeSelect(s)
	if len(got) != 1 {
		t.Fatalf("%s", s)
	}
}
