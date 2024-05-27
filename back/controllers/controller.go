package controllers

import (
	"challenge/docs"
	"challenge/middlewares"
	"challenge/models"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func RegisterRoutes(r *gin.Engine) {
	docs.SwaggerInfo.Title = "UrEsport API"
	docs.SwaggerInfo.Description = "This is a sample server for UrEsport API."
	docs.SwaggerInfo.Version = "1.0"
	docs.SwaggerInfo.Host = "fr.uresport.api"
	docs.SwaggerInfo.BasePath = "/v2"
	docs.SwaggerInfo.Schemes = []string{"http", "https"}

	api := r.Group("/")
	{
		api.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

		users := api.Group("/users")
		{
			users.GET("/",
				middlewares.IsLoggedIn(false),
				middlewares.QueryFilter(),
				GetUsers,
			)
			users.GET("/:id",
				middlewares.IsLoggedIn(true),
				middlewares.GetUser(),
				GetUser,
			)
			users.PATCH("/:id",
				middlewares.IsLoggedIn(true),
				middlewares.GetUser(),
				middlewares.IsMe(),
				middlewares.Validate[models.UpdateUserDto](),
				UpdateUser,
			)
			users.DELETE("/:id",
				middlewares.IsLoggedIn(true),
				middlewares.GetUser(),
				middlewares.IsMe(),
				DeleteUser,
			)
			users.GET("/me",
				middlewares.IsLoggedIn(true),
				GetUserMe,
			)
		}

		features := api.Group("/features")
		{
			features.GET("/", GetFeatures)
			features.POST("/",
				middlewares.IsLoggedIn(true),
				middlewares.IsAdmin(),
				middlewares.Validate[models.CreateFeatureDto](),
				CreateFeature,
			)
			features.GET("/:id",
				middlewares.GetFeature(),
				GetFeature,
			)
			features.GET("/:id/toggle",
				middlewares.IsLoggedIn(true),
				middlewares.IsAdmin(),
				middlewares.GetFeature(),
				ToggleFeature,
			)
			features.PATCH("/:id",
				middlewares.IsLoggedIn(true),
				middlewares.IsAdmin(),
				middlewares.GetFeature(),
				middlewares.Validate[models.UpdateFeatureDto](),
				UpdateFeature,
			)
			features.DELETE("/:id",
				middlewares.IsLoggedIn(true),
				middlewares.IsAdmin(),
				middlewares.GetFeature(),
				DeleteFeature,
			)
		}

		auth := api.Group("/auth")
		{
			auth.POST("/login",
				middlewares.Validate[models.LoginUserDto](),
				Login,
			)
			auth.POST("/register",
				middlewares.Validate[models.CreateUserDto](),
				Register,
			)
			auth.POST("/logout",
				middlewares.IsLoggedIn(true),
				Logout,
			)
			auth.POST("/refresh", Refresh)
			auth.POST("/verify", middlewares.Validate[models.VerifyUserDto](), Verify)
			auth.POST("/request-password-reset", middlewares.Validate[models.RequestPasswordResetDto](), RequestPasswordReset)
			auth.POST("/reset-password", middlewares.Validate[models.ResetPasswordDto](), ResetPassword)
			auth.GET("/:provider/callback", OAuth2Callback)
		}

		tournaments := api.Group("/tournaments")
		{
			tournaments.GET("/",
				middlewares.QueryFilter(),
				GetTournaments,
			)
			tournaments.POST("/",
				middlewares.IsLoggedIn(true),
				middlewares.Validate[models.CreateTournamentDto](),
				CreateTournament,
			)
			tournaments.GET("/:id",
				middlewares.GetTournament(),
				GetTournament,
			)
			tournaments.PATCH("/:id",
				middlewares.IsLoggedIn(true),
				middlewares.GetTournament(),
				middlewares.IsTournamentOwner(),
				middlewares.Validate[models.UpdateTournamentDto](),
				UpdateTournament,
			)
			tournaments.DELETE("/:id",
				middlewares.IsLoggedIn(true),
				middlewares.GetTournament(),
				middlewares.IsTournamentOwner(),
				DeleteTournament,
			)
			tournaments.POST("/:id/join",
				middlewares.IsLoggedIn(true),
				middlewares.GetTournament(),
				JoinTournament,
			)
			tournaments.POST("/:id/invite",
				middlewares.IsLoggedIn(true),
				middlewares.GetTournament(),
				middlewares.IsTournamentOwner(),
				middlewares.Validate[models.InviteUserDto](),
				InviteUserToTournament,
			)
			tournaments.DELETE("/:id/leave",
				middlewares.IsLoggedIn(true),
				middlewares.GetTournament(),
				LeaveTournament,
			)
			tournaments.DELETE("/:id/kick",
				middlewares.IsLoggedIn(true),
				middlewares.GetTournament(),
				middlewares.IsTournamentOwner(),
				middlewares.Validate[models.InviteUserDto](),
				KickUserFromTournament,
			)
			tournaments.PATCH("/:id/toggle-private",
				middlewares.IsLoggedIn(true),
				middlewares.GetTournament(),
				middlewares.IsTournamentOwner(),
				TogglePrivateTournament,
			)
		}
	}
}
