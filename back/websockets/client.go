package websockets

import (
	"challenge/models"

	"github.com/google/uuid"
	"github.com/gorilla/websocket"
)

// Message is the struct for sending messages through websocket
type Message struct {
	Command string      `json:"command"`
	Message interface{} `json:"message"`
}

// Client is the struct for managing a websocket connection
type Client struct {
	ID   string
	Conn *websocket.Conn
	User *models.User
	Ws   *Websocket
}

// NewClient creates a new websocket client
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

// SendJson sends a message to the client
func (c *Client) SendJson(message Message) error {
	return c.Conn.WriteJSON(message)
}

// Emit sends a message to the client
//
// client.Emit("event", "message to send")
// client.Emit("event", []string{"message1", "message2"})
func (c *Client) Emit(command string, message interface{}) error {
	msg := Message{
		Command: command,
		Message: message,
	}

	return c.SendJson(msg)
}

// EmitError sends an error message to the client
//
// client.EmitError("error message")
func (c *Client) EmitError(message string) error {
	errorMsg := Message{
		Command: "error",
		Message: message,
	}

	return c.SendJson(errorMsg)
}

// Close closes the connection of a client
func (c *Client) Close() {
	c.Conn.Close()
}
