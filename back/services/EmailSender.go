package services

import (
	"github.com/resend/resend-go/v2"
	"os"
)

func SendEmail() {
	apiKey := os.Getenv("RESEND_API_KEY")

	client := resend.NewClient(apiKey)

	params := &resend.SendEmailRequest{
		To:      []string{"to@example", "you@example.com"},
		From:    "me@exemple.io",
		Text:    "hello world",
		Subject: "Hello from Golang",
		Cc:      []string{"cc@example.com"},
		Bcc:     []string{"cc@example.com"},
		ReplyTo: "replyto@example.com",
	}

	err, _ := client.Emails.Send(params)
	if err != nil {
		panic(err)
	}
}
