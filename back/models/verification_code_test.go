package models_test

import (
	"challenge/models"
	"testing"
	"time"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func TestVerificationCode_Save(t *testing.T) {
	db, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to connect database: %v", err)
	}

	db.AutoMigrate(&models.VerificationCode{})

	verificationCode := models.VerificationCode{
		UserID:    1,
		Code:      "12345",
		ExpiresAt: time.Now().Add(15 * time.Minute),
	}

	if err := verificationCode.Save(db); err != nil {
		t.Fatalf("failed to save verification code: %v", err)
	}

	var vc models.VerificationCode
	if err := db.First(&vc, "code = ?", "12345").Error; err != nil {
		t.Fatalf("failed to find verification code: %v", err)
	}
}

func TestVerificationCode_IsExpired(t *testing.T) {
	vc := models.VerificationCode{
		ExpiresAt: time.Now().Add(-1 * time.Minute),
	}

	if !vc.IsExpired() {
		t.Fatalf("expected verification code to be expired")
	}
}

func TestDeleteExpiredCodes(t *testing.T) {
	db, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to connect database: %v", err)
	}

	db.AutoMigrate(&models.VerificationCode{})

	vc := models.VerificationCode{
		UserID:    1,
		Code:      "12345",
		ExpiresAt: time.Now().Add(-1 * time.Minute),
	}

	if err := vc.Save(db); err != nil {
		t.Fatalf("failed to save verification code: %v", err)
	}

	if err := models.DeleteExpiredCodes(db); err != nil {
		t.Fatalf("failed to delete expired codes: %v", err)
	}

	var count int64
	db.Model(&models.VerificationCode{}).Where("code = ?", "12345").Count(&count)
	if count != 0 {
		t.Fatalf("expected expired verification code to be deleted")
	}
}