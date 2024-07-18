package websockets

import (
	"challenge/models"
	"challenge/services"
	"fmt"
)

func countUsers(client *services.Client) map[string]int {
	totalUsers, _ := models.CountUsers()

	loggedClients := client.Ws.FilterClient(func(c *services.Client) bool {
		return c.Get("logged").(bool)
	})

	annonClients := client.Ws.FilterClient(func(c *services.Client) bool {
		return !c.Get("logged").(bool)
	})

	return map[string]int{
		"loggedUsers": len(loggedClients),
		"annonUsers":  len(annonClients),
		"totalUsers":  int(totalUsers),
	}
}

func SendNbUserToAdmin(client *services.Client) error {
	wsData := countUsers(client)
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

	wsData := countUsers(client)

	return client.Emit("user:connected", wsData)
}
