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
	tournament, _ := c.MustGet("tournament").(models.Tournament)

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

	connectedUser, _ := c.MustGet("user").(models.User)
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
	tournament, _ := c.MustGet("tournament").(models.Tournament)
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
	tournament, _ := c.MustGet("tournament").(models.Tournament)

	if err := tournament.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// JoinTournament godoc
//
//	@Summary		join yourself to a tournament
//	@Description	join yourself to a tournament
//	@Tags			tournament
//	@Param			id	path	int	true	"Tournament ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/join [post]
func JoinTournament(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(models.Tournament)

	if tournament.Private {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "This tournament is private"})
		return
	}

	connectedUser, _ := c.MustGet("user").(models.User)

	if err := tournament.AddParticipant(connectedUser); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// LeaveTournament godoc
//
//	@Summary		leave yourself from a tournament
//	@Description	leave yourself from a tournament
//	@Tags			tournament
//	@Param			id	path	int	true	"Tournament ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/leave [delete]
func LeaveTournament(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(models.Tournament)
	connectedUser, _ := c.MustGet("user").(models.User)

	if err := tournament.RemoveParticipant(connectedUser); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// InviteUser godoc
//
//	@Summary		invite user to your tournament
//	@Description	invite user to your tournament
//	@Tags			tournament
//	@Param			id		path	int						true	"Tournament ID"
//	@Param			invite	body	models.InviteUserDto	true	"Invite"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/invite [post]
func InviteUserToTournament(c *gin.Context) {
	var userToInvite models.User

	tournament, _ := c.MustGet("tournament").(models.Tournament)
	body, _ := c.MustGet("body").(models.InviteUserDto)

	if err := userToInvite.FindOne("username", body.Username); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if err := tournament.AddParticipant(userToInvite); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// KickUserFromTournament godoc
//
//	@Summary		kick user from your tournament
//	@Description	kick user from your tournament
//	@Tags			tournament
//	@Param			id		path	int						true	"Tournament ID"
//	@Param			kick	body	models.InviteUserDto	true	"Kick"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/kick [delete]
func KickUserFromTournament(c *gin.Context) {
	var userToKick models.User

	tournament, _ := c.MustGet("tournament").(models.Tournament)
	body, _ := c.MustGet("body").(models.InviteUserDto)

	if err := userToKick.FindOne("username", body.Username); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if err := tournament.RemoveParticipant(userToKick); err != nil {
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
	tournament, _ := c.MustGet("tournament").(models.Tournament)

	tournament.TogglePrivate()

	if err := tournament.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
