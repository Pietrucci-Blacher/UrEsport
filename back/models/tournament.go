package models

import "time"

type Tournament struct {
	ID           int       `json:"id" gorm:"primaryKey"`
	Name         string    `json:"name" gorm:"type:varchar(100)"`
	Description  string    `json:"description" gorm:"type:varchar(255)"`
	StartDate    time.Time `json:"start_date"`
	EndDate      time.Time `json:"end_date"`
	Location     string    `json:"location" gorm:"type:varchar(100)"`
	OrganizerID  int       `json:"organizer" gorm:"foreignKey:ID"`
	Participants []User    `json:"participants" gorm:"many2many:tournament_participants;"`
	Image        string    `json:"image" gorm:"type:varchar(255)"`
	Private      bool      `json:"private"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
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

type InviteUserDto struct {
	Username string `json:"username" validate:"required"`
}

func FindAllTournaments() ([]Tournament, error) {
	var tournaments []Tournament

	err := DB.Model(&Tournament{}).
		Preload("Participants").
		Find(&tournaments).Error

	return tournaments, err
}

func (t *Tournament) Sanitize() Tournament {
	var participants []User

	for _, p := range t.Participants {
		participants = append(participants, p.Sanitize())
	}

	return Tournament{
		ID:           t.ID,
		Name:         t.Name,
		Description:  t.Description,
		StartDate:    t.StartDate,
		EndDate:      t.EndDate,
		Location:     t.Location,
		Image:        t.Image,
		Private:      t.Private,
		CreatedAt:    t.CreatedAt,
		UpdatedAt:    t.UpdatedAt,
		Participants: participants,
	}
}

func (t *Tournament) AddParticipant(user User) error {
	return DB.Model(t).Association("Participants").Append(&user)
}

func (t *Tournament) RemoveParticipant(user User) error {
	return DB.Model(t).Association("Participants").Delete(&user)
}

func (t *Tournament) Save() error {
	return DB.Save(t).Error
}

func (t *Tournament) FindOneById(id int) error {
	return DB.Model(&Tournament{}).
		Preload("Participants").
		First(t, id).Error
}

func (t *Tournament) FindOne(key string, value any) error {
	return DB.Model(&Tournament{}).
		Preload("Participants").
		Where(key, value).
		First(t).Error
}

func (t *Tournament) Delete() error {
	return DB.Delete(t).Error
}
