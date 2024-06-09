package models

import (
	"challenge/utils"
	"time"
)

type Tournament struct {
	ID          int       `json:"id" gorm:"primaryKey"`
	Name        string    `json:"name" gorm:"type:varchar(100)"`
	Description string    `json:"description" gorm:"type:varchar(255)"`
	StartDate   time.Time `json:"start_date"`
	EndDate     time.Time `json:"end_date"`
	Location    string    `json:"location" gorm:"type:varchar(100)"`
	OwnerID     int       `json:"owner_id"`
	Owner       User      `json:"owner" gorm:"foreignKey:OwnerID"`
	Teams       []Team    `json:"teams" gorm:"many2many:tournament_teams;"`
	Image       string    `json:"image" gorm:"type:varchar(255)"`
	Private     bool      `json:"private" gorm:"default:false"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type CreateTournamentDto struct {
	Name        string    `json:"name" validate:"required"`
	Description string    `json:"description" validate:"required"`
	StartDate   time.Time `json:"start_date" validate:"required"`
	EndDate     time.Time `json:"end_date" validate:"required"`
	Location    string    `json:"location" validate:"required"`
	Image       string    `json:"image" validate:"required"`
	Private     bool      `json:"private"`
}

type UpdateTournamentDto struct {
	Name        string    `json:"name"`
	Description string    `json:"description"`
	StartDate   time.Time `json:"start_date"`
	EndDate     time.Time `json:"end_date"`
	Location    string    `json:"location"`
	Image       string    `json:"image"`
}

type SanitizedTournament struct {
	ID          int             `json:"id"`
	Name        string          `json:"name"`
	Description string          `json:"description"`
	StartDate   time.Time       `json:"start_date"`
	EndDate     time.Time       `json:"end_date"`
	Location    string          `json:"location"`
	Image       string          `json:"image"`
	Private     bool            `json:"private"`
	OwnerID     int             `json:"owner_id"`
	Owner       SanitizedUser   `json:"owner"`
	Teams       []SanitizedTeam `json:"teams"`
	CreatedAt   time.Time       `json:"created_at"`
	UpdatedAt   time.Time       `json:"updated_at"`
}

func FindAllTournaments(query utils.QueryFilter) ([]Tournament, error) {
	var tournaments []Tournament

	err := DB.Model(&Tournament{}).
		Offset(query.GetSkip()).
		Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Order(query.GetSort()).
		Preload("Teams").
		Preload("Owner").
		Find(&tournaments).Error

	return tournaments, err
}

func FindTournamentsByUserID(userID int) ([]Tournament, error) {
	var tournaments []Tournament

	err := DB.Model(&Tournament{}).
		Where("owner_id", userID).
		Preload("Teams").
		Preload("Owner").
		Find(&tournaments).Error

	return tournaments, err
}

func (t *Tournament) Sanitize(getTeam bool) SanitizedTournament {
	var teams []SanitizedTeam

	tournament := SanitizedTournament{
		ID:          t.ID,
		Name:        t.Name,
		Description: t.Description,
		StartDate:   t.StartDate,
		EndDate:     t.EndDate,
		Location:    t.Location,
		Image:       t.Image,
		Private:     t.Private,
		OwnerID:     t.OwnerID,
		Owner:       t.Owner.Sanitize(false),
		CreatedAt:   t.CreatedAt,
		UpdatedAt:   t.UpdatedAt,
	}

	if getTeam {
		for _, team := range t.Teams {
			teams = append(teams, team.Sanitize())
		}

		tournament.Teams = teams
	}

	return tournament
}

func (t *Tournament) IsOwner(user User) bool {
	return t.OwnerID == user.ID
}

func (t *Tournament) TogglePrivate() {
	t.Private = !t.Private
}

func (t *Tournament) AddTeam(team Team) error {
	return DB.Model(t).Association("Teams").Append(&team)
}

func (t *Tournament) RemoveTeam(team Team) error {
	return DB.Model(t).Association("Teams").Delete(&team)
}

func (t *Tournament) RemoveAllTeams() error {
	return DB.Model(t).Association("Teams").Clear()
}

func (r *Tournament) HasTeam(team Team) bool {
	for _, t := range r.Teams {
		if t.ID == team.ID {
			return true
		}
	}
	return false
}

func (t *Tournament) Save() error {
	return DB.Save(t).Error
}

func (t *Tournament) FindOneById(id int) error {
	return DB.Model(&Tournament{}).
		Preload("Teams").
		Preload("Owner").
		First(&t, id).Error
}

func (t *Tournament) FindOne(key string, value any) error {
	return DB.Model(&Tournament{}).
		Preload("Teams").
		Preload("Owner").
		Where(key, value).
		First(t).Error
}

func (t *Tournament) Delete() error {
	if err := t.RemoveAllTeams(); err != nil {
		return err
	}
	return DB.Delete(t).Error
}

func ClearTournaments() error {
	return DB.Exec("DELETE FROM tournaments").Error
}
