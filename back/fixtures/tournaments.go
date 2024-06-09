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

		tournament := models.Tournament{
			Name:        fake.Lorem().Word(),
			Description: fake.Lorem().Sentence(20),
			StartDate:   time.Now(),
			EndDate:     time.Now().AddDate(0, 0, 7),
			Location:    fake.Address().City(),
			OwnerID:     owner,
			Image:       fake.Lorem().Word(),
			Private:     fake.Bool(),
		}

		if err := tournament.Save(); err != nil {
			return err
		}

		fmt.Printf("Tournament %s created\n", tournament.Name)

		var team models.Team
		if err := team.FindOneById(rand.Intn(TEAM_NB-1) + 1); err != nil {
			return err
		}

		if err := tournament.AddTeam(team); err != nil {
			return err
		}

		fmt.Printf("Participant %s added to tournament %s\n", team.Name, tournament.Name)
	}

	return nil
}
