package logx

import "github.com/gogf/gf/v2/frame/g"

// Apply turns debug output and error stacks on or off.
// app.debug drives SetDebug. logger.stStatus drives SetStack (1 on, 0 off).
func Apply(debug, stack bool) {
	g.Log().SetDebug(debug)
	g.Log().SetStack(stack)
}
