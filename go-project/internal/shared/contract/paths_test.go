package contract

import "testing"

func TestAPIPathsNotEmpty(t *testing.T) {
	if len(APIPaths) < 20 {
		t.Fatalf("contract too small: %d", len(APIPaths))
	}
}
