package models

import (
	"fmt"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDB(test bool) error {
	var dialect gorm.Dialector

	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=disable",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"),
		os.Getenv("DB_PORT"),
	)

	if !test {
		dialect = postgres.Open(dsn)
	} else {
		dialect = sqlite.Open("file::memory:?cache=shared")
	}

	database, err := gorm.Open(dialect, &gorm.Config{})
	if err != nil {
		return err
	}

	DB = database

	if test {
		if err := Migration(); err != nil {
			return err
		}
	}

	return nil
}

func CloseDB() error {
	sqlDB, err := DB.DB()
	if err != nil {
		return err
	}

	return sqlDB.Close()
}

func Migration() error {
	return DB.AutoMigrate(
		&User{},
		&Feature{},
		&Token{},
		&Tournament{},
		&VerificationCode{},
		&Team{},
		&Game{},
	)
}

func DropTables() error {
	return DB.Migrator().DropTable(
		&User{},
		&Feature{},
		&Token{},
		&Tournament{},
		&VerificationCode{},
		&Team{},
		"tournament_teams",
		"team_members",
		&Game{},
	)
}

type Model interface {
	FindOne(key string, value any) error
	FindOneById(id int) error
	Save() error
	Delete() error
}
