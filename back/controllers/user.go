package controllers

import (
	"challenge/models"
	"encoding/json"
	"strconv"

	"github.com/gin-gonic/gin"
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

	if err := c.BindJSON(&user); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CoutUsersByEmail(user.Email); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Email already exists"})
		return
	}

	if count, err := models.CoutUsersByUsername(user.Username); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Username already exists"})
		return
	}

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
	var body map[string]string
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

	if err := c.BindJSON(&body); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CoutUsersByEmail(body["email"]); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Email already exists"})
		return
	}

	if count, err := models.CoutUsersByUsername(body["username"]); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Username already exists"})
		return
	}

	dbBody, err := json.Marshal(body)
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if err := json.Unmarshal([]byte(dbBody), &user); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
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
