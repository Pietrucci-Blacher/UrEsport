package middlewares

import (
	"challenge/utils"
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
		query := utils.NewQueryFilter(page, limit, where)

		c.Set("query", query)
	}
}
