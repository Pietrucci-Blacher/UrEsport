package models

import (
	"challenge/services"
	"time"
)

type Rating struct {
	ID           uint      `json:"id" gorm:"primaryKey"`
	TournamentID uint      `json:"tournament_id" gorm:"not null"`
	UserID       uint      `json:"user_id" gorm:"not null"`
	Rating       float32   `json:"rating" gorm:"not null"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

func (r *Rating) FindOne(key string, value any) error {
	return DB.Model(&Rating{}).
		Where(key, value).
		First(&r).Error
}

func (r *Rating) FindOneById(id int) error {
	return DB.Model(&Rating{}).
		First(&r, id).Error
}

type CreateRatingDto struct {
	TournamentID uint    `json:"tournament_id" validate:"required"`
	UserID       uint    `json:"user_id" validate:"required"`
	Rating       float32 `json:"rating" validate:"required,gte=0,lte=5"`
}

type GetRatingDto struct {
	TournamentID uint `json:"tournament_id"`
	UserID       uint `json:"user_id"`
}

type UpdateRatingDto struct {
	Rating float32 `json:"rating" validate:"required,gte=0,lte=5"`
}

func FindAllRatings(query services.QueryFilter) ([]Rating, error) {
	var ratings []Rating

	err := DB.Model(&Rating{}).
		Offset(query.GetSkip()).
		//Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Order(query.GetSort()).
		Find(&ratings).Error

	return ratings, err
}

func FindRatingByTournamentAndUser(tournamentID, userID uint, rating *Rating) error {
	return DB.Where("tournament_id = ? AND user_id = ?", tournamentID, userID).First(rating).Error
}

func CountRatingByUserAndTournament(userID, tournamentID uint) (int64, error) {
	var count int64

	err := DB.Model(&Rating{}).
		Where("user_id = ? AND tournament_id = ?", userID, tournamentID).
		Count(&count).Error

	return count, err
}

func (r *Rating) Save() error {
	return DB.Save(r).Error
}

func FindRatingById(id string, rating *Rating) error { // Correction du nom de la fonction
	return DB.Where("id = ?", id).First(rating).Error
}

func (r *Rating) Delete() error {
	return DB.Delete(r).Error
}
