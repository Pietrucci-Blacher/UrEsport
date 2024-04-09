package models

import (
	"time"

	"golang.org/x/crypto/bcrypt"
)

// User implements Model
type User struct {
	ID        int       `json:"id" gorm:"primaryKey"`
	Firstname string    `json:"firstname" gorm:"type:varchar(100)"`
	Lastname  string    `json:"lastname" gorm:"type:varchar(100)"`
	Username  string    `json:"username" gorm:"type:varchar(100)"`
	Email     string    `json:"email" gorm:"type:varchar(100)"`
	Password  string    `json:"password"`
	Roles     []string  `json:"roles" gorm:"json"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type CreateUserDto struct {
	Firstname string `json:"firstname" validate:"required"`
	Lastname  string `json:"lastname" validate:"required"`
	Username  string `json:"username" validate:"required"`
	Email     string `json:"email" validate:"required,email"`
	Password  string `json:"password" validate:"required"`
}

type UpdateUserDto struct {
	Firstname string `json:"firstname"`
	Lastname  string `json:"lastname"`
	Username  string `json:"username"`
	Email     string `json:"email" validate:"email"`
}

func UserExists(id int) bool {
	var count int64
	DB.Model(&User{}).Where("id = ?", id).Count(&count)
	return count > 0
}

func FindAllUsers() ([]User, error) {
	var users []User
	err := DB.Find(&users).Error
	return users, err
}

func CountUsersByEmail(email string) (int64, error) {
	var count int64
	err := DB.Model(&User{}).Where("email = ?", email).Count(&count).Error
	return count, err
}

func CountUsersByUsername(username string) (int64, error) {
	var count int64
	err := DB.Model(&User{}).Where("username = ?", username).Count(&count).Error
	return count, err
}

func (u *User) IsRole(role string) bool {
	for _, r := range u.Roles {
		if r == role {
			return true
		}
	}
	return false
}

func (u *User) HashPassword() error {
	bytes, err := bcrypt.GenerateFromPassword([]byte(u.Password), 10)
	if err != nil {
		return err
	}

	u.Password = string(bytes)

	return nil
}

func (u *User) ComparePassword(password string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(password))
	return err == nil
}

func (u *User) FindOneById(id int) error {
	return DB.First(&u, id).Error
}

func (u *User) FindOne(key string, value any) error {
	return DB.Where(key+" = ?", value).First(&u).Error
}

func (u *User) Delete() error {
	return DB.Delete(&u).Error
}

func (u *User) Save() error {
	return DB.Save(&u).Error
}
