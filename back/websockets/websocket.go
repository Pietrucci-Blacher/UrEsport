package websockets

import (
	"challenge/middlewares"
	"challenge/models"
	s "challenge/services"
	"fmt"

	"github.com/gin-gonic/gin"
)

func RegisterWebsocket(r *gin.Engine) {
	ws := s.GetWebsocket()

	ws.OnConnect(connect)
	ws.OnDisconnect(disconnect)
	ws.OnEvent("ping", PingTest)

	r.GET("/ws",
		middlewares.IsLoggedIn(),
		ws.GinWsHandler,
	)
}

func connect(client *s.Client, c *gin.Context) error {
	user := c.MustGet("user").(models.User)
	client.User = &user

	fmt.Printf("Client %s connected, len %d, user %s\n",
		client.ID,
		len(client.Ws.GetClients()),
		client.User.Username,
	)

	return nil
}

func disconnect(client *s.Client) error {
	fmt.Printf("Client %s disconnected, len %d, user %s\n",
		client.ID,
		len(client.Ws.GetClients()),
		client.User.Username,
	)

	return nil
}

func PingTest(client *s.Client, msg interface{}) error {
	if err := client.Emit("pong", msg); err != nil {
		return err
	}

	return nil
}
