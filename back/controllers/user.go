package controllers

import (
	"challenge/models"
	"strconv"

	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
)

func GetUsers(c *gin.Context) {
	users, err := models.FindAllUsers()
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, users)
}

func GetUser(c *gin.Context) {
	var user models.User

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if err := user.FindOneById(id); err != nil {
		c.JSON(404, gin.H{"error": "User not found"})
		return
	}

	c.JSON(200, user)
}

func CreateUser(c *gin.Context) {
	var user models.User
	var data models.CreateUserDto

	if err := c.BindJSON(&data); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CoutUsersByEmail(data.Email); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Email already exists"})
		return
	}

	if count, err := models.CoutUsersByUsername(data.Username); err != nil || count > 0 {
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

	c.JSON(201, user)
}

func UpdateUser(c *gin.Context) {
	var user models.User
	var body models.UpdateUserDto

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if err := user.FindOneById(id); err != nil {
		c.JSON(404, gin.H{"error": "User not found"})
		return
	}

	if err := c.BindJSON(&body); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CoutUsersByEmail(body.Email); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Email already exists"})
		return
	}

	if count, err := models.CoutUsersByUsername(body.Username); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Username already exists"})
		return
	}

	validate := validator.New()
	if err := validate.Struct(body); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
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
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, user)
}

func DeleteUser(c *gin.Context) {
	var user models.User

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if err := user.FindOneById(id); err != nil {
		c.JSON(404, gin.H{"error": "User not found"})
		return
	}

	if err := user.Delete(); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	c.JSON(204, nil)
}
