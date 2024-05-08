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

	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	user := c.MustGet("user").(models.User)
	client := NewClient(conn, &user)
	ws.AddClient(client)

	defer func() {
		if err := ws.RemoveClient(client.ID); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	}()

	ws.OnEvent("test", testWebsocket)

	if err := ws.Listen(client); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	}
}

func testWebsocket(client *Client, msg Message) error {
	fmt.Printf("nb client : %d, client id : %s, user : %s, msg : %v\n",
		len(client.Ws.GetClients()),
		client.ID,
		client.User.Username,
		msg,
	)

	message := fmt.Sprintf("test de %s", client.User.Username)

	if err := client.Ws.BroadcastMessage("test", message); err != nil {
		return err
	}

	if err := client.SendMessage("test", []string{"test1", "test2"}); err != nil {
		return err
	}

	return nil
}
