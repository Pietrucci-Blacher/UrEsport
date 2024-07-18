package middlewares

import (
	"challenge/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func IsRatingOwner() gin.HandlerFunc {
	return func(c *gin.Context) {
		user, _ := c.MustGet("connectedUser").(models.User)
		rating, _ := c.MustGet("rating").(*models.Rating)

		if rating.UserID != uint(user.ID) && !user.IsRole(models.ROLE_ADMIN) {
			models.ErrorLogf([]string{"rating", "IsRatingOwner"}, "You are not the owner of this rating")
			c.JSON(http.StatusUnauthorized, gin.H{"error": "You are not the owner of this rating"})
			c.Abort()
			return
		}

		c.Next()
	}
}
