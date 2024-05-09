package websockets

type Room struct {
	Name    string
	clients map[string]*Client
}

func NewRoom(name string) *Room {
	return &Room{
		Name:    name,
		clients: make(map[string]*Client),
	}
}

func (r *Room) AddClient(client *Client) {
	r.clients[client.ID] = client
}

func (r *Room) RemoveClient(client *Client) {
	delete(r.clients, client.ID)
}

func (r *Room) GetClients() map[string]*Client {
	return r.clients
}

func (r *Room) BroadcastMessage(command string, message interface{}) error {
	msg := Message{
		Command: command,
		Message: message,
	}

	return r.BroadcastJson(msg)
}

func (r *Room) BroadcastJson(message Message) error {
	for _, client := range r.clients {
		if err := client.SendJson(message); err != nil {
			return err
		}
	}

	return nil
}
