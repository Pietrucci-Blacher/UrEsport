package fixtures

import (
	"challenge/models"
	"fmt"
	"math/rand"
)

func LoadUsers() error {
	if err := models.ClearUsers(); err != nil {
		return err
	}

	for i := 0; i < USER_NB; i++ {
		role := USER_ROLES[rand.Intn(len(USER_ROLES))]

		user := models.User{
			Firstname: fake.Person().FirstName(),
			Lastname:  fake.Person().LastName(),
			Username:  fake.Person().FirstName(),
			Email:     fake.Internet().Email(),
			Roles:     []string{role},
		}

		if err := user.HashPassword(USER_PASSWORD); err != nil {
			return err
		}

		if err := user.Save(); err != nil {
			return err
		}

		fmt.Printf("User %s created with password %s\n", user.Username, USER_PASSWORD)
	}

	return nil
}
