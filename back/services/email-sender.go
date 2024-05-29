package services

import (
	"context"
	"fmt"
	"math/rand"
	"os"
	"time"

	sib_api_v3_sdk "github.com/getbrevo/brevo-go/lib"
)

type EmailTemplate string

const (
	WelcomeEmail       EmailTemplate = "WELCOME_EMAIL"
	PasswordResetEmail EmailTemplate = "PASSWORD_RESET_EMAIL"
	VerificationEmail  EmailTemplate = "VERIFICATION_EMAIL"
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

	subject, htmlContent := getEmailContent(template, "")

	to := []sib_api_v3_sdk.SendSmtpEmailTo{
		{
			Email: userEmail,
		},
	}

	body := sib_api_v3_sdk.SendSmtpEmail{
		HtmlContent: htmlContent,
		Subject:     subject,
		Sender: &sib_api_v3_sdk.SendSmtpEmailSender{
			Name:  os.Getenv("BREVO_SENDER"),
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

func SendVerificationEmail(userEmail, code string) error {
	return SendEmailWithCode(userEmail, VerificationEmail, code)
}

func SendEmailWithCode(userEmail string, template EmailTemplate, code string) error {
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

	subject, htmlContent := getEmailContent(template, code)

	to := []sib_api_v3_sdk.SendSmtpEmailTo{
		{
			Email: userEmail,
		},
	}

	body := sib_api_v3_sdk.SendSmtpEmail{
		HtmlContent: htmlContent,
		Subject:     subject,
		Sender: &sib_api_v3_sdk.SendSmtpEmailSender{
			Name:  os.Getenv("BREVO_SENDER"),
			Email: senderEmail,
		},
		To: to,
		Params: map[string]interface{}{
			"subject": subject,
			"code":    code,
		},
	}

	ctx := context.Background()
	response, httpResp, err := sib.TransactionalEmailsApi.SendTransacEmail(ctx, body)
	if err != nil {
		return fmt.Errorf("error sending email: %w, response: %v, http response: %v", err, response, httpResp)
	}

	return nil
}

func getEmailContent(template EmailTemplate, code string) (subject, htmlContent string) {
	switch template {
	case WelcomeEmail:
		subject = "Bienvenue sur notre plateforme !"
		htmlContent = "<p>Nous sommes ravis de vous accueillir. Commencez dès maintenant à explorer nos fonctionnalités.</p>"
	case PasswordResetEmail:
		subject = "Réinitialisation de votre mot de passe"
		htmlContent = "<p>Suivez ce lien pour réinitialiser votre mot de passe. Si vous n'avez pas demandé cette réinitialisation, veuillez ignorer cet email.</p>"
	case VerificationEmail:
		subject = "Vérifiez votre compte"
		htmlContent = fmt.Sprintf("<p>Votre code de vérification est : %s</p><p>Ce code expirera dans 15 minutes.</p>", code)
	default:
		subject = "Hello from Golang"
		htmlContent = "<p>Hello world</p>"
	}
	return subject, htmlContent
}

func GenerateVerificationCode() int {
	source := rand.NewSource(time.Now().UnixNano())
	randomGenerator := rand.New(source)
	return 10000 + randomGenerator.Intn(90000)
}
