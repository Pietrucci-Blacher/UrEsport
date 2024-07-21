package models

import (
	"challenge/services"
	"time"
)

type Game struct {
	ID          int          `json:"id" gorm:"primaryKey"`
	Name        string       `json:"name" gorm:"type:varchar(100)"`
	Description string       `json:"description" gorm:"type:varchar(255)"`
	Image       string       `json:"image" gorm:"type:varchar(255)"`
	Tags        []string     `json:"tags" gorm:"json"`
	Tournaments []Tournament `json:"tournaments" gorm:"foreignKey:GameID"`
	CreatedAt   time.Time    `json:"created_at"`
	UpdatedAt   time.Time    `json:"updated_at"`
	DeletedAt   *time.Time   `json:"deleted_at"`
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
		Where("deleted_at IS NULL").
		Offset(query.GetSkip()).
		Where(query.GetWhere()).
		Where(query.GetSearch()).
		Order(query.GetSort()).
		Preload("Tournaments")

	if query.GetLimit() != 0 {
		value.Limit(query.GetLimit())
	}

	err := value.Find(&games).Error

	return games, err
}

func CountGameByName(name string) (int64, error) {
	var count int64

	err := DB.Model(&Game{}).
		Where("deleted_at IS NULL").
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

func (g *Game) FindOne(key string, value any) error {
	return DB.Where(key, value).
		Where("deleted_at IS NULL").
		First(g).Error
}

func (g *Game) Delete() error {
	del := time.Now()
	g.DeletedAt = &del
	g.Name = "[deleted]"
	g.Description = "[deleted]"

	return g.Save()
}

func ClearGames() error {
	return DB.Exec("DELETE FROM games").Error
}

func (g *Game) GetTournaments() ([]Tournament, error) {
	var tournaments []Tournament
	err := DB.Model(&g).Association("Tournaments").Find(&tournaments)
	return tournaments, err
}
