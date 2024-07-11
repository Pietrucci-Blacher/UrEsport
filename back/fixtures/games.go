package fixtures

import (
	"challenge/models"
	"fmt"
	"math/rand"
)

func LoadGames() ([]models.Game, error) {
	if err := models.ClearGames(); err != nil {
		return nil, err
	}

	var games []models.Game

	for i := 0; i < GAME_NB; i++ {
		rand.Shuffle(len(GAME_TAGS), func(i, j int) { GAME_TAGS[i], GAME_TAGS[j] = GAME_TAGS[j], GAME_TAGS[i] })
		tags := GAME_TAGS[:3]

		game := models.Game{
			Name:        fake.Lorem().Word(),
			Description: fake.Lorem().Sentence(20),
			Image:       fmt.Sprintf("https://picsum.photos/seed/%d/200/300", i),
			Tags:        tags,
		}

		if err := game.Save(); err != nil {
			return nil, err
		}

		games = append(games, game)
		fmt.Printf("Game %s created with ID %d\n", game.Name, game.ID)
	}

	return games, nil
}
