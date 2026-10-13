package dao

import (
	"fssadmin/go-project/internal/shared/dbx"

	"github.com/gogf/gf/v2/database/gdb"
)

const Table = "sa_article"
const CatTable = "sa_article_category"
const BannerTable = "sa_article_banner"

func Model() *gdb.Model       { return dbx.Alive(dbx.Model(Table)) }
func CatModel() *gdb.Model    { return dbx.Alive(dbx.Model(CatTable)) }
func BannerModel() *gdb.Model { return dbx.Alive(dbx.Model(BannerTable)) }
