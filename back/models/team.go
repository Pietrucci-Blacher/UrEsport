package models

import (
	"challenge/utils"
	"time"
)

type Team struct {
	ID        int       `json:"id" gorm:"primaryKey"`
	Name      string    `json:"name" gorm:"type:varchar(100)"`
	Members   []User    `json:"members" gorm:"many2many:team_members;"`
	Owner     User      `json:"owner" gorm:"foreignKey:OwnerID"`
	OwnerID   int       `json:"owner_id"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type SanitizedTeam struct {
	ID        int             `json:"id"`
	Name      string          `json:"name"`
	Members   []SanitizedUser `json:"members"`
	Owner     SanitizedUser   `json:"owner"`
	OwnerID   int             `json:"owner_id"`
	CreatedAt time.Time       `json:"created_at"`
	UpdatedAt time.Time       `json:"updated_at"`
}

type CreateTeamDto struct {
	Name string `json:"name" validate:"required"`
}

type UpdateTeamDto struct {
	Name string `json:"name"`
}

func FindAllTeams(query utils.QueryFilter) ([]Team, error) {
	var teams []Team

	err := DB.Model(&Team{}).
		Offset(query.GetSkip()).
		Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Preload("Members").
		Preload("Owner").
		Find(&teams).Error

	return teams, err
}

func (t *Team) Sanitize() SanitizedTeam {
	var sanitizedMembers []SanitizedUser

	for _, member := range t.Members {
		sanitizedMembers = append(sanitizedMembers, member.Sanitize(false))
	}

	return SanitizedTeam{
		ID:        t.ID,
		Name:      t.Name,
		Members:   sanitizedMembers,
		Owner:     t.Owner.Sanitize(false),
		OwnerID:   t.OwnerID,
		CreatedAt: t.CreatedAt,
		UpdatedAt: t.UpdatedAt,
	}
}

func (t *Team) FindOneById(id int) error {
	return DB.Model(&Team{}).
		Preload("Members").
		Preload("Owner").
		First(&t, id).Error
}

func (t *Team) FindOne(key string, value any) error {
	return DB.Model(&Team{}).
		Where(key, value).
		Preload("Members").
		Preload("Owner").
		First(&t).Error
}

func (t *Team) Save() error {
	return DB.Save(&t).Error
}

func (t *Team) Delete() error {
	return DB.Delete(&t).Error
}

func ClearTeams() error {
	return DB.Exec("DELETE FROM teams").Error
}
