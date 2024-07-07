package middlewares

import (
	"challenge/models"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

func IsRatingOwner() gin.HandlerFunc {
	return func(c *gin.Context) {
		user, _ := c.MustGet("connectedUser").(models.User)
		rating, _ := c.MustGet("rating").(*models.Rating)

		if rating.UserID != uint(user.ID) && !user.IsRole(models.ROLE_ADMIN) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "You are not the owner of this rating"})
			c.Abort()
			return
		}

		c.Next()
	}
}

func GetRating(key string) gin.HandlerFunc {
	return func(c *gin.Context) {
		var rating models.Rating
		id := c.Param(key)

		// Ajout de logs pour vérifier la valeur de id
		log.Printf("Rating ID from route: %s", id)

		if err := models.DB.First(&rating, id).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Rating not found"})
			c.Abort()
			return
		}

		c.Set("rating", &rating)
		c.Next()
	}
}
