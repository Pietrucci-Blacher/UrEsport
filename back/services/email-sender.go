package services

import (
	"context"
	"fmt"
	"os"

	sib_api_v3_sdk "github.com/getbrevo/brevo-go/lib"
)

type EmailTemplate string

const (
	WelcomeEmail       EmailTemplate = "WELCOME_EMAIL"
	PasswordResetEmail EmailTemplate = "PASSWORD_RESET_EMAIL"
)

func SendEmail(userEmail string, template EmailTemplate) error {
	apiKey := os.Getenv("BREVO_API_KEY")
	if apiKey == "" {
		return fmt.Errorf("BREVO_API_KEY environment variable is not set")
	}

	senderEmail := os.Getenv("BREVO_SENDER")
	if senderEmail == "" {
		return fmt.Errorf("BREVO_SENDER environment variable is not set")
	}

	cfg := sib_api_v3_sdk.NewConfiguration()
	cfg.AddDefaultHeader("api-key", apiKey)

	sib := sib_api_v3_sdk.NewAPIClient(cfg)

	subject, htmlContent := getEmailContent(template)

	to := []sib_api_v3_sdk.SendSmtpEmailTo{
		{
			Email: userEmail,
		},
	}

	body := sib_api_v3_sdk.SendSmtpEmail{
		HtmlContent: htmlContent,
		Subject:     subject,
		Sender: &sib_api_v3_sdk.SendSmtpEmailSender{
			Name:  "UREsport",
			Email: senderEmail,
		},
		To: to,
		Params: map[string]interface{}{
			"subject": subject,
		},
	}

	ctx := context.Background()
	response, httpResp, err := sib.TransactionalEmailsApi.SendTransacEmail(ctx, body)
	if err != nil {
		return fmt.Errorf("error sending email: %w, response: %v, http response: %v", err, response, httpResp)
	}

	return nil
}

func getEmailContent(template EmailTemplate) (subject, htmlContent string) {
	switch template {
	case WelcomeEmail:
		subject = "Bienvenue sur notre plateforme !"
		htmlContent = "<p>Nous sommes ravis de vous accueillir. Commencez dès maintenant à explorer nos fonctionnalités.</p>"
	case PasswordResetEmail:
		subject = "Réinitialisation de votre mot de passe"
		htmlContent = "<p>Suivez ce lien pour réinitialiser votre mot de passe. Si vous n'avez pas demandé cette réinitialisation, veuillez ignorer cet email.</p>"
	default:
		subject = "Hello from Golang"
		htmlContent = "<p>Hello world</p>"
	}
	return subject, htmlContent
}
