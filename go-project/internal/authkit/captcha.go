package authkit

import (
	"bytes"
	"crypto/rand"
	"encoding/base64"
	"image"
	"image/color"
	"image/png"
	"math"
	"math/big"
	"strings"
)

const captchaChars = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ"

func RandomCode(n int) string {
	var b strings.Builder
	for i := 0; i < n; i++ {
		idx, _ := rand.Int(rand.Reader, big.NewInt(int64(len(captchaChars))))
		b.WriteByte(captchaChars[idx.Int64()])
	}
	return b.String()
}

func RandomHex(n int) string {
	buf := make([]byte, n)
	_, _ = rand.Read(buf)
	return strings.ToLower(base64.RawURLEncoding.EncodeToString(buf))
}

func ImageDataURI(code string) string {
	const w, h, scale = 160, 48, 4
	img := image.NewRGBA(image.Rect(0, 0, w, h))
	bg := color.RGBA{245, 248, 252, 255}
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			img.Set(x, y, bg)
		}
	}
	glyphW := 5 * scale
	gap := 8
	gaps := len(code) - 1
	if gaps < 0 {
		gaps = 0
	}
	total := len(code)*glyphW + gaps*gap
	x0 := (w - total) / 2
	y0 := (h - 7*scale) / 2
	// 每个字符取一个随机色相，且任意两色相差不小于 45 度，避免出现两块相近的颜色。
	// 饱和度/亮度固定，保证在浅色背景上始终清晰可读。
	hues := randomHues(len(code))
	for i, ch := range code {
		drawGlyph(img, x0+i*(glyphW+gap), y0, ch, scale, inkColor(hues[i]), newGlyphWarp())
	}
	noise(img, w, h)
	var buf bytes.Buffer
	_ = png.Encode(&buf, img)
	return "data:image/png;base64," + base64.StdEncoding.EncodeToString(buf.Bytes())
}

// randomHues 返回 n 个随机色相，两两色相差不小于 45 度。
// 色环最多容纳 360/minGap 个互不相近的色相，超出后不再约束（验证码长度固定为 4）。
func randomHues(n int) []int {
	const minGap = 45
	maxSpaced := 360/minGap - 1
	hues := make([]int, 0, n)
	for len(hues) < n {
		h := randN(360)
		if len(hues) >= maxSpaced || hueFarEnough(h, hues, minGap) {
			hues = append(hues, h)
		}
	}
	return hues
}

func hueFarEnough(h int, hues []int, minGap int) bool {
	for _, prev := range hues {
		d := h - prev
		if d < 0 {
			d = -d
		}
		if d > 180 {
			d = 360 - d
		}
		if d < minGap {
			return false
		}
	}
	return true
}

// inkColor 由色相生成高饱和字形颜色（HSL，S=0.85 / L=0.42，浅色背景上清晰且鲜艳）。
func inkColor(hue int) color.RGBA {
	const sat, light = 0.85, 0.42
	h := float64(((hue%360)+360)%360) / 360
	c := (1 - math.Abs(2*light-1)) * sat
	x := c * (1 - math.Abs(math.Mod(h*6, 2)-1))
	m := light - c/2
	var r, g, b float64
	switch {
	case h < 1.0/6:
		r, g, b = c, x, 0
	case h < 2.0/6:
		r, g, b = x, c, 0
	case h < 3.0/6:
		r, g, b = 0, c, x
	case h < 4.0/6:
		r, g, b = 0, x, c
	case h < 5.0/6:
		r, g, b = x, 0, c
	default:
		r, g, b = c, 0, x
	}
	return color.RGBA{rgb8(r + m), rgb8(g + m), rgb8(b + m), 255}
}

func rgb8(v float64) uint8 {
	x := math.Round(v * 255)
	if x < 0 {
		return 0
	}
	if x > 255 {
		return 255
	}
	return uint8(x)
}

// glyphWarp 描述单个字形的随机形变：倾斜（剪切）、旋转、缩放、正弦扭曲与位置抖动。
// 所有映射都在字形格局部坐标中完成，最后再平移回字形格左上角。
type glyphWarp struct {
	dx, dy              float64 // 位置抖动
	scaleX, scaleY      float64
	cos, sin            float64 // 旋转
	slant               float64 // 水平剪切系数，正值为右倾
	ampX, freqX, phaseX float64
	ampY, freqY, phaseY float64
}

func newGlyphWarp() glyphWarp {
	angle := float64(randN(17)-8) * math.Pi / 180 // ±8 度
	lean := 1.0
	if randN(2) == 0 {
		lean = -1
	}
	return glyphWarp{
		dx:     float64(randN(31)-15) / 10, // ±1.5 px
		dy:     float64(randN(41)-20) / 10, // ±2.0 px
		scaleX: 0.92 + float64(randN(17))/100,
		scaleY: 0.88 + float64(randN(25))/100,
		cos:    math.Cos(angle),
		sin:    math.Sin(angle),
		slant:  lean * (0.12 + float64(randN(13))/100),
		ampX:   lean * (0.6 + float64(randN(10))/10),
		freqX:  0.25 + float64(randN(30))/100,
		phaseX: float64(randN(628)) / 100,
		ampY:   0.4 + float64(randN(8))/10,
		freqY:  0.2 + float64(randN(25))/100,
		phaseY: float64(randN(628)) / 100,
	}
}

