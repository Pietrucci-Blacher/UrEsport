package models

import (
	"time"

	"gorm.io/gorm"
)

type VerificationCode struct {
	ID        uint      `gorm:"primaryKey"`
	UserID    uint      `gorm:"not null"`
	Code      string    `gorm:"not null"`
	ExpiresAt time.Time `gorm:"not null"`
	CreatedAt time.Time
	UpdatedAt time.Time
}

type VerifyUserDto struct {
	Email string `json:"email" binding:"required,email"`
	Code  string `json:"code" binding:"required"`
}

type RequestPasswordResetDto struct {
	Email string `json:"email" binding:"required,email"`
}

type ResetPasswordDto struct {
	Email       string `json:"email" binding:"required,email"`
	Code        string `json:"code" binding:"required"`
	NewPassword string `json:"new_password" binding:"required"`
}

func (vc *VerificationCode) Save() error {
	return DB.Save(vc).Error
}

func (vc *VerificationCode) IsExpired() bool {
	return time.Now().After(vc.ExpiresAt)
}

func DeleteExpiredCodes() error {
	return DB.Where("expires_at < ?", time.Now()).Delete(&VerificationCode{}).Error
}
