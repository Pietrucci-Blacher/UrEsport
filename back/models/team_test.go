package models

import (
	"challenge/utils"
	"testing"

	"github.com/stretchr/testify/assert"
)

func createSampleTeamData() (User, Team) {
	user := User{
		ID:        1,
		Firstname: fake.Person().FirstName(),
		Lastname:  fake.Person().LastName(),
		Username:  fake.Person().Name(),
		Email:     fake.Internet().Email(),
		Password:  fake.Internet().Password(),
		Roles:     []string{"user"},
	}
	team := Team{
		ID:      1,
		Name:    fake.Lorem().Word(),
		OwnerID: user.ID,
	}

	DB.Create(&user)
	DB.Create(&team)

	return user, team
}

func TestFindAllTeams(t *testing.T) {
	setup()
	defer close()
	_, _ = createSampleTeamData()

	params := map[string][]string{}
	query, _ := utils.NewQueryFilter(params)
	teams, err := FindAllTeams(query)

	assert.Nil(t, err)
	assert.Equal(t, 1, len(teams))
}

func TestFindTeamsByUserID(t *testing.T) {
	setup()
	defer close()
	user, _ := createSampleTeamData()

	teams, err := FindTeamsByUserID(user.ID)

	assert.Nil(t, err)
	assert.Equal(t, 1, len(teams))
}

func TestSanitizeTeam(t *testing.T) {
	setup()
	defer close()
	_, team := createSampleTeamData()

	sanitized := team.Sanitize()

	assert.Equal(t, team.ID, sanitized.ID)
	assert.Equal(t, team.Name, sanitized.Name)
	assert.Equal(t, team.OwnerID, sanitized.OwnerID)
}

func TestIsOwnerTeam(t *testing.T) {
	setup()
	defer close()
	user, team := createSampleTeamData()

	assert.True(t, team.IsOwner(user))
}

func TestAddMember(t *testing.T) {
	setup()
	defer close()
	user, team := createSampleTeamData()

	err := team.AddMember(user)

	assert.Nil(t, err)
	assert.Equal(t, 1, len(team.Members))
}

func TestRemoveMember(t *testing.T) {
	setup()
	defer close()
	user, team := createSampleTeamData()
	_ = team.AddMember(user)

	err := team.RemoveMember(user)

	assert.Nil(t, err)
	assert.Equal(t, 0, len(team.Members))
}

func TestRemoveAllMembers(t *testing.T) {
	setup()
	defer close()
	user, team := createSampleTeamData()
	_ = team.AddMember(user)

	err := team.RemoveAllMembers()

	assert.Nil(t, err)
	assert.Equal(t, 0, len(team.Members))
}

func TestIsMember(t *testing.T) {
	setup()
	defer close()
	user, team := createSampleTeamData()
	_ = team.AddMember(user)

	assert.True(t, team.IsMember(user))
}

func TestSaveTeam(t *testing.T) {
	setup()
	defer close()
	_, team := createSampleTeamData()
	team.Name = "Updated Team"

	err := team.Save()

	assert.Nil(t, err)
	assert.Equal(t, "Updated Team", team.Name)
}

func TestFindOneTeamByID(t *testing.T) {
	setup()
	defer close()
	_, team := createSampleTeamData()

	var foundTeam Team
	err := foundTeam.FindOneById(team.ID)

	assert.Nil(t, err)
	assert.Equal(t, team.ID, foundTeam.ID)
}

func TestFindOneTeam(t *testing.T) {
	setup()
	defer close()
	_, team := createSampleTeamData()

	var foundTeam Team
	err := foundTeam.FindOne("name", team.Name)

	assert.Nil(t, err)
	assert.Equal(t, team.Name, foundTeam.Name)
}

func TestDeleteTeam(t *testing.T) {
	setup()
	defer close()
	_, team := createSampleTeamData()

	err := team.Delete()

	assert.Nil(t, err)
	var count int64
	DB.Model(&Team{}).Count(&count)
	assert.Equal(t, int64(0), count)
}

func TestClearTeams(t *testing.T) {
	setup()
	defer close()
	_, _ = createSampleTeamData()

	err := ClearTeams()

	assert.Nil(t, err)
	var count int64
	DB.Model(&Team{}).Count(&count)
	assert.Equal(t, int64(0), count)
}
