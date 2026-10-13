package cachex

import (
	"testing"
	"time"
)

func TestTTLZeroMeansNoExpire(t *testing.T) {
	if ttl() < 0 {
		t.Fatal(ttl())
	}
	d := time.Duration(3600) * time.Second
	if d != time.Hour {
		t.Fatal(d)
	}
}

func TestKeyPrefix(t *testing.T) {
	got := key(dictKey)
	if got == "" || got == dictKey {
		t.Fatal(got)
	}
}
