package middlewares

import (
	"challenge/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetFeature() gin.HandlerFunc {
	return func(c *gin.Context) {
		var feature models.Feature

		id, err := strconv.Atoi(c.Param("id"))
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Bad Request"})
			c.Abort()
			return
		}

		if err := feature.FindOneById(id); err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Feature not Found"})
			c.Abort()
			return
		}

		c.Set("feature", feature)
		c.Next()
	}
}
