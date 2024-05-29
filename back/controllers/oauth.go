package controllers

import (
	"challenge/models"
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"os"
	"strconv"

	"github.com/coreos/go-oidc/v3/oidc"
	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

var (
	discordOAuthConfig = &oauth2.Config{
		ClientID:     os.Getenv("DISCORD_CLIENT_ID"),
		ClientSecret: os.Getenv("DISCORD_CLIENT_SECRET"),
		RedirectURL:  os.Getenv("DISCORD_REDIRECT_URI"),
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://discord.com/api/oauth2/authorize",
			TokenURL: "https://discord.com/api/oauth2/token",
		},
		Scopes: []string{"identify", "email"},
	}

	twitchOAuthConfig = &oauth2.Config{
		ClientID:     os.Getenv("TWITCH_CLIENT_ID"),
		ClientSecret: os.Getenv("TWITCH_CLIENT_SECRET"),
		RedirectURL:  os.Getenv("TWITCH_REDIRECT_URI"),
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://id.twitch.tv/oauth2/authorize",
			TokenURL: "https://id.twitch.tv/oauth2/token",
		},
		Scopes: []string{"user:read:email"},
	}

	appleOAuthConfig = &oauth2.Config{
		ClientID:     os.Getenv("IOS_CLIENT_ID"),
		ClientSecret: os.Getenv("IOS_CLIENT_SECRET"),
		RedirectURL:  os.Getenv("IOS_REDIRECT_URI"),
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://appleid.apple.com/auth/authorize",
			TokenURL: "https://appleid.apple.com/auth/token",
		},
		Scopes: []string{"name", "email"},
	}

	googleOAuthConfig = &oauth2.Config{
		ClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
		ClientSecret: os.Getenv("GOOGLE_CLIENT_SECRET"),
		RedirectURL:  os.Getenv("GOOGLE_REDIRECT_URI"),
		Endpoint:     google.Endpoint,
		Scopes:       []string{"openid", "profile", "email"},
	}
)

// OAuth2Callback godoc
//
//	@Summary		OAuth2 callback
//	@Description	Handle OAuth2 callback
//	@Tags			auth
//	@Produce		json
//	@Param			state	query		string	true	"State"
//	@Param			code	query		string	true	"Code"
//	@Success		200		{object}	models.LoginSuccessResponse
//	@Failure		400		{object}	utils.HttpError
//	@Router			/auth/oauth2/{provider}/callback [get]
func OAuth2Callback(c *gin.Context) {
	provider := c.Param("provider")
	code := c.Query("code")

	var oauthConfig *oauth2.Config
	switch provider {
	case "discord":
		oauthConfig = discordOAuthConfig
	case "twitch":
		oauthConfig = twitchOAuthConfig
	case "apple":
		oauthConfig = appleOAuthConfig
	case "google":
		oauthConfig = googleOAuthConfig
	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid provider"})
		return
	}

	token, err := oauthConfig.Exchange(context.Background(), code)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to exchange token"})
		return
	}

	userInfo, err := fetchUserInfo(provider, token)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch user info"})
		return
	}

	var user models.User
	if err := user.FindOne("email", userInfo.Email); err != nil {
		user = models.User{
			Firstname: userInfo.Firstname,
			Lastname:  userInfo.Lastname,
			Username:  userInfo.Username,
			Email:     userInfo.Email,
			Roles:     []string{models.ROLE_USER},
		}

		if err := user.Save(); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save user"})
			return
		}
	}

	tokenModel, err := models.NewToken("access_token", user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create token"})
		return
	}
	if err := tokenModel.GenerateTokens(); err != nil || tokenModel.Save() != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate or save token"})
		return
	}

	cookieSecure, _ := strconv.ParseBool(os.Getenv("COOKIE_SECURE"))
	c.SetCookie("access_token", tokenModel.AccessToken, 3600, "/", "", cookieSecure, true)
	c.SetCookie("refresh_token", tokenModel.RefreshToken, 3600*24*30, "/", "", cookieSecure, true)

	c.JSON(http.StatusOK, gin.H{
		"access_token":  tokenModel.AccessToken,
		"refresh_token": tokenModel.RefreshToken,
	})
}

