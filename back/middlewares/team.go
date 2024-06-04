package middlewares

import (
	"challenge/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func IsTeamOwner() gin.HandlerFunc {
	return func(c *gin.Context) {
		user, _ := c.MustGet("connectedUser").(models.User)
		team, _ := c.MustGet("team").(*models.Team)

		if !team.IsOwner(user) && !user.IsRole(models.ROLE_ADMIN) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		c.Next()
	}
}
