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
	DeletedAt   *time.Time   `json:"deleted_at"`
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
	Name    string `json:"name" validate:"required"`
	Private bool   `json:"private"`
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

	value := DB.Model(&Team{}).
		Where("deleted_at IS NULL").
		Offset(query.GetSkip()).
		Where(query.GetWhere()).
		Order(query.GetSort()).
		Preload("Members").
		Preload("Owner").
		Preload("Tournaments")

	if query.GetLimit() != 0 {
		value.Limit(query.GetLimit())
	}

	err := value.Find(&teams).Error

	return teams, err
}

func FindTeamsByUserID(userID int) ([]Team, error) {
	var teams []Team

	err := DB.Model(&Team{}).
		Where("deleted_at IS NULL").
		Where("owner_id", userID).
		Preload("Members").
		Preload("Owner").
		Preload("Tournaments").
		Find(&teams).Error

	return teams, err
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
		Where("deleted_at IS NULL").
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
	if err := t.RemoveAllTournaments(); err != nil {
		return err
	}
	if err := t.RemoveAllMembers(); err != nil {
		return err
	}

	del := time.Now()
	t.DeletedAt = &del
	t.Name = "[deleted]"

	return t.Save()
}

func ClearTeams() error {
	return DB.Exec("DELETE FROM teams").Error
}

func FindTeamsByUserId(userId int) ([]Team, error) {
	var teams []Team

	// Retrieve teams where the user is the owner
	err := DB.Model(&Team{}).
		Where("deleted_at IS NULL").
		Where("owner_id", userId).
		Preload("Members").
		Preload("Owner").
		Preload("Tournaments").
		Preload("Tournaments.Game").
		Find(&teams).Error
	if err != nil {
		return nil, err
	}

	// Retrieve teams where the user is a member
	var memberTeams []Team
	err = DB.Model(&Team{}).
		Where("deleted_at IS NULL").
		Joins("JOIN team_members ON team_members.team_id = teams.id").
		Where("team_members.user_id", userId).
		Preload("Members").
		Preload("Owner").
		Preload("Tournaments").
		Preload("Tournaments.Game").
		Find(&memberTeams).Error
	if err != nil {
		return nil, err
	}

	// Merge the two lists of teams, ensuring no duplicates
	teamMap := make(map[int]Team)
	for _, team := range teams {
		teamMap[team.ID] = team
	}
	for _, team := range memberTeams {
		if _, exists := teamMap[team.ID]; !exists {
			teams = append(teams, team)
		}
	}

	return teams, nil
}
