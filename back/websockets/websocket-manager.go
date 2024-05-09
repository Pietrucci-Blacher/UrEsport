package websockets

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

var WebsocketInstance *Websocket

// Websocket is the main struct for managing websocket connections
type Websocket struct {
	clients      map[string]*Client
	events       map[string]func(*Client, Message) error
	rooms        map[string]*Room
	onConnect    func(*Client, *gin.Context) error
	onDisconnect func(*Client) error
}

// NewWebsocket creates a new Websocket instance
func NewWebsocket() *Websocket {
	return &Websocket{
		clients: make(map[string]*Client),
		events:  make(map[string]func(*Client, Message) error),
		rooms:   make(map[string]*Room),
		onConnect: func(client *Client, c *gin.Context) error {
			return nil
		},
		onDisconnect: func(client *Client) error {
			return nil
		},
	}
}

// GetWebsocket returns the singleton instance of Websocket
// ws := GetWebsocket()
func GetWebsocket() *Websocket {
	if WebsocketInstance == nil {
		WebsocketInstance = NewWebsocket()
	}
	return WebsocketInstance
}

// connectGin creates a new websocket connection from a gin context
func (w *Websocket) connectGin(c *gin.Context) (*Client, error) {
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		return nil, err
	}

	client := NewClient(conn, nil)
	w.AddClient(client)

	if err := w.onConnect(client, c); err != nil {
		return nil, err
	}

	return client, nil
}

// listen listens for incoming messages from the client
func (w *Websocket) listen(client *Client) error {
	defer w.Close(client.ID)

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

// GinWsHandler is the handler for the websocket connection
//
// r.GET("/ws", ws.GinWsHandler)
func (w *Websocket) GinWsHandler(c *gin.Context) {
	client, err := w.connectGin(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := w.listen(client); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	}
}

// OnConnect sets the callback function to be called when a client connects
//
// ws.OnConnect(something)
func (w *Websocket) OnConnect(callback func(*Client, *gin.Context) error) {
	w.onConnect = callback
}

// OnDisconnect sets the callback function to be called when a client disconnects
//
// ws.OnDisconnect(something)
func (w *Websocket) OnDisconnect(callback func(*Client) error) {
	w.onDisconnect = callback
}

// GetClients returns the list of connected clients
//
// ws.GetClients()
func (w *Websocket) GetClients() map[string]*Client {
	return w.clients
}

// AddClient adds a new client to the list of connected clients
//
// ws.AddClient(client)
func (w *Websocket) AddClient(client *Client) {
	w.clients[client.ID] = client
}

// RemoveClient removes a client from the list of connected clients
//
// ws.RemoveClient(client.ID)
func (w *Websocket) RemoveClient(id string) error {
	client := w.GetClient(id)
	if client == nil {
		return fmt.Errorf("Client not found\n")
	}

	for _, room := range w.rooms {
		room.RemoveClient(client)
	}

	client.Close()
	delete(w.clients, id)

	return nil
}

// Close closes the connection of a client
//
// ws.Close(client.ID)
func (w *Websocket) Close(id string) {
	client := w.GetClient(id)

	if err := w.RemoveClient(id); err != nil {
		fmt.Printf("Error: %v\n", err)
	}

	if err := w.onDisconnect(client); err != nil {
		fmt.Printf("Error: %v\n", err)
	}
}

// GetClient returns a client by its ID
//
// ws.GetClient(client.ID)
func (w *Websocket) GetClient(id string) *Client {
	return w.clients[id]
}

// GetClientByUserId returns a client by its user ID
//
// ws.GetClientByUserId(user.ID)
func (w *Websocket) GetClientByUserId(id int) *Client {
	for _, client := range w.clients {
		if client.User.ID == id {
			return client
		}
	}
	return nil
}

// SendJson sends a message to all connected clients
//
// ws.SendJson(message)
func (w *Websocket) SendJson(message Message) error {
	for _, client := range w.clients {
		if err := client.SendJson(message); err != nil {
			return err
		}
	}

	return nil
}

// Emit sends a message to all connected clients
// ws.Emit("event", "message to send")
// client.Ws.Emit("event", []string{"message1", "message2"})
func (w *Websocket) Emit(command string, message interface{}) error {
	wsMessage := Message{
		Command: command,
		Message: message,
	}

	return w.SendJson(wsMessage)
}

// EmitError sends an error message to all connected clients
//
// ws.EmitError("error message")
// client.Ws.EmitError("error message")
func (w *Websocket) EmitError(message string) error {
	wsMessage := Message{
		Command: "error",
		Message: message,
	}

	return w.SendJson(wsMessage)
}

// OnEvent sets a callback function to be called when a specific command is received
//
// ws.OnEvent("testWebsocket", testWebsocket)
func (w *Websocket) OnEvent(command string, callback func(*Client, Message) error) {
	w.events[command] = callback
}

// DispatchCommand dispatches a command to the appropriate callback function
func (w *Websocket) DispatchCommand(client *Client, msg Message) error {
	callback, ok := w.events[msg.Command]
	if !ok {
		return client.EmitError("Invalid command")
	}

	return callback(client, msg)
}

// Room return and creates a new room if it doesn't exist
//
// ws.Room("room-name")
// client.Ws.Room("room-name")
func (w *Websocket) Room(name string) *Room {
	if _, ok := w.rooms[name]; !ok {
		w.rooms[name] = NewRoom(name)
	}

	return w.rooms[name]
}

// RemoveRoom removes a room by its name
//
// ws.RemoveRoom("room-name")
// client.Ws.RemoveRoom("room-name")
func (w *Websocket) RemoveRoom(name string) {
	delete(w.rooms, name)
}

// GetRooms returns the list of rooms
//
// ws.GetRooms()
// client.Ws.GetRooms()
func (w *Websocket) GetRooms() map[string]*Room {
	return w.rooms
}
