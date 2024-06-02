package middlewares

import (
	"challenge/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func IsMe() gin.HandlerFunc {
	return func(c *gin.Context) {
		user, _ := c.MustGet("findedUser").(models.User)
		connectedUser, _ := c.MustGet("user").(models.User)

		if user.ID != connectedUser.ID && !connectedUser.IsRole(models.ROLE_ADMIN) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		c.Next()
	}
}