// at 将字形格局部坐标（左上角为原点）映射为形变后的同一坐标系下的坐标。
func (w glyphWarp) at(lx, ly, glyphW, glyphH float64) (float64, float64) {
	x := (lx - glyphW/2) * w.scaleX
	y := (ly - glyphH/2) * w.scaleY
	x += w.slant * y                           // 倾斜
	x, y = x*w.cos-y*w.sin, x*w.sin+y*w.cos    // 旋转
	x += w.ampX * math.Sin(w.freqX*y+w.phaseX) // 水平扭曲
	y += w.ampY * math.Sin(w.freqY*x+w.phaseY) // 垂直扭曲
	return x + glyphW/2 + w.dx, y + glyphH/2 + w.dy
}

// drawGlyph 按字形位图逐像素做正向映射并写入画布。
// 每个源像素做 3x3 子采样，避免形变后出现空洞。
func drawGlyph(img *image.RGBA, x, y int, ch rune, scale int, c color.Color, w glyphWarp) {
	rows, ok := glyphs[ch]
	if !ok {
		rows = glyphs['8']
	}
	const steps = 3
	glyphW := float64(5 * scale)
	glyphH := float64(7 * scale)
	for row := 0; row < 7; row++ {
		bits := rows[row]
		for col := 0; col < 5; col++ {
			if bits&(1<<uint(4-col)) == 0 {
				continue
			}
			for dy := 0; dy < scale; dy++ {
				for dx := 0; dx < scale; dx++ {
					lx0 := float64(col*scale + dx)
					ly0 := float64(row*scale + dy)
					for sy := 0; sy < steps; sy++ {
						for sx := 0; sx < steps; sx++ {
							lx := lx0 + (float64(sx)+0.5)/steps
							ly := ly0 + (float64(sy)+0.5)/steps
							px, py := w.at(lx, ly, glyphW, glyphH)
							img.Set(x+int(math.Round(px)), y+int(math.Round(py)), c)
						}
					}
				}
			}
		}
	}
}

func noise(img *image.RGBA, w, h int) {
	line := color.RGBA{170, 190, 210, 255}
	for n := 0; n < 3; n++ {
		y1 := randN(h)
		y2 := randN(h)
		for x := 0; x < w; x++ {
			y := y1 + (y2-y1)*x/w
			if y >= 0 && y < h {
				img.Set(x, y, line)
			}
		}
	}
	dot := color.RGBA{160, 170, 190, 255}
	for n := 0; n < w*h/80; n++ {
		img.Set(randN(w), randN(h), dot)
	}
}

func randN(n int) int {
	if n <= 0 {
		return 0
	}
	v, _ := rand.Int(rand.Reader, big.NewInt(int64(n)))
	return int(v.Int64())
}

// 5x7 bitmaps, MSB is the left pixel. No 0/O/1/I to match RandomCode.
var glyphs = map[rune][7]byte{
	'2': {0x0E, 0x11, 0x01, 0x06, 0x08, 0x10, 0x1F},
	'3': {0x1E, 0x01, 0x01, 0x0E, 0x01, 0x01, 0x1E},
	'4': {0x02, 0x06, 0x0A, 0x12, 0x1F, 0x02, 0x02},
	'5': {0x1F, 0x10, 0x1E, 0x01, 0x01, 0x11, 0x0E},
	'6': {0x06, 0x08, 0x10, 0x1E, 0x11, 0x11, 0x0E},
	'7': {0x1F, 0x01, 0x02, 0x04, 0x08, 0x08, 0x08},
	'8': {0x0E, 0x11, 0x11, 0x0E, 0x11, 0x11, 0x0E},
	'9': {0x0E, 0x11, 0x11, 0x0F, 0x01, 0x02, 0x0C},
	'A': {0x0E, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11},
	'B': {0x1E, 0x11, 0x11, 0x1E, 0x11, 0x11, 0x1E},
	'C': {0x0E, 0x11, 0x10, 0x10, 0x10, 0x11, 0x0E},
	'D': {0x1E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x1E},
	'E': {0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x1F},
	'F': {0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x10},
	'G': {0x0E, 0x11, 0x10, 0x17, 0x11, 0x11, 0x0E},
	'H': {0x11, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11},
	'J': {0x07, 0x02, 0x02, 0x02, 0x02, 0x12, 0x0C},
	'K': {0x11, 0x12, 0x14, 0x18, 0x14, 0x12, 0x11},
	'L': {0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x1F},
	'M': {0x11, 0x1B, 0x15, 0x15, 0x11, 0x11, 0x11},
	'N': {0x11, 0x19, 0x15, 0x13, 0x11, 0x11, 0x11},
	'P': {0x1E, 0x11, 0x11, 0x1E, 0x10, 0x10, 0x10},
	'Q': {0x0E, 0x11, 0x11, 0x11, 0x15, 0x12, 0x0D},
	'R': {0x1E, 0x11, 0x11, 0x1E, 0x14, 0x12, 0x11},
	'S': {0x0F, 0x10, 0x10, 0x0E, 0x01, 0x01, 0x1E},
	'T': {0x1F, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04},
	'U': {0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E},
	'V': {0x11, 0x11, 0x11, 0x11, 0x11, 0x0A, 0x04},
	'W': {0x11, 0x11, 0x11, 0x15, 0x15, 0x15, 0x0A},
	'X': {0x11, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11},
	'Y': {0x11, 0x11, 0x0A, 0x04, 0x04, 0x04, 0x04},
	'Z': {0x1F, 0x01, 0x02, 0x04, 0x08, 0x10, 0x1F},
}
