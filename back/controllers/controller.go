package controllers

import (
	"challenge/docs"
	"challenge/middlewares"

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
		users := api.Group("/users")
		{
			users.GET("/", GetUsers)
			users.GET("/:id", GetUser)
			users.PATCH("/:id", middlewares.IsLoggedIn(), UpdateUser)
			users.DELETE("/:id", middlewares.IsLoggedIn(), DeleteUser)
		}

		features := api.Group("/features")
		{
			features.GET("/", GetFeatures)
			features.POST("/", middlewares.IsLoggedIn(), middlewares.IsAdmin(), CreateFeature)
			features.GET("/:id", GetFeature)
			features.GET("/:id/toggle", middlewares.IsLoggedIn(), middlewares.IsAdmin(), ToggleFeature)
			features.PATCH("/:id", middlewares.IsLoggedIn(), middlewares.IsAdmin(), UpdateFeature)
			features.DELETE("/:id", middlewares.IsLoggedIn(), middlewares.IsAdmin(), DeleteFeature)
		}

		auth := api.Group("/auth")
		{
			auth.POST("/login", Login)
			auth.POST("/register", Register)
			auth.POST("/logout", Logout)
		}
	}
}
