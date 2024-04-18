package controllers

import (
	"challenge/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
)

// GetTournaments godoc
// @Summary      get all tournaments
// @Description  get all tournaments
// @Tags         tournament
// @Accept       json
// @Produce      json
// @Success      200  {object} []models.Tournament
// @Failure      500  {object} utils.HttpError
// @Router       /tournaments/ [get]
func GetTournaments(c *gin.Context) {
	tournaments, err := models.FindAllTournaments()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, tournaments)
}

// GetTournament godoc
// @Summary      get tournament by id
// @Description  get tournament by id
// @Tags         tournament
// @Accept       json
// @Produce      json
// @Param        id path int true "Tournament ID"
// @Success      200  {object} models.Tournament
// @Failure      404  {object} utils.HttpError
// @Failure      500  {object} utils.HttpError
// @Router       /tournaments/{id} [get]
func GetTournament(c *gin.Context) {
	var tournament models.Tournament

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := tournament.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tournament not found"})
		return
	}

	c.JSON(http.StatusOK, tournament)
}

// CreateTournament godoc
// @Summary      create tournament
// @Description  create tournament
// @Tags         tournament
// @Accept       json
// @Produce      json
// @Param        tournament body models.CreateTournamentDto true "Tournament"
// @Success      200  {object} models.Tournament
// @Failure      400  {object} utils.HttpError
// @Failure      500  {object} utils.HttpError
// @Router       /tournaments/ [post]
func CreateTournament(c *gin.Context) {
	var tournament models.Tournament
	var data models.CreateTournamentDto

	connectedUser, _ := c.MustGet("user").(models.User)

	if err := c.BindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	validate := validator.New()
	if err := validate.Struct(data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	tournament.Name = data.Name
	tournament.Description = data.Description
	tournament.Location = data.Location
	tournament.Image = data.Image
	tournament.StartDate = data.StartDate
	tournament.EndDate = data.EndDate
	tournament.OrganizerID = connectedUser.ID
	tournament.Private = data.Private

	if err := tournament.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, tournament)
}

// UpdateTournament godoc
// @Summary      update tournament
// @Description  update tournament
// @Tags         tournament
// @Accept       json
// @Produce      json
// @Param        tournament body models.UpdateTournamentDto true "Tournament"
// @Param        id path int true "Tournament ID"
// @Success      200  {object} models.Tournament
// @Failure      400  {object} utils.HttpError
// @Failure      401  {object} utils.HttpError
// @Failure      404  {object} utils.HttpError
// @Failure      500  {object} utils.HttpError
// @Router       /tournaments/{id} [put]
func UpdateTournament(c *gin.Context) {
	var tournament models.Tournament
	var data models.UpdateTournamentDto

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := tournament.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tournament not found"})
		return
	}

	connectedUser, _ := c.MustGet("user").(models.User)

	if connectedUser.ID != tournament.OrganizerID && !connectedUser.IsRole(models.ROLE_ADMIN) {
		c.JSON(
			http.StatusUnauthorized,
			gin.H{"error": "You are not allowed to update this tournament"},
		)
		return
	}

	if err := c.BindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	validate := validator.New()
	if err := validate.Struct(data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if data.Name != "" {
		tournament.Name = data.Name
	}
	if data.Description != "" {
		tournament.Description = data.Description
	}
	if data.Location != "" {
		tournament.Location = data.Location
	}
	if data.Image != "" {
		tournament.Image = data.Image
	}
	if !data.StartDate.IsZero() {
		tournament.StartDate = data.StartDate
	}
	if !data.EndDate.IsZero() {
		tournament.EndDate = data.EndDate
	}

	if err := tournament.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, tournament)
}

