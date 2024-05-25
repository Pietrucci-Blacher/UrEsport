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

func (vc *VerificationCode) Save(db *gorm.DB) error {
	return db.Save(vc).Error
}

func (vc *VerificationCode) IsExpired() bool {
	return time.Now().After(vc.ExpiresAt)
}

func DeleteExpiredCodes(db *gorm.DB) error {
	return db.Where("expires_at < ?", time.Now()).Delete(&VerificationCode{}).Error
}
