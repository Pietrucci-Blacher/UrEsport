package middlewares

import (
	"strconv"

	"github.com/gin-gonic/gin"
)

func QueryFilter() gin.HandlerFunc {
	return func(c *gin.Context) {
		page, err := strconv.Atoi(c.DefaultQuery("page", "1"))
		if err != nil {
			page = 1
		}

		limit, err := strconv.Atoi(c.DefaultQuery("limit", "10"))
		if err != nil {
			limit = 10
		}

		where := c.DefaultQuery("where", "")

		c.Set("limit", limit)
		c.Set("skip", (page-1)*limit)
		c.Set("where", where)
	}
}
