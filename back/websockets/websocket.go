package websockets

import (
	"challenge/middlewares"
	"challenge/models"
	"fmt"

	"github.com/gin-gonic/gin"
)

func RegisterWebsocket(r *gin.Engine) {
	ws := GetWebsocket()

	ws.OnConnect(connect)
	ws.OnDisconnect(disconnect)
	ws.OnEvent("testWebsocket", testWebsocket)
	ws.OnEvent("testRoom", testRoom)

	r.GET("/ws",
		middlewares.IsLoggedIn(),
		ws.GinWsHandler,
	)
}

func connect(client *Client, c *gin.Context) error {
	fmt.Printf("Client %s connected, len %d\n", client.ID, len(client.Ws.GetClients()))

	user := c.MustGet("user").(models.User)
	client.User = &user

	return nil
}

func disconnect(client *Client) error {
	fmt.Printf("Client %s disconnected, len %d\n", client.ID, len(client.Ws.GetClients()))
	return nil
}

func testWebsocket(client *Client, msg Message) error {
	fmt.Printf("client id : %s, user : %s, msg : %v\n",
		client.ID,
		client.User.Username,
		msg,
	)

	message := fmt.Sprintf("test room de %s", client.User.Username)

	if err := client.Ws.Emit("test-event", "autre test en broadcast"); err != nil {
		return err
	}

	if err := client.Ws.Room("test-room").Emit("test-event", message); err != nil {
		return err
	}

	if err := client.Emit("test-event", []string{"test1", "test2"}); err != nil {
		return err
	}

	return nil
}

func testRoom(client *Client, msg Message) error {
	client.Ws.Room("test-room").AddClient(client)

	return nil
}
