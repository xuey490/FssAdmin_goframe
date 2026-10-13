package middleware

import "testing"

func TestCSRFAllowsSafeBearerAndPublic(t *testing.T) {
	if !csrfAllowed("GET", "", "", "", false) {
		t.Fatal("get")
	}
	if !csrfAllowed("POST", "Bearer abc", "", "", false) {
		t.Fatal("bearer")
	}
	if !csrfAllowed("POST", "", "", "", true) {
		t.Fatal("public")
	}
	if csrfAllowed("POST", "", "", "cookie", false) {
		t.Fatal("missing header")
	}
	if csrfAllowed("POST", "Bearer ", "", "", false) {
		t.Fatal("empty bearer")
	}
	if !csrfAllowed("POST", "", "tok", "tok", false) {
		t.Fatal("match")
	}
	if !csrfExempt("/core/refresh") || !csrfExempt("/core/login") {
		t.Fatal("exempt")
	}
	if csrfExempt("/core/server/monitor") {
		t.Fatal("monitor")
	}
}
