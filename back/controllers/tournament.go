package controllers

import (
	"challenge/models"
	"challenge/services"
	"errors"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
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
		models.ErrorLogf([]string{"tournament", "GetTournaments"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	for _, tournament := range tournaments {
		sanitized = append(sanitized, tournament.Sanitize(true))
	}

	models.PrintLogf([]string{"tournament", "GetTournaments"}, "Fetched %d tournaments", len(sanitized))
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

	models.PrintLogf([]string{"tournament", "GetTournament"}, "Fetched tournament %s", tournament.Name)
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

	defaultImageURL := "https://www.mucem.org/sites/default/files/styles/default-thumbnail.jpg"

	imageURL := body.Image
	if imageURL == "" {
		imageURL = defaultImageURL
	}

	tournament := models.Tournament{
		Name:        body.Name,
		Description: body.Description,
		StartDate:   body.StartDate,
		EndDate:     body.EndDate,
		Location:    body.Location,
		Latitude:    body.Latitude,
		Longitude:   body.Longitude,
		OwnerID:     connectedUser.ID,
		Image:       imageURL,
		//Image:       body.Image,
		Private:  body.Private,
		GameID:   body.GameID,
		NbPlayer: body.NbPlayer,
		Upvotes:  0,
	}

	if err := tournament.Save(); err != nil {
		models.ErrorLogf([]string{"tournament", "CreateTournament"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "CreateTournament"}, "Tournament %s created", tournament.Name)
	c.JSON(http.StatusCreated, tournament)
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
	if !body.StartDate.IsZero() {
		tournament.StartDate = body.StartDate
	}
	if !body.EndDate.IsZero() {
		tournament.EndDate = body.EndDate
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
	if body.Image != "" {
		tournament.Image = body.Image
	}
	if body.NbPlayer != 0 {
		tournament.NbPlayer = body.NbPlayer
	}
	if !body.StartDate.IsZero() {
		tournament.StartDate = body.StartDate
	}
	if !body.EndDate.IsZero() {
		tournament.EndDate = body.EndDate
	}
	if body.NbPlayer >= 1 {
		tournament.NbPlayer = body.NbPlayer
	}

	tournament.Private = body.Private

	if body.GameID != 0 {
		var game models.Game
		if err := game.FindOneById(body.GameID); err != nil {
			models.ErrorLogf([]string{"tournament", "UpdateTournament"}, "%s", err.Error())
			c.JSON(http.StatusNotFound, gin.H{"error": "Game not found"})
			return
		}
		tournament.GameID = body.GameID
	}

	if err := tournament.Save(); err != nil {
		models.ErrorLogf([]string{"tournament", "UpdateTournament"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "UpdateTournament"}, "Tournament %s updated", tournament.Name)
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
		models.ErrorLogf([]string{"tournament", "UploadTournamentImage"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "UploadTournamentImage"}, "Tournament %s image updated", tournament.Name)
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
		models.ErrorLogf([]string{"tournament", "DeleteTournament"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "DeleteTournament"}, "Tournament %s deleted", tournament.Name)
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
		models.ErrorLogf([]string{"tournament", "JoinTournament"}, "Tournament %s is private", tournament.Name)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "This tournament is private"})
		return
	}

	if tournament.IsUserHasTeamInTournament(team.OwnerID) {
		models.ErrorLogf([]string{"tournament", "JoinTournament"}, "User %d already has a team in this tournament", team.OwnerID)
		c.JSON(http.StatusConflict, gin.H{"error": "You already have a team in this tournament"})
		return
	}

	if len(team.Members) != tournament.NbPlayer {
		models.ErrorLogf([]string{"tournament", "JoinTournament"}, "Team %s must contain %d members", team.Name, tournament.NbPlayer)
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": fmt.Sprintf("Team must contain %d members", tournament.NbPlayer),
		})
		return
	}

	if tournament.HasTeam(*team) {
		models.ErrorLogf([]string{"tournament", "JoinTournament"}, "Team %s already in this tournament", team.Name)
		c.JSON(http.StatusConflict, gin.H{"error": "Team already in this tournament"})
		return
	}

	if err := tournament.AddTeam(*team); err != nil {
		models.ErrorLogf([]string{"tournament", "JoinTournament"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "JoinTournament"}, "Team %s joined tournament %s", team.Name, tournament.Name)
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
		models.ErrorLogf([]string{"tournament", "LeaveTournament"}, "Team %s not found in this tournament", team.Name)
		c.JSON(http.StatusNotFound, gin.H{"error": "Team not found in this tournament"})
		return
	}

	if err := tournament.RemoveTeam(*team); err != nil {
		models.ErrorLogf([]string{"tournament", "LeaveTournament"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "LeaveTournament"}, "Team %s left tournament %s", team.Name, tournament.Name)
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
		models.ErrorLogf([]string{"tournament", "InviteTeamToTournament"}, "Team %s not found", body.Name)
		c.JSON(http.StatusNotFound, gin.H{"error": "Team not found"})
		return
	}

	if tournament.IsUserHasTeamInTournament(team.OwnerID) {
		models.ErrorLogf([]string{"tournament", "InviteTeamToTournament"}, "User %d already has a team in this tournament", team.OwnerID)
		c.JSON(http.StatusConflict, gin.H{"error": "User already has a team in this tournament"})
		return
	}

	if tournament.HasTeam(team) {
		models.ErrorLogf([]string{"tournament", "InviteTeamToTournament"}, "Team %s already in this tournament", team.Name)
		c.JSON(http.StatusConflict, gin.H{"error": "Team is already in this tournament"})
		return
	}

	if len(team.Members) != tournament.NbPlayer {
		models.ErrorLogf([]string{"tournament", "InviteTeamToTournament"}, "Team %s must contain %d members", team.Name, tournament.NbPlayer)
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": fmt.Sprintf("Team must contain %d members", tournament.NbPlayer),
		})
		return
	}

	if err := invit.FindOneByTournamentAndTeam(tournament.ID, team.ID); err == nil {
		models.ErrorLogf([]string{"tournament", "InviteTeamToTournament"}, "Team %s already invited", team.Name)
		c.JSON(http.StatusConflict, gin.H{"error": "Team already invited"})
		return
	}

	if models.NewTournamentInvit(tournament.ID, team.ID).Save() != nil {
		models.ErrorLogf([]string{"tournament", "InviteTeamToTournament"}, "Error while saving invitation")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while saving invitation"})
		return
	}

	models.PrintLogf([]string{"tournament", "InviteTeamToTournament"}, "Team %s invited to tournament %s", team.Name, tournament.Name)
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
		models.ErrorLogf([]string{"tournament", "KickUserFromTournament"}, "Team %s not found", body.Name)
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if !tournament.HasTeam(team) {
		models.ErrorLogf([]string{"tournament", "KickUserFromTournament"}, "Team %s not in this tournament", team.Name)
		c.JSON(http.StatusConflict, gin.H{"error": "Team is not in this tournament"})
		return
	}

	if err := tournament.RemoveTeam(team); err != nil {
		models.ErrorLogf([]string{"tournament", "KickUserFromTournament"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "KickUserFromTournament"}, "Team %s kicked from tournament %s", team.Name, tournament.Name)
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
		models.ErrorLogf([]string{"tournament", "TogglePrivateTournament"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "TogglePrivateTournament"}, "Tournament %s privacy toggled", tournament.Name)
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
		models.ErrorLogf([]string{"tournament", "AcceptTournamentInvitation"}, "Team %s already in this tournament", team.Name)
		c.JSON(http.StatusConflict, gin.H{"error": "Team is already in this tournament"})
		return
	}

	if tournament.IsUserHasTeamInTournament(team.OwnerID) {
		models.ErrorLogf([]string{"tournament", "AcceptTournamentInvitation"}, "User %d already has a team in this tournament", team.OwnerID)
		c.JSON(http.StatusConflict, gin.H{"error": "User already has a team in this tournament"})
		return
	}

	if len(team.Members) != tournament.NbPlayer {
		models.ErrorLogf([]string{"tournament", "AcceptTournamentInvitation"}, "Team %s must contain %d members", team.Name, tournament.NbPlayer)
		c.JSON(http.StatusUnauthorized, gin.H{
			"error": fmt.Sprintf("Team must contain %d members", tournament.NbPlayer),
		})
		return
	}

	if err := invit.FindOneByTournamentAndTeam(tournament.ID, team.ID); err != nil {
		models.ErrorLogf([]string{"tournament", "AcceptTournamentInvitation"}, "Invitation not found")
		c.JSON(http.StatusNotFound, gin.H{"error": "Invitation not found"})
		return
	}

	if err := tournament.AddTeam(*team); err != nil {
		models.ErrorLogf([]string{"tournament", "AcceptTournamentInvitation"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	invit.Status = models.ACCEPTED

	if err := invit.Save(); err != nil {
		models.ErrorLogf([]string{"tournament", "AcceptTournamentInvitation"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "AcceptTournamentInvitation"}, "Team %s accepted invitation to tournament %s", team.Name, tournament.Name)
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
		models.ErrorLogf([]string{"tournament", "RejectTournamentInvitation"}, "Invitation not found")
		c.JSON(http.StatusNotFound, gin.H{"error": "Invitation not found"})
		return
	}

	invit.Status = models.REJECTED

	if err := invit.Save(); err != nil {
		models.ErrorLogf([]string{"tournament", "RejectTournamentInvitation"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "RejectTournamentInvitation"}, "Team %s rejected invitation to tournament %s", team.Name, tournament.Name)
	c.JSON(http.StatusNoContent, nil)
}

// GenerateTournamentBracket godoc
//
//	@Summary		generate tournament bracket
//	@Description	generate tournament bracket
//	@Tags			tournament
//	@Param			id	path	int	true	"Tournament ID"
//	@Success		204
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/bracket [post]
func GenerateTournamentBracket(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)

	if len(tournament.Teams) < 2 {
		models.ErrorLogf([]string{"tournament", "GenerateTournamentBracket"}, "Not enough teams to generate bracket")
		c.JSON(http.StatusConflict, gin.H{"error": "Not enough teams to generate bracket"})
		return
	}

	countMatchs, err := models.CountMatchsByTournamentID(tournament.ID)
	if err != nil {
		models.ErrorLogf([]string{"tournament", "GenerateTournamentBracket"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	} else if countMatchs > 0 {
		models.ErrorLogf([]string{"tournament", "GenerateTournamentBracket"}, "Bracket already generated")
		c.JSON(http.StatusConflict, gin.H{"error": "Bracket already generated"})
		return
	}

	matches, err := tournament.GenerateBraketTree()
	if err != nil {
		models.ErrorLogf([]string{"tournament", "GenerateTournamentBracket"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "GenerateTournamentBracket"}, "Bracket generated for tournament %s", tournament.Name)
	c.JSON(http.StatusOK, matches)
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
	connectedUser, _ := c.MustGet("connectedUser").(models.User)
	tournament, _ := c.MustGet("tournament").(*models.Tournament)

	if err := tournament.AddUpvote(connectedUser.ID); err != nil {
		models.ErrorLogf([]string{"tournament", "AddUpvote"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "AddUpvote"}, "Upvote added to tournament %s", tournament.Name)
	c.JSON(http.StatusOK, gin.H{"message": "Upvote toggled"})
}

// GetTournamentUpvote godoc
//
//	@Summary		get tournament upvote
//	@Description	get tournament upvote
//	@Tags			tournament
//	@Param			id	path	int	true	"Tournament ID"
//	@Success		200	{object}	models.Upvote
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/upvote [get]
func GetTournamentUpvote(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)

	models.PrintLogf([]string{"tournament", "GetTournamentUpvote"}, "Upvote count for tournament %s", tournament.Name)
	c.JSON(http.StatusOK, gin.H{"upvote": tournament.Upvotes})
}

type SimpleUpvote struct {
	ID           uint      `json:"id"`
	UserID       uint      `json:"user_id"`
	TournamentID uint      `json:"tournament_id"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

// GetUpvoteById godoc
//
//	@Summary		get upvote by user and tournament ID
//	@Description	get upvote by user and tournament ID
//	@Tags			tournament
//	@Param			id		path	int	true	"Tournament ID"
//	@Param			userid	path	int	true	"User ID"
//	@Success		200	{object}	SimpleUpvote
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/upvotes/{userid} [get]
func GetUpvoteById(c *gin.Context) {
	connectedUser, _ := c.MustGet("connectedUser").(models.User)
	tournament, _ := c.MustGet("tournament").(*models.Tournament)

	upvote, err := models.GetUpvoteByUserAndTournament(uint(connectedUser.ID), uint(tournament.ID))
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			models.ErrorLogf([]string{"tournament", "GetUpvoteById"}, "Upvote not found for user %d and tournament %d", connectedUser.ID, tournament.ID)
			c.JSON(http.StatusNotFound, gin.H{"error": "Upvote not found"})
		} else {
			models.ErrorLogf([]string{"tournament", "GetUpvoteById"}, "%s", err.Error())
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		}
		return
	}

	models.ErrorLogf([]string{"tournament", "GetUpvoteById"}, "Upvote found: %v", upvote)
	c.JSON(http.StatusOK, upvote)
}

// GetTeamsToTournamentId godoc
//
//	@Summary		get teams by tournament ID
//	@Description	get teams by tournament ID
//	@Tags			tournament
//	@Param			id	path	int	true	"Tournament ID"
//	@Success		200	{object}	[]models.Team
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/teams [get]
func GetTeamsToTournamentId(c *gin.Context) {
	tournament, _ := c.MustGet("tournament").(*models.Tournament)

	teams, err := tournament.GetTeamsByTournamentID(tournament.ID)
	if err != nil {
		models.ErrorLogf([]string{"tournament", "GetTeamsToTournamentId"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"tournament", "GetTeamsToTournamentId"}, "Fetched %d teams for tournament %s", len(teams), tournament.Name)
	c.JSON(http.StatusOK, teams)
}

// GetHasJoinedTournament godoc
//
//	@Summary		check if user has joined tournament
//	@Description	check if user has joined tournament
//	@Tags			tournament
//	@Param			id		path	int	true	"Tournament ID"
//	@Param			userid	path	int	true	"User ID"
//	@Success		200	{object}	bool
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/tournaments/{id}/joined/{userid} [get]
func GetHasJoinedTournament(c *gin.Context) {
	connectedUser, _ := c.MustGet("connectedUser").(models.User)
	tournament, _ := c.MustGet("tournament").(*models.Tournament)

	hasJoined := tournament.IsUserHasTeamInTournament(connectedUser.ID)

	models.PrintLogf([]string{"tournament", "GetHasJoinedTournament"}, "User %d has joined tournament %d: %t", connectedUser.ID, tournament.ID, hasJoined)
	c.JSON(http.StatusOK, gin.H{"hasJoined": hasJoined})
}
