package controllers

import (
	"challenge/models"
	"challenge/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetUsers godoc
//
//	@Summary		get all users
//	@Description	get all users
//	@Tags			user
//	@Accept			json
//	@Produce		json
//	@Success		200	{object}	[]models.User
//	@Failure		500	{object}	utils.HttpError
//	@Router			/users/ [get]
func GetUsers(c *gin.Context) {
	var sanitized []models.SanitizedUser

	query, _ := c.MustGet("query").(utils.QueryFilter)

	users, err := models.FindAllUsers(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	for _, user := range users {
		sanitized = append(sanitized, user.Sanitize(true))
	}

	c.JSON(http.StatusOK, sanitized)
}

// GetUser godoc
//
//	@Summary		get users by id
//	@Description	get users by id
//	@Tags			user
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Feature ID"
//	@Success		200	{object}	models.User
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/users/{id} [get]
func GetUser(c *gin.Context) {
	user, _ := c.MustGet("findedUser").(models.User)

	sanitized := user.Sanitize(true)

	c.JSON(http.StatusOK, sanitized)
}

// GetUserMe godoc
//
//	@Summary		get connected user
//	@Description	get connected user
//	@Tags			user
//	@Accept			json
//	@Produce		json
//	@Success		200	{object}	models.User
//	@Router			/users/me [get]
func GetUserMe(c *gin.Context) {
	connectedUser, _ := c.MustGet("user").(models.User)
	c.JSON(http.StatusOK, connectedUser)
}

// UpdateUser godoc
//
//	@Summary		update user
//	@Description	update user
//	@Tags			user
//	@Accept			json
//	@Produce		json
//	@Param			user	body		models.UpdateUserDto	true	"User"
//	@Param			id		path		int						true	"User ID"
//	@Success		200		{object}	models.User
//	@Failure		400		{object}	utils.HttpError
//	@Failure		401		{object}	utils.HttpError
//	@Failure		404		{object}	utils.HttpError
//	@Failure		500		{object}	utils.HttpError
//	@Router			/users/{id} [patch]
func UpdateUser(c *gin.Context) {

	user, _ := c.MustGet("findedUser").(models.User)
	body, _ := c.MustGet("body").(models.UpdateUserDto)

	if count, err := models.CountUsersByEmail(body.Email); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email already exists"})
		return
	}

	if count, err := models.CountUsersByUsername(body.Username); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Username already exists"})
		return
	}

	if body.Firstname != "" {
		user.Firstname = body.Firstname
	}
	if body.Lastname != "" {
		user.Lastname = body.Lastname
	}
	if body.Username != "" {
		user.Username = body.Username
	}
	if body.Email != "" {
		user.Email = body.Email
	}

	if err := user.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, user)
}

// DeleteUser godoc
//
//	@Summary		delete user
//	@Description	delete user
//	@Tags			user
//	@Accept			json
//	@Produce		json
//	@Param			id	path	int	true	"User ID"
//	@Success		204
//	@Failure		400	{object}	utils.HttpError
//	@Failure		401	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/users/{id} [delete]
func DeleteUser(c *gin.Context) {
	user, _ := c.MustGet("findedUser").(models.User)

	if err := user.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}
