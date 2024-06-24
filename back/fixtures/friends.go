package fixtures

import (
	"challenge/models"
	"fmt"
	"math/rand"
	"time"
)

func LoadFriends() error {
	// Seed the random number generator
	rand.Seed(time.Now().UnixNano())

	for i := 0; i < FRIEND_NB; i++ {
		// Generate random integers between 1 and 3
		userID := rand.Intn(3) + 1
		friendID := rand.Intn(3) + 1

		// Ensure friendID is not the same as userID
		for friendID == userID {
			friendID = rand.Intn(3) + 1
		}

		_, err := models.CreateFriend(userID, friendID, false)
		if err != nil {
			return err
		}

		fmt.Printf("Friendship between user %d and user %d created\n", userID, friendID)
	}

	return nil
}
