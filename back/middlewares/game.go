package middlewares

import (
	"challenge/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetGame() gin.HandlerFunc {
	return func(c *gin.Context) {
		var game models.Game

		id, err := strconv.Atoi(c.Param("id"))
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Bad Request"})
			c.Abort()
			return
		}

		if err := game.FindOneById(id); err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Game not Found"})
			c.Abort()
			return
		}

		c.Set("game", game)
		c.Next()
	}
}
