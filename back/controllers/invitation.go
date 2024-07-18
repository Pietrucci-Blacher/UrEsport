package controllers

import (
	"challenge/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetInvitTournament godoc
//
//	@Summary		get all invitations for a tournament
//	@Description	get all invitations for a tournament
//	@Tags			invitation
//	@Accept			json
//	@Produce		json
//	@Param			inout	path		int	true	"Inbound or Outbound"
//	@Success		200	{object}	[]models.Invit
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/invit/tournaments/{inout} [get]
func GetInvitTournament(c *gin.Context) {
	var err error
	var ids []int
	var param string
	var tournaments []models.Tournament
	var teams []models.Team
	var invit []models.Invit = []models.Invit{}

	connectedUser := c.MustGet("connectedUser").(models.User)
	inout := c.Param("inout")

	if inout == "outbound" {
		param = "tournament_id"
		tournaments, err = models.FindTournamentsByUserID(connectedUser.ID)
	} else if inout == "inbound" {
		param = "team_id"
		teams, err = models.FindTeamsByUserID(connectedUser.ID)
	} else {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid inout parameter"})
		return
	}

	if err != nil {
		models.ErrorLogf([]string{"invit", "GetInvitTournament"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	} else if len(tournaments) == 0 && len(teams) == 0 {
		models.PrintLogf([]string{"invit", "GetInvitTournament"}, "No tournament or team found")
		c.JSON(http.StatusOK, invit)
		return
	}

	if len(tournaments) > 0 {
		for _, tournament := range tournaments {
			ids = append(ids, tournament.ID)
		}
	} else if len(teams) > 0 {
		for _, team := range teams {
			ids = append(ids, team.ID)
		}
	}

	invit, err = models.FindInvitByType(models.TOURNAMENT_INVIT, param, ids)
	if err != nil {
		models.ErrorLogf([]string{"invit", "GetInvitTournament"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, invit)
}

// GetInvitTeam godoc
//
//	@Summary		get all invitations for a team
//	@Description	get all invitations for a team
//	@Tags			invitation
//	@Accept			json
//	@Produce		json
//	@Param			inout	path		int	true	"Inbound or Outbound"
//	@Success		200	{object}	[]models.Invit
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/invit/teams/{inout} [get]
func GetInvitTeam(c *gin.Context) {
	var err error
	var ids []int
	var param string
	var teams []models.Team
	var invit []models.Invit = []models.Invit{}

	connectedUser := c.MustGet("connectedUser").(models.User)
	inout := c.Param("inout")

	if inout == "outbound" {
		param = "team_id"
		teams, err = models.FindTeamsByUserID(connectedUser.ID)
	} else if inout == "inbound" {
		param = "user_id"
		ids = []int{connectedUser.ID}
	} else {
		models.ErrorLogf([]string{"invit", "GetInvitTeam"}, "Invalid inout parameter")
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid inout parameter"})
		return
	}

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	} else if inout == "outbound" && len(teams) == 0 {
		c.JSON(http.StatusOK, invit)
		return
	}

	if len(teams) > 0 {
		for _, team := range teams {
			ids = append(ids, team.ID)
		}
	}

	invit, err = models.FindInvitByType(models.TEAM_INVIT, param, ids)
	if err != nil {
		models.ErrorLogf([]string{"invit", "GetInvitTeam"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, invit)
}
