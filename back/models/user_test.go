package models

import (
	"testing"

	faker "github.com/jaswdr/faker/v2"
)

var fake = faker.New()

func TestSave(t *testing.T) {
	var nbUsers int = 10
	var result []User
	var users []User

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
		users = append(users, user)
		if err := user.Save(); err != nil {
			t.Error(err)
		}
	}

	if len(users) != nbUsers {
		t.Error("Expected 10 users, got", len(users))
	}

	DB.Find(&result)

	for i, res := range result {
		if res.ID == 0 {
			t.Error("Expected user ID to be set")
		}

		if res.Firstname != users[i].Firstname {
			t.Error("Expected", res.Firstname, "got", users[i].Firstname)
		}

		if res.Lastname != users[i].Lastname {
			t.Error("Expected", res.Lastname, "got", users[i].Lastname)
		}

		if res.Username != users[i].Username {
			t.Error("Expected", res.Username, "got", users[i].Username)
		}

		if res.Email != users[i].Email {
			t.Error("Expected", res.Email, "got", users[i].Email)
		}
	}
}
