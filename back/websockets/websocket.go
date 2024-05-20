package websockets

import (
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
		// middlewares.IsLoggedIn(),
		ws.GinWsHandler,
	)
}

func connect(client *services.Client, c *gin.Context) error {
	user, ok := c.Get("user")
	if ok {
		client.Set("user", user.(models.User))
	}

	client.Set("logged", ok)

	fmt.Printf("Client %s connected, len %d\n",
		client.ID,
		len(client.Ws.GetClients()),
	)

	return nil
}

func disconnect(client *services.Client) error {
	fmt.Printf("Client %s disconnected, len %d\n",
		client.ID,
		len(client.Ws.GetClients()),
	)

	return nil
}

func PingTest(client *services.Client, msg any) error {
	if err := client.Ws.Emit("pong", "test broadcast"); err != nil {
		return err
	}

	return client.Emit("pong", msg)
}
