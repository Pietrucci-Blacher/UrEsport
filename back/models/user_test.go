package models

import (
	"testing"

	"github.com/jaswdr/faker/v2"
)

var fake = faker.New()
var users []User

// func addUser(nb int) error {
// 	for i := 0; i < nb; i++ {
// 		user := User{
// 			Firstname: fake.Person().FirstName(),
// 			Lastname:  fake.Person().LastName(),
// 			Username:  fake.Person().Name(),
// 			Email:     fake.Internet().Email(),
// 			Password:  fake.Internet().Password(),
// 		}
// 		if err := user.Save(); err != nil {
// 			return err
// 		}
// 		users = append(users, user)
// 	}

// 	return nil
// }

func TestCreateUser(t *testing.T) {
	var nbUsers int = 10
	var userTest User

	if err := ConnectDB(true); err != nil {
		t.Error(err)
	}
	defer CloseDB()

	for i := 0; i < nbUsers; i++ {
		user := User{
			Firstname: fake.Person().FirstName(),
			Lastname:  fake.Person().LastName(),
			Username:  fake.Person().Name(),
			Email:     fake.Internet().Email(),
			Password:  fake.Internet().Password(),
		}
		if err := user.Save(); err != nil {
			t.Error(err)
		}
		users = append(users, user)
	}

	if len(users) != nbUsers {
		t.Error("Expected 10 users, got", len(users))
	}

	for _, user := range users {
		DB.First(&userTest, user.ID)

		if user.Firstname != userTest.Firstname {
			t.Error("Expected", user.Firstname, "got", userTest.Firstname)
		}

		if user.Lastname != userTest.Lastname {
			t.Error("Expected", user.Lastname, "got", userTest.Lastname)
		}

		if user.Username != userTest.Username {
			t.Error("Expected", user.Username, "got", userTest.Username)
		}

		if user.Email != userTest.Email {
			t.Error("Expected", user.Email, "got", userTest.Email)
		}
	}
}
