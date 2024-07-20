package fixtures

import (
	"challenge/models"

	"github.com/jaswdr/faker/v2"
)

var (
	fake = faker.New()

	FEATURES = map[string]string{
		"login":    "Allow user to login",
		"register": "Allow user to register",
	}

	USER_PASSWORD = "password"
	USER_NB       = 30
	USER_ROLES    = []string{models.ROLE_USER, models.ROLE_ADMIN}

	GAME_TAGS = []string{"RPG", "Aventure", "Action", "FPS", "MMORPG", "Survival", "Horror", "Simulation", "Sport", "Battle Royale"}

	TOURNAMENT_NB       = 30
	TOURNAMENT_TEAMS_NB = 8

	TEAM_NB         = 33
	TEAM_MEMBERS_NB = 4

	FRIEND_NB = 10
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

	games, err := LoadGames()
	if err != nil {
		return err
	}

	if err := LoadFriends(); err != nil {
		return err
	}

	if err := LoadTournaments(games); err != nil {
		return err
	}

	if err := LoadRatings(); err != nil {
		return err
	}

	return nil
}
