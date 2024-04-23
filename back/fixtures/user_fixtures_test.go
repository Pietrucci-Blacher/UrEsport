package fixtures_test

import (
	"challenge/fixtures"
	"challenge/models"
	"testing"
	"time"
)

func TestLoadUsers(t *testing.T) {
	expectedUsers := []*models.User{
		{
			Firstname: "John",
			Lastname:  "Doe",
			Username:  "johndoe",
			Email:     "john@example.com",
			Password:  "password123",
			Roles:     []string{"user"},
			CreatedAt: time.Now(),
			UpdatedAt: time.Now(),
		},
		{
			Firstname: "Jane",
			Lastname:  "Doe",
			Username:  "janedoe",
			Email:     "jane@example.com",
			Password:  "password456",
			Roles:     []string{"admin"},
			CreatedAt: time.Now(),
			UpdatedAt: time.Now(),
		},
	}

	actualUsers, err := fixtures.LoadUsers() // Assume this function now returns ([]*models.User, error)
	if err != nil {
		t.Errorf("Erreur lors du chargement des utilisateurs : %v", err)
		return
	}

	// Verify if the number of loaded users matches the expected number
	if len(actualUsers) != len(expectedUsers) {
		t.Errorf("Le nombre d'utilisateurs chargés ne correspond pas. Attendu : %d, Reçu : %d", len(expectedUsers), len(actualUsers))
		return
	}

	// Verify if each loaded user matches the expected user
	for i, expectedUser := range expectedUsers {
		actualUser := actualUsers[i]

		if expectedUser.Firstname != actualUser.Firstname ||
			expectedUser.Lastname != actualUser.Lastname ||
			expectedUser.Username != actualUser.Username ||
			expectedUser.Email != actualUser.Email ||
			expectedUser.Password != actualUser.Password ||
			!compareStringSlices(expectedUser.Roles, actualUser.Roles) {
			t.Errorf("L'utilisateur chargé ne correspond pas à celui attendu. Index : %d", i)
		}
	}
}

// Utility function to compare two slices of strings
func compareStringSlices(slice1, slice2 []string) bool {
	if len(slice1) != len(slice2) {
		return false
	}

	for i, val := range slice1 {
		if val != slice2[i] {
			return false
		}
	}

	return true
}
