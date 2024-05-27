package models

import (
	"testing"
	"time"
)

func TestVerificationCode_Save(t *testing.T) {
	if err := ConnectDB(true); err != nil {
		t.Error(err)
		return
	}
	defer func() {
		if err := CloseDB(); err != nil {
			t.Error("Failed to close database:", err)
		}
	}()

	verificationCode := VerificationCode{
		UserID:    1,
		Code:      "12345",
		ExpiresAt: time.Now().Add(15 * time.Minute),
	}

	if err := verificationCode.Save(); err != nil {
		t.Fatalf("failed to save verification code: %v", err)
	}

	var vc VerificationCode
	if err := DB.First(&vc, "code = ?", "12345").Error; err != nil {
		t.Fatalf("failed to find verification code: %v", err)
	}
}

func TestVerificationCode_IsExpired(t *testing.T) {
	vc := VerificationCode{
		ExpiresAt: time.Now().Add(-1 * time.Minute),
	}

	if !vc.IsExpired() {
		t.Fatalf("expected verification code to be expired")
	}
}

func TestDeleteExpiredCodes(t *testing.T) {
	if err := ConnectDB(true); err != nil {
		t.Error(err)
		return
	}

	defer func() {
		if err := CloseDB(); err != nil {
			t.Error("Failed to close database:", err)
		}
	}()

	vc := VerificationCode{
		UserID:    1,
		Code:      "12345",
		ExpiresAt: time.Now().Add(-1 * time.Minute),
	}

	if err := vc.Save(); err != nil {
		t.Fatalf("failed to save verification code: %v", err)
	}

	if err := DeleteExpiredCodes(); err != nil {
		t.Fatalf("failed to delete expired codes: %v", err)
	}

	var count int64
	DB.Model(&VerificationCode{}).Where("code = ?", "12345").Count(&count)
	if count != 0 {
		t.Fatalf("expected expired verification code to be deleted")
	}
}
