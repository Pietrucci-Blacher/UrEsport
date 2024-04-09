package models

import (
	"fmt"
	"github.com/golang-jwt/jwt/v5"
	"os"
	"time"
)

type Token struct {
	UserID int    `json:"user_id" gorm:"primaryKey"`
	Token  string `json:"token" gorm:"type:varchar(255)"`
}

var jwtKey = []byte(os.Getenv("JWT_SECRET_KEY"))

// UserClaims extends jwt.RegisteredClaims
type UserClaims struct {
	jwt.RegisteredClaims
	UserID int `json:"user_id"`
}

func GenerateJWTToken(userID int) (string, error) {
	now := time.Now()

	claims := &UserClaims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(now.Add(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(now),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		return "", fmt.Errorf("failed to sign the token: %w", err)
	}

	return tokenString, nil
}