func fetchUserInfo(provider string, token *oauth2.Token) (models.UserInfo, error) {
	switch provider {
	case "discord":
		return fetchDiscordUserInfo(token)
	case "twitch":
		return fetchTwitchUserInfo(token)
	case "apple":
		return fetchAppleUserInfo(token)
	case "google":
		return fetchGoogleUserInfo(token)
	default:
		return models.UserInfo{}, errors.New("unsupported provider")
	}
}

func fetchDiscordUserInfo(token *oauth2.Token) (models.UserInfo, error) {
	client := oauth2.NewClient(context.Background(), oauth2.StaticTokenSource(token))
	resp, err := client.Get("https://discord.com/api/users/@me")
	if err != nil {
		return models.UserInfo{}, err
	}
	defer resp.Body.Close()

	var userInfo struct {
		Email     string `json:"email"`
		Username  string `json:"username"`
		Firstname string `json:"given_name"`
		Lastname  string `json:"family_name"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&userInfo); err != nil {
		return models.UserInfo{}, err
	}

	return models.UserInfo{
		Email:     userInfo.Email,
		Username:  userInfo.Username,
		Firstname: userInfo.Firstname,
		Lastname:  userInfo.Lastname,
	}, nil
}

func fetchTwitchUserInfo(token *oauth2.Token) (models.UserInfo, error) {
	client := oauth2.NewClient(context.Background(), oauth2.StaticTokenSource(token))
	resp, err := client.Get("https://api.twitch.tv/helix/users")
	if err != nil {
		return models.UserInfo{}, err
	}
	defer resp.Body.Close()

	var userInfo struct {
		Data []struct {
			Email     string `json:"email"`
			Username  string `json:"username"`
			Firstname string `json:"firstname"`
			Lastname  string `json:"lastname"`
		} `json:"data"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&userInfo); err != nil {
		return models.UserInfo{}, err
	}

	if len(userInfo.Data) == 0 {
		return models.UserInfo{}, errors.New("no user info found")
	}

	return models.UserInfo{
		Email:     userInfo.Data[0].Email,
		Username:  userInfo.Data[0].Username,
		Firstname: userInfo.Data[0].Firstname,
		Lastname:  userInfo.Data[0].Lastname,
	}, nil
}

func fetchAppleUserInfo(token *oauth2.Token) (models.UserInfo, error) {
	idToken, ok := token.Extra("id_token").(string)
	if !ok {
		return models.UserInfo{}, errors.New("no id_token found")
	}

	provider, err := oidc.NewProvider(context.Background(), "https://appleid.apple.com")
	if err != nil {
		return models.UserInfo{}, err
	}

	verifier := provider.Verifier(&oidc.Config{ClientID: appleOAuthConfig.ClientID})
	parsedToken, err := verifier.Verify(context.Background(), idToken)
	if err != nil {
		return models.UserInfo{}, err
	}

	var userInfo struct {
		Email     string `json:"email"`
		Username  string `json:"username"`
		Firstname string `json:"given_name"`
		Lastname  string `json:"family_name"`
	}
	if err := parsedToken.Claims(&userInfo); err != nil {
		return models.UserInfo{}, err
	}

	return models.UserInfo{
		Email:     userInfo.Email,
		Username:  userInfo.Username,
		Firstname: userInfo.Firstname,
		Lastname:  userInfo.Lastname,
	}, nil
}

func fetchGoogleUserInfo(token *oauth2.Token) (models.UserInfo, error) {
	client := oauth2.NewClient(context.Background(), oauth2.StaticTokenSource(token))
	resp, err := client.Get("https://www.googleapis.com/oauth2/v3/userinfo")
	if err != nil {
		return models.UserInfo{}, err
	}
	defer resp.Body.Close()

	var userInfo struct {
		Email     string `json:"email"`
		Username  string `json:"username"`
		Firstname string `json:"given_name"`
		Lastname  string `json:"family_name"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&userInfo); err != nil {
		return models.UserInfo{}, err
	}

	return models.UserInfo{
		Email:     userInfo.Email,
		Username:  userInfo.Username,
		Firstname: userInfo.Firstname,
		Lastname:  userInfo.Lastname,
	}, nil
}
