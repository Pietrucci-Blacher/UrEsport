package fixtures

import (
	"challenge/models"
	"fmt"
	"math/rand"
	"time"
)

func LoadTournaments() error {
	if err := models.ClearTournaments(); err != nil {
		return err
	}

	for i := 0; i < TOURNAMENT_NB; i++ {
		owner := rand.Intn(USER_NB-1) + 1
		game := rand.Intn(GAME_NB-1) + 1

		tournament := models.Tournament{
			Name:        fake.Lorem().Word(),
			Description: fake.Lorem().Sentence(20),
			StartDate:   time.Now(),
			EndDate:     time.Now().AddDate(0, 0, 7),
			Location:    fake.Address().City(),
			Latitude:    fake.Address().Latitude(),
			Longitude:   fake.Address().Longitude(),
			OwnerID:     owner,
			Image:       fmt.Sprintf("https://picsum.photos/seed/%d/200/300", i),
			Private:     fake.Bool(),
			GameID:      game,
			NbPlayer:    TEAM_MEMBERS_NB + 1,
		}

		if err := tournament.Save(); err != nil {
			return err
		}

		fmt.Printf("Tournament %s created\n", tournament.Name)

		for j := 0; j < TOURNAMENT_TEAM_NB; j++ {
			if err := addTeamToTournament(tournament.ID); err != nil {
				return err
			}
		}
	}

	return nil
}

func addTeamToTournament(tournamentID int) error {
	var tournament models.Tournament
	var team models.Team

	if err := tournament.FindOneById(tournamentID); err != nil {
		return err
	}

	if err := team.FindOneById(rand.Intn(TEAM_NB-1) + 1); err != nil {
		return err
	}

	if tournament.HasTeam(team) {
		return addTeamToTournament(tournamentID)
	}

	if err := tournament.AddTeam(team); err != nil {
		return err
	}

	fmt.Printf("Team %s added to tournament %s\n", team.Name, tournament.Name)

	return nil
}
