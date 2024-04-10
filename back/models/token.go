package models

import (
	"fmt"
	jwt "github.com/golang-jwt/jwt/v5"
	"log"
	"os"
	"time"
)

type Token struct {
	ID        int       `json:"id" gorm:"primaryKey"`
	UserID    int       `json:"user_id" gorm:"primaryKey;references:ID"`
	Token     string    `json:"token" gorm:"type:varchar(255)"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

var jwtKey = []byte(os.Getenv("JWT_SECRET_KEY"))

// UserClaims extends jwt.RegisteredClaims
type UserClaims struct {
	jwt.RegisteredClaims
	UserID int `json:"user_id"`
}

func NewToken(tokenString string, userID int) error {
	token := Token{
		UserID:    userID,
		Token:     tokenString,
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}
	return token.Save()
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

	err = NewToken(tokenString, userID)
	if err != nil {
		return "", fmt.Errorf("failed to save the token: %w", err)
	}

	return tokenString, nil
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
