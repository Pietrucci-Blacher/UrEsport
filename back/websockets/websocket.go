package websockets

import (
	"challenge/middlewares"
	"challenge/models"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

func RegisterWebsocket(r *gin.Engine) {
	r.GET("/ws",
		middlewares.IsLoggedIn(),
		wsHandler,
	)
}

func wsHandler(c *gin.Context) {
	ws := GetWebsocket()

	ws.OnConnect(connect)
	ws.OnDisconnect(disconnect)
	ws.OnEvent("testWebsocket", testWebsocket)
	ws.OnEvent("testRoom", testRoom)

	client, err := ws.Connect(c.Writer, c.Request)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	user := c.MustGet("user").(models.User)
	client.User = &user

	if err := ws.Listen(client); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	}
}

func connect(client *Client) error {
	fmt.Printf("Client %s connected, len %d\n", client.ID, len(client.Ws.GetClients()))
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

	message := fmt.Sprintf("test de %s", client.User.Username)

	// if err := client.Ws.BroadcastMessage("test", message); err != nil {
	// 	return err
	// }

	if err := client.Ws.Room("test").BroadcastMessage("test", message); err != nil {
		return err
	}

	if err := client.SendMessage("test", []string{"test1", "test2"}); err != nil {
		return err
	}

	return nil
}

func testRoom(client *Client, msg Message) error {
	client.Ws.Room("test").AddClient(client)

	return nil
}
