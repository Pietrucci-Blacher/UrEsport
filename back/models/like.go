package models

import (
	"errors"
	"time"

	"gorm.io/gorm"
)

type Like struct {
	ID        int       `json:"id" gorm:"primaryKey"`
	UserID    int       `json:"user_id"`
	GameID    int       `json:"game_id"`
	Game      Game      `json:"game" gorm:"foreignKey:GameID"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type CreateLikeDto struct {
	UserID int `json:"user_id" validate:"required"`
	GameID int `json:"game_id" validate:"required"`
}

func GetAllLikes() ([]Like, error) {
	var likes []Like
	err := DB.Find(&likes).Error
	return likes, err
}

func GetLikeByID(id int) (*Like, error) {
	var like Like
	err := DB.First(&like, id).Error
	return &like, err
}

func GetLikesByUserIDAndGameID(userID, gameID int) ([]Like, error) {
	var likes []Like
	err := DB.Where("user_id = ? AND game_id = ?", userID, gameID).Find(&likes).Error
	return likes, err
}

func CreateLike(like *Like) error {
	return DB.Create(like).Error
}

func (l *Like) FindOne(key string, value any) error {
	return DB.Where(key, value).First(l).Error
}

func (l *Like) FindOneById(id int) error {
	return DB.First(l, id).Error
}

func (l *Like) Save() error {
	return DB.Save(l).Error
}

func (l *Like) Delete() error {
	return DB.Delete(l).Error
}

func LikeExists(userID int, gameID int) (bool, error) {
	var like Like
	err := DB.Where("user_id = ? AND game_id = ?", userID, gameID).First(&like).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return false, nil
	}
	return err == nil, err
}

func GetLikesByUserID(userID int) ([]Like, error) {
	var likes []Like
	err := DB.Where("user_id = ?", userID).
		Preload("Game").
		Find(&likes).
		Error
	return likes, err
}
