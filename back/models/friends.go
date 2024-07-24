package models

import (
	"time"
)

// Friend représente la relation d'amitié entre deux utilisateurs
type Friend struct {
	ID        int       `gorm:"primary_key" json:"id"`
	UserID    int       `json:"user_id"`
	FriendID  int       `json:"friend_id"`
	Favorite  bool      `json:"favorite"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// CreateFriend crée une nouvelle relation d'amitié entre deux utilisateurs
func CreateFriend(userID, friendID int, favorite bool) (*Friend, error) {
	friend := &Friend{
		UserID:   userID,
		FriendID: friendID,
		Favorite: favorite,
	}

	if err := DB.Create(friend).Error; err != nil {
		return nil, err
	}

	return friend, nil
}

// DeleteFriend supprime une relation d'amitié entre deux utilisateurs
func DeleteFriend(userID, friendID int) error {
	var friend Friend
	if err := DB.Where("user_id = ? AND friend_id = ?", userID, friendID).First(&friend).Error; err != nil {
		return err
	}

	if err := DB.Delete(&friend).Error; err != nil {
		return err
	}

	return nil
}

// GetFriendsByUserID récupère la liste d'amis d'un utilisateur donné
func GetFriendsByUserID(userID int) (map[string][]*User, error) {
	var friends []*Friend
	if err := DB.Where("user_id = ?", userID).Find(&friends).Error; err != nil {
		return nil, err
	}

	var friendIDs []int
	var favoriteFriendIDs []int
	for _, friend := range friends {
		if friend.Favorite {
			favoriteFriendIDs = append(favoriteFriendIDs, friend.FriendID)
		} else {
			friendIDs = append(friendIDs, friend.FriendID)
		}
	}

	var users []*User
	if err := DB.Where("id IN (?)", friendIDs).Find(&users).Error; err != nil {
		return nil, err
	}

	var favoriteUsers []*User
	if err := DB.Where("id IN (?)", favoriteFriendIDs).Find(&favoriteUsers).Error; err != nil {
		return nil, err
	}

	return map[string][]*User{
		"friends":   users,
		"favorites": favoriteUsers,
	}, nil
}

func ClearFriends() interface{} {
	return DB.Exec("DELETE FROM friends")
}

func IsFriend(id int, id2 int) bool {
	var friend Friend
	if err := DB.Where("user_id = ? AND friend_id = ?", id, id2).First(&friend).Error; err != nil {
		return false
	}

	return true
}

func UpdateFriend(userID, friendID int, favorite bool) error {
	var friend Friend
	if err := DB.Where("user_id = ? AND friend_id = ?", userID, friendID).First(&friend).Error; err != nil {
		return err
	}

	friend.Favorite = favorite

	if err := DB.Save(&friend).Error; err != nil {
		return err
	}

	return nil
}
