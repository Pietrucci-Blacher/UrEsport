package controllers

import (
	"challenge/docs"
	"challenge/middlewares"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

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
			users.GET("/", middlewares.IsLoggedIn(), middlewares.IsAdmin(), GetUsers)
			users.GET("/:id", middlewares.IsLoggedIn(), GetUser)
			users.PATCH("/:id", middlewares.IsLoggedIn(), UpdateUser)
			users.DELETE("/:id", middlewares.IsLoggedIn(), DeleteUser)
			users.GET("/me", middlewares.IsLoggedIn(), GetUserMe)
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

		tournaments := api.Group("/tournaments")
		{
			tournaments.GET("/", GetTournaments)
			tournaments.POST("/", middlewares.IsLoggedIn(), CreateTournament)
			tournaments.GET("/:id", GetTournament)
			tournaments.PATCH("/:id", middlewares.IsLoggedIn(), UpdateTournament)
			tournaments.DELETE("/:id", middlewares.IsLoggedIn(), DeleteTournament)
			tournaments.POST("/:id/join", middlewares.IsLoggedIn(), JoinTournament)
			tournaments.POST("/:id/invite", middlewares.IsLoggedIn(), InviteUserToTournament)
			tournaments.DELETE("/:id/leave", middlewares.IsLoggedIn(), LeaveTournament)
			tournaments.DELETE("/:id/kick", middlewares.IsLoggedIn(), KickUserFromTournament)
			tournaments.PATCH("/:id/toggle-private", middlewares.IsLoggedIn(), TogglePrivateTournament)
		}
	}
}
