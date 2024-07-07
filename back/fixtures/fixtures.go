package fixtures

import (
	"challenge/models"

	"github.com/jaswdr/faker/v2"
)

var (
	fake = faker.New()

	FEATURES = map[string]string{
		"login":      "Allow user to login",
		"chat":       "Allow user to chat",
		"tournament": "Allow user to create tournament",
		"game":       "Allow user to play game",
	}

	USER_PASSWORD = "password"
	USER_NB       = 20
	USER_ROLES    = []string{models.ROLE_USER, models.ROLE_ADMIN}

	GAME_TAGS = []string{"RPG", "Aventure", "Action", "FPS", "MMORPG", "Survival", "Horror", "Simulation", "Sport", "Battle Royale"}

	TOURNAMENT_NB      = 10
	TOURNAMENT_TEAM_NB = 5

	TEAM_NB = 10

	GAME_NB         = 40
	TEAM_MEMBERS_NB = 4
)

func ImportFixtures() error {
	if err := LoadFeatures(); err != nil {
		return err
	}

	if err := LoadUsers(); err != nil {
		return err
	}

	if err := LoadTeams(); err != nil {
		return err
	}

	if err := LoadGames(); err != nil {
		return err
	}

	if err := LoadTournaments(); err != nil {
		return err
	}

	// Load the ratings fixtures
	if err := LoadRatings(); err != nil {
		return err
	}

	return nil
}
