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
	Depth        int        `json:"depth"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

type UpdateMatchDto struct {
	Team1ID     *int `json:"team1_id"`
	Team2ID     *int `json:"team2_id"`
	Score1      int  `json:"score1"`
	Score2      int  `json:"score2"`
	WinnerID    *int `json:"winner_id"`
	NextMatchID *int `json:"next_match_id"`
}

type ScoreMatchDto struct {
	Score int `json:"score" validate:"required"`
}

func NewEmptyMatch(tournamentID int) Match {
	return Match{
		TournamentID: tournamentID,
		Team1ID:      nil,
		Team2ID:      nil,
		WinnerID:     nil,
		NextMatchID:  nil,
		Depth:        0,
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
		Depth:        0,
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

func DeleteByTournamentID(tournamentID int) error {
	return DB.Where("tournament_id", tournamentID).Delete(&Match{}).Error
}

func CountMatchsByTournamentID(tournamentID int) (int64, error) {
	var count int64

	err := DB.Model(&Match{}).
		Where("tournament_id", tournamentID).
		Count(&count).Error

	return count, err
}

func (m *Match) SetScore(team Team, score int) {
	if *m.Team1ID == team.ID {
		m.Score1 = score
		return
	}

	m.Score2 = score
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
