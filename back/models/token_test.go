package models

import (
	"strconv"
	"testing"
	"time"

	jwt "github.com/golang-jwt/jwt/v5"
)

func TestSaveToken(t *testing.T) {
	if err := ConnectDB(true); err != nil {
		t.Error(err)
		return
	}

	defer func() {
		if err := CloseDB(); err != nil {
			t.Error("Failed to close database:", err)
		}
	}()

	token := Token{
		UserID:    1,
		Token:     "sample_token",
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}

	if err := token.Save(); err != nil {
		t.Error("Failed to save token:", err)
		return
	}

	var fetchedToken Token
	if err := fetchedToken.FindOneById(token.ID); err != nil {
		t.Error("Failed to find token:", err)
		return
	}

	if fetchedToken.Token != token.Token {
		t.Errorf("Expected %s, got %s", token.Token, fetchedToken.Token)
	}
}

func TestFindTokensByUserID(t *testing.T) {
	if err := ConnectDB(true); err != nil {
		t.Error(err)
		return
	}

	defer func() {
		if err := CloseDB(); err != nil {
			t.Error("Failed to close database:", err)
		}
	}()

	// Creating tokens for a user with ID 1
	for i := 0; i < 5; i++ {
		token := Token{
			UserID:    1,
			Token:     "token_" + strconv.Itoa(i),
			CreatedAt: time.Now(),
			UpdatedAt: time.Now(),
		}
		if err := token.Save(); err != nil {
			t.Error("Failed to save token:", err)
			return
		}
	}

	tokens, err := FindTokensByUserID(1)
	if err != nil {
		t.Error("Failed to find tokens by user ID:", err)
		return
	}

	if len(tokens) != 5 {
		t.Errorf("Expected 5 tokens, got %d", len(tokens))
	}
}

func TestDeleteTokensByUserID(t *testing.T) {
	if err := ConnectDB(true); err != nil {
		t.Error(err)
		return
	}

	defer func() {
		if err := CloseDB(); err != nil {
			t.Error("Failed to close database:", err)
		}
	}()

	if err := DeleteTokensByUserID(1); err != nil {
		t.Error("Failed to delete tokens by user ID:", err)
		return
	}

	tokens, err := FindTokensByUserID(1)
	if err != nil {
		t.Error("Failed to find tokens by user ID:", err)
		return
	}

	if len(tokens) != 0 {
		t.Errorf("Expected 0 tokens, got %d", len(tokens))
	}
}

func TestGenerateJWTToken(t *testing.T) {
	if err := ConnectDB(true); err != nil {
		t.Error(err)
		return
	}

	defer func() {
		if err := CloseDB(); err != nil {
			t.Error("Failed to close database:", err)
		}
	}()

	now := time.Now()

	claims := &UserClaims{
		UserID: 1,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(now.Add(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(now),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		t.Error("Failed to sign JWT token:", err)
		return
	}

	// Save the token
	if err := NewToken(tokenString, 1); err != nil {
		t.Error("Failed to save JWT token:", err)
		return
	}

	claimsParsed, err := ParseJWTToken(tokenString)
	if err != nil {
		t.Error("Failed to parse JWT token:", err)
		return
	}

	if claimsParsed.UserID != 1 {
		t.Errorf("Expected UserID 1, got %d", claimsParsed.UserID)
	}
}

func TestParseJWTToken(t *testing.T) {
    if err := ConnectDB(true); err != nil {
        t.Error(err)
        return
    }

    defer func() {
        if err := CloseDB(); err != nil {
            t.Error("Failed to close database:", err)
        }
    }()

    now := time.Now()

    claims := &UserClaims{
        UserID: 1,
        RegisteredClaims: jwt.RegisteredClaims{
            ExpiresAt: jwt.NewNumericDate(now.Add(24 * time.Hour)),
            IssuedAt:  jwt.NewNumericDate(now),
        },
    }

    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

    tokenString, err := token.SignedString(jwtKey)
    if err != nil {
        t.Error("Failed to sign JWT token:", err)
        return
    }

    if err := NewToken(tokenString, 1); err != nil {
        t.Error("Failed to save JWT token:", err)
        return
    }

    // Parsing the token directly
    claimsParsed, err := ParseJWTToken(tokenString)
    if err != nil {
        t.Error("Failed to parse JWT token:", err)
        return
    }

    if claimsParsed.UserID != 1 {
        t.Errorf("Expected UserID 1, got %d", claimsParsed.UserID)
    }

    if claimsParsed.ExpiresAt.Time.Before(time.Now().Add(24 * time.Hour)) {
        t.Error("Expected token expiration to be 24 hours from now")
    }
}


func TestTokenDelete(t *testing.T) {
	if err := ConnectDB(true); err != nil {
		t.Error(err)
		return
	}

	defer func() {
		if err := CloseDB(); err != nil {
			t.Error("Failed to close database:", err)
		}
	}()

	token := Token{
		UserID:    1,
		Token:     "sample_token",
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}

	if err := token.Save(); err != nil {
		t.Error("Failed to save token:", err)
		return
	}

	if err := token.Delete(); err != nil {
		t.Error("Failed to delete token:", err)
		return
	}

	var fetchedToken Token
	if err := fetchedToken.FindOneById(token.ID); err == nil {
		t.Error("Expected token to be deleted")
	}
}
