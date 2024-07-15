package controllers

import (
	"challenge/models"
	"challenge/services"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetMatch godoc
//
//	@Summary		Get a match
//	@Description 	Get a match by ID
//	@Tags 			match
//	@Accept 		json
//	@Produce 		json
//	@Param id 		path int true "Match ID"
//	@Success 		200 {object} models.Match
//	@Failure 		400 {object} utils.HttpError
//	@Failure 		404 {object} utils.HttpError
//	@Router 		/matches/{id} [get]
func GetMatch(c *gin.Context) {
	match, _ := c.MustGet("match").(*models.Match)
	c.JSON(http.StatusOK, match)
}

// GetMatchs godoc
//
//	@Summary		Get all matches
//	@Description 	Get all matches
//	@Tags 			match
//	@Accept 		json
//	@Produce 		json
//	@Param			limit query int false "Limit"
//	@Param			page query int false "Page"
//	@Param			sort query string false "Sort"
//	@Success 		200 {object} []models.Match
//	@Failure 		400 {object} utils.HttpError
//	@Failure 		404 {object} utils.HttpError
//	@Router 		/matches [get]
func GetMatchs(c *gin.Context) {
	query, _ := c.MustGet("query").(services.QueryFilter)

	matches, err := models.FindAllMatchs(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, matches)
}

// UpdateMatch godoc
//
//	@Summary		Update a match
//	@Description 	Update a match
//	@Tags 			match
//	@Accept 		json
//	@Produce 		json
//	@Param 			id path int true "Match ID"
//	@Param 			body body models.UpdateMatchDto true "Match"
//	@Success 		200 {object} models.Match
//	@Failure 		400 {object} utils.HttpError
//	@Failure 		404 {object} utils.HttpError
//	@Router 		/matches/{id} [patch]
func UpdateMatch(c *gin.Context) {
	ws := services.GetWebsocket()
	match, _ := c.MustGet("match").(*models.Match)
	body, _ := c.MustGet("body").(models.UpdateMatchDto)

	if body.Team1ID != nil {
		match.Team1ID = body.Team1ID
	}
	if body.Team2ID != nil {
		match.Team2ID = body.Team2ID
	}
	if body.Score1 != 0 {
		match.Score1 = body.Score1
	}
	if body.Score2 != 0 {
		match.Score2 = body.Score2
	}
	if body.Winner != models.NONE {
		match.Winner = body.Winner
	}
	if body.Status != "" {
		match.Status = body.Status
	}
	if body.NextMatchID != nil {
		match.NextMatchID = body.NextMatchID
	}

	if err := match.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	roomName := fmt.Sprintf("tournament:%d", match.TournamentID)
	_ = ws.Room(roomName).Emit("match:update", match)

	c.JSON(http.StatusOK, match)
}

// ScoreMatch godoc
//
//	@Summary		Score a match
//	@Description 	Score a match
//	@Tags 			match
//	@Accept 		json
//	@Produce 		json
//	@Param 			match path int true "Match ID"
//	@Param 			team path int true "Team ID"
//	@Param 			body body models.ScoreMatchDto true "Score"
//	@Success 		200 {object} models.Match
//	@Failure 		400 {object} utils.HttpError
//	@Failure 		404 {object} utils.HttpError
//	@Router 		/matches/{id}/team/{team}/score [patch]
func ScoreMatch(c *gin.Context) {
	ws := services.GetWebsocket()
	match, _ := c.MustGet("match").(*models.Match)
	team, _ := c.MustGet("team").(*models.Team)
	body, _ := c.MustGet("body").(models.ScoreMatchDto)

	match.SetScore(*team, body.Score)

	if err := match.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	roomName := fmt.Sprintf("tournament:%d", match.TournamentID)
	_ = ws.Room(roomName).Emit("match:update", match)

	c.JSON(http.StatusOK, match)
}

// CloseMatch godoc
//
//	@Summary		Close a match
//	@Description 	Close a match
//	@Tags 			match
//	@Accept 		json
//	@Produce 		json
//	@Param 			id path int true "Match ID"
//	@Param 			team path int true "Team ID"
//	@Success 		200 {object} models.Match
//	@Failure 		400 {object} utils.HttpError
//	@Failure 		404 {object} utils.HttpError
//	@Router 		/matches/{id}/team/{team}/close [patch]
func CloseMatch(c *gin.Context) {
	ws := services.GetWebsocket()
	match, _ := c.MustGet("match").(*models.Match)

	match.Close()

	if err := match.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	roomName := fmt.Sprintf("tournament:%d", match.TournamentID)
	_ = ws.Room(roomName).Emit("match:update", match)

	c.JSON(http.StatusOK, match)
}
