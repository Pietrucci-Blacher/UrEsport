package controllers

import (
	"challenge/models"
	"net/http"
	"strconv"

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
	gameID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid game ID"})
		return
	}

	var game models.Game
	if err := game.FindOneById(gameID); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Game not found"})
		return
	}

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
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/ [post]
func CreateGame(c *gin.Context) {
	var game models.Game
	var body models.CreateGameDto

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CountFeatureByName(body.Name); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Game already exists"})
		return
	}

	game = models.Game{
		Name:        body.Name,
		Description: body.Description,
		Image:       body.Image,
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
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/{id} [put]
func UpdateGame(c *gin.Context) {
	gameID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid game ID"})
		return
	}

	var game models.Game
	if err := game.FindOneById(gameID); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Game not found"})
		return
	}

	var body models.UpdateGameDto
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if body.Name != "" {
		game.Name = body.Name
	}

	if body.Description != "" {
		game.Description = body.Description
	}

	if body.Image != "" {
		game.Image = body.Image
	}

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
	gameID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid game ID"})
		return
	}

	var game models.Game
	if err := game.FindOneById(gameID); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Game not found"})
		return
	}

	if err := game.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.Status(http.StatusNoContent)
}
