package controllers

import (
	"challenge/models"
	"challenge/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetTournaments godoc
//
//	@Summary		get all tournaments
//	@Description	get all tournaments
//	@Tags			tournament
//	@Accept			json
//	@Produce		json
//	@Success		200	{object}	[]models.SanitizedTournament
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/ [get]
func GetTournaments(c *gin.Context) {
	var sanitized []models.SanitizedTournament

	query, _ := c.MustGet("query").(utils.QueryFilter)

	tournaments, err := models.FindAllTournaments(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	for _, tournament := range tournaments {
		sanitized = append(sanitized, tournament.Sanitize(true))
	}

	c.JSON(http.StatusOK, sanitized)
}

// GetTournament godoc
//
//	@Summary		get tournament by id
//	@Description	get tournament by id
//	@Tags			tournament
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Tournament ID"
//	@Success		200	{object}	models.SanitizedTournament
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id} [get]
func GetTournament(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)

	sanitized := tournament.Sanitize(true)

	c.JSON(http.StatusOK, sanitized)
}

// CreateTournament godoc
//
//	@Summary		create tournament
//	@Description	create tournament
//	@Tags			tournament
//	@Accept			json
//	@Produce		json
//	@Param			tournament	body		models.CreateTournamentDto	true	"Tournament"
//	@Success		200			{object}	models.Tournament
//	@Failure		400			{object}	utils.HttpError
//	@Failure		500			{object}	utils.HttpError
//	@Router			/tournaments/ [post]
func CreateTournament(c *gin.Context) {
	var tournament models.Tournament

	connectedUser, _ := c.MustGet("connectedUser").(models.User)
	body, _ := c.MustGet("body").(models.CreateTournamentDto)

	tournament.Name = body.Name
	tournament.Description = body.Description
	tournament.Location = body.Location
	tournament.Image = body.Image
	tournament.StartDate = body.StartDate
	tournament.EndDate = body.EndDate
	tournament.OrganizerID = connectedUser.ID
	tournament.Private = body.Private

	if err := tournament.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, tournament)
}

// UpdateTournament godoc
//
//	@Summary		update tournament
//	@Description	update tournament
//	@Tags			tournament
//	@Accept			json
//	@Produce		json
//	@Param			tournament	body		models.UpdateTournamentDto	true	"Tournament"
//	@Param			id			path		int							true	"Tournament ID"
//	@Success		200			{object}	models.Tournament
//	@Failure		400			{object}	utils.HttpError
//	@Failure		401			{object}	utils.HttpError
//	@Failure		404			{object}	utils.HttpError
//	@Failure		500			{object}	utils.HttpError
//	@Router			/tournaments/{id} [patch]
func UpdateTournament(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)
	body, _ := c.MustGet("body").(models.UpdateTournamentDto)

	if body.Name != "" {
		tournament.Name = body.Name
	}
	if body.Description != "" {
		tournament.Description = body.Description
	}
	if body.Location != "" {
		tournament.Location = body.Location
	}
	if body.Image != "" {
		tournament.Image = body.Image
	}
	if !body.StartDate.IsZero() {
		tournament.StartDate = body.StartDate
	}
	if !body.EndDate.IsZero() {
		tournament.EndDate = body.EndDate
	}

	if err := tournament.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, tournament)
}

// DeleteTournament godoc
//
//	@Summary		delete tournament
//	@Description	delete tournament
//	@Tags			tournament
//	@Param			id	path	int	true	"Tournament ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id} [delete]
func DeleteTournament(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)

	if err := tournament.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// JoinTournament godoc
//
//	@Summary		join team you own to a tournament
//	@Description	join team you own to a tournament
//	@Tags			tournament
//	@Param			tournament	path	int	true	"Tournament ID"
//	@Param			team	path	int	true	"Team ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{tournament}/team/{team}/join [post]
func JoinTournament(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)
	team, _ := c.MustGet("team").(*models.Team)

	if tournament.Private {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "This tournament is private"})
		return
	}

	if tournament.IsInTeam(*team) {
		c.JSON(http.StatusNotFound, gin.H{"error": "Team already in this tournament"})
		return
	}

	if err := tournament.AddTeam(*team); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// LeaveTournament godoc
//
//	@Summary		leave team you own from a tournament
//	@Description	leave team you own from a tournament
//	@Tags			tournament
//	@Param			tournament	path	int	true	"Tournament ID"
//	@Param			team	path	int	true	"Team ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{tournament}/team/{team}/leave [delete]
func LeaveTournament(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)
	team, _ := c.MustGet("team").(*models.Team)

	if !tournament.IsInTeam(*team) {
		c.JSON(http.StatusNotFound, gin.H{"error": "Team not found in this tournament"})
		return
	}

	if err := tournament.RemoveTeam(*team); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// InviteTeamToTournament godoc
//
//	@Summary		invite team to your tournament
//	@Description	invite team to your tournament
//	@Tags			tournament
//	@Param			id		path	int						true	"Tournament ID"
//	@Param			team	body	models.InviteTeamDto	true	"Invite"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/invite [post]
func InviteTeamToTournament(c *gin.Context) {
	var team models.Team

	tournament, _ := c.MustGet("tournament").(*models.Tournament)
	body, _ := c.MustGet("body").(models.InviteTeamDto)

	if err := team.FindOne("name", body.Name); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Team not found"})
		return
	}

	if tournament.IsInTeam(team) {
		c.JSON(http.StatusConflict, gin.H{"error": "Team is already in this tournament"})
		return
	}

	if models.NewTournamentInvit(tournament.ID).Save() != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while saving invitation"})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// KickTeamFromTournament godoc
//
//	@Summary		kick team from your tournament
//	@Description	kick team from your tournament
//	@Tags			tournament
//	@Param			id		path	int						true	"Tournament ID"
//	@Param			kick	body	models.InviteTeamDto	true	"Kick"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/kick [delete]
func KickUserFromTournament(c *gin.Context) {
	var team models.Team

	tournament, _ := c.MustGet("tournament").(*models.Tournament)
	body, _ := c.MustGet("body").(models.InviteTeamDto)

	if err := team.FindOne("name", body.Name); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if !tournament.IsInTeam(team) {
		c.JSON(http.StatusConflict, gin.H{"error": "Team is not in this tournament"})
		return
	}

	if err := tournament.RemoveTeam(team); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// TogglePrivateTournament godoc
//
//	@Summary		toggle tournament privacy
//	@Description	toggle tournament privacy
//	@Tags			tournament
//	@Param			id	path	int	true	"Tournament ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/toggle-private [patch]
func TogglePrivateTournament(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)

	tournament.TogglePrivate()

	if err := tournament.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
