package services

import (
	"os"

	"github.com/resend/resend-go/v2"
)

type EmailTemplate string

const (
	WelcomeEmail       EmailTemplate = "WELCOME_EMAIL"
	PasswordResetEmail EmailTemplate = "PASSWORD_RESET_EMAIL"
)

func SendEmail(userEmail string, template EmailTemplate) error {
	apiKey := os.Getenv("RESEND_API_KEY")
	client := resend.NewClient(apiKey)

	subject, text := getEmailContent(template)

	params := &resend.SendEmailRequest{
		To:      []string{userEmail},
		From:    os.Getenv("RESEND_SENDER"),
		Text:    text,
		Subject: subject,
		Cc:      []string{"cc@example.com"},
		Bcc:     []string{"bcc@example.com"},
	}

	_, err := client.Emails.Send(params)
	if err != nil {
		return err
	}

	return nil
}

func getEmailContent(template EmailTemplate) (subject, text string) {
	switch template {
	case WelcomeEmail:
		subject = "Bienvenue sur notre plateforme !"
		text = "Nous sommes ravis de vous accueillir. Commencez dès maintenant à explorer nos fonctionnalités."
	case PasswordResetEmail:
		subject = "Réinitialisation de votre mot de passe"
		text = "Suivez ce lien pour réinitialiser votre mot de passe. Si vous n'avez pas demandé cette réinitialisation, veuillez ignorer cet email."
	default:
		subject = "Hello from Golang"
		text = "hello world"
	}
	return subject, text
}
