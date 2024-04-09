package controllers

import (
	"challenge/models"
	"challenge/services"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"net/http"
	"os"
	"strconv"
)

func Login(c *gin.Context) {
	var loginRequest struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	if err := c.BindJSON(&loginRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	var user models.User
	if err := user.FindOne("email", loginRequest.Email); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	if !user.ComparePassword(loginRequest.Password) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	token, err := models.GenerateJWTToken(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	cookieSecure, _ := strconv.ParseBool(os.Getenv("COOKIE_SECURE"))

	c.SetCookie("auth_token", token, 3600, "/", "", cookieSecure, true)

	c.JSON(http.StatusOK, gin.H{"token": token})
}

func Register(c *gin.Context) {
	var user models.User
	var data models.CreateUserDto

	if err := c.BindJSON(&data); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CountUsersByEmail(data.Email); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Email already exists"})
		return
	}

	if count, err := models.CountUsersByUsername(data.Username); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Username already exists"})
		return
	}

	validate := validator.New()
	if err := validate.Struct(data); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	user.Firstname = data.Firstname
	user.Lastname = data.Lastname
	user.Username = data.Username
	user.Email = data.Email
	user.Password = data.Password
	user.Roles = []string{"user"}

	if err := user.HashPassword(); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if err := user.Save(); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	err := services.SendEmail(user.Email, services.WelcomeEmail)
	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(201, user)
}

func Logout(c *gin.Context) {
	tokenString, err := c.Cookie("auth_token")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "No session found"})
		return
	}

	var token models.Token
	if err := models.DB.Where("token = ?", tokenString).First(&token).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Session not found"})
		return
	}

	if err := models.DB.Delete(&token).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to end session"})
		return
	}

	c.SetCookie("auth_token", "", -1, "/", "", false, true)
	c.JSON(http.StatusOK, gin.H{"message": "Logged out successfully"})
}
