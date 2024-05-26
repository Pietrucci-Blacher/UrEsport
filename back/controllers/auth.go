package controllers

import (
	"challenge/models"
	"challenge/services"
	"net/http"
	"os"
	"strconv"

	"github.com/gin-gonic/gin"
)

// Login godoc
//
//	@Summary		Login user
//	@Description	Login user
//	@Tags			auth
//	@Accept			json
//	@Produce		json
//	@Param			login	body		models.LoginUserDto	true	"Login user"
//	@Success		200		{object}	models.LoginSuccessResponse
//	@Failure		400		{object}	utils.HttpError
//	@Router			/auth/login [post]
func Login(c *gin.Context) {
	var user models.User
	body, _ := c.MustGet("body").(models.LoginUserDto)

	if err := user.FindOne("email", body.Email); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	if !user.ComparePassword(body.Password) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	if err := models.DeleteTokensByUserID(user.ID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete tokens"})
		return
	}

	token := models.NewToken(user.ID)

	if err := token.GenerateTokens(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	if err := token.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save token"})
		return
	}

	cookieSecure, _ := strconv.ParseBool(os.Getenv("COOKIE_SECURE"))
	c.SetCookie("access_token", token.AccessToken, 3600, "/", "", cookieSecure, true)
	c.SetCookie("refresh_token", token.RefreshToken, 3600*24*30, "/", "", cookieSecure, true)

	c.JSON(http.StatusOK, gin.H{
		"access_token":  token.AccessToken,
		"refresh_token": token.RefreshToken,
	})
}

// Refresh godoc
//
//	@Summary		Refresh token
//	@Description	Refresh token
//	@Tags			auth
//	@Accept			json
//	@Produce		json
//	@Success		200		{object}	models.RefreshSuccessResponse
//	@Failure		400		{object}	utils.HttpError
//	@Router			/auth/refresh [post]
func Refresh(c *gin.Context) {
	var token models.Token

	refreshTokenString, err := c.Cookie("refresh_token")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "No refresh token found"})
		return
	}

	if err := token.FindOne("refresh_token", refreshTokenString); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Refresh token not found"})
		return
	}

	if err = token.GenerateAccessToken(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	if err := token.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save token"})
		return
	}

	cookieSecure, _ := strconv.ParseBool(os.Getenv("COOKIE_SECURE"))
	c.SetCookie("access_token", token.AccessToken, 3600, "/", "", cookieSecure, true)

	c.JSON(http.StatusOK, gin.H{"access_token": token.AccessToken})
}

// Register godoc
//
//	@Summary		Register user
//	@Description	Register user
//	@Tags			auth
//	@Accept			json
//	@Produce		json
//	@Param			register	body	models.CreateUserDto	true	"Register user"
//	@Success		201
//	@Failure		400	{object}	utils.HttpError
//	@Router			/auth/register [post]
func Register(c *gin.Context) {
	body, _ := c.MustGet("body").(models.CreateUserDto)

	if count, err := models.CountUsersByEmail(body.Email); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email already exists"})
		return
	}

	if count, err := models.CountUsersByUsername(body.Username); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Username already exists"})
		return
	}

	user := models.User{
		Firstname: body.Firstname,
		Lastname:  body.Lastname,
		Username:  body.Username,
		Email:     body.Email,
		Roles:     []string{models.ROLE_USER},
	}

	if err := user.HashPassword(body.Password); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := user.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	err := services.SendEmail(user.Email, services.WelcomeEmail)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "User created successfully"})
}

// Logout godoc
//
//	@Summary		Logout user
//	@Description	Logout user
//	@Tags			auth
//	@Accept			json
//	@Produce		json
//	@Success		201
//	@Failure		400	{object}	utils.HttpError
//	@Router			/auth/logout [post]
func Logout(c *gin.Context) {
	var token models.Token

	tokenString, err := c.Cookie("access_token")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "No session found"})
		return
	}

	if err := token.FindOne("access_token", tokenString); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Session not found"})
		return
	}

	if err := token.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to end session"})
		return
	}

	c.SetCookie("access_token", "", -1, "/", "", false, true)
	c.SetCookie("refresh_token", "", -1, "/", "", false, true)
	c.JSON(http.StatusOK, gin.H{"message": "Logged out successfully"})
}
