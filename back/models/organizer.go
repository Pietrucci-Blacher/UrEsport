package models

import (
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
	QRCode InvitationMethod = iota
	InviteLink
)

func (o *Organizer) GenerateLink(u *User) map[InvitationMethod]string {
	links := make(map[InvitationMethod]string)

	links[InviteLink] = fmt.Sprintf("https://example.com/invite?user=%s", u.Username)
	qrCode, err := qrcode.New(links[InviteLink], qrcode.Medium)
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

	switch method {
	case QRCode, InviteLink:
		links := o.GenerateLink(u)
		fmt.Printf("Link for %s: %s\n", u.Username, links[method])
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
