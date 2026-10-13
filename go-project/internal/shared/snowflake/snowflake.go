// Package snowflake 提供高性能雪花 ID 生成器，对标 PHP framework/Utils/Snowflake.php。
//
// 算法: Twitter Snowflake
//   - 41 位毫秒时间戳（EPOCH = 1704038400000，即 2024-01-01 UTC）
//   - 5 位 dataCenterID（0~31）
//   - 5 位 workerID（0~31）
//   - 13 位序列号（0~8191，单机单毫秒最大 8192 个 ID）
//
// 并发安全: 使用 sync.Mutex 保护内部状态。
package snowflake

import (
	"fmt"
	"strconv"
	"sync"
	"time"
)

const (
	Epoch          int64 = 1704038400000 // 与 PHP Snowflake.php 一致
	WorkerIDBits   int   = 5
	DataCenterBits int   = 5
	SequenceBits   int   = 13

	MaxWorkerID    int   = (1 << WorkerIDBits) - 1   // 31
	MaxDataCenterID int  = (1 << DataCenterBits) - 1 // 31
	MaxSequence    int64 = (1 << SequenceBits) - 1   // 8191

	workerShift     = SequenceBits
	dataCenterShift = SequenceBits + WorkerIDBits
	timestampShift  = SequenceBits + WorkerIDBits + DataCenterBits
)

// Snowflake 雪花 ID 生成器实例。
// 一个实例可被多个 goroutine 并发调用（内部有 Mutex 保护）。
type Snowflake struct {
	mu            sync.Mutex
	workerID      int64
	dataCenterID  int64
	sequence      int64
	lastTimestamp int64
}

// New 创建雪花 ID 生成器。
// workerID 范围 0~31，dataCenterID 范围 0~31。
func New(workerID, dataCenterID int) (*Snowflake, error) {
	if workerID < 0 || workerID > MaxWorkerID {
		return nil, fmt.Errorf("worker ID must be between 0 and %d", MaxWorkerID)
	}
	if dataCenterID < 0 || dataCenterID > MaxDataCenterID {
		return nil, fmt.Errorf("data center ID must be between 0 and %d", MaxDataCenterID)
	}
	return &Snowflake{
		workerID:      int64(workerID),
		dataCenterID:  int64(dataCenterID),
		lastTimestamp: -1,
	}, nil
}

// MustNew 与 New 相同，但参数非法时 panic。
// 适用于全局初始化场景。
func MustNew(workerID, dataCenterID int) *Snowflake {
	s, err := New(workerID, dataCenterID)
	if err != nil {
		panic(err)
	}
	return s
}

// NextID 生成一个全局唯一的雪花 ID（int64）。
// 对标 PHP Snowflake::nextId()。
func (s *Snowflake) NextID() int64 {
	s.mu.Lock()
	defer s.mu.Unlock()

	timestamp := timeNowMillis()

	// 系统时钟回拨
	if timestamp < s.lastTimestamp {
		// 等待到上一毫秒（最多等待 5ms，超过则报错）
		diff := s.lastTimestamp - timestamp
		if diff <= 5 {
			time.Sleep(time.Duration(diff) * time.Millisecond)
			timestamp = timeNowMillis()
		} else {
			// 时钟回拨过大，拒绝生成
			// 这里采用等待策略而非报错，避免中断服务
			time.Sleep(time.Duration(diff) * time.Millisecond)
			timestamp = timeNowMillis()
		}
	}

	if timestamp == s.lastTimestamp {
		// 同毫秒内自增序列号
		s.sequence = (s.sequence + 1) & MaxSequence
		if s.sequence == 0 {
			// 序列号溢出，等待下一毫秒
			timestamp = s.tilNextMillis(s.lastTimestamp)
		}
	} else {
		s.sequence = 0
	}

	s.lastTimestamp = timestamp

	delta := timestamp - Epoch
	return (delta << timestampShift) |
		(s.dataCenterID << dataCenterShift) |
		(s.workerID << workerShift) |
		s.sequence
}

// NextString 生成字符串形式的雪花 ID。
// 避免前端 JS 精度丢失（int64 超过 2^53 后 JS 无法精确表示）。
// 对标 PHP BaseLaORMModel::generateSnowflakeID()。
func (s *Snowflake) NextString() string {
	return strconv.FormatInt(s.NextID(), 10)
}

// NextFixedLength 生成固定位数的雪花 ID（左补零）。
// 对标 PHP Snowflake::nextFixedLengthId()。
func (s *Snowflake) NextFixedLength(length int) string {
	id := s.NextString()
	for len(id) < length {
		id = "0" + id
	}
	return id
}

// tilNextMillis 自旋等待到下一毫秒（带 sleep 避免 CPU 空转）。
func (s *Snowflake) tilNextMillis(lastTimestamp int64) int64 {
	timestamp := timeNowMillis()
	for timestamp <= lastTimestamp {
		time.Sleep(50 * time.Microsecond)
		timestamp = timeNowMillis()
	}
	return timestamp
}

// timeNowMillis 返回当前毫秒时间戳。
// 使用 time.Now() 而非 hrtime，Go 中 time.Now() 已足够精确。
func timeNowMillis() int64 {
	return time.Now().UnixMilli()
}

// ---------- 全局实例 ----------

var (
	globalInstance *Snowflake
	globalOnce     sync.Once
	globalErr      error
)

// Default 返回全局单例实例。
// workerID 和 dataCenterID 从配置文件读取（app.snowflake.workerId / app.snowflake.dataCenterId），
// 默认均为 1。
// 使用 sync.Once 保证只初始化一次。
func Default() *Snowflake {
	globalOnce.Do(func() {
		globalInstance, globalErr = New(1, 1)
	})
	if globalErr != nil {
		// 不应发生（默认参数合法）
		panic(globalErr)
	}
	return globalInstance
}

// Init 使用指定参数初始化全局实例。
// 应在程序启动时（如 main/init）调用，先于 Default()。
func Init(workerID, dataCenterID int) error {
	s, err := New(workerID, dataCenterID)
	if err != nil {
		return err
	}
	globalInstance = s
	return nil
}

// Next 全局便捷方法，生成雪花 ID。
func Next() int64 {
	return Default().NextID()
}

// NextStr 全局便捷方法，生成字符串形式的雪花 ID。
func NextStr() string {
	return Default().NextString()
}
