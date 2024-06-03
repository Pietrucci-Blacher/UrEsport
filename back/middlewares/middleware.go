package middlewares

import (
	"challenge/models"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
)

func Validate[T any]() gin.HandlerFunc {
	return func(c *gin.Context) {
		var body T

		if err := c.BindJSON(&body); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		validate := validator.New()
		if err := validate.Struct(body); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		c.Set("body", body)
	}
}

func Get[T models.Model](name string) gin.HandlerFunc {
	return func(c *gin.Context) {
		var model T

		id, err := strconv.Atoi(c.Param("id"))
		fmt.Printf("name: %s, id: %d\n", name, id)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Bad Request"})
			c.Abort()
			return
		}

		if err := model.FindOneById(id); err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Not Found"})
			c.Abort()
			return
		}

		fmt.Printf("model: %v\n", model)

		c.Set(name, model)
		c.Next()
	}
}
