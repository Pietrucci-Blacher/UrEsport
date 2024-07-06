package fixtures

import (
    "challenge/models"
    "fmt"
    "math/rand"
    "time"
)

func LoadFriends() error {
    rng := rand.New(rand.NewSource(time.Now().UnixNano()))

    for i := 0; i < FRIEND_NB; i++ {
       userID := rng.Intn(3) + 1
       friendID := rng.Intn(3) + 1

       for friendID == userID {
          friendID = rng.Intn(3) + 1
       }

       _, err := models.CreateFriend(userID, friendID, false)
       if err != nil {
          return err
       }

       fmt.Printf("Friendship between user %d and user %d created\n", userID, friendID)
    }

    return nil
}