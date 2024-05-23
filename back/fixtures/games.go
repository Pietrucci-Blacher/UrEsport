package fixtures

import (
	"challenge/models"
	"fmt"
	"time"

	"github.com/jaswdr/faker/v2"
)

var (
	fake_games = faker.New()

	GAME_NB = 10
)

func LoadGames() error {
	if err := models.ClearGames(); err != nil {
		return err
	}

	for i := 0; i < GAME_NB; i++ {
		game := models.Game{
			Name:        fake_games.Word(),
			Description: fake_games.Sentence(20),
			Image:       fake_games.URL(),
			CreatedAt:   time.Now(),
			UpdatedAt:   time.Now(),
		}

		if err := game.Save(); err != nil {
			return err
		}

		fmt.Printf("Game %s created\n", game.Name)
	}

	return nil
}
