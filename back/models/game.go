package models

import (
	"time"

	"github.com/lib/pq"
)

type Game struct {
	ID          int            `json:"id" gorm:"primaryKey"`
	Name        string         `json:"name" gorm:"type:varchar(100)"`
	Description string         `json:"description" gorm:"type:varchar(255)"`
	Image       string         `json:"image" gorm:"type:varchar(255)"`
	Tags        pq.StringArray `json:"tags" gorm:"type:text[]"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
}

type CreateGameDto struct {
	Name        string   `json:"name" validate:"required"`
	Description string   `json:"description" validate:"required"`
	Image       string   `json:"image" validate:"required"`
	Tags        []string `json:"tags" validate:"required"`
}

type UpdateGameDto struct {
	Name        string   `json:"name"`
	Description string   `json:"description"`
	Image       string   `json:"image"`
	Tags        []string `json:"tags"`
}

func FindAllGames() ([]Game, error) {
	var games []Game
	err := DB.Find(&games).Error
	return games, err
}

func CountGameByName(name string) (int64, error) {
	var count int64

	err := DB.Model(&Game{}).
		Where("name = ?", name).
		Count(&count).Error

	return count, err
}

func (g *Game) Save() error {
	return DB.Save(g).Error
}

func (g *Game) FindOneById(id int) error {
	return DB.First(g, id).Error
}

func (g *Game) FindOne(key string, value interface{}) error {
	return DB.Where(key, value).First(g).Error
}

func (g *Game) Delete() error {
	return DB.Delete(g).Error
}

func ClearGames() error {
	return DB.Exec("DELETE FROM games").Error
}
