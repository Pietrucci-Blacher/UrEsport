package main

import (
    "challenge/controllers"
    "challenge/fixtures"
    "challenge/models"
    "challenge/services"
    "challenge/websockets"
    "fmt"
    "os"
    "strings"
    "time"

    "github.com/gin-contrib/cors"
    "github.com/gin-gonic/gin"
    "github.com/joho/godotenv"
)

func main() {
    if len(os.Args) == 2 && os.Args[1] == "help" {
       fmt.Printf("Usage: %s [migrate|droptable|fixtures|convertmjml]\n", os.Args[0])
       os.Exit(0)
    }

    if err := godotenv.Load(); err != nil {
       fmt.Fprintf(os.Stderr, "Error: Failed to load .env file\n")
       os.Exit(1)
    }

    if err := models.ConnectDB(false); err != nil {
       fmt.Fprintf(os.Stderr, "Error: Failed to connect to database\n")
       os.Exit(1)
    }

    if len(os.Args) == 2 {
       switch os.Args[1] {
       case "migrate":
          if err := models.Migration(); err != nil {
             fmt.Fprintf(os.Stderr, "Error: Failed to migrate database\n")
             os.Exit(1)
          }
          fmt.Println("Database migrated")
          os.Exit(0)
       case "droptable":
          if err := models.DropTables(); err != nil {
             fmt.Fprintf(os.Stderr, "Error: Failed to drop table\n")
             os.Exit(1)
          }
          fmt.Println("Table dropped")
          os.Exit(0)
       case "fixtures":
          if err := fixtures.ImportFixtures(); err != nil {
             fmt.Fprintf(os.Stderr, "Error: %v\n", err)
             os.Exit(1)
          }
          fmt.Println("Fixtures imported")
          os.Exit(0)
       case "convertmjml":
          inputDir := "template"
          outputDir := "template-html"
          if err := services.ConvertMJMLToHTML(inputDir, outputDir); err != nil {
             fmt.Fprintf(os.Stderr, "Error: Failed to convert MJML to HTML: %v\n", err)
             os.Exit(1)
          }
          fmt.Println("MJML files converted to HTML")
          os.Exit(0)
       default:
          fmt.Fprintf(os.Stderr, "Unknown command: %s\n", os.Args[1])
          os.Exit(1)
       }
    }

    ginMode := os.Getenv("GIN_MODE")
    if ginMode == "" {
       ginMode = gin.ReleaseMode
    }
    gin.SetMode(ginMode)

    r := gin.Default()
    r.Use(gin.Logger())
    r.Use(gin.Recovery())

    allowedOrigins := os.Getenv("ALLOWED_ORIGINS")

    if gin.Mode() == gin.DebugMode {
        r.Use(cors.New(cors.Config{
            AllowOrigins:     []string{"http://localhost:*"},
            AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
            AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization", "X-Requested-With"},
            ExposeHeaders:    []string{"Content-Length"},
            AllowCredentials: true,
            AllowOriginFunc: func(origin string) bool {
                return strings.HasPrefix(origin, "http://localhost:")
            },
            MaxAge: 12 * time.Hour,
        }))
    } else {
        r.Use(cors.New(cors.Config{
            AllowOrigins:     strings.Split(allowedOrigins, ","),
            AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
            AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization", "X-Requested-With"},
            ExposeHeaders:    []string{"Content-Length"},
            AllowCredentials: true,
            MaxAge:           12 * time.Hour,
        }))
    }

    controllers.RegisterRoutes(r)
    websockets.RegisterWebsocket(r)

    if err := r.Run(":8080"); err != nil {
       fmt.Fprintf(os.Stderr, "Error: %v\n", err)
       os.Exit(1)
    }
}