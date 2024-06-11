package models

import (
	"challenge/services"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func createSampleData() (User, Team, Tournament) {
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
	tournament := Tournament{
		ID:          1,
		Name:        fake.Lorem().Word(),
		Description: fake.Lorem().Sentence(5),
		StartDate:   time.Now(),
		EndDate:     time.Now().Add(24 * time.Hour),
		Location:    fake.Address().City(),
		OwnerID:     user.ID,
		Image:       fake.Internet().URL(),
		Private:     false,
		Teams:       []Team{team},
	}

	DB.Create(&user)
	DB.Create(&team)
	DB.Create(&tournament)

	return user, team, tournament
}

func TestFindAllTournaments(t *testing.T) {
	setup()
	defer close()
	_, _, _ = createSampleData()

	params := map[string][]string{}
	query, _ := services.NewQueryFilter(params)
	tournaments, err := FindAllTournaments(query)

	assert.Nil(t, err)
	assert.Equal(t, 1, len(tournaments))
}

func TestFindTournamentsByUserID(t *testing.T) {
	setup()
	defer close()
	user, _, _ := createSampleData()

	tournaments, err := FindTournamentsByUserID(user.ID)

	assert.Nil(t, err)
	assert.Equal(t, 1, len(tournaments))
}

func TestSanitize(t *testing.T) {
	setup()
	defer close()
	_, _, tournament := createSampleData()

	sanitized := tournament.Sanitize(false)

	assert.Equal(t, tournament.ID, sanitized.ID)
	assert.Equal(t, tournament.Name, sanitized.Name)
	assert.Equal(t, tournament.Description, sanitized.Description)
	assert.Equal(t, tournament.StartDate, sanitized.StartDate)
	assert.Equal(t, tournament.EndDate, sanitized.EndDate)
	assert.Equal(t, tournament.Location, sanitized.Location)
	assert.Equal(t, tournament.Image, sanitized.Image)
	assert.Equal(t, tournament.Private, sanitized.Private)
	assert.Equal(t, tournament.OwnerID, sanitized.OwnerID)
	assert.Equal(t, 0, len(sanitized.Teams))
}

func TestIsOwner(t *testing.T) {
	setup()
	defer close()
	user, _, tournament := createSampleData()

	assert.True(t, tournament.IsOwner(user))
}

func TestTogglePrivate(t *testing.T) {
	setup()
	defer close()
	_, _, tournament := createSampleData()

	tournament.TogglePrivate()

	assert.True(t, tournament.Private)
}

func TestAddTeam(t *testing.T) {
	setup()
	defer close()
	_, team, tournament := createSampleData()

	err := tournament.AddTeam(team)

	assert.Nil(t, err)
	assert.Equal(t, 2, len(tournament.Teams))
}

func TestRemoveTeam(t *testing.T) {
	setup()
	defer close()
	_, team, tournament := createSampleData()

	err := tournament.RemoveTeam(team)

	assert.Nil(t, err)
	assert.Equal(t, 0, len(tournament.Teams))
}

func TestRemoveAllTeams(t *testing.T) {
	setup()
	defer close()
	_, _, tournament := createSampleData()

	err := tournament.RemoveAllTeams()

	assert.Nil(t, err)
	assert.Equal(t, 0, len(tournament.Teams))
}

func TestHasTeam(t *testing.T) {
	setup()
	defer close()
	_, team, tournament := createSampleData()

	assert.True(t, tournament.HasTeam(team))
}

func TestTournamentSave(t *testing.T) {
	setup()
	defer close()
	_, _, tournament := createSampleData()
	tournament.Name = "Updated Name"

	err := tournament.Save()

	assert.Nil(t, err)
	assert.Equal(t, "Updated Name", tournament.Name)
}

func TestTournamentFindOneById(t *testing.T) {
	setup()
	defer close()
	_, _, tournament := createSampleData()

	var foundTournament Tournament
	err := foundTournament.FindOneById(tournament.ID)

	assert.Nil(t, err)
	assert.Equal(t, tournament.ID, foundTournament.ID)
}

func TestFindOne(t *testing.T) {
	setup()
	defer close()
	_, _, tournament := createSampleData()

	var foundTournament Tournament
	err := foundTournament.FindOne("name", tournament.Name)

	assert.Nil(t, err)
	assert.Equal(t, tournament.Name, foundTournament.Name)
}

func TestDelete(t *testing.T) {
	setup()
	defer close()
	_, _, tournament := createSampleData()

	err := tournament.Delete()

	assert.Nil(t, err)
	var count int64
	DB.Model(&Tournament{}).Count(&count)
	assert.Equal(t, int64(0), count)
}

func TestClearTournaments(t *testing.T) {
	setup()
	defer close()
	_, _, _ = createSampleData()

	err := ClearTournaments()

	assert.Nil(t, err)
	var count int64
	DB.Model(&Tournament{}).Count(&count)
	assert.Equal(t, int64(0), count)
}
