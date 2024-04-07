package models

import "time"

type User struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	Firstname string    `json:"name"`
	Lastname  string    `json:"last_name"`
	Username  string    `json:"username"`
	Email     string    `json:"email"`
	Password  string    `json:"password"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func FindAllUsers() ([]User, error) {
	var users []User
	err := DB.Find(&users).Error
	return users, err
}

func FindUserById(id uint) (User, error) {
	var user User
	err := DB.First(&user, id).Error
	return user, err
}

func CreateUser(user *User) error {
	err := DB.Create(&user).Error
	return err
}

func (u *User) UpdateUser(user *User) error {
	err := DB.Model(&u).Updates(&user).Error
	return err
}

func (u *User) DeleteUser() error {
	err := DB.Delete(&u).Error
	return err
}
