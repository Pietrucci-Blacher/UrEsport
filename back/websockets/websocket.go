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
	user, ok := c.Get("connectedUser")
	if ok {
		client.Set("user", user.(models.User))
	}

	client.Set("logged", ok)

	if ok {
		fmt.Printf("Client %s connected, name %s, len %d\n",
			client.ID,
			user.(models.User).Username,
			len(client.Ws.GetClients()),
		)
	} else {
		fmt.Printf("Client %s connected, len %d\n",
			client.ID,
			len(client.Ws.GetClients()),
		)
	}

	return nil
}

func disconnect(client *services.Client) error {
	var user models.User

	logged := client.Get("logged").(bool)
	if logged {
		user = client.Get("user").(models.User)
	}

	if logged {
		fmt.Printf("Client %s disconnected, name %s, len %d\n",
			client.ID,
			user.Username,
			len(client.Ws.GetClients()),
		)
	} else {
		fmt.Printf("Client %s disconnected, len %d\n",
			client.ID,
			len(client.Ws.GetClients()),
		)
	}

	return nil
}

func PingTest(client *services.Client, msg any) error {
	if err := client.Ws.Emit("pong", "test broadcast"); err != nil {
		return err
	}

	return client.Emit("pong", msg)
}
