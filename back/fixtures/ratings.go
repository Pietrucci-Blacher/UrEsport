package fixtures

import (
	"challenge/models"
	"math/rand"
)

func LoadRatings() error {
	var users []models.User
	var tournaments []models.Tournament

	// Load all users
	if err := models.DB.Find(&users).Error; err != nil {
		return err
	}

	// Load all tournaments
	if err := models.DB.Find(&tournaments).Error; err != nil {
		return err
	}

	// Create ratings for tournaments
	for _, tournament := range tournaments {
		// Generate a random number of ratings for each tournament
		numRatings := rand.Intn(10) + 1 // Random number of ratings between 1 and 10

		for i := 0; i < numRatings; i++ {
			user := users[rand.Intn(len(users))] // Random user for each rating

			rating := models.Rating{
				TournamentID: uint(tournament.ID),
				UserID:       uint(user.ID),
				Rating:       float32(rand.Intn(5) + 1), // Random rating between 1 and 5
			}

			if err := models.DB.Create(&rating).Error; err != nil {
				return err
			}
		}
	}

	return nil
}
