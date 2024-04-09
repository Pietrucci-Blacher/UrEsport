package controllers

import "github.com/gin-gonic/gin"

func ping(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "pong",
	})
}

func RegisterRoutes(r *gin.Engine) {
	api := r.Group("/")
	{
		api.GET("/ping", ping)
		users := api.Group("/users")
		{
			users.GET("/", GetUsers)
			users.POST("/", CreateUser)
			users.GET("/:id", GetUser)
			users.PATCH("/:id", UpdateUser)
			users.DELETE("/:id", DeleteUser)
		}
		features := api.Group("/features")
		{
			features.GET("/", GetFeatures)
			features.POST("/", CreateFeature)
			features.GET("/:id", GetFeature)
			features.GET("/:id/toggle", ToggleFeature)
			features.PATCH("/:id", UpdateFeature)
			features.DELETE("/:id", DeleteFeature)
		}
	}
}
