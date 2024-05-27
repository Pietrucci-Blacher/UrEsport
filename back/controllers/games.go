package controllers

import (
	"challenge/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetGames godoc
//
//	@Summary		get all games
//	@Description	get all games
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Success		200	{object}	[]models.SanitizedGame
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/ [get]
func GetGames(c *gin.Context) {

	games, err := models.FindAllGames()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, games)
}

// GetGame godoc
//
//	@Summary		get game by id
//	@Description	get game by id
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Game ID"
//	@Success		200	{object}	models.SanitizedGame
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/{id} [get]
func GetGame(c *gin.Context) {
	game, _ := c.MustGet("game").(models.Game)

	c.JSON(http.StatusOK, game)

}

// CreateGame godoc
//
//	@Summary		create a game
//	@Description	create a game
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			game	body		models.CreateGameDto	true	"Game object"
//	@Success		201		{object}	models.SanitizedGame
//	@Failure		400		{object}	utils.HttpError
//	@Failure		500		{object}	utils.HttpError
//	@Router			/games/ [post]
func CreateGame(c *gin.Context) {
	var dto models.CreateGameDto
	if err := c.ShouldBindJSON(&dto); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	game := models.Game{
		Name:        dto.Name,
		Description: dto.Description,
		Image:       dto.Image,
	}

	if err := game.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, game)
}

// UpdateGame godoc
//
//	@Summary		update a game
//	@Description	update a game
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			id		path		int						true	"Game ID"
//	@Param			game	body		models.UpdateGameDto	true	"Game object"
//	@Success		200		{object}	models.SanitizedGame
//	@Failure		400		{object}	utils.HttpError
//	@Failure		404		{object}	utils.HttpError
//	@Failure		500		{object}	utils.HttpError
//	@Router			/games/{id} [put]
func UpdateGame(c *gin.Context) {
	game, _ := c.MustGet("game").(models.Game)

	var dto models.UpdateGameDto
	if err := c.ShouldBindJSON(&dto); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	game.Name = dto.Name
	game.Description = dto.Description
	game.Image = dto.Image

	if err := game.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, game)
}

// DeleteGame godoc
//
//	@Summary		delete a game
//	@Description	delete a game
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Game ID"
//	@Success		204	{object}	models.SanitizedGame
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/{id} [delete]
func DeleteGame(c *gin.Context) {
	game, _ := c.MustGet("game").(models.Game)

	if err := game.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.Status(http.StatusNoContent)
}

// GetGameTournaments godoc
//
//	@Summary		get all tournaments of a game
//	@Description	get all tournaments of a game
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Game ID"
//	@Success		200	{object}	[]models.SanitizedTournament
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/{id}/tournaments [get]
func GetGameTournaments(c *gin.Context) {
	game, _ := c.MustGet("game").(models.Game)

	tournaments, err := game.GetTournaments()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, tournaments)
}

// AddGameTournament godoc
//
//	@Summary		add a tournament to a game
//	@Description	add a tournament to a game
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			id				path		int	true	"Game ID"
//	@Param			tournament_id	path		int	true	"Tournament ID"
//	@Success		200				{object}	models.SanitizedTournament
//	@Failure		404				{object}	utils.HttpError
//	@Failure		500				{object}	utils.HttpError
//	@Router			/games/{id}/tournaments/{tournament_id} [post]
func AddGameTournament(c *gin.Context) {
	game, _ := c.MustGet("game").(models.Game)
	tournament, _ := c.MustGet("tournament").(models.Tournament)

	if err := game.AddTournament(tournament); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, tournament)
}

// RemoveGameTournament godoc
//
//	@Summary		remove a tournament from a game
//	@Description	remove a tournament from a game
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			id				path		int	true	"Game ID"
//	@Param			tournament_id	path		int	true	"Tournament ID"
//	@Success		204				{object}	models.SanitizedTournament
//	@Failure		404				{object}	utils.HttpError
//	@Failure		500				{object}	utils.HttpError
//	@Router			/games/{id}/tournaments/{tournament_id} [delete]
func RemoveGameTournament(c *gin.Context) {
	game, _ := c.MustGet("game").(models.Game)
	tournament, _ := c.MustGet("tournament").(models.Tournament)

	if err := game.RemoveTournament(tournament); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.Status(http.StatusNoContent)
}

// GetGameParticipants godoc
//
//	@Summary		get all participants of a game
//	@Description	get all participants of a game
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Game ID"
//	@Success		200	{object}	[]models.SanitizedUser
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/{id}/participants [get]
func GetGameParticipants(c *gin.Context) {
	game, _ := c.MustGet("game").(models.Game)

	participants, err := game.GetParticipants()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, participants)
}

// AddGameParticipant godoc
//
//	@Summary		add a participant to a game
//	@Description	add a participant to a game
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			id		path		int	true	"Game ID"
//	@Param			user_id	path		int	true	"User ID"
//	@Success		200		{object}	models.SanitizedUser
//	@Failure		404		{object}	utils.HttpError
//	@Failure		500		{object}	utils.HttpError
//	@Router			/games/{id}/participants/{user_id} [post]
func AddGameParticipant(c *gin.Context) {
	game, _ := c.MustGet("game").(models.Game)
	user, _ := c.MustGet("user").(models.User)

	if err := game.AddParticipant(user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, user)
}

// RemoveGameParticipant godoc
//
//	@Summary		remove a participant from a game
//	@Description	remove a participant from a game
//	@Tags			game
//	@Accept			json
//	@Produce		json
//	@Param			id		path		int	true	"Game ID"
//	@Param			user_id	path		int	true	"User ID"
//	@Success		204		{object}	models.SanitizedUser
//	@Failure		404		{object}	utils.HttpError
//	@Failure		500		{object}	utils.HttpError
//	@Router			/games/{id}/participants/{user_id} [delete]
func RemoveGameParticipant(c *gin.Context) {
	game, _ := c.MustGet("game").(models.Game)
	user, _ := c.MustGet("user").(models.User)

	if err := game.RemoveParticipant(user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.Status(http.StatusNoContent)
}
