package models

import (
	"challenge/services"
	"time"
)

type Match struct {
	ID           int        `json:"id" gorm:"primaryKey"`
	TournamentID int        `json:"tournament_id"`
	Tournament   Tournament `json:"tournament" gorm:"foreignKey:TournamentID"`
	Team1ID      *int       `json:"team1_id"`
	Team1        Team       `json:"team1" gorm:"foreignKey:Team1ID"`
	Team2ID      *int       `json:"team2_id"`
	Team2        Team       `json:"team2" gorm:"foreignKey:Team2ID"`
	WinnerID     *int       `json:"winner_id"`
	Score1       int        `json:"score1"`
	Score2       int        `json:"score2"`
	NextMatchID  *int       `json:"next_match_id"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

type ScoreMatchDto struct {
	Score1 int `json:"score1" validate:"required"`
	Score2 int `json:"score2" validate:"required"`
}

func NewEmptyMatch(tournamentID int) Match {
	return Match{
		TournamentID: tournamentID,
		Team1ID:      nil,
		Team2ID:      nil,
		WinnerID:     nil,
		NextMatchID:  nil,
		Score1:       0,
		Score2:       0,
	}
}

func NewMatch(tournamentID, team1ID, team2ID int) Match {
	return Match{
		TournamentID: tournamentID,
		Team1ID:      &team1ID,
		Team2ID:      &team2ID,
		WinnerID:     nil,
		NextMatchID:  nil,
		Score1:       0,
		Score2:       0,
	}
}

func FindAllMatchs(query services.QueryFilter) ([]Match, error) {
	var matches []Match

	err := DB.Model(&Match{}).
		Offset(query.GetSkip()).
		Limit(query.GetLimit()).
		Where(query.GetWhere()).
		Order(query.GetSort()).
		Preload("Tournament").
		Preload("Team1").
		Preload("Team2").
		Find(&matches).Error

	return matches, err
}

func (m *Match) SetWinner(score1, score2 int) Team {
	if score1 > score2 {
		m.WinnerID = m.Team1ID
		return m.Team1
	}

	m.WinnerID = m.Team2ID
	return m.Team2
}

func (m *Match) HasTeam(team Team) bool {
	return *m.Team1ID == team.ID || *m.Team2ID == team.ID
}

func (m *Match) HasTeamMember(user User) bool {
	return m.Team1.HasMember(user) || m.Team2.HasMember(user)
}

func (m *Match) HasTeamOwner(user User) bool {
	return m.Team1.IsOwner(user) || m.Team2.IsOwner(user)
}

func (m *Match) FindOneById(id int) error {
	return DB.Model(&Match{}).
		Preload("Tournament").
		Preload("Team1").
		Preload("Team2").
		First(m, id).Error
}

func (m *Match) FindOne(key string, value any) error {
	return DB.Model(&Match{}).
		Preload("Tournament").
		Preload("Team1").
		Preload("Team2").
		Where(key, value).
		First(m).Error
}

func (m *Match) Save() error {
	return DB.Save(m).Error
}

func (m *Match) Delete() error {
	return DB.Delete(m).Error
}
