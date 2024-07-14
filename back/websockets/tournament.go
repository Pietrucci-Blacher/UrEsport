package websockets

import (
	"challenge/models"
	"challenge/services"
	"encoding/json"
	"fmt"
)

type RoomMsg struct {
	TournamentID int `json:"tournament_id"`
}

func AddAnonClientToTournamentRoom(client *services.Client, msg any) error {
	var roomMsg RoomMsg

	jsonMsg, err := json.Marshal(msg)
	if err != nil {
		return err
	}

	if err := json.Unmarshal(jsonMsg, &roomMsg); err != nil {
		return err
	}

	if roomMsg.TournamentID <= 0 {
		return fmt.Errorf("tournamentID is required")
	}

	roomName := fmt.Sprintf("tournament:%d", roomMsg.TournamentID)
	client.Ws.Room(roomName).AddClient(client)

	return client.Emit("info", "You have been added to the room")
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
