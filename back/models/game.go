package models

import (
	"challenge/utils"
	"time"
)

type Game struct {
	ID          int       `json:"id" gorm:"primaryKey"`
	Name        string    `json:"name" gorm:"type:varchar(100)"`
	Description string    `json:"description" gorm:"type:varchar(255)"`
	Image       string    `json:"image" gorm:"type:varchar(255)"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type CreateGameDto struct {
	Name        string `json:"name" validate:"required"`
	Description string `json:"description" validate:"required"`
	Image       string `json:"image" validate:"required"`
}

type UpdateGameDto struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	Image       string `json:"image"`
}

type SanitizedGame struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Image       string `json:"image"`
}

func FindAllGames(query utils.QueryFilter) ([]Game, error) {
	var games []Game

	err := DB.Model(&Game{}).
		Offset(query.GetSkip()).
		Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Find(&games).Error

	return games, err
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

func (g *Game) GetTournaments() (interface{}, interface{}) {
	var tournaments []Tournament
	err := DB.Model(&g).Association("Tournaments").Find(&tournaments)
	return tournaments, err
}

func (g *Game) AddTournament(tournament Tournament) interface{} {
	return DB.Model(&g).Association("Tournaments").Append(&tournament)
}

func (g *Game) RemoveTournament(tournament Tournament) interface{} {
	return DB.Model(&g).Association("Tournaments").Delete(&tournament)
}

func (g *Game) GetParticipants() (interface{}, interface{}) {
	var participants []User
	err := DB.Model(&g).Association("Participants").Find(&participants)
	return participants, err
}

func (g *Game) AddParticipant(user User) interface{} {
	return DB.Model(&g).Association("Participants").Append(&user)
}

func (g *Game) RemoveParticipant(user User) interface{} {
	return DB.Model(&g).Association("Participants").Delete(&user)
}

func ClearGames() error {
	return DB.Exec("DELETE FROM games").Error
}
