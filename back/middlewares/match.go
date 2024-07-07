package middlewares

import (
	"challenge/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func IsTeamInMatch() gin.HandlerFunc {
	return func(c *gin.Context) {
		match, _ := c.MustGet("match").(*models.Match)
		team, _ := c.MustGet("team").(*models.Team)

		if !match.HasTeam(*team) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "This team is not in this match"})
			c.Abort()
			return
		}

		c.Next()
	}
}

func IsTeamOwnerInMatch() gin.HandlerFunc {
	return func(c *gin.Context) {
		match, _ := c.MustGet("match").(*models.Match)
		user, _ := c.MustGet("connectedUser").(models.User)

		if !match.HasTeamOwner(user) && !user.IsRole(models.ROLE_ADMIN) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "You are not the owner of a team in this match"})
			c.Abort()
			return
		}

		c.Next()
	}
}

func IsTeamMemberInMatch() gin.HandlerFunc {
	return func(c *gin.Context) {
		match, _ := c.MustGet("match").(*models.Match)
		user, _ := c.MustGet("connectedUser").(models.User)

		if !match.HasTeamMember(user) && !user.IsRole(models.ROLE_ADMIN) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "You are not in this match"})
			c.Abort()
			return
		}

		c.Next()
	}
}

func IsMatchTournmanentOwner() gin.HandlerFunc {
	return func(c *gin.Context) {
		match, _ := c.MustGet("match").(*models.Match)
		user, _ := c.MustGet("connectedUser").(models.User)

		if !match.Tournament.IsOwner(user) && !user.IsRole(models.ROLE_ADMIN) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "You are not the owner of this tournament"})
			c.Abort()
			return
		}

		c.Next()
	}
}
