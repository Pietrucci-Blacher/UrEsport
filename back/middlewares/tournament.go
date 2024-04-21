package middlewares

import (
	"challenge/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetTournament() gin.HandlerFunc {
	return func(c *gin.Context) {
		var tournament models.Tournament

		id, err := strconv.Atoi(c.Param("id"))
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Bad Request"})
			c.Abort()
			return
		}

		if err := tournament.FindOneById(id); err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Tournament not Found"})
			c.Abort()
			return
		}

		c.Set("tournament", tournament)
		c.Next()
	}
}

func IsTournamentOwner() gin.HandlerFunc {
	return func(c *gin.Context) {
		user, _ := c.MustGet("user").(models.User)
		tournament, _ := c.MustGet("tournament").(models.Tournament)

		if user.ID != tournament.OrganizerID && !user.IsRole(models.ROLE_ADMIN) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		c.Next()
	}
}
