package models

import (
	"challenge/services"
	"time"
)

type Team struct {
	ID          int          `json:"id" gorm:"primaryKey"`
	Name        string       `json:"name" gorm:"type:varchar(100)"`
	Members     []User       `json:"members" gorm:"many2many:team_members;"`
	Tournaments []Tournament `json:"tournaments" gorm:"many2many:tournament_teams;"`
	Owner       User         `json:"owner" gorm:"foreignKey:OwnerID"`
	OwnerID     int          `json:"owner_id"`
	Private     bool         `json:"private" gorm:"default:false"`
	CreatedAt   time.Time    `json:"created_at"`
	UpdatedAt   time.Time    `json:"updated_at"`
}

type SanitizedTeam struct {
	ID          int                   `json:"id"`
	Name        string                `json:"name"`
	Members     []SanitizedUser       `json:"members"`
	Tournaments []SanitizedTournament `json:"tournaments"`
	Owner       SanitizedUser         `json:"owner"`
	OwnerID     int                   `json:"owner_id"`
	Private     bool                  `json:"private"`
	CreatedAt   time.Time             `json:"created_at"`
	UpdatedAt   time.Time             `json:"updated_at"`
}

type CreateTeamDto struct {
	Name string `json:"name" validate:"required"`
}

type UpdateTeamDto struct {
	Name string `json:"name"`
}

type InviteUserDto struct {
	Username string `json:"username" validate:"required"`
}

type InviteTeamDto struct {
	Name string `json:"name" validate:"required"`
}

func FindAllTeams(query services.QueryFilter) ([]Team, error) {
	var teams []Team

	err := DB.Model(&Team{}).
		Offset(query.GetSkip()).
		Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Order(query.GetSort()).
		Preload("Members").
		Preload("Owner").
		Preload("Tournaments").
		Find(&teams).Error

	return teams, err
}

func FindTeamsByUserID(userID int) ([]Team, error) {
	var teams []Team

	err := DB.Model(&Team{}).
		Where("owner_id", userID).
		Preload("Members").
		Preload("Owner").
		Preload("Tournaments").
		Find(&teams).Error

	return teams, err
}

func IsTeamExists(name string) bool {
	var team Team
	DB.Where("name", name).First(&team)
	return team.ID != 0
}

func (t *Team) TogglePrivate() {
	t.Private = !t.Private
}

func (t *Team) AddMember(user User) error {
	return DB.Model(&t).Association("Members").Append(&user)
}

func (t *Team) RemoveMember(user User) error {
	return DB.Model(&t).Association("Members").Delete(&user)
}

func (t *Team) RemoveAllMembers() error {
	return DB.Model(&t).Association("Members").Clear()
}

func (t *Team) RemoveAllTournaments() error {
	return DB.Model(&t).Association("Tournaments").Clear()
}

func (t *Team) HasMember(user User) bool {
	for _, member := range t.Members {
		if member.ID == user.ID {
			return true
		}
	}
	return false
}

func (t *Team) IsOwner(user User) bool {
	return t.OwnerID == user.ID
}

func (t *Team) Sanitize() SanitizedTeam {
	var sanitizedMembers []SanitizedUser
	var sanitizedTournaments []SanitizedTournament

	for _, member := range t.Members {
		sanitizedMembers = append(sanitizedMembers, member.Sanitize(false))
	}

	for _, tournament := range t.Tournaments {
		sanitizedTournaments = append(sanitizedTournaments, tournament.Sanitize(false))
	}

	return SanitizedTeam{
		ID:          t.ID,
		Name:        t.Name,
		Members:     sanitizedMembers,
		Tournaments: sanitizedTournaments,
		Owner:       t.Owner.Sanitize(false),
		OwnerID:     t.OwnerID,
		Private:     t.Private,
		CreatedAt:   t.CreatedAt,
		UpdatedAt:   t.UpdatedAt,
	}
}

func (t *Team) FindOneById(id int) error {
	return DB.Model(&Team{}).
		Preload("Members").
		Preload("Owner").
		Preload("Tournaments").
		First(&t, id).Error
}

func (t *Team) FindOne(key string, value any) error {
	return DB.Model(&Team{}).
		Where(key, value).
		Preload("Members").
		Preload("Owner").
		Preload("Tournaments").
		First(&t).Error
}

func (t *Team) Save() error {
	return DB.Save(&t).Error
}

func (t *Team) Delete() error {
	if err := t.RemoveAllMembers(); err != nil {
		return err
	}

	if err := t.RemoveAllTournaments(); err != nil {
		return err
	}

	return DB.Delete(&t).Error
}

func ClearTeams() error {
	return DB.Exec("DELETE FROM teams").Error
}