// DeleteTournament godoc
// @Summary      delete tournament
// @Description  delete tournament
// @Tags         tournament
// @Param        id path int true "Tournament ID"
// @Success      204
// @Failure      401  {object} utils.HttpError
// @Failure      404  {object} utils.HttpError
// @Failure      500  {object} utils.HttpError
// @Router       /tournaments/{id} [delete]
func DeleteTournament(c *gin.Context) {
	var tournament models.Tournament

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := tournament.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tournament not found"})
		return
	}

	connectedUser, _ := c.MustGet("user").(models.User)

	if connectedUser.ID != tournament.OrganizerID && !connectedUser.IsRole(models.ROLE_ADMIN) {
		c.JSON(
			http.StatusUnauthorized,
			gin.H{"error": "You are not allowed to delete this tournament"},
		)
		return
	}

	if err := tournament.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// JoinTournament godoc
// @Summary      add participant to tournament
// @Description  add participant to tournament
// @Tags         tournament
// @Param        id path int true "Tournament ID"
// @Success      204
// @Failure      401  {object} utils.HttpError
// @Failure      404  {object} utils.HttpError
// @Failure      500  {object} utils.HttpError
// @Router       /tournaments/{id}/join [post]
func JoinTournament(c *gin.Context) {
	var tournament models.Tournament

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := tournament.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tournament not found"})
		return
	}

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
// @Summary      remove participant from tournament
// @Description  remove participant from tournament
// @Tags         tournament
// @Param        id path int true "Tournament ID"
// @Success      204
// @Failure      401  {object} utils.HttpError
// @Failure      404  {object} utils.HttpError
// @Failure      500  {object} utils.HttpError
// @Router       /tournaments/{id}/leave [delete]
func LeaveTournament(c *gin.Context) {
	var tournament models.Tournament

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := tournament.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tournament not found"})
		return
	}

	connectedUser, _ := c.MustGet("user").(models.User)

	if err := tournament.RemoveParticipant(connectedUser); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// InviteUser godoc
// @Summary      invite user to tournament
// @Description  invite user to tournament
// @Tags         tournament
// @Param        id path int true "Tournament ID"
// @Param        invite body models.InviteUserDto  true "Invite"
// @Success      204
// @Failure      401  {object} utils.HttpError
// @Failure      404  {object} utils.HttpError
// @Failure      500  {object} utils.HttpError
// @Router       /tournaments/{id}/invite [post]
func InviteUserToTournament(c *gin.Context) {
	var tournament models.Tournament
	var data models.InviteUserDto
	var userToInvite models.User

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := tournament.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tournament not found"})
		return
	}

	connectedUser, _ := c.MustGet("user").(models.User)

	if connectedUser.ID != tournament.OrganizerID && !connectedUser.IsRole(models.ROLE_ADMIN) {
		c.JSON(
			http.StatusUnauthorized,
			gin.H{"error": "You are not allowed to invite user to this tournament"},
		)
		return
	}

	if err := c.BindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	validate := validator.New()
	if err := validate.Struct(data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := userToInvite.FindOne("username", data.Username); err != nil {
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
// @Summary      kick user from tournament
// @Description  kick user from tournament
// @Tags         tournament
// @Param        id path int true "Tournament ID"
// @Param        kick body models.InviteUserDto  true "Kick"
// @Success      204
// @Failure      401  {object} utils.HttpError
// @Failure      404  {object} utils.HttpError
// @Failure      500  {object} utils.HttpError
// @Router       /tournaments/{id}/kick [delete]
func KickUserFromTournament(c *gin.Context) {
	var tournament models.Tournament
	var data models.InviteUserDto
	var userToKick models.User

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := tournament.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tournament not found"})
		return
	}

	connectedUser, _ := c.MustGet("user").(models.User)

	if connectedUser.ID != tournament.OrganizerID && !connectedUser.IsRole(models.ROLE_ADMIN) {
		c.JSON(
			http.StatusUnauthorized,
			gin.H{"error": "You are not allowed to kick user from this tournament"},
		)
		return
	}

	if err := c.BindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	validate := validator.New()
	if err := validate.Struct(data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := userToKick.FindOne("username", data.Username); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if err := tournament.RemoveParticipant(userToKick); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
