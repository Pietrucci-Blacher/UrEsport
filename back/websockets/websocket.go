package websockets

import (
	"challenge/middlewares"
	"challenge/models"
	"challenge/services"
	"fmt"

	"github.com/gin-gonic/gin"
)

func RegisterWebsocket(r *gin.Engine) {
	ws := services.GetWebsocket()

	ws.OnConnect(connect)
	ws.OnDisconnect(disconnect)
	ws.On("ping", PingTest)

	r.GET("/ws",
		middlewares.IsLoggedIn(false),
		ws.GinWsHandler,
	)
}

func connect(client *services.Client, c *gin.Context) error {
	connectedUser, ok := c.Get("connectedUser")
	client.Set("logged", ok)

	if !ok {
		fmt.Printf("Client %s connected, len %d\n",
			client.ID,
			len(client.Ws.GetClients()),
		)
		return nil
	}

	user := connectedUser.(models.User)
	client.Set("user", user)

	if err := addClientToTournamentRoom(client); err != nil {
		return err
	}

	fmt.Printf("Client %s connected, name %s, len %d\n",
		client.ID,
		user.Username,
		len(client.Ws.GetClients()),
	)

	if err := client.Emit("connected", nil); err != nil {
		return err
	}

	return nil
}

func disconnect(client *services.Client) error {
	logged := client.Get("logged").(bool)

	if !logged {
		fmt.Printf("Client %s disconnected, len %d\n",
			client.ID,
			len(client.Ws.GetClients()),
		)
		return nil
	}

	user := client.Get("user").(models.User)
	fmt.Printf("Client %s disconnected, name %s, len %d\n",
		client.ID,
		user.Username,
		len(client.Ws.GetClients()),
	)

	return nil
}

func PingTest(client *services.Client, msg any) error {
	if err := client.Ws.Emit("pong", "test broadcast"); err != nil {
		return err
	}

	// Try to find a client with user ID 2
	cl := client.Ws.FindClient(func(c *services.Client) bool {
		if !c.Get("logged").(bool) {
			return false
		}
		return c.Get("user").(models.User).ID == 2
	})

	if cl != nil {
		if err := cl.Emit("pong", "test private"); err != nil {
			return err
		}
	}

	return client.Emit("pong", msg)
}

func addClientToTournamentRoom(client *services.Client) error {
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
