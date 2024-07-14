package websockets

import (
	"challenge/models"
	"challenge/services"
	"fmt"
)

func SendNbUserToAdmin(client *services.Client) error {
	wsData := map[string]int{
		"nbUsers": len(client.Ws.GetClients()),
	}

	return client.Ws.Room("admin").Emit("user:connected", wsData)
}

func GetNbUser(client *services.Client, msg any) error {
	logged := client.Get("logged").(bool)

	if !logged {
		return fmt.Errorf("You must be logged in to get the number of users")
	}

	user := client.Get("user").(models.User)

	if !user.IsRole(models.ROLE_ADMIN) {
		return fmt.Errorf("You must be an admin to get the number of users")
	}

	wsData := map[string]int{
		"nbUsers": len(client.Ws.GetClients()),
	}

	return client.Emit("user:connected", wsData)
}
