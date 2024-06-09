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
//	@Success		200	{object}	[]models.Game
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
//	@Success		200	{object}	models.Game
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/{id} [get]
func GetGame(c *gin.Context) {
	game, _ := c.MustGet("game").(*models.Game)
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
//	@Success		201		{object}	models.Game
//	@Failure		400		{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/ [post]
func CreateGame(c *gin.Context) {
	var game models.Game
	body, _ := c.MustGet("body").(models.CreateGameDto)

	if count, err := models.CountGameByName(body.Name); err != nil || count > 0 {
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
//	@Success		200		{object}	models.Game
//	@Failure		400		{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/{id} [put]
func UpdateGame(c *gin.Context) {
	body, _ := c.MustGet("body").(models.UpdateGameDto)
	game, _ := c.MustGet("game").(*models.Game)

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
//	@Success		204
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/{id} [delete]
func DeleteGame(c *gin.Context) {
	game, _ := c.MustGet("game").(*models.Game)

	if err := game.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.Status(http.StatusNoContent)
}
