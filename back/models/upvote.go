package models

import (
	"time"
)

type Upvote struct {
	ID           int        `json:"id" gorm:"primaryKey"`
	UserID       int        `json:"user_id"`
	User         User       `json:"user" gorm:"foreignKey:UserID"`
	TournamentID int        `json:"tournament_id"`
	Tournament   Tournament `json:"tournament" gorm:"foreignKey:TournamentID"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}
