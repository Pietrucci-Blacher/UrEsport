package controllers

<<<<<<< Updated upstream
import (
	"challenge/docs"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

// gin-swagger middleware
// swagger embed files

func RegisterRoutes(r *gin.Engine) {
	// programmatically set swagger info
	docs.SwaggerInfo.Title = "Swagger Example API"
	docs.SwaggerInfo.Description = "This is a sample server Petstore server."
	docs.SwaggerInfo.Version = "1.0"
	docs.SwaggerInfo.Host = "petstore.swagger.io"
	docs.SwaggerInfo.BasePath = "/v2"
	docs.SwaggerInfo.Schemes = []string{"http", "https"}

	api := r.Group("/")
	{
<<<<<<< Updated upstream
		api.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
		api.GET("/ping", ping)
=======
>>>>>>> Stashed changes
=======
import "github.com/gin-gonic/gin"

func RegisterRoutes(r *gin.Engine) {
	api := r.Group("/")
	{
>>>>>>> Stashed changes
		users := api.Group("/users")
		{
			users.GET("/", GetUsers)
			users.GET("/:id", GetUser)
			users.PATCH("/:id", UpdateUser)
			users.DELETE("/:id", DeleteUser)
		}
<<<<<<< Updated upstream
<<<<<<< Updated upstream
		features := api.Group("/features")
		{
			features.GET("/", GetFeatures)
			features.POST("/", CreateFeature)
			features.GET("/:id", GetFeature)
			features.GET("/:id/toggle", ToggleFeature)
			features.PATCH("/:id", UpdateFeature)
			features.DELETE("/:id", DeleteFeature)
=======
=======
>>>>>>> Stashed changes

		auth := api.Group("/auth")
		{
			auth.POST("/login", Login)
			auth.POST("/register", Register)
<<<<<<< Updated upstream
			//auth.POST("/logout", Logout)
>>>>>>> Stashed changes
=======
			auth.POST("/logout", Logout)
>>>>>>> Stashed changes
		}
	}
}
