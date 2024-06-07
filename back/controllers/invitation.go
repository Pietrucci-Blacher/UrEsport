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
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	} else if len(tournaments) == 0 && len(teams) == 0 {
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
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, invit)
}

// AcceptInvit godoc
//
//	@Summary		accept an invitation
//	@Description	accept an invitation
//	@Tags			invitation
//	@Accept			json
//	@Produce		json
//	@Param			invit	path		int	true	"Invitation ID"
//	@Success		200	{object}	models.Invit
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/invit/{invit}/accept [get]
func AcceptInvit(c *gin.Context) {
	var err error

	invit, _ := c.MustGet("invit").(*models.Invit)

	if invit.Status != models.PENDING {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invitation already accepted or rejected"})
		return
	}

	invit.Status = models.ACCEPTED

	if invit.Type == models.TOURNAMENT_INVIT {
		err = invit.Tournament.AddTeam(invit.Team)
	} else if invit.Type == models.TEAM_INVIT {
		err = invit.Team.AddMember(invit.User)
	}

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := invit.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// DeclineInvit godoc
//
//	@Summary		decline an invitation
//	@Description	decline an invitation
//	@Tags			invitation
//	@Accept			json
//	@Produce		json
//	@Param			invit	path		int	true	"Invitation ID"
//	@Success		200	{object}	models.Invit
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/invit/{invit}/reject [get]
func RejectInvit(c *gin.Context) {
	invit, _ := c.MustGet("invit").(*models.Invit)

	if invit.Status != models.PENDING {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invitation already accepted or rejected"})
		return
	}

	invit.Status = models.REJECTED

	if err := invit.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
