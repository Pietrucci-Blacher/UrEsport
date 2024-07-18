package controllers

import (
	"challenge/models"
	"challenge/services"
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

	query, _ := c.MustGet("query").(services.QueryFilter)

	teams, err := models.FindAllTeams(query)
	if err != nil {
		models.ErrorLogf([]string{"team", "GetTeams"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	for _, team := range teams {
		sanitized = append(sanitized, team.Sanitize())
	}

	models.PrintLogf([]string{"team", "GetTeams"}, "Fetched %d teams", len(sanitized))
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
	models.PrintLogf([]string{"team", "GetTeam"}, "Fetched team %s", team.Name)
	c.JSON(http.StatusOK, sanitized)
}

// GetUserTeams godoc
//
//	@Summary		get user teams
//	@Description	get user teams
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Success		200	{object}	[]models.SanitizedTeam
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/user/{userid} [get]
func GetUserTeams(c *gin.Context) {
	user, _ := c.MustGet("user").(*models.User)

	teams, err := models.FindTeamsByUserId(user.ID)
	if err != nil {
		models.ErrorLogf([]string{"team", "GetUserTeams"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var sanitizedTeams []models.SanitizedTeam
	for _, team := range teams {
		sanitizedTeams = append(sanitizedTeams, team.Sanitize())
	}

	models.PrintLogf([]string{"team", "GetUserTeams"}, "Fetched %d teams", len(sanitizedTeams))
	c.JSON(http.StatusOK, sanitizedTeams)
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
	connectedUser, _ := c.MustGet("connectedUser").(models.User)
	body, _ := c.MustGet("body").(models.CreateTeamDto)

	team := models.Team{
		Name:    body.Name,
		OwnerID: connectedUser.ID,
		Private: body.Private,
	}

	if err := team.Save(); err != nil {
		models.ErrorLogf([]string{"team", "CreateTeam"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := team.AddMember(connectedUser); err != nil {
		models.ErrorLogf([]string{"team", "CreateTeam"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"team", "CreateTeam"}, "Team %s created", team.Name)
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
		models.ErrorLogf([]string{"team", "UpdateTeam"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"team", "UpdateTeam"}, "Team %s updated", team.Name)
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
		models.ErrorLogf([]string{"team", "DeleteTeam"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"team", "DeleteTeam"}, "Team %s deleted", team.Name)
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
	connectedUser, _ := c.MustGet("connectedUser").(models.User)

	if team.Private {
		models.ErrorLogf([]string{"team", "JoinTeam"}, "User %d tried to join private team %d", connectedUser.ID, team.ID)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "This team is private"})
		return
	}

	if team.HasMember(connectedUser) {
		models.ErrorLogf([]string{"team", "JoinTeam"}, "User %d is already a member of team %d", connectedUser.ID, team.ID)
		c.JSON(http.StatusConflict, gin.H{"error": "You are already a member of this team"})
		return
	}

	if err := team.AddMember(connectedUser); err != nil {
		models.ErrorLogf([]string{"team", "JoinTeam"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"team", "JoinTeam"}, "User %d joined team %d", connectedUser.ID, team.ID)
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
	connectedUser, _ := c.MustGet("connectedUser").(models.User)

	if team.IsOwner(connectedUser) {
		models.ErrorLogf([]string{"team", "LeaveTeam"}, "User %d tried to leave team %d", connectedUser.ID, team.ID)
		c.JSON(http.StatusConflict, gin.H{"error": "You can't leave the team because you are the owner"})
		return
	}

	if !team.HasMember(connectedUser) {
		models.ErrorLogf([]string{"team", "LeaveTeam"}, "User %d is not a member of team %d", connectedUser.ID, team.ID)
		c.JSON(http.StatusConflict, gin.H{"error": "You are not a member of this team"})
		return
	}

	if err := team.RemoveMember(connectedUser); err != nil {
		models.ErrorLogf([]string{"team", "LeaveTeam"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"team", "LeaveTeam"}, "User %d left team %d", connectedUser.ID, team.ID)
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
	var invit models.Invit

	team, _ := c.MustGet("team").(*models.Team)
	body, _ := c.MustGet("body").(models.InviteUserDto)

	if err := user.FindOne("username", body.Username); err != nil {
		models.ErrorLogf([]string{"team", "InviteUserToTeam"}, "User %s not found", body.Username)
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if team.HasMember(user) {
		models.ErrorLogf([]string{"team", "InviteUserToTeam"}, "User %s is already a member of team %d", user.Username, team.ID)
		c.JSON(http.StatusConflict, gin.H{"error": "User is already a member of this team"})
		return
	}

	if err := invit.FindOneByTeamAndUser(team.ID, user.ID); err == nil {
		models.ErrorLogf([]string{"team", "InviteUserToTeam"}, "User %s is already invited to team %d", user.Username, team.ID)
		c.JSON(http.StatusConflict, gin.H{"error": "User already invited"})
		return
	}

	if models.NewTeamInvit(team.ID, user.ID).Save() != nil {
		models.ErrorLogf([]string{"team", "InviteUserToTeam"}, "Error while saving the invitation")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while saving the invitation"})
		return
	}

	models.PrintLogf([]string{"team", "InviteUserToTeam"}, "User %s invited to team %d", user.Username, team.ID)
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
		models.ErrorLogf([]string{"team", "KickUserFromTeam"}, "User %s not found", body.Username)
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if team.IsOwner(user) {
		models.ErrorLogf([]string{"team", "KickUserFromTeam"}, "User %s is the owner of team %d", user.Username, team.ID)
		c.JSON(http.StatusConflict, gin.H{"error": "You can't kick the owner of the team"})
		return
	}

	if !team.HasMember(user) {
		models.ErrorLogf([]string{"team", "KickUserFromTeam"}, "User %s is not a member of team %d", user.Username, team.ID)
		c.JSON(http.StatusConflict, gin.H{"error": "User is not a member of this team"})
		return
	}

	if err := team.RemoveMember(user); err != nil {
		models.ErrorLogf([]string{"team", "KickUserFromTeam"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"team", "KickUserFromTeam"}, "User %s kicked from team %d", user.Username, team.ID)
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
		models.ErrorLogf([]string{"team", "TogglePrivateTeam"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"team", "TogglePrivateTeam"}, "Team %s is now %t", team.Name, team.Private)
	c.JSON(http.StatusNoContent, nil)
}

// AcceptTeamInvitation godoc
//
//	@Summary		accept team invitation
//	@Description	accept team invitation
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			team	path	int	true	"Team ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/{team}/accept [get]
func AcceptTeamInvitation(c *gin.Context) {
	var invit models.Invit

	team, _ := c.MustGet("team").(*models.Team)
	connectedUser, _ := c.MustGet("connectedUser").(models.User)

	if team.HasMember(connectedUser) {
		models.ErrorLogf([]string{"team", "AcceptTeamInvitation"}, "User %s is already a member of team %d", connectedUser.Username, team.ID)
		c.JSON(http.StatusConflict, gin.H{"error": "You are already a member of this team"})
		return
	}

	if err := invit.FindOneByTeamAndUser(team.ID, connectedUser.ID); err != nil {
		models.ErrorLogf([]string{"team", "AcceptTeamInvitation"}, "Invitation not found")
		c.JSON(http.StatusNotFound, gin.H{"error": "Invitation not found"})
		return
	}

	if err := team.AddMember(connectedUser); err != nil {
		models.ErrorLogf([]string{"team", "AcceptTeamInvitation"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	invit.Status = models.ACCEPTED

	if err := invit.Save(); err != nil {
		models.ErrorLogf([]string{"team", "AcceptTeamInvitation"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"team", "AcceptTeamInvitation"}, "User %s accepted invitation to team %d", connectedUser.Username, team.ID)
	c.JSON(http.StatusNoContent, nil)
}

// RejectTeamInvitation godoc
//
//	@Summary		reject team invitation
//	@Description	reject team invitation
//	@Tags			team
//	@Accept			json
//	@Produce		json
//	@Param			team	path	int	true	"Team ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/teams/{team}/reject [get]
func RejectTeamInvitation(c *gin.Context) {
	var invit models.Invit

	team, _ := c.MustGet("team").(*models.Team)
	connectedUser, _ := c.MustGet("connectedUser").(models.User)

	if err := invit.FindOneByTeamAndUser(team.ID, connectedUser.ID); err != nil {
		models.ErrorLogf([]string{"team", "RejectTeamInvitation"}, "Invitation not found")
		c.JSON(http.StatusNotFound, gin.H{"error": "Invitation not found"})
		return
	}

	invit.Status = models.REJECTED

	if err := invit.Save(); err != nil {
		models.ErrorLogf([]string{"team", "RejectTeamInvitation"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"team", "RejectTeamInvitation"}, "User %s rejected invitation to team %d", connectedUser.Username, team.ID)
	c.JSON(http.StatusNoContent, nil)
}
