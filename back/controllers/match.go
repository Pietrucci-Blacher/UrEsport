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
	models.PrintLogf([]string{"match", "GetMatch"}, "Fetched match %d", match.ID)
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
		models.ErrorLogf([]string{"match", "GetMatchs"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"match", "GetMatchs"}, "Fetched %d matches", len(matches))
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
	if body.WinnerID != nil {
		match.WinnerID = body.WinnerID
	}
	if body.Status != "" {
		match.Status = body.Status
	}
	if body.NextMatchID != nil {
		match.NextMatchID = body.NextMatchID
	}

	if err := match.Save(); err != nil {
		models.ErrorLogf([]string{"match", "UpdateMatch"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	roomName := fmt.Sprintf("tournament:%d", match.TournamentID)
	_ = ws.Room(roomName).Emit("match:update", match)
	_ = ws.Room(roomName).Emit("bracket:update", match)

	models.PrintLogf([]string{"match", "UpdateMatch"}, "Match %d updated", match.ID)
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

	if match.Status != models.PLAYING {
		models.ErrorLogf([]string{"match", "ScoreMatch"}, "Match %d is not playing", match.ID)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Match is not playing"})
		return
	}

	isTeam1 := team.ID == *match.Team1ID
	isTeam2 := team.ID == *match.Team2ID

	if isTeam1 && match.Team1Close || isTeam2 && match.Team2Close {
		models.ErrorLogf([]string{"match", "ScoreMatch"}, "You can't score if you want to close the match %d", match.ID)
		c.JSON(http.StatusBadRequest, gin.H{"error": "You can't score if you want to close the match"})
		return
	}

	match.SetScore(*team, body.Score)
	match.Team1Close = false
	match.Team2Close = false

	if err := match.Save(); err != nil {
		models.ErrorLogf([]string{"match", "ScoreMatch"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	roomName := fmt.Sprintf("tournament:%d", match.TournamentID)
	_ = ws.Room(roomName).Emit("match:update", match)
	_ = ws.Room(roomName).Emit("bracket:update", match)

	models.PrintLogf([]string{"match", "ScoreMatch"}, "Match %d scored", match.ID)
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
	var nextMatch models.Match

	ws := services.GetWebsocket()
	match, _ := c.MustGet("match").(*models.Match)
	team, _ := c.MustGet("team").(*models.Team)
	roomName := fmt.Sprintf("tournament:%d", match.TournamentID)

	if match.Status != models.PLAYING {
		models.ErrorLogf([]string{"match", "CloseMatch"}, "Match %d is not playing", match.ID)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Match is not playing"})
		return
	}

	match.TeamWantToClose(team.ID)

	if !match.Team1Close || !match.Team2Close {
		if err := match.Save(); err != nil {
			models.ErrorLogf([]string{"match", "CloseMatch"}, "%s", err.Error())
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		_ = ws.Room(roomName).Emit("match:update", match)
		models.PrintLogf([]string{"match", "CloseMatch"}, "Match %d closed by team %d", match.ID, team.ID)
		c.JSON(http.StatusOK, match)
		return
	}

	if match.Score1 == match.Score2 && match.Team1Close && match.Team2Close {
		models.ErrorLogf([]string{"match", "CloseMatch"}, "Match %d can't be a draw", match.ID)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Match can't be a draw"})
		return
	}

	match.Close()

	if err := nextMatch.FindOneById(*match.NextMatchID); err != nil {
		models.ErrorLogf([]string{"match", "CloseMatch"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	nextMatch.SetWinnerToMatch(match.WinnerID)

	if nextMatch.Team1ID == nil || nextMatch.Team2ID == nil {
		if err := match.Save(); err != nil {
			models.ErrorLogf([]string{"match", "CloseMatch"}, "%s", err.Error())
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		if err := nextMatch.Save(); err != nil {
			models.ErrorLogf([]string{"match", "CloseMatch"}, "%s", err.Error())
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		_ = ws.Room(roomName).Emit("match:update", match)
		_ = ws.Room(roomName).Emit("match:update", nextMatch)
		models.PrintLogf([]string{"match", "CloseMatch"}, "Match %d closed by team %d", match.ID, team.ID)
		c.JSON(http.StatusOK, match)
		return
	}

	nextMatch.Status = models.PLAYING

	if err := match.Save(); err != nil {
		models.ErrorLogf([]string{"match", "CloseMatch"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if err := nextMatch.Save(); err != nil {
		models.ErrorLogf([]string{"match", "CloseMatch"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	_ = ws.Room(roomName).Emit("match:update", match)
	_ = ws.Room(roomName).Emit("match:update", nextMatch)
	_ = ws.Room(roomName).Emit("bracket:update", match)
	_ = ws.Room(roomName).Emit("bracket:update", nextMatch)
	models.PrintLogf([]string{"match", "CloseMatch"}, "Match %d closed by team %d", match.ID, team.ID)
	c.JSON(http.StatusOK, match)
}
