package services

// Room is the struct for managing a room of clients
type Room struct {
	Name    string
	clients map[string]*Client
}

// NewRoom creates a new room
func NewRoom(name string) *Room {
	return &Room{
		Name:    name,
		clients: make(map[string]*Client),
	}
}

// AddClient adds a client to the room
//
// room.AddClient(client)
// client.Ws.Room("room-name").AddClient(client)
func (r *Room) AddClient(client *Client) {
	r.clients[client.ID] = client
}

// RemoveClient removes a client from the room
//
// room.RemoveClient(client)
// client.Ws.Room("room-name").RemoveClient(client)
func (r *Room) RemoveClient(client *Client) {
	delete(r.clients, client.ID)
}

// GetClients returns the list of clients in the room
//
// room.GetClients()
// clients := client.Ws.Room("room-name").GetClients()
func (r *Room) GetClients() map[string]*Client {
	return r.clients
}

// SendJson sends a message to all clients in the room
func (r *Room) SendJson(message Message) error {
	for _, client := range r.clients {
		if err := client.SendJson(message); err != nil {
			return err
		}
	}

	return nil
}

// Emit sends a message to all clients in the room
//
// room.Emit("event", "message to send")
// client.Ws.Room("room-name").Emit("event", []string{"message1", "message2"})
func (r *Room) Emit(command string, message any) error {
	msg := Message{
		Command: command,
		Message: message,
	}

	return r.SendJson(msg)
}

// EmitError sends an error message to all clients in the room
//
// room.EmitError("error message")
// client.Ws.Room("room-name").EmitError("error message")
func (r *Room) EmitError(message string) error {
	errorMsg := Message{
		Command: "error",
		Message: message,
	}

	return r.SendJson(errorMsg)
}
