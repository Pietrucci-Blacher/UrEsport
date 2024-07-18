package models

import (
	"challenge/services"
	"errors"
	"math"
	"time"

	"gorm.io/gorm"
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
	Upvotes     int       `json:"upvote" gorm:"default:0"`
}

type CreateTournamentDto struct {
	Name        string    `json:"name" validate:"required"`
	Description string    `json:"description" validate:"required"`
	StartDate   time.Time `json:"start_date" validate:"required"`
	EndDate     time.Time `json:"end_date" validate:"required"`
	Location    string    `json:"location"`
	Latitude    float64   `json:"latitude"`
	Longitude   float64   `json:"longitude"`
	Private     bool      `json:"private"`
	GameID      int       `json:"game_id" validate:"required"`
	NbPlayer    int       `json:"nb_player" validate:"required"`
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
	Private     bool      `json:"private"`
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
	Game        Game            `json:"game"`
	NbPlayer    int             `json:"nb_player"`
	CreatedAt   time.Time       `json:"created_at"`
	UpdatedAt   time.Time       `json:"updated_at"`
	Upvotes     int             `json:"upvotes"`
}

func FindAllTournaments(query services.QueryFilter) ([]Tournament, error) {
	var tournaments []Tournament

	value := DB.Model(&Tournament{}).
		Offset(query.GetSkip()).
		//Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Order(query.GetSort()).
		Preload("Teams").
		Preload("Owner").
		Preload("Game")

	if query.GetLimit() != 0 {
		value.Limit(query.GetLimit())
	}

	value.Find(&tournaments)

	return tournaments, value.Error
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

func InTournamentArray(array []Tournament, value Tournament) bool {
	for _, v := range array {
		if v.ID == value.ID {
			return true
		}
	}
	return false
}

func (t *Tournament) GenerateBraketTree() ([]Match, error) {
	var matches []Match
	var ids []int

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

	for i, match := range matches {
		if match.Depth != 0 {
			continue
		}
		ids = append(ids, i)
	}

	for i, team := range t.Teams {
		match := &matches[ids[i/2]]

		if match.Team1ID == nil {
			match.Team1ID = &team.ID
			match.Team1 = team
		} else {
			match.Team2ID = &team.ID
			match.Team2 = team
		}

		if match.Team1ID != nil && match.Team2ID != nil {
			match.Status = PLAYING
		}

		if err := match.Save(); err != nil {
			return nil, err
		}
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
		Game:        t.Game,
		NbPlayer:    t.NbPlayer,
		CreatedAt:   t.CreatedAt,
		UpdatedAt:   t.UpdatedAt,
		Upvotes:     t.Upvotes,
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

func (t *Tournament) AddUpvote(userID int) error {
	return DB.Transaction(func(tx *gorm.DB) error {
		var upvote Upvote
		err := tx.Where("user_id = ? AND tournament_id = ?", userID, t.ID).First(&upvote).Error

		if errors.Is(err, gorm.ErrRecordNotFound) {
			// Ajouter l'upvote
			upvote = Upvote{UserID: userID, TournamentID: t.ID}
			if err := tx.Create(&upvote).Error; err != nil {
				return err
			}
			// Incrémenter le compteur de upvotes
			if err := tx.Model(&Tournament{}).Where("id = ?", t.ID).UpdateColumn("upvotes", gorm.Expr("upvotes + ?", 1)).Error; err != nil {
				return err
			}
		} else if err == nil {
			// Retirer l'upvote
			if err := tx.Delete(&upvote).Error; err != nil {
				return err
			}
			// Décrémenter le compteur de upvotes
			if err := tx.Model(&Tournament{}).Where("id = ?", t.ID).UpdateColumn("upvotes", gorm.Expr("upvotes - ?", 1)).Error; err != nil {
				return err
			}
		} else {
			return err
		}

		return nil
	})
}

// Compter le nombre de upvotes d'un tournoi
func (t *Tournament) CountUpvotes() (int64, error) {
	var count int64
	err := DB.Model(&Upvote{}).Where("tournament_id = ?", t.ID).Count(&count).Error
	return count, err
}

func GetUpvoteByUserAndTournament(userID, tournamentID uint) (*Upvote, error) {
	var upvote Upvote
	err := DB.Where("user_id = ? AND tournament_id = ?", userID, tournamentID).First(&upvote).Error
	return &upvote, err
}
