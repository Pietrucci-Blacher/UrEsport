package models

import (
	_ "bytes"
	"encoding/base64"
	"errors"
	"fmt"
	"github.com/skip2/go-qrcode"
)

type Organizer struct {
	InvitedUsers []*User
}

type InvitationMethod int

const (
	LinkAutoCopy InvitationMethod = iota
	DiscordLink
	EmailLink
	QRCode
)

func (o *Organizer) GenerateLink(u *User) map[InvitationMethod]string {
	links := make(map[InvitationMethod]string)

	links[LinkAutoCopy] = fmt.Sprintf("http://localhost:8080/invite?user=%s", u.Username)
	links[DiscordLink] = "https://discord.gg/your-invite-code"
	links[EmailLink] = fmt.Sprintf("https://example.com/invite-by-email?user=%s", u.Username)
	qrCode, err := qrcode.New(links[LinkAutoCopy], qrcode.Medium)
	if err != nil {
		fmt.Println("Could not generate QR Code", err)
	} else {
		var png []byte
		png, err = qrCode.PNG(-1)
		if err != nil {
			fmt.Println("Could not generate PNG", err)
		} else {
			links[QRCode] = base64.StdEncoding.EncodeToString(png)
		}
	}

	return links
}

func (o *Organizer) InviteUser(u *User, method InvitationMethod) error {
	if u.Invited {
		return errors.New("User already invited")
	}

	u.Invited = true
	o.InvitedUsers = append(o.InvitedUsers, u)
	fmt.Printf("User %s has been invited\n", u.Username)

	links := o.GenerateLink(u)
	fmt.Println(links[LinkAutoCopy]) // Affiche le lien pour LinkAutoCopy
	fmt.Println(links[DiscordLink])  // Affiche le lien pour DiscordLink
	fmt.Println(links[EmailLink])    // Affiche le lien pour EmailLink
	// Logique pour chaque méthode d'invitation
	switch method {
	case LinkAutoCopy:
		links := o.GenerateLink(u)
		fmt.Printf("Link for %s has been automatically copied: %s\n", u.Username, links[LinkAutoCopy])
	case DiscordLink:
		links := o.GenerateLink(u)
		fmt.Printf("Discord link for %s has been sent: %s\n", u.Username, links[DiscordLink])
	case EmailLink:
		links := o.GenerateLink(u)
		fmt.Printf("Email link for %s has been sent: %s\n", u.Email, links[EmailLink])
	default:
		return errors.New("Invalid invitation method")
	}

	return nil
}

func (o *Organizer) LaunchCheckIn() error {
	if len(o.InvitedUsers) == 0 {
		return errors.New("No users invited")
	}

	for _, user := range o.InvitedUsers {
		fmt.Printf("Check-in request sent to %s\n", user.Username)
	}

	fmt.Println("Check-in launched")
	return nil
}
