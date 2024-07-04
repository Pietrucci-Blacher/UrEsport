package websockets

import (
	"challenge/models"
	"challenge/services"
	"fmt"
)

type RoomMsg struct {
	tournamentID int
}

func AddAnonClientToTournamentRoom(client *services.Client, msg any) error {
	roomMsg := msg.(RoomMsg)
	if roomMsg.tournamentID <= 0 {
		return fmt.Errorf("tournamentID is required")
	}

	roomName := fmt.Sprintf("tournament:%d", roomMsg.tournamentID)
	client.Ws.Room(roomName).AddClient(client)

	if err := client.Emit("info", "You have been added to the room"); err != nil {
		return err
	}

	return nil
}

func AddClientToTournamentRoom(client *services.Client) error {
	user := client.Get("user").(models.User)
	OwnerTournaments, err := models.FindTournamentsByUserID(user.ID)
	if err != nil {
		return err
	}

	userTeamInTournament, err := user.FindTournaments()
	if err != nil {
		return err
	}

	tournaments := append(OwnerTournaments, userTeamInTournament...)

	for _, tournament := range tournaments {
		roomName := fmt.Sprintf("tournament:%d", tournament.ID)
		client.Ws.Room(roomName).AddClient(client)
	}

	return nil
}
