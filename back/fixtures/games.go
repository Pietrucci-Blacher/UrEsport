package fixtures

import (
	"challenge/models"
	"fmt"
	"math/rand"
)

var VIDEO_GAME_NAMES = []string{
	"League of Legends",
	"Valorant",
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
	"Monster Hunter: World",
	"Sekiro: Shadows Die Twice",
	"Animal Crossing: New Horizons",
}

var VIDEO_GAME_URL = []string{
	"https://tinyurl.com/zpdvsuxc",
	"https://tinyurl.com/59vytarj",
	"https://shorturl.at/08JBi",
	"https://shorturl.at/xBlDr",
	"https://shorturl.at/yPGZm",
	"https://shorturl.at/A1KZm",
	"https://shorturl.at/P1syr",
	"https://shorturl.at/Xq5pz",
	"https://shorturl.at/lTd99",
	"https://shorturl.at/tdCsf",
	"https://shorturl.at/6XYDP",
	"https://t.ly/bp50b",
	"https://t.ly/AczXT",
	"https://t.ly/MvMok",
	"https://t.ly/dMtJj",
	"https://t.ly/gV7EB",
	"https://tinyurl.com/3brzy935",
	"https://tinyurl.com/knpjwm74",
	"https://tinyurl.com/ppphabw9",
	"https://tinyurl.com/ycx3cm2p",
	"https://tinyurl.com/mccvaz3w",
	"https://tinyurl.com/yumjda77",
	"https://tinyurl.com/vpweps46",
	"https://tinyurl.com/mvuv5nfd",
	"https://tinyurl.com/tfz9zz77",
	"https://tinyurl.com/c2zwc8b8",
	"https://tinyurl.com/fz8smvkz",
	"https://tinyurl.com/4bk9zj5w",
	"https://tinyurl.com/22f3tjsb",
	"https://tinyurl.com/mawrnw24",
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
			Image:       VIDEO_GAME_URL[i],
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
