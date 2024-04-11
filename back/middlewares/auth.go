package middlewares

import (
	"challenge/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func IsLoggedIn() gin.HandlerFunc {
	return func(c *gin.Context) {
		var user models.User
		token, err := c.Cookie("auth_token")
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal Server Error"})
			c.Abort()
			return
		}

		var t models.Token
		if err := t.FindOne("token", token); err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		userClaim, err := models.ParseJWTToken(token)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		if err := user.FindOneById(userClaim.UserID); err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "User not Found"})
			c.Abort()
			return
		}

		c.Set("user", user)
		c.Next()
	}
}

func IsAdmin() gin.HandlerFunc {
	return func(c *gin.Context) {
		user, _ := c.MustGet("user").(models.User)

		if !user.IsRole("admin") {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		c.Next()
	}
}
