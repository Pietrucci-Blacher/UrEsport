package middlewares

import (
	"challenge/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetUser() gin.HandlerFunc {
	return func(c *gin.Context) {
		var user models.User

		id, err := strconv.Atoi(c.Param("id"))
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Bad Request"})
			c.Abort()
			return
		}

		if err := user.FindOneById(id); err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "User not Found"})
			c.Abort()
			return
		}

		c.Set("findedUser", user)
		c.Next()
	}
}

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
