package datetime

import (
	"time"
)

const ISO8601JST = "2006-01-02T15:04:05+09:00"

var TimeNow = time.Now

var locationJST *time.Location

func GetLocationJST() *time.Location {
	if locationJST == nil {
		// UTC+9:00を"JST"として登録
		locationJST = time.FixedZone("JST", 9*60*60)
	}
	return locationJST
}

func NowInJST() time.Time {
	return TimeNow().In(GetLocationJST())
}

func ParseInJST(layout string, value string) (time.Time, error) {
	return time.ParseInLocation(layout, value, GetLocationJST())
}

func FormatInJST(t time.Time, layout string) string {
	return t.In(GetLocationJST()).Format(layout)
}
