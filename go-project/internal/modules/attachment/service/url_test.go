package service

import "testing"

func TestJoinPublicURL(t *testing.T) {
	got := joinPublicURL("https://img.example.com", "/profile/static/upload", "2026/10/13", "a.jpg")
	want := "https://img.example.com/profile/static/upload/2026/10/13/a.jpg"
	if got != want {
		t.Fatalf("got %q want %q", got, want)
	}
	got = joinPublicURL("", "profile/static/upload", "2026/10/13", "a.jpg")
	want = "/profile/static/upload/2026/10/13/a.jpg"
	if got != want {
		t.Fatalf("relative got %q want %q", got, want)
	}
}

func TestRewritePublicURL(t *testing.T) {
	prefix := "/profile/static/upload"
	domain := "https://site.example"
	cases := map[string]string{
		"/uploads/2026/10/13/a.jpg":                            domain + prefix + "/2026/10/13/a.jpg",
		"/static/upload/2026/10/13/a.jpg":                      domain + prefix + "/2026/10/13/a.jpg",
		"http://localhost:8181/profile/2026/10/13/a.jpg":       domain + prefix + "/2026/10/13/a.jpg",
		"http://localhost:8181/uploads/2026/10/13/a.jpg":       domain + prefix + "/2026/10/13/a.jpg",
		prefix + "/2026/10/13/a.jpg":                           domain + prefix + "/2026/10/13/a.jpg",
		"https://old.example/static/upload/2026/10/13/b.png":   domain + prefix + "/2026/10/13/b.png",
	}
	for raw, want := range cases {
		if got := rewritePublicURL(raw, domain, prefix); got != want {
			t.Fatalf("rewrite %q = %q, want %q", raw, got, want)
		}
	}
}

func TestDayAndName(t *testing.T) {
	day, name := dayAndName("uploads/2026/10/13/x.jpg")
	if day != "2026/10/13" || name != "x.jpg" {
		t.Fatalf("day=%q name=%q", day, name)
	}
}
