package fixtures

import (
	"challenge/models"
	"fmt"
)

func LoadGames() error {
	if err := models.ClearGames(); err != nil {
		return err
	}

	for i := 0; i < GAME_NB; i++ {
		game := models.Game{
			Name:        fake.Lorem().Word(),
			Description: fake.Lorem().Sentence(20),
			Image:       fmt.Sprintf("https://picsum.photos/seed/%d/200/300", i),
		}

		if err := game.Save(); err != nil {
			return err
		}

		fmt.Printf("Game %s created\n", game.Name)
	}

	return nil
}
