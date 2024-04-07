package main

import (
	"challenge/models"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func ping(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "pong",
	})
}

func registerRoutes(r *gin.Engine) {
	api := r.Group("/")
	{
		// api.GET("/ping", ping)
		users := api.Group("/users")
		{
			users.GET("/ping", ping)
			// users.GET("/", models.GetUsers)
			// users.POST("/", models.CreateUser)
			// users.GET("/:id", models.GetUser)
			// users.PATCH("/:id", models.UpdateUser)
			// users.DELETE("/:id", models.DeleteUser)
		}
	}
}

func main() {
	if err := godotenv.Load(); err != nil {
		panic("Failed to load env file")
	}

	if err := models.ConnectDB(true); err != nil {
		panic("Failed to connect to database")
	}

	r := gin.Default()
	registerRoutes(r)
	r.Run(":8080")
}
