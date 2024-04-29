package fixtures

import (
	"challenge/models"
	"math/rand"
	"strings"

	faker "github.com/jaswdr/faker/v2"
)

var fake = faker.New()

func LoadUsers() error {
	var users []*models.User

	if err := models.ClearUsers(); err != nil {
		return err
	}

	for i := 0; i < 20; i++ {
		firstname := fake.Person().FirstName()
		lastname := fake.Person().LastName()
		username := strings.ToLower(strings.ReplaceAll(firstname+"."+lastname, " ", ""))
		email := fake.Internet().Email()
		password := fake.Internet().Password()
		roles := []string{"user", "admin"}
		role := roles[rand.Intn(len(roles))]

		user := &models.User{
			Firstname: firstname,
			Lastname:  lastname,
			Username:  username,
			Email:     email,
			Password:  password,
			Roles:     []string{role},
		}

		if err := user.HashPassword(); err != nil {
			return err
		}

		if err := user.Save(); err != nil {
			return err
		}

		users = append(users, user)
	}

	return nil
}
