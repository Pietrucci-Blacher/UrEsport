package websockets

import (
	"challenge/models"

	"github.com/google/uuid"
	"github.com/gorilla/websocket"
)

type Message struct {
	Command string      `json:"command"`
	Message interface{} `json:"message"`
}

type Client struct {
	ID   string
	Conn *websocket.Conn
	User *models.User
	Ws   *Websocket
}

func NewClient(conn *websocket.Conn, user *models.User) *Client {
	ws := GetWebsocket()
	id := uuid.New().String()

	return &Client{
		ID:   id,
		Conn: conn,
		User: user,
		Ws:   ws,
	}
}

func (c *Client) SendMessage(command string, message interface{}) error {
	msg := Message{
		Command: command,
		Message: message,
	}

	return c.SendJson(msg)
}

func (c *Client) SendJson(message Message) error {
	return c.Conn.WriteJSON(message)
}

func (c *Client) SendError(message string) error {
	errorMsg := Message{
		Command: "error",
		Message: message,
	}

	return c.SendJson(errorMsg)
}

func (c *Client) Close() {
	c.Conn.Close()
}
