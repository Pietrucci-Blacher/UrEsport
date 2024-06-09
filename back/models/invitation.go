package models

import (
	"challenge/utils"
	"time"
)

const (
	PENDING  = "pending"
	ACCEPTED = "accepted"
	REJECTED = "rejected"

	TEAM_INVIT       = "team"
	TOURNAMENT_INVIT = "tournament"
)

type Invit struct {
	ID           int        `json:"id" gorm:"primaryKey"`
	TeamID       *int       `json:"team_id"`
	Team         Team       `json:"team" gorm:"foreignKey:TeamID"`
	TournamentID *int       `json:"tournament_id"`
	Tournament   Tournament `json:"tournament" gorm:"foreignKey:TournamentID"`
	UserID       *int       `json:"user_id"`
	User         User       `json:"user" gorm:"foreignKey:UserID"`
	Type         string     `json:"type" gorm:"type:varchar(100)"`
	Status       string     `json:"status" gorm:"type:varchar(100)"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

func NewTeamInvit(teamID int, userID int) *Invit {
	return &Invit{
		TeamID: &teamID,
		UserID: &userID,
		Type:   TEAM_INVIT,
		Status: PENDING,
	}
}

func NewTournamentInvit(tournamentID int, teamID int) *Invit {
	return &Invit{
		TeamID:       &teamID,
		TournamentID: &tournamentID,
		Type:         TOURNAMENT_INVIT,
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
		Preload("User").
		Find(&invitations).Error

	return invitations, err
}

// FindInvit returns all invitations of a specific type for a list of ids
//
// invitType: the type of invitation (team_invit or tournament_invit)
// param: the parameter to filter the ids (team_id or tournament_id)
// ids: the list of ids to filter
//
// FindInvit("team_invit", "team_id", []int{1, 2, 3})
// FindInvit("team_invit", "user_id", []int{1})
// FindInvit("tournament_invit", "team_id", []int{1, 2, 3})
// FindInvit("tournament_invit", "tournament_id", []int{1, 2, 3})
func FindInvitByType(invitType, param string, ids []int) ([]Invit, error) {
	var invitations []Invit

	err := DB.Model(&Invit{}).
		Where(param+" IN ?", ids).
		Where("type", invitType).
		Where("status", PENDING).
		Preload("Team").
		Preload("Tournament").
		Preload("User").
		Find(&invitations).Error

	return invitations, err
}

func (i *Invit) IsForTeam(team Team) bool {
	return *i.TeamID == team.ID
}

func (i *Invit) IsForTournament(tournament Tournament) bool {
	return *i.TournamentID == tournament.ID
}

func (i *Invit) FindOneByTournamentAndTeam(tournamentID, teamID int) error {
	return DB.Model(&Invit{}).
		Where("team_id", teamID).
		Where("tournament_id", tournamentID).
		Where("type", TOURNAMENT_INVIT).
		Where("status", PENDING).
		First(&i).Error
}

func (i *Invit) FindOneByTeamAndUser(teamID, userID int) error {
	return DB.Model(&Invit{}).
		Where("team_id", teamID).
		Where("user_id", userID).
		Where("type", TEAM_INVIT).
		Where("status", PENDING).
		First(&i).Error
}

func (i *Invit) FindOneById(id int) error {
	return DB.Model(&Invit{}).
		Preload("Team").
		Preload("Tournament").
		Preload("User").
		First(&i, id).Error
}

func (i *Invit) FindOne(key string, value any) error {
	return DB.Model(&Invit{}).
		Where(key, value).
		Preload("Team").
		Preload("Tournament").
		Preload("User").
		First(&i).Error
}

func (i *Invit) Save() error {
	return DB.Save(i).Error
}

func (i *Invit) Delete() error {
	return DB.Delete(i).Error
}
