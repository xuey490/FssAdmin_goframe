package authkit

import (
	"strings"

	"golang.org/x/crypto/bcrypt"
)

func Check(password, hash string) bool {
	if password == "" || hash == "" {
		return false
	}
	h := hash
	if strings.HasPrefix(h, "$2y$") {
		h = "$2a$" + h[4:]
	}
	return bcrypt.CompareHashAndPassword([]byte(h), []byte(password)) == nil
}

func Hash(password string) (string, error) {
	b, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(b), nil
}
