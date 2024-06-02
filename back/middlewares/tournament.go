package middlewares

import (
	"challenge/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

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
