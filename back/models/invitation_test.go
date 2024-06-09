package models

import (
	"challenge/utils"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func createSampleInvitData() (User, Team, Tournament, Invit, Invit) {
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
	teamInvit := Invit{
		ID:           1,
		UserID:       &user.ID,
		TeamID:       &team.ID,
		TournamentID: nil,
		Type:         TEAM_INVIT,
		Status:       PENDING,
	}
	tournamentInvit := Invit{
		ID:           2,
		UserID:       nil,
		TeamID:       &team.ID,
		TournamentID: &tournament.ID,
		Type:         TOURNAMENT_INVIT,
		Status:       PENDING,
	}

	DB.Create(&user)
	DB.Create(&team)
	DB.Create(&tournament)
	DB.Create(&teamInvit)
	DB.Create(&tournamentInvit)

	return user, team, tournament, teamInvit, tournamentInvit
}

func TestFindAllInvits(t *testing.T) {
	setup()
	defer close()
	_, _, _, _, _ = createSampleInvitData()

	params := map[string][]string{}
	query, _ := utils.NewQueryFilter(params)
	invitations, err := FindAllInvits(query)

	assert.Nil(t, err)
	assert.Equal(t, 2, len(invitations))
}

func TestFindInvitByTypeTeam(t *testing.T) {
	setup()
	defer close()
	_, team, _, _, _ := createSampleInvitData()

	invitations, err := FindInvitByType(TEAM_INVIT, "team_id", []int{team.ID})

	assert.Nil(t, err)
	assert.Equal(t, 1, len(invitations))
}

func TestIsForTeam(t *testing.T) {
	setup()
	defer close()
	_, team, _, teamInvit, _ := createSampleInvitData()

	assert.True(t, teamInvit.IsForTeam(team))
}

func TestIsForTournament(t *testing.T) {
	setup()
	defer close()
	_, _, tournament, _, tournamentInvit := createSampleInvitData()

	assert.True(t, tournamentInvit.IsForTournament(tournament))
}

func TestFindOneByTournamentAndTeam(t *testing.T) {
	setup()
	defer close()
	_, team, tournament, _, tournamentInvit := createSampleInvitData()

	var foundInvitation Invit
	err := foundInvitation.FindOneByTournamentAndTeam(*tournamentInvit.TournamentID, *tournamentInvit.TeamID)

	assert.Nil(t, err)
	assert.Equal(t, tournamentInvit.ID, foundInvitation.ID)
	assert.Equal(t, tournament.ID, *foundInvitation.TournamentID)
	assert.Equal(t, team.ID, *foundInvitation.TeamID)
}

func TestFindOneByTeamAndUser(t *testing.T) {
	setup()
	defer close()
	user, team, _, teamInvit, _ := createSampleInvitData()

	var foundInvitation Invit
	err := foundInvitation.FindOneByTeamAndUser(*teamInvit.TeamID, *teamInvit.UserID)

	assert.Nil(t, err)
	assert.Equal(t, teamInvit.ID, foundInvitation.ID)
	assert.Equal(t, team.ID, *foundInvitation.TeamID)
	assert.Equal(t, user.ID, *foundInvitation.UserID)
}

func TestSaveInvit(t *testing.T) {
	setup()
	defer close()
	_, _, _, teamInvit, _ := createSampleInvitData()
	teamInvit.Status = ACCEPTED

	err := teamInvit.Save()

	assert.Nil(t, err)
	assert.Equal(t, ACCEPTED, teamInvit.Status)
}

func TestFindOneInvitByID(t *testing.T) {
	setup()
	defer close()
	_, _, _, teamInvit, _ := createSampleInvitData()

	var foundInvitation Invit
	err := foundInvitation.FindOneById(teamInvit.ID)

	assert.Nil(t, err)
	assert.Equal(t, teamInvit.ID, foundInvitation.ID)
}

func TestFindOneInvit(t *testing.T) {
	setup()
	defer close()
	_, _, _, teamInvit, _ := createSampleInvitData()

	var foundInvitation Invit
	err := foundInvitation.FindOne("status", teamInvit.Status)

	assert.Nil(t, err)
	assert.Equal(t, teamInvit.Status, foundInvitation.Status)
}

func TestDeleteInvit(t *testing.T) {
	setup()
	defer close()
	_, _, _, teamInvit, _ := createSampleInvitData()

	err := teamInvit.Delete()

	assert.Nil(t, err)
	var count int64
	DB.Model(&Invit{}).Count(&count)
	assert.Equal(t, int64(1), count)
}
