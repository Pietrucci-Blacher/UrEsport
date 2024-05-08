package websockets

import (
	"fmt"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

var WebsocketInstance *Websocket

type Websocket struct {
	clients map[string]*Client
	events  map[string]func(*Client, Message) error
}

func NewWebsocket() *Websocket {
	return &Websocket{
		clients: make(map[string]*Client),
		events:  make(map[string]func(*Client, Message) error),
	}
}

func GetWebsocket() *Websocket {
	if WebsocketInstance == nil {
		WebsocketInstance = NewWebsocket()
	}
	return WebsocketInstance
}

func (w *Websocket) GetClients() map[string]*Client {
	return w.clients
}

func (w *Websocket) AddClient(client *Client) {
	w.clients[client.ID] = client
}

func (w *Websocket) RemoveClient(id string) error {
	client := w.GetClient(id)
	if client == nil {
		return fmt.Errorf("Client not found\n")
	}

	client.Close()
	delete(w.clients, id)

	return nil
}

func (w *Websocket) GetClient(id string) *Client {
	return w.clients[id]
}

func (w *Websocket) GetClientByUserId(id int) *Client {
	for _, client := range w.clients {
		if client.User.ID == id {
			return client
		}
	}
	return nil
}

func (w *Websocket) BroadcastJson(message Message) error {
	for _, client := range w.clients {
		if err := client.SendJson(message); err != nil {
			return err
		}
	}

	return nil
}

func (w *Websocket) BroadcastMessage(command string, message interface{}) error {
	wsMessage := Message{
		Command: command,
		Message: message,
	}

	return w.BroadcastJson(wsMessage)
}

func (w *Websocket) OnEvent(command string, callback func(*Client, Message) error) {
	w.events[command] = callback
}

func (w *Websocket) Listen(client *Client) error {
	for {
		var msg Message

		if err := client.Conn.ReadJSON(&msg); err != nil {
			return err
		}

		if err := w.DispatchCommand(client, msg); err != nil {
			return err
		}
	}
}

func (w *Websocket) DispatchCommand(client *Client, msg Message) error {
	callback, ok := w.events[msg.Command]
	if !ok {
		return client.SendError("Invalid command")
	}

	return callback(client, msg)
}
