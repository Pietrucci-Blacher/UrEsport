package controllers

import (
	"challenge/docs"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

// gin-swagger middleware
// swagger embed files

func RegisterRoutes(r *gin.Engine) {
	docs.SwaggerInfo.Title = "UrEsport API"
	docs.SwaggerInfo.Description = "This is a sample server for UrEsport API."
	docs.SwaggerInfo.Version = "1.0"
	docs.SwaggerInfo.Host = "petstore.swagger.io"
	docs.SwaggerInfo.BasePath = "/v2"
	docs.SwaggerInfo.Schemes = []string{"http", "https"}

	api := r.Group("/")
	{
		api.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
		api.GET("/ping", ping)

		users := api.Group("/users")
		{
			users.GET("/", GetUsers)
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

		auth := api.Group("/auth")
		{
			auth.POST("/login", Login)
			auth.POST("/register", Register)
			auth.POST("/logout", Logout)
		}
	}
}
