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

	ws.On("tournament:add-to-room", AddAnonClientToTournamentRoom)

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
		if err := client.Emit("connected", nil); err != nil {
			return err
		}
		return nil
	}

	user := connectedUser.(models.User)
	client.Set("user", user)

	if err := AddClientToTournamentRoom(client); err != nil {
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
