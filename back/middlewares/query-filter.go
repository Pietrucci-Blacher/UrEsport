package middlewares

import (
	"challenge/services"
	"net/http"

	"github.com/gin-gonic/gin"
)

func QueryFilter() gin.HandlerFunc {
	return func(c *gin.Context) {
		query := c.Request.URL.Query()

		queryFilter, err := services.NewQueryFilter(query)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error parsing query"})
			c.Abort()
			return
		}

		c.Set("query", queryFilter)
		c.Next() // Continue to the next handler
	}
}
