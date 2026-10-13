package authkit

import "testing"

func TestBcryptYPrefix(t *testing.T) {
	hash, err := Hash("admin123")
	if err != nil {
		t.Fatal(err)
	}
	if !Check("admin123", hash) {
		t.Fatal("self hash failed")
	}
	y := "$2y$" + hash[4:]
	if !Check("admin123", y) {
		t.Fatal("$2y$ compat failed")
	}
	if Check("wrong", y) {
		t.Fatal("wrong password accepted")
	}
}
