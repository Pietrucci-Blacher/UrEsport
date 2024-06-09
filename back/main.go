package main

import (
	"challenge/controllers"
	"challenge/fixtures"
	"challenge/models"
	"challenge/websockets"
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	if len(os.Args) == 2 && os.Args[1] == "help" {
		fmt.Printf("Usage: %s [migrate|droptable|fixtures]\n", os.Args[0])
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

	if len(os.Args) == 2 && os.Args[1] == "migrate" {
		if err := models.Migration(); err != nil {
			fmt.Fprintf(os.Stderr, "Error: Failed to migrate database\n")
			os.Exit(1)
		}
		fmt.Println("Database migrated")
		os.Exit(0)
	}

	if len(os.Args) == 2 && os.Args[1] == "droptable" {
		if err := models.DropTables(); err != nil {
			fmt.Fprintf(os.Stderr, "Error: Failed to drop table\n")
			os.Exit(1)
		}
		fmt.Println("Table dropped")
		os.Exit(0)
	}

	if len(os.Args) == 2 && os.Args[1] == "fixtures" {
		if err := fixtures.ImportFixtures(); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}
		fmt.Println("Fixtures imported")
		os.Exit(0)
	}

	ginMode := os.Getenv("GIN_MODE")
	if ginMode == "" {
		ginMode = gin.ReleaseMode
	}
	gin.SetMode(ginMode)

	r := gin.Default()
	r.Use(gin.Logger())
	r.Use(gin.Recovery())
	controllers.RegisterRoutes(r)
	websockets.RegisterWebsocket(r)

	if err := r.Run(":8080"); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
