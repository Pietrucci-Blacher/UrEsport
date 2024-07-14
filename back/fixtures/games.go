package fixtures

import (
	"challenge/models"
	"fmt"
	"math/rand"
)

var VIDEO_GAME_NAMES = []string{
	"The Legend of Zelda: Breath of the Wild",
	"Super Mario Odyssey",
	"Red Dead Redemption 2",
	"The Witcher 3: Wild Hunt",
	"Overwatch",
	"Minecraft",
	"Fortnite",
	"God of War",
	"Horizon Zero Dawn",
	"Spider-Man",
	"Dark Souls III",
	"Bloodborne",
	"Cyberpunk 2077",
	"Assassin's Creed Odyssey",
	"Call of Duty: Warzone",
	"Fallout 4",
	"Final Fantasy XV",
	"Genshin Impact",
	"Ghost of Tsushima",
	"Resident Evil 2",
	"Skyrim",
	"Apex Legends",
	"Destiny 2",
	"Hades",
	"Doom Eternal",
	"Persona 5",
	"Monster Hunter: World",
	"Control",
	"Sekiro: Shadows Die Twice",
	"Animal Crossing: New Horizons",
}

func LoadGames() ([]models.Game, error) {
	if err := models.ClearGames(); err != nil {
		return nil, err
	}

	var games []models.Game

	for i := 0; i < len(VIDEO_GAME_NAMES); i++ {
		rand.Shuffle(len(GAME_TAGS), func(i, j int) { GAME_TAGS[i], GAME_TAGS[j] = GAME_TAGS[j], GAME_TAGS[i] })
		tags := GAME_TAGS[:3]

		game := models.Game{
			Name:        VIDEO_GAME_NAMES[i],
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
