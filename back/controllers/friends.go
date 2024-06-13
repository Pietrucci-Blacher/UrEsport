package controllers

import (
	"challenge/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
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
	userIDStr := c.Param("user")
	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	// Vérifier si l'utilisateur existe
	if !models.UserExists(userID) {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// Récupérer la liste d'amis de l'utilisateur
	friends, err := models.GetFriendsByUserID(userID)
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
	userIDStr := c.Param("user")
	friendIDStr := c.Param("friend_id")

	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	friendID, err := strconv.Atoi(friendIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid friend ID"})
		return
	}

	// Vérifier si l'utilisateur et l'ami existent
	if !models.UserExists(userID) || !models.UserExists(friendID) {
		c.JSON(http.StatusNotFound, gin.H{"error": "User or friend not found"})
		return
	}

	// Récupérer l'ami de l'utilisateur
	friend, err := models.GetFriendsByUserID(userID)
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
	userIDStr := c.Param("user")
	friendIDStr := c.Param("friend_id")

	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	friendID, err := strconv.Atoi(friendIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid friend ID"})
		return
	}

	// Vérifier si l'utilisateur et l'ami existent
	if !models.UserExists(userID) || !models.UserExists(friendID) {
		c.JSON(http.StatusNotFound, gin.H{"error": "User or friend not found"})
		return
	}

	// Vérifier si l'ami existe déjà dans la liste d'amis de l'utilisateur
	if models.IsFriend(userID, friendID) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Friend already exists"})
		return
	}

	// Ajouter l'ami à la liste d'amis de l'utilisateur
	_, err = models.CreateFriend(int(userID), int(friendID), false)
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
	userIDStr := c.Param("user")
	friendIDStr := c.Param("friend_id")

	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	friendID, err := strconv.Atoi(friendIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid friend ID"})
		return
	}

	// Vérifier si l'utilisateur et l'ami existent
	if !models.UserExists(userID) || !models.UserExists(friendID) {
		c.JSON(http.StatusNotFound, gin.H{"error": "User or friend not found"})
		return
	}

	// Supprimer l'ami de la liste d'amis de l'utilisateur
	err = models.DeleteFriend(int(userID), int(friendID))
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
	userIDStr := c.Param("user")
	friendIDStr := c.Param("friend_id")

	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	friendID, err := strconv.Atoi(friendIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid friend ID"})
		return
	}

	// Vérifier si l'utilisateur et l'ami existent
	if !models.UserExists(userID) || !models.UserExists(friendID) {
		c.JSON(http.StatusNotFound, gin.H{"error": "User or friend not found"})
		return
	}

	favoriteStr := c.Query("favorite")
	favorite, err := strconv.ParseBool(favoriteStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid favorite status"})
		return
	}

	// Mettre à jour le statut favori de l'ami
	err = models.UpdateFriend(int(userID), int(friendID), favorite)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
