package models

import (
	"challenge/utils"
	"time"
)

const (
	PENDING  = "pending"
	ACCEPTED = "accepted"
	REJECTED = "rejected"
)

type Invit struct {
	ID           int        `json:"id" gorm:"primaryKey"`
	TeamID       int        `json:"team_id"`
	Team         Team       `json:"team" gorm:"foreignKey:TeamID"`
	TournamentID int        `json:"tournament_id"`
	Tournament   Tournament `json:"tournament" gorm:"foreignKey:TournamentID"`
	Status       string     `json:"status" gorm:"type:varchar(100)"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

func NewTeamInvit(teamID int) *Invit {
	return &Invit{
		TeamID:       teamID,
		TournamentID: 0,
		Status:       PENDING,
	}
}

func NewTournamentInvit(tournamentID int) *Invit {
	return &Invit{
		TeamID:       0,
		TournamentID: tournamentID,
		Status:       PENDING,
	}
}

func FindAllInvits(query utils.QueryFilter) ([]Invit, error) {
	var invitations []Invit

	err := DB.Model(&Invit{}).
		Offset(query.GetSkip()).
		Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Order(query.GetSort()).
		Preload("Team").
		Preload("Tournament").
		Find(&invitations).Error

	return invitations, err
}

func (i *Invit) IsForTeam(team Team) bool {
	return i.TeamID == team.ID
}

func (i *Invit) IsForTournament(tournament Tournament) bool {
	return i.TournamentID == tournament.ID
}

func (i *Invit) FindOneById(id int) error {
	return DB.Model(&Invit{}).
		Preload("Team").
		Preload("Tournament").
		First(&i, id).Error
}

func (i *Invit) FindOne(key string, value any) error {
	return DB.Model(&Invit{}).
		Where(key, value).
		Preload("Team").
		Preload("Tournament").
		First(&i).Error
}

func (i *Invit) Save() error {
	return DB.Save(i).Error
}

func (i *Invit) Delete() error {
	return DB.Delete(i).Error
}
