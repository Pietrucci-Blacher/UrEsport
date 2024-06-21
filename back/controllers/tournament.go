package controllers

import (
	"challenge/models"
	"challenge/services"
	"fmt"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
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

	query, _ := c.MustGet("query").(services.QueryFilter)

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
	connectedUser, _ := c.MustGet("connectedUser").(models.User)
	body, _ := c.MustGet("body").(models.CreateTournamentDto)

	tournament := models.Tournament{
		Name:        body.Name,
		Description: body.Description,
		Location:    body.Location,
		Latitude:    body.Latitude,
		Longitude:   body.Longitude,
		StartDate:   body.StartDate,
		EndDate:     body.EndDate,
		OwnerID:     connectedUser.ID,
		Private:     body.Private,
		GameID:      body.GameID,
		NbPlayer:    body.NbPlayer,
	}

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
	if body.Latitude != 0 {
		tournament.Latitude = body.Latitude
	}
	if body.Longitude != 0 {
		tournament.Longitude = body.Longitude
	}
	if !body.StartDate.IsZero() {
		tournament.StartDate = body.StartDate
	}
	if !body.EndDate.IsZero() {
		tournament.EndDate = body.EndDate
	}
	if body.GameID != 0 {
		tournament.GameID = body.GameID
	}
	if body.NbPlayer >= 1 {
		tournament.NbPlayer = body.NbPlayer
	}

	if err := tournament.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, tournament)
}

// UpdateTournamentImage godoc
//
//	@Summary		update tournament image
//	@Description	update tournament image
//	@Tags			tournament
//	@Accept			multipart/form-data
//	@Produce		json
//	@Param			tournament		path	int		true	"Tournament ID"
//	@Param			upload[]		formData	file	true	"Image"
//	@Success		200			{object}	models.SanitizedTournament
//	@Failure		400			{object}	utils.HttpError
//	@Failure		401			{object}	utils.HttpError
//	@Failure		404			{object}	utils.HttpError
//	@Failure		500			{object}	utils.HttpError
//	@Router			/tournaments/{tournament}/image [post]
func UploadTournamentImage(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)
	files, _ := c.MustGet("files").([]string)

	tournament.Image = files[0]

	if err := tournament.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, tournament.Sanitize(false))
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

	if len(team.Members) != tournament.NbPlayer {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": fmt.Sprintf("Team must contain %d members", tournament.NbPlayer),
		})
		return
	}

	if tournament.HasTeam(*team) {
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

	if !tournament.HasTeam(*team) {
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
	var invit models.Invit

	tournament, _ := c.MustGet("tournament").(*models.Tournament)
	body, _ := c.MustGet("body").(models.InviteTeamDto)

	if err := team.FindOne("name", body.Name); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Team not found"})
		return
	}

	if tournament.HasTeam(team) {
		c.JSON(http.StatusConflict, gin.H{"error": "Team is already in this tournament"})
		return
	}

	if len(team.Members) != tournament.NbPlayer {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": fmt.Sprintf("Team must contain %d members", tournament.NbPlayer),
		})
		return
	}

	if err := invit.FindOneByTournamentAndTeam(tournament.ID, team.ID); err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "Team already invited"})
		return
	}

	if models.NewTournamentInvit(tournament.ID, team.ID).Save() != nil {
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

	if !tournament.HasTeam(team) {
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

// AcceptTournamentInvitation godoc
//
//	@Summary		accept tournament invitation
//	@Description	accept tournament invitation
//	@Tags			tournament
//	@Param			tournament	path	int	true	"Tournament ID"
//	@Param			team		path	int	true	"Team ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{tournament}/team/{team}/accept [get]
func AcceptTournamentInvitation(c *gin.Context) {
	var invit models.Invit

	tournament, _ := c.MustGet("tournament").(*models.Tournament)
	team, _ := c.MustGet("team").(*models.Team)

	if tournament.HasTeam(*team) {
		c.JSON(http.StatusConflict, gin.H{"error": "Team is already in this tournament"})
		return
	}

	if len(team.Members) != tournament.NbPlayer {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": fmt.Sprintf("Team must contain %d members", tournament.NbPlayer),
		})
		return
	}

	if err := invit.FindOneByTournamentAndTeam(tournament.ID, team.ID); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Invitation not found"})
		return
	}

	if err := tournament.AddTeam(*team); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	invit.Status = models.ACCEPTED

	if err := invit.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// RejectTournamentInvitation godoc
//
//	@Summary		reject tournament invitation
//	@Description	reject tournament invitation
//	@Tags			tournament
//	@Param			tournament	path	int	true	"Tournament ID"
//	@Param			team		path	int	true	"Team ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{tournament}/team/{team}/reject [get]
func RejectTournamentInvitation(c *gin.Context) {
	var invit models.Invit

	tournament, _ := c.MustGet("tournament").(*models.Tournament)
	team, _ := c.MustGet("team").(*models.Team)

	if err := invit.FindOneByTournamentAndTeam(tournament.ID, team.ID); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Invitation not found"})
		return
	}

	invit.Status = models.REJECTED

	if err := invit.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// AddUpvote godoc
//
//	@Summary		add upvote to tournament
//	@Description	add upvote to tournament
//	@Tags			tournament
//	@Param			id	path	int	true	"Tournament ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/upvote [post]
func AddUpvote(c *gin.Context) {
	connectedUser, exists := c.Get("connectedUser")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
		return
	}

	user, ok := connectedUser.(models.User)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid user"})
		return
	}

	tournament, exists := c.Get("tournament")
	if !exists {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Tournament not found in context"})
		return
	}

	// Cast to the correct type
	t, ok := tournament.(*models.Tournament)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid tournament type"})
		return
	}

	// Log the tournament ID
	log.Printf("Tournament ID: %d", t.ID)

	// Perform the upvote
	if err := t.AddUpvote(user.ID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Upvote toggled"})
}
