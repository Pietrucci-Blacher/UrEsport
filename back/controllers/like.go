package controllers

import (
	"challenge/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// GetAllLikes godoc
//
//	@Summary		get all likes
//	@Description	get all likes
//	@Tags			like
//	@Accept			json
//	@Produce		json
//	@Success		200		{object}	[]models.Like
//	@Failure		500	{object}	utils.HttpError
//	@Router			/games/likes [get]
func GetAllLikes(c *gin.Context) {
	likes, err := models.GetAllLikes()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, likes)
}

// GetLikeByID godoc
//
//	@Summary		get like by ID
//	@Description	get like by ID
//	@Tags			like
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Like ID"
//	@Success		200		{object}	models.Like
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/likes/{id} [get]
func GetLikeByID(c *gin.Context) {
	idParam := c.Param("id")
	id, err := strconv.Atoi(idParam)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid like ID"})
		return
	}

	like, err := models.GetLikeByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Like not found"})
		return
	}

	c.JSON(http.StatusOK, like)
}

// GetLikesByUserIDAndGameID godoc
//
//	@Summary		get likes by userID and gameID
//	@Description	get likes by userID and gameID
//	@Tags			like
//	@Accept			json
//	@Produce		json
//	@Param			user	path		int	true	"User ID"
//	@Param			game	path		int	true	"Game ID"
//	@Success		200		{object}	[]models.Like
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/likes/user/{user}/game/{game} [get]
func GetLikesByUserIDAndGameID(c *gin.Context) {
	userIDParam := c.Param("user")
	gameIDParam := c.Param("game")

	userID, err := strconv.Atoi(userIDParam)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	gameID, err := strconv.Atoi(gameIDParam)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid game ID"})
		return
	}

	likes, err := models.GetLikesByUserIDAndGameID(userID, gameID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if len(likes) == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "No likes found"})
		return
	}

	c.JSON(http.StatusOK, likes)
}

// GetLikesByUserID godoc
//
//	@Summary		get likes by userID
//	@Description	get likes by userID
//	@Tags			like
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"User ID"
//	@Success		200		{object}	[]models.Like
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/likes/user/{id} [get]
func GetLikesByUserID(c *gin.Context) {
	user, _ := c.MustGet("user").(*models.User)

	likes, err := models.GetLikesByUserID(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, likes)

}

// CreateLike godoc
//
//	@Summary		create a like
//	@Description	create a like
//	@Tags			like
//	@Accept			json
//	@Produce		json
//	@Param			like	body		models.Like	true	"Like"
//	@Success		201	{object}	models.Like
//	@Failure		500	{object}	utils.HttpError
//	@Router			/likes [post]
func CreateLike(c *gin.Context) {
	body, _ := c.MustGet("body").(models.CreateLikeDto)

	exists, err := models.LikeExists(body.UserID, body.GameID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Erreur lors de la vérification du like"})
		return
	}

	if exists {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Le like existe déjà"})
		return
	}

	like := models.Like{
		UserID: body.UserID,
		GameID: body.GameID,
	}

	if err := models.CreateLike(&like); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, like)
}

// DeleteLike godoc
//
//	@Summary		delete a like
//	@Description	delete a like
//	@Tags			like
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Like ID"
//	@Success		204
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/likes/{id} [delete]
func DeleteLike(c *gin.Context) {
	like, _ := c.MustGet("like").(*models.Like)

	if err := like.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.Status(http.StatusNoContent)
}
