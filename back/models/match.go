package models

import (
	"challenge/services"
	"time"
)

const (
	NONE      = 0
	TEAM1_WIN = 1
	TEAM2_WIN = 2
	DRAW      = 3

	WAITING  = "waiting"
	PLAYING  = "playing"
	FINISHED = "finished"
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
	Status       string     `json:"status"`
	Score1       int        `json:"score1"`
	Score2       int        `json:"score2"`
	NextMatchID  *int       `json:"next_match_id"`
	Depth        int        `json:"depth"`
	Team1Close   bool       `json:"team1_close" gorm:"default:false"`
	Team2Close   bool       `json:"team2_close" gorm:"default:false"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

type UpdateMatchDto struct {
	Team1ID     *int   `json:"team1_id"`
	Team2ID     *int   `json:"team2_id"`
	Score1      int    `json:"score1"`
	Score2      int    `json:"score2"`
	WinnerID    *int   `json:"winner_id"`
	Status      string `json:"status"`
	NextMatchID *int   `json:"next_match_id"`
}

type ScoreMatchDto struct {
	Score int `json:"score" validate:"required"`
}

func NewMatch(tournamentID int, next *int, depth int) Match {
	return Match{
		TournamentID: tournamentID,
		Team1ID:      nil,
		Team2ID:      nil,
		WinnerID:     nil,
		Status:       WAITING,
		NextMatchID:  next,
		Depth:        depth,
		Team1Close:   false,
		Team2Close:   false,
		Score1:       0,
		Score2:       0,
	}
}

func FindAllMatchs(query services.QueryFilter) ([]Match, error) {
	var matches []Match

	err := DB.Model(&Match{}).
		Offset(query.GetSkip()).
		//Limit(query.GetLimit()).
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

func CreateBinaryTree(tournamentId int, matchId *int, depth int, chMatch chan<- Match, chErr chan<- error) {
	match := NewMatch(tournamentId, matchId, depth)

	if err := match.Save(); err != nil {
		chErr <- err
		chMatch <- match
		return
	}

	if depth > 0 {
		go CreateBinaryTree(tournamentId, &match.ID, depth-1, chMatch, chErr)
		go CreateBinaryTree(tournamentId, &match.ID, depth-1, chMatch, chErr)
	}

	chErr <- nil
	chMatch <- match
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

func (m *Match) TeamWantToClose(teamID int) {
	if teamID == *m.Team1ID {
		m.Team1Close = !m.Team1Close
		return
	}

	m.Team2Close = !m.Team2Close
}

func (m *Match) Close() {
	if m.Score1 > m.Score2 {
		m.WinnerID = m.Team1ID
	} else if m.Score1 < m.Score2 {
		m.WinnerID = m.Team2ID
	}

	m.Status = FINISHED
	m.Team1Close = false
	m.Team2Close = false
}

func (m *Match) SetWinnerToMatch(winnerID *int) {
	if m.Team1ID == nil {
		m.Team1ID = winnerID
		return
	}

	m.Team2ID = winnerID
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
