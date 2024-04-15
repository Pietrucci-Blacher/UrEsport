package main

import (
	"challenge/controllers"
	"challenge/models"
	"fmt"
	"os"

	"challenge/fixtures"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		panic("Failed to load env file")
	}

	if err := models.ConnectDB(false); err != nil {
		panic("Failed to connect to database")
	}

	if len(os.Args) == 2 && os.Args[1] == "--help" {
		fmt.Printf("Usage: %s [migrate|drop-table|fixtures]\n", os.Args[0])
		return
	}

	if len(os.Args) == 2 && os.Args[1] == "migrate" {
		if err := models.Migration(); err != nil {
			panic("Failed to migrate database")
		}
		fmt.Println("Database migrated")
		return
	}

	if len(os.Args) == 2 && os.Args[1] == "drop-table" {
		if err := models.DropTables(); err != nil {
			panic("Failed to drop table")
		}
		fmt.Println("Table dropped")
		return
	}

	if len(os.Args) == 2 && os.Args[1] == "fixtures" {
		// TODO: Implement fixtures
		fixtures.ImportFixtures()
		fmt.Println("Fixtures imported")
		return
	}

	r := gin.Default()
	r.Use(gin.Logger())
	r.Use(gin.Recovery())
	controllers.RegisterRoutes(r)

	if err := r.Run(":8080"); err != nil {
		panic("Failed to start server")
	}
}
