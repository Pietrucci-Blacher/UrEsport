package middlewares

import (
	"challenge/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func QueryFilter() gin.HandlerFunc {
	return func(c *gin.Context) {
		page, err := strconv.Atoi(c.DefaultQuery("page", "0"))
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error parsing page"})
			c.Abort()
			return
		}

		limit, err := strconv.Atoi(c.DefaultQuery("limit", "0"))
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error parsing limit"})
			c.Abort()
			return
		}

		populate := c.DefaultQuery("populate", "")
		where := c.DefaultQuery("where", "")
		sort := c.DefaultQuery("sort", "")
		query := utils.NewQueryFilter(page, limit, where, sort, populate)

		c.Set("query", query)
	}
}
