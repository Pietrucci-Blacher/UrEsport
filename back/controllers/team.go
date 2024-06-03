package controllers

import (
	"challenge/models"
	"challenge/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetTeams godoc
//
//	@Summary		get all teams
//	@Description	get all teams
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Success		200	{object}	[]models.SanitizedTeam
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/ [get]
func GetTeams(c *gin.Context) {
	var sanitized []models.SanitizedTeam

	query, _ := c.MustGet("query").(utils.QueryFilter)

	teams, err := models.FindAllTeams(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	for _, team := range teams {
		sanitized = append(sanitized, team.Sanitize())
	}

	c.JSON(http.StatusOK, sanitized)
}

// GetTeam godoc
//
//	@Summary		get team by id
//	@Description	get team by id
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Team ID"
//	@Success		200	{object}	models.SanitizedTeam
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/{id} [get]
func GetTeam(c *gin.Context) {
	team, _ := c.MustGet("team").(*models.Team)
	sanitized := team.Sanitize()
	c.JSON(http.StatusOK, sanitized)
}

// CreateTeam godoc
//
//	@Summary		create team
//	@Description	create team
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			team	body		models.CreateTeamDto	true	"Team DTO"
//	@Success		201	{object}	models.Team
//	@Failure		400	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/ [post]
func CreateTeam(c *gin.Context) {
	connectedUser, _ := c.MustGet("user").(models.User)
	body, _ := c.MustGet("body").(models.CreateTeamDto)

	team := models.Team{
		Name:    body.Name,
		OwnerID: connectedUser.ID,
	}

	if err := team.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, team)
}

// UpdateTeam godoc
//
//	@Summary		update team
//	@Description	update team
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			team	body		models.UpdateTeamDto	true	"Team DTO"
//	@Param			id		path		int						true	"Team ID"
//	@Success		200		{object}	models.SanitizedTeam
//	@Failure		400		{object}	utils.HttpError
//	@Failure		401		{object}	utils.HttpError
//	@Failure		404		{object}	utils.HttpError
//	@Failure		500		{object}	utils.HttpError
//	@Router			/teams/{id} [patch]
func UpdateTeam(c *gin.Context) {
	team, _ := c.MustGet("team").(*models.Team)
	body, _ := c.MustGet("body").(models.UpdateTeamDto)

	if body.Name == "" {
		team.Name = body.Name
	}

	if err := team.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, team)
}

// DeleteTeam godoc
//
//	@Summary		delete team
//	@Description	delete team
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			id	path	int	true	"Team ID"
//	@Success		204	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/{id} [delete]
func DeleteTeam(c *gin.Context) {
	team, _ := c.MustGet("team").(*models.Team)

	if err := team.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
