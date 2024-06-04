package fixtures

import (
	"challenge/models"
	"fmt"
	"math/rand"
)

func LoadTeams() error {
	if err := models.ClearTeams(); err != nil {
		return err
	}

	for i := 0; i < TEAM_NB; i++ {
		owner := rand.Intn(USER_NB-1) + 1

		team := models.Team{
			Name:    fake.Lorem().Word(),
			OwnerID: owner,
		}

		if err := team.Save(); err != nil {
			return err
		}

		fmt.Printf("Team %s created\n", team.Name)

		// for j := 0; j < TEAM_MEMBERS_NB; j++ {
		// 	var member models.User
		// 	if err := member.FindOneById(rand.Intn(USER_NB-1) + 1); err != nil {
		// 		return err
		// 	}

		// 	if err := team.AddMember(member); err != nil {
		// 		return err
		// 	}

		// 	fmt.Printf("Member %s added to team %s\n", member.Username, team.Name)
		// }
	}

	return nil
}
