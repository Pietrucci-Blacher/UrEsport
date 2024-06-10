package utils

import (
	"github.com/h2non/filetype"
)

var (
	IMAGE = []string{"jpg", "png"}
	PDF   = []string{"pdf"}

	SIZE_1KB   = 1 << 10
	SIZE_5KB   = 5 << 10
	SIZE_10KB  = 10 << 10
	SIZE_20KB  = 20 << 10
	SIZE_50KB  = 50 << 10
	SIZE_1MB   = 1 << 20
	SIZE_5MB   = 5 << 20
	SIZE_10MB  = 10 << 20
	SIZE_20MB  = 20 << 20
	SIZE_50MB  = 50 << 20
	SIZE_100MB = 100 << 20
	SIZE_200MB = 200 << 20
	SIZE_500MB = 500 << 20
)

func IsFileType(buf []byte, fileType []string) bool {
	for _, t := range fileType {
		if filetype.Is(buf, t) {
			return true
		}
	}
	return false
}
