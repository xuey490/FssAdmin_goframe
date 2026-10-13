package biz

import "fmt"

type Error struct {
	Msg        string
	Code       int
	HTTPStatus int
}

func (e *Error) Error() string { return e.Msg }

func New(msg string, code int) *Error {
	hs := 200
	if code == 401 {
		hs = 401
	}
	return &Error{Msg: msg, Code: code, HTTPStatus: hs}
}

func Unauthorized(msg string) *Error {
	return &Error{Msg: msg, Code: 401, HTTPStatus: 401}
}

func Forbidden(msg string) *Error {
	return &Error{Msg: msg, Code: 403, HTTPStatus: 200}
}

func NotFound(msg string) *Error {
	return &Error{Msg: msg, Code: 404, HTTPStatus: 200}
}

func Bad(msg string) *Error { return New(msg, 400) }

func Wrap(err error, msg string) *Error {
	if err == nil {
		return New(msg, 1)
	}
	return New(fmt.Sprintf("%s: %v", msg, err), 1)
}

func As(err error) (*Error, bool) {
	if err == nil {
		return nil, false
	}
	e, ok := err.(*Error)
	return e, ok
}
