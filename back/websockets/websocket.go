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
		middlewares.IsLoggedIn(),
		ws.GinWsHandler,
	)
}

func connect(client *services.Client, c *gin.Context) error {
	user := c.MustGet("user").(models.User)
	client.User = &user

	fmt.Printf("Client %s connected, len %d, user %s\n",
		client.ID,
		len(client.Ws.GetClients()),
		client.User.Username,
	)

	return nil
}

func disconnect(client *services.Client) error {
	fmt.Printf("Client %s disconnected, len %d, user %s\n",
		client.ID,
		len(client.Ws.GetClients()),
		client.User.Username,
	)

	return nil
}

func PingTest(client *services.Client, msg any) error {
	if err := client.Ws.Emit("pong", "test broadcast"); err != nil {
		return err
	}

	return client.Emit("pong", msg)
}
