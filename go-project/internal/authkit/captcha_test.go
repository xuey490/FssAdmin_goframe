package authkit

import (
	"bytes"
	"encoding/base64"
	"image"
	"image/png"
	"strings"
	"testing"
)

const captchaPrefix = "data:image/png;base64,"

// decodeCaptcha 解码验证码 data URI，返回图像、字形包围盒与字形像素数。
// 字形是随机彩色（高饱和），背景近似灰白、噪点弱着色，
// 因此用「通道极差」判定字形像素，而不是固定亮度阈值。
func decodeCaptcha(t *testing.T, uri string) (image.Image, image.Rectangle, int) {
	t.Helper()
	raw, err := base64.StdEncoding.DecodeString(strings.TrimPrefix(uri, captchaPrefix))
	if err != nil {
		t.Fatal(err)
	}
	img, err := png.Decode(bytes.NewReader(raw))
	if err != nil {
		t.Fatal(err)
	}
	b := img.Bounds()
	ink := 0
	minX, minY, maxX, maxY := b.Max.X, b.Max.Y, -1, -1
	for y := b.Min.Y; y < b.Max.Y; y++ {
		for x := b.Min.X; x < b.Max.X; x++ {
			r, g, bl, _ := img.At(x, y).RGBA()
			r8, g8, b8 := r>>8, g>>8, bl>>8
			if max(r8, g8, b8)-min(r8, g8, b8) <= 100 {
				continue
			}
			ink++
			minX, minY = min(minX, x), min(minY, y)
			maxX, maxY = max(maxX, x), max(maxY, y)
		}
	}
	if maxX < 0 {
		return img, image.Rectangle{}, 0
	}
	return img, image.Rect(minX, minY, maxX+1, maxY+1), ink
}

func TestImageDataURIIsPNG(t *testing.T) {
	uri := ImageDataURI("A2B3")
	if !strings.HasPrefix(uri, captchaPrefix) {
		t.Fatalf("prefix %s", uri[:min(40, len(uri))])
	}
	img, _, ink := decodeCaptcha(t, uri)
	b := img.Bounds()
	if b.Dx() != 160 || b.Dy() != 48 {
		t.Fatalf("size %dx%d", b.Dx(), b.Dy())
	}
	if ink < 200 {
		t.Fatalf("glyphs missing, ink=%d", ink)
	}
}

// 形变（倾斜/旋转/扭曲）都是随机参数，多轮采样确保字形不会被画到画布外。
func TestWarpedGlyphsStayInsideCanvas(t *testing.T) {
	for i := 0; i < 50; i++ {
		_, bbox, ink := decodeCaptcha(t, ImageDataURI("W4HN"))
		if ink < 200 {
			t.Fatalf("glyphs missing, ink=%d", ink)
		}
		if bbox.Min.X < 1 || bbox.Min.Y < 1 || bbox.Max.X > 159 || bbox.Max.Y > 47 {
			t.Fatalf("第 %d 轮渲染被裁切: %v", i, bbox)
		}
	}
}

func TestImageDataURIRandomized(t *testing.T) {
	if ImageDataURI("A2B3") == ImageDataURI("A2B3") {
		t.Fatal("同一验证码两次渲染完全一致，颜色与形变应当随机")
	}
}

func TestGlyphsCoverCharset(t *testing.T) {
	for _, ch := range captchaChars {
		if _, ok := glyphs[ch]; !ok {
			t.Fatalf("missing glyph %c", ch)
		}
	}
}

func TestDifferentCodesDiffer(t *testing.T) {
	if ImageDataURI("2222") == ImageDataURI("8888") {
		t.Fatal("distinct glyphs produced identical images")
	}
}
