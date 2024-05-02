package models

import (
	"testing"
)

func TestInviteUser(t *testing.T) {
	organizer := &Organizer{}
	user := &User{
		ID:        1,
		Username:  "TestUser",
		Email:     "testuser@example.com",
		Firstname: "Test",
		Lastname:  "User",
	}

	err := organizer.InviteUser(user, LinkAutoCopy)
	if err != nil {
		t.Errorf("Failed to invite user: %v", err)
	}

	if !user.Invited {
		t.Errorf("User was not marked as invited")
	}

	if len(organizer.InvitedUsers) != 1 {
		t.Errorf("User was not added to the list of invited users")
	}
}

func TestLaunchCheckIn(t *testing.T) {
	organizer := &Organizer{}
	user := &User{
		ID:        1,
		Username:  "TestUser",
		Email:     "testuser@example.com",
		Firstname: "Test",
		Lastname:  "User",
		Invited:   true,
	}

	organizer.InvitedUsers = append(organizer.InvitedUsers, user)

	err := organizer.LaunchCheckIn()
	if err != nil {
		t.Errorf("Failed to launch check-in: %v", err)
	}
}
