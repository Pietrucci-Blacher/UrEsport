package models

import (
	"fmt"
	"log"
	"os"
	"time"

	jwt "github.com/golang-jwt/jwt/v5"
)

type Token struct {
	ID           int       `json:"id" gorm:"primaryKey"`
	UserID       int       `json:"user_id" gorm:"primaryKey;references:ID"`
	AccessToken  string    `json:"access_token" gorm:"type:varchar(255)"`
	RefreshToken string    `json:"refresh_token" gorm:"type:varchar(255)"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

var jwtKey = []byte(os.Getenv("JWT_SECRET_KEY"))

// UserClaims extends jwt.RegisteredClaims
type UserClaims struct {
	jwt.RegisteredClaims
	UserID int `json:"user_id"`
}

func NewToken(accessToken, refreshToken string, userID int) error {
	token := Token{
		UserID:       userID,
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
	}
	return token.Save()
}

func FindTokensByUserID(userID int) ([]Token, error) {
	var tokens []Token
	err := DB.Where("user_id = ?", userID).Find(&tokens).Error
	return tokens, err
}

func DeleteTokensByUserID(userID int) error {
	return DB.Where("user_id = ?", userID).Delete(&Token{}).Error
}

func GenerateJWTToken(userID int) (string, string, error) {
	now := time.Now()

	claims := &UserClaims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(now.Add(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(now),
		},
	}

	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	refreshToken := jwt.New(jwt.SigningMethodHS256)
	refreshToken.Claims = jwt.MapClaims{
		"exp": now.Add(30 * 24 * time.Hour).Unix(),
		"sub": 1,
	}

	accessTokenString, err := accessToken.SignedString(jwtKey)
	if err != nil {
		return "", "", fmt.Errorf("failed to sign the token: %w", err)
	}

	refreshTokenString, err := refreshToken.SignedString(jwtKey)
	if err != nil {
		return "", "", fmt.Errorf("failed to sign the token: %w", err)
	}

	err = NewToken(accessTokenString, refreshTokenString, userID)
	if err != nil {
		return "", "", fmt.Errorf("failed to save the token: %w", err)
	}

	return accessTokenString, refreshTokenString, nil
}

func ParseJWTToken(tokenString string) (*UserClaims, error) {
	claims := &UserClaims{}

	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})

	if err != nil {
		return nil, fmt.Errorf("failed to parse the token: %w", err)
	}

	if !token.Valid {
		return nil, fmt.Errorf("the token is invalid")
	}

	return claims, nil
}

func (t *Token) FindOne(key string, value any) error {
	return DB.Where(key+" = ?", value).First(&t).Error
}

func (t *Token) FindOneById(id int) error {
	return DB.First(&t, id).Error
}

func (t *Token) Save() error {
	if err := DB.Save(&t).Error; err != nil {
		log.Printf("Error saving token: %v", err)
		return err
	}
	return nil
}

func (t *Token) Delete() error {
	return DB.Delete(&t).Error
}
