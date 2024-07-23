package fixtures

import (
	"challenge/models"
	"fmt"
	"math/rand"
	"time"
)

var locations = []struct {
	City      string
	Latitude  float64
	Longitude float64
}{
	{"Paris", 48.8566, 2.3522},
	{"New York", 40.7128, -74.0060},
	{"Tokyo", 35.6895, 139.6917},
	{"Los Angeles", 34.0522, -118.2437},
	{"London", 51.5074, -0.1278},
	{"Berlin", 52.5200, 13.4050},
	{"Sydney", -33.8688, 151.2093},
	{"Rome", 41.9028, 12.4964},
	{"Toronto", 43.651070, -79.347015},
	{"Dubai", 25.2048, 55.2708},
	{"Madrid", 40.4168, -3.7038},
	{"Beijing", 39.9042, 116.4074},
	{"Moscow", 55.7558, 37.6173},
	{"Rio de Janeiro", -22.9068, -43.1729},
	{"Cape Town", -33.9249, 18.4241},
	{"Bangkok", 13.7563, 100.5018},
	{"Singapore", 1.3521, 103.8198},
	{"Hong Kong", 22.3193, 114.1694},
	{"San Francisco", 37.7749, -122.4194},
	{"Chicago", 41.8781, -87.6298},
	{"Istanbul", 41.0082, 28.9784},
	{"Mexico City", 19.4326, -99.1332},
	{"Sao Paulo", -23.5505, -46.6333},
	{"Seoul", 37.5665, 126.9780},
	{"Buenos Aires", -34.6037, -58.3816},
	{"Lisbon", 38.7223, -9.1393},
	{"Kuala Lumpur", 3.1390, 101.6869},
	{"Amsterdam", 52.3676, 4.9041},
	{"Vienna", 48.2082, 16.3738},
	{"Athens", 37.9838, 23.7275},
	{"Dublin", 53.3498, -6.2603},
	{"Copenhagen", 55.6761, 12.5683},
	{"Stockholm", 59.3293, 18.0686},
	{"Oslo", 59.9139, 10.7522},
}

func LoadTournaments(games []models.Game) error {
	if err := models.ClearTournaments(); err != nil {
		return err
	}

	teamPool := generateTeamPool()

	// Shuffle locations to ensure uniqueness per tournament
	rand.Shuffle(len(locations), func(i, j int) {
		locations[i], locations[j] = locations[j], locations[i]
	})

	// Create at least one tournament for each game
	for i, game := range games {
		owner := rand.Intn(USER_NB-1) + 1
		location := locations[i]

		tournament := models.Tournament{
			Name:        fmt.Sprintf("Tournament of %s", game.Name),
			Description: fake.Lorem().Sentence(20),
			StartDate:   time.Now(),
			EndDate:     time.Now().AddDate(0, 0, 7),
			Location:    location.City,
			Latitude:    location.Latitude,
			Longitude:   location.Longitude,
			OwnerID:     owner,
			Image:       game.Image, // Ensure the image corresponds to the game
			Private:     fake.Bool(),
			GameID:      game.ID,
			NbPlayer:    TEAM_MEMBERS_NB + 1,
		}

		if err := tournament.Save(); err != nil {
			return err
		}

		fmt.Printf("Tournament %s created\n", tournament.Name)

		teamsAdded := make(map[int]bool)

		for j := 0; j < TOURNAMENT_TEAMS_NB; j++ {
			if err := addTeamToTournament(tournament.ID, teamPool, teamsAdded); err != nil {
				return err
			}
		}

		if err := addUpvotesToTournament(tournament.ID); err != nil {
			return err
		}
	}

	// Create additional tournaments if needed
	for i := len(games); i < TOURNAMENT_NB; i++ {
		owner := rand.Intn(USER_NB-1) + 1
		tournamentGame := games[rand.Intn(len(games))]
		location := locations[i]

		tournament := models.Tournament{
			Name:        fmt.Sprintf("Tournament of %s", tournamentGame.Name),
			Description: fake.Lorem().Sentence(20),
			StartDate:   time.Now(),
			EndDate:     time.Now().AddDate(0, 0, 7),
			Location:    location.City,
			Latitude:    location.Latitude,
			Longitude:   location.Longitude,
			OwnerID:     owner,
			Image:       tournamentGame.Image, // Ensure the image corresponds to the game
			Private:     fake.Bool(),
			GameID:      tournamentGame.ID,
			NbPlayer:    TEAM_MEMBERS_NB + 1,
		}

		if err := tournament.Save(); err != nil {
			return err
		}

		fmt.Printf("Tournament %s created\n", tournament.Name)

		teamsAdded := make(map[int]bool)

		for j := 0; j < TOURNAMENT_TEAMS_NB; j++ {
			if err := addTeamToTournament(tournament.ID, teamPool, teamsAdded); err != nil {
				return err
			}
		}

		if err := addUpvotesToTournament(tournament.ID); err != nil {
			return err
		}
	}

	return nil
}

func addTeamToTournament(tournamentID int, teamPool []int, teamsAdded map[int]bool) error {
	var tournament models.Tournament
	var team models.Team

	if err := tournament.FindOneById(tournamentID); err != nil {
		return err
	}

	var teamID int
	for {
		teamID = teamPool[rand.Intn(len(teamPool))]
		if !teamsAdded[teamID] {
			break
		}
	}

	if err := team.FindOneById(teamID); err != nil {
		return err
	}

	if tournament.HasTeam(team) || tournament.IsUserHasTeamInTournament(team.OwnerID) {
		return addTeamToTournament(tournamentID, teamPool, teamsAdded)
	}

	if err := tournament.AddTeam(team); err != nil {
		return err
	}

	teamsAdded[teamID] = true

	fmt.Printf("Team %s added to tournament %s\n", team.Name, tournament.Name)

	return nil
}

func addUpvotesToTournament(tournamentID int) error {
	var tournament models.Tournament
	if err := tournament.FindOneById(tournamentID); err != nil {
		return err
	}

	upvotedUsers := make(map[int]bool)

	for i := 0; i < rand.Intn(500)+1; i++ {
		userID := rand.Intn(USER_NB-1) + 1
		if upvotedUsers[userID] {
			continue // Skip if the user has already upvoted
		}
		if err := tournament.AddUpvote(userID); err != nil {
			if err.Error() == "User has already upvoted this tournament" {
				upvotedUsers[userID] = true
				continue // Skip if the user has already upvoted
			}
			return err
		}
		upvotedUsers[userID] = true
		fmt.Printf("User %d upvoted tournament %s\n", userID, tournament.Name)
	}

	return nil
}

func generateTeamPool() []int {
	var teamIDs []int
	for i := 1; i <= TEAM_NB; i++ {
		teamIDs = append(teamIDs, i)
	}
	return teamIDs
}
