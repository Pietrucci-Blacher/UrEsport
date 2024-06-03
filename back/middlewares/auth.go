package middlewares

import (
	"challenge/models"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func IsLoggedIn(mandatory bool) gin.HandlerFunc {
	return func(c *gin.Context) {
		var user models.User
		var token models.Token

		accessToken, err := c.Cookie("access_token")
		if err != nil {
			accessToken = c.GetHeader("Authorization")
		}

		if !mandatory && accessToken == "" {
			c.Next()
			return
		}

		if accessToken == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		if strings.Split(accessToken, " ")[0] == "Bearer" {
			accessToken = strings.Split(accessToken, " ")[1]
		}

		if err := token.FindOne("access_token", accessToken); err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}

		userClaim, err := models.ParseJWTToken(accessToken)
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

		if !user.Verified {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not Verified"})
			c.Abort()
			return
		}

		c.Set("user", user)
		c.Set("token", token)
		c.Next()
	}
}

func IsNotLoggedIn() gin.HandlerFunc {
	return func(c *gin.Context) {
		if _, err := c.Cookie("access_token"); err == nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Already Logged In"})
			c.Abort()
			return
		}

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
