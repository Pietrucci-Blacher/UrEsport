package models

import (
	"challenge/services"
	"math"
	"time"
)

type Tournament struct {
	ID          int       `json:"id" gorm:"primaryKey"`
	Name        string    `json:"name" gorm:"type:varchar(100)"`
	Description string    `json:"description" gorm:"type:varchar(255)"`
	StartDate   time.Time `json:"start_date"`
	EndDate     time.Time `json:"end_date"`
	Location    string    `json:"location" gorm:"type:varchar(100)"`
	Latitude    float64   `json:"latitude" gorm:"type:decimal(10,8)"`
	Longitude   float64   `json:"longitude" gorm:"type:decimal(11,8)"`
	OwnerID     int       `json:"owner_id"`
	Owner       User      `json:"owner" gorm:"foreignKey:OwnerID"`
	Teams       []Team    `json:"teams" gorm:"many2many:tournament_teams;"`
	Image       string    `json:"image" gorm:"type:text"`
	Private     bool      `json:"private" gorm:"default:false"`
	GameID      int       `json:"game_id"`
	Game        Game      `json:"game" gorm:"foreignKey:GameID"`
	NbPlayer    int       `json:"nb_player" gorm:"default:1"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type CreateTournamentDto struct {
	Name        string    `json:"name" validate:"required"`
	Description string    `json:"description" validate:"required"`
	StartDate   time.Time `json:"start_date" validate:"required"`
	EndDate     time.Time `json:"end_date" validate:"required"`
	Location    string    `json:"location" validate:"required"`
	Latitude    float64   `json:"latitude" validate:"required"`
	Longitude   float64   `json:"longitude" validate:"required"`
	Private     bool      `json:"private"`
	NbPlayer    int       `json:"nb_player" validate:"required"`
	GameID      int       `json:"game_id" validate:"required"`
}

type UpdateTournamentDto struct {
	Name        string    `json:"name"`
	Description string    `json:"description"`
	StartDate   time.Time `json:"start_date"`
	EndDate     time.Time `json:"end_date"`
	Location    string    `json:"location"`
	Latitude    float64   `json:"latitude"`
	Longitude   float64   `json:"longitude"`
	Image       string    `json:"image"`
	NbPlayer    int       `json:"nb_player"`
	GameID      int       `json:"game_id"`
}

type SanitizedTournament struct {
	ID          int             `json:"id"`
	Name        string          `json:"name"`
	Description string          `json:"description"`
	StartDate   time.Time       `json:"start_date"`
	EndDate     time.Time       `json:"end_date"`
	Location    string          `json:"location"`
	Latitude    float64         `json:"latitude"`
	Longitude   float64         `json:"longitude"`
	Image       string          `json:"image"`
	Private     bool            `json:"private"`
	OwnerID     int             `json:"owner_id"`
	Owner       SanitizedUser   `json:"owner"`
	Teams       []SanitizedTeam `json:"teams"`
	GameID      int             `json:"game_id"`
	Game        Game            `json:"game"`
	NbPlayer    int             `json:"nb_player"`
	CreatedAt   time.Time       `json:"created_at"`
	UpdatedAt   time.Time       `json:"updated_at"`
}

func FindAllTournaments(query services.QueryFilter) ([]Tournament, error) {
	var tournaments []Tournament

	err := DB.Model(&Tournament{}).
		Offset(query.GetSkip()).
		Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Order(query.GetSort()).
		Preload("Teams").
		Preload("Owner").
		Preload("Game").
		Find(&tournaments).Error

	return tournaments, err
}

func FindTournamentsByUserID(userID int) ([]Tournament, error) {
	var tournaments []Tournament

	err := DB.Model(&Tournament{}).
		Where("owner_id", userID).
		Preload("Teams").
		Preload("Owner").
		Preload("Game").
		Find(&tournaments).Error

	return tournaments, err
}

func (t *Tournament) GenerateBraketTree() ([]Match, error) {
	var matches []Match

	chErr := make(chan error)
	chMatch := make(chan Match)
	nbTeam := len(t.Teams)

	if nbTeam%2 != 0 {
		nbTeam++
	}

	depth := int(math.Round(math.Log2(float64(nbTeam / 2))))
	nbMatch := (2 << uint(depth)) - 1 // 2^depth - 1

	go CreateBinaryTree(t.ID, nil, depth, chMatch, chErr)

	for i := 0; i < nbMatch; i++ {
		if err := <-chErr; err != nil {
			return nil, err
		}

		match := <-chMatch
		matches = append(matches, match)
	}

	var i int
	for _, match := range matches {
		if match.Depth != 0 {
			continue
		}

		if i < len(t.Teams) {
			match.Team1ID = &t.Teams[i].ID
			match.Team1 = t.Teams[i]
		}
		if i+1 < len(t.Teams) {
			match.Team2ID = &t.Teams[i+1].ID
			match.Team2 = t.Teams[i+1]
		}

		if err := match.Save(); err != nil {
			return nil, err
		}

		i += 2
	}

	return matches, nil
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
		Latitude:    t.Latitude,
		Longitude:   t.Longitude,
		Image:       t.Image,
		Private:     t.Private,
		OwnerID:     t.OwnerID,
		Owner:       t.Owner.Sanitize(false),
		GameID:      t.GameID,
		Game:        t.Game,
		NbPlayer:    t.NbPlayer,
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

func (t *Tournament) HasTeam(team Team) bool {
	for _, t := range t.Teams {
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
		Preload("Game").
		First(&t, id).Error
}

func (t *Tournament) FindOne(key string, value any) error {
	return DB.Model(&Tournament{}).
		Preload("Teams").
		Preload("Owner").
		Preload("Game").
		Where(key, value).
		First(&t).Error
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
