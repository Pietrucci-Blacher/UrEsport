package controllers

import (
	"challenge/models"
	"challenge/services"
	"github.com/gin-gonic/gin"
	"net/http"
)

// GetFriends godoc
// @Summary Get all friends of a user
// @Description Get all friends of a user
// @Tags friend
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Success 200 {object} models.User
// @Failure 400 {object} utils.HttpError
// @Failure 404 {object} utils.HttpError
// @Failure 500 {object} utils.HttpError
// @Router /users/{id}/friends [get]
func GetFriends(c *gin.Context) {
	user, _ := c.MustGet("user").(*models.User)

	// Récupérer la liste d'amis de l'utilisateur
	friends, err := models.GetFriendsByUserID(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, friends)
}

// GetFriend godoc
// @Summary Get a friend of a user
// @Description Get a friend of a user
// @Tags friend
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Param friend_id path int true "Friend ID"
// @Success 200 {object} models.User
// @Failure 400 {object} utils.HttpError
// @Failure 404 {object} utils.HttpError
// @Failure 500 {object} utils.HttpError
// @Router /users/{id}/friends/{friend_id} [get]
func GetFriend(c *gin.Context) {
	user, _ := c.MustGet("user").(*models.User)

	// Récupérer l'ami de l'utilisateur
	friend, err := models.GetFriendsByUserID(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, friend)
}

// AddFriend godoc
// @Summary Add a friend to the user's friend list
// @Description Add a friend to the user's friend list
// @Tags friend
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Param friend_id path int true "Friend ID"
// @Success 200
// @Failure 400 {object} utils.HttpError
// @Failure 404 {object} utils.HttpError
// @Failure 500 {object} utils.HttpError
// @Router /users/{id}/friends/{friend_id} [post]
func AddFriend(c *gin.Context) {
	w := services.GetWebsocket()
	user, _ := c.MustGet("user").(*models.User)
	friend, _ := c.MustGet("friend").(*models.User)

	// Vérifier si l'ami existe déjà dans la liste d'amis de l'utilisateur
	if models.IsFriend(user.ID, friend.ID) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Friend already exists"})
		return
	}

	// Ajouter l'ami à la liste d'amis de l'utilisateur
	_, err := models.CreateFriend(user.ID, friend.ID, false)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Friend added successfully"})
}

// DeleteFriend godoc
// @Summary Remove a friend from the user's friend list
// @Description Remove a friend from the user's friend list
// @Tags friend
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Param friend_id path int true "Friend ID"
// @Success 204
// @Failure 400 {object} utils.HttpError
// @Failure 404 {object} utils.HttpError
// @Failure 500 {object} utils.HttpError
// @Router /users/{id}/friends/{friend_id} [delete]
func DeleteFriend(c *gin.Context) {
	user, _ := c.MustGet("user").(*models.User)
	friend, _ := c.MustGet("friend").(*models.User)

	// Supprimer l'ami de la liste d'amis de l'utilisateur
	err := models.DeleteFriend(user.ID, friend.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusNoContent, nil)
}

// UpdateFriend godoc
// @Summary Update the favorite status of a friend
// @Description Update the favorite status of a friend
// @Tags friend
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Param friend_id path int true "Friend ID"
// @Param favorite query bool true "Favorite status"
// @Success 204
// @Failure 400 {object} utils.HttpError
// @Failure 404 {object} utils.HttpError
// @Failure 500 {object} utils.HttpError
// @Router /users/{id}/friends/{friend_id} [patch]
func UpdateFriend(c *gin.Context) {
	user, _ := c.MustGet("user").(*models.User)
	friend, _ := c.MustGet("friend").(*models.User)
	favorite := c.GetBool("favorite")

	// Mettre à jour le statut favori de l'ami
	err := models.UpdateFriend(user.ID, friend.ID, favorite)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusNoContent, nil)
}
