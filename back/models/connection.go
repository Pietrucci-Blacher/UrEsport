package models

import (
	"fmt"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDB() error {
	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=disable",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"),
		os.Getenv("DB_PORT"),
	)

	database, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
	if err != nil {
		return err
	}

	DB = database

	return nil
}

func Migration() error {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
	return DB.AutoMigrate(&User{}, &Feature{})
=======
=======
>>>>>>> Stashed changes
	return DB.AutoMigrate(
		&User{},
		&Token{},
	)
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
}

type Model interface {
	FindOne(key string, value any)
	FindOneById(id int) error
	Save() error
	Delete() error
}
