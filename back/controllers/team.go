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
//	@Success		201	{object}	models.SanitizedTeam
//	@Failure		400	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/ [post]
func CreateTeam(c *gin.Context) {
	connectedUser, _ := c.MustGet("user").(models.User)
	body, _ := c.MustGet("body").(models.CreateTeamDto)

	if models.IsTeamExists(body.Name) {
		c.JSON(http.StatusConflict, gin.H{"error": "Team already exists"})
		return
	}

	team := models.Team{
		Name:    body.Name,
		OwnerID: connectedUser.ID,
	}

	if err := team.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := team.AddMember(connectedUser); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, team.Sanitize())
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

	if body.Name != "" {
		team.Name = body.Name
	}

	if err := team.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, team.Sanitize())
}

// DeleteTeam godoc
//
//	@Summary		delete team
//	@Description	delete team
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			id	path	int	true	"Team ID"
//	@Success		204
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

// JoinTeam godoc
//
//	@Summary		join team
//	@Description	join team
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			id	path	int	true	"Team ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/{id}/join [post]
func JoinTeam(c *gin.Context) {
	team, _ := c.MustGet("team").(*models.Team)

	if team.Private {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "This team is private"})
		return
	}

	connectedUser, _ := c.MustGet("user").(models.User)

	if team.IsMember(connectedUser) {
		c.JSON(http.StatusConflict, gin.H{"error": "You are already a member of this team"})
		return
	}

	if err := team.AddMember(connectedUser); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// LeaveTeam godoc
//
//	@Summary		leave team
//	@Description	leave team
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			id	path	int	true	"Team ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/{id}/leave [delete]
func LeaveTeam(c *gin.Context) {
	team, _ := c.MustGet("team").(*models.Team)
	connectedUser, _ := c.MustGet("user").(models.User)

	if team.IsOwner(connectedUser) {
		c.JSON(http.StatusConflict, gin.H{"error": "You can't leave the team because you are the owner"})
		return
	}

	if !team.IsMember(connectedUser) {
		c.JSON(http.StatusConflict, gin.H{"error": "You are not a member of this team"})
		return
	}

	if err := team.RemoveMember(connectedUser); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)

}

// InviteUserToTeam godoc
//
//	@Summary		invite user to team
//	@Description	invite user to team
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			id		path	int	true	"Team ID"
//	@Param			team	body		models.InviteUserDto	true	"Team DTO"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/{id}/invite [post]
func InviteUserToTeam(c *gin.Context) {
	var user models.User

	team, _ := c.MustGet("team").(*models.Team)
	body, _ := c.MustGet("body").(models.InviteUserDto)

	if err := user.FindOne("username", body.Username); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if team.IsMember(user) {
		c.JSON(http.StatusConflict, gin.H{"error": "User is already a member of this team"})
		return
	}

	if err := team.AddMember(user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// KickUserFromTeam godoc
//
//	@Summary		kick user from team
//	@Description	kick user from team
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			id		path	int	true	"Team ID"
//	@Param			team	body		models.InviteUserDto	true	"Team DTO"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/{id}/kick [delete]
func KickUserFromTeam(c *gin.Context) {
	var user models.User

	team, _ := c.MustGet("team").(*models.Team)
	body, _ := c.MustGet("body").(models.InviteUserDto)

	if err := user.FindOne("username", body.Username); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if team.IsOwner(user) {
		c.JSON(http.StatusConflict, gin.H{"error": "You can't kick the owner of the team"})
		return
	}

	if !team.IsMember(user) {
		c.JSON(http.StatusConflict, gin.H{"error": "User is not a member of this team"})
		return
	}

	if err := team.RemoveMember(user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// TogglePrivateTeam godoc
//
//	@Summary		toggle private team
//	@Description	toggle private team
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			id	path	int	true	"Team ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/{id}/toggle-private [patch]
func TogglePrivateTeam(c *gin.Context) {
	team, _ := c.MustGet("team").(*models.Team)

	team.TogglePrivate()

	if err := team.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
