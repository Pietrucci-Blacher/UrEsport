package fixtures

import (
	"challenge/models"
	"fmt"
	"math/rand"
)

var ESPORT_TEAM_NAMES = []string{
	"Gentle Mates", "Karmine Corp", "Team Liquid", "Fnatic", "Cloud9",
	"SK Telecom T1", "Virtus.pro", "Na'Vi", "G2 Esports", "OG",
	"Evil Geniuses", "TSM", "Team SoloMid", "Team Envy", "FaZe Clan",
	"Ninjas in Pyjamas", "Astralis", "Complexity Gaming", "100 Thieves", "Gen.G",
	"Invictus Gaming", "Royal Never Give Up", "PSG.LGD", "Vici Gaming", "T1",
	"Team Secret", "Alliance", "Newbee", "Team Spirit", "BIG",
	"Heroic", "MAD Lions", "Team Vitality",
}

func LoadTeams() error {
	if err := models.ClearTeams(); err != nil {
		return err
	}

	for i := 0; i < TEAM_NB; i++ {
		ownerID := rand.Intn(USER_NB-1) + 1

		var owner models.User
		if err := owner.FindOneById(ownerID); err != nil {
			return err
		}

		teamName := ESPORT_TEAM_NAMES[i%len(ESPORT_TEAM_NAMES)]
		team := models.Team{
			Name:    teamName,
			OwnerID: ownerID,
		}

		if err := team.Save(); err != nil {
			return err
		}

		if err := team.AddMember(owner); err != nil {
			return err
		}

		fmt.Printf("Team %s created\n", team.Name)

		for j := 0; j < TEAM_MEMBERS_NB-1; j++ {
			if err := addMemberToTeam(team.ID); err != nil {
				return err
			}
		}
	}

	return nil
}

func addMemberToTeam(teamID int) error {
	var team models.Team
	var member models.User

	if err := team.FindOneById(teamID); err != nil {
		return err
	}

	if err := member.FindOneById(rand.Intn(USER_NB-1) + 1); err != nil {
		return err
	}

	if team.HasMember(member) {
		return addMemberToTeam(teamID)
	}

	if err := team.AddMember(member); err != nil {
		return err
	}

	fmt.Printf("Member %s added to team %s\n", member.Username, team.Name)

	return nil
}
