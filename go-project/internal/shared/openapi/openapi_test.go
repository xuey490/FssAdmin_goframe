package openapi

import "testing"

func TestIncludeRouteKeepsAPIPrefixOnce(t *testing.T) {
	if !includeRoute("handler", "POST", "/api/core/login") {
		t.Fatal("api")
	}
	if includeRoute("handler", "POST", "/api/v1/core/login") || includeRoute("handler", "POST", "/core/login") {
		t.Fatal("dup")
	}
	if includeRoute("middleware", "POST", "/api/core/login") || includeRoute("handler", "ALL", "/api/x") {
		t.Fatal("skip")
	}
	if includeRoute("handler", "GET", "/api.json") || includeRoute("handler", "GET", "/docs") {
		t.Fatal("docs")
	}
	if tagOf("/api/core/login") != "core" {
		t.Fatal(tagOf("/api/core/login"))
	}
}
