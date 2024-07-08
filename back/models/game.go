package models

import (
	"challenge/services"
	"time"
)

type Game struct {
	ID          int       `json:"id" gorm:"primaryKey"`
	Name        string    `json:"name" gorm:"type:varchar(100)"`
	Description string    `json:"description" gorm:"type:varchar(255)"`
	Image       string    `json:"image" gorm:"type:varchar(255)"`
	Tags        []string  `json:"tags" gorm:"json"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
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

func FindAllGames(query services.QueryFilter) ([]Game, error) {
	var games []Game

	value := DB.Model(&Game{}).
		Offset(query.GetSkip()).
		Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Order(query.GetSort()).
		Find(&games)

	return games, value.Error
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
