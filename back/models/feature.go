package models

import "time"

type Feature struct {
	ID          int       `json:"id" gorm:"primaryKey"`
	Name        string    `json:"name" gorm:"type:varchar(30)"`
	Description string    `json:"description"`
	Active      bool      `json:"active"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type CreateFeatureDto struct {
	Name        string `json:"name" validate:"required"`
	Description string `json:"description" validate:"required"`
}

type UpdateFeatureDto struct {
	Name        string `json:"name"`
	Description string `json:"description"`
}

func FindAllFeature() ([]Feature, error) {
	var features []Feature
	err := DB.Find(&features).Error
	return features, err
}

func CountFeatureByName(name string) (int64, error) {
	var count int64
	err := DB.Model(&Feature{}).Where("name = ?", name).Count(&count).Error
	return count, err
}

func (f *Feature) Toggle() {
	f.Active = !f.Active
}

func (f *Feature) FindOneById(id int) error {
	return DB.First(&f, id).Error
}

func (f *Feature) FindOne(key string, value any) error {
	return DB.Where(key+" = ?", value).First(&f).Error
}

func (f *Feature) Delete() error {
	return DB.Delete(&f).Error
}

func (f *Feature) Save() error {
	return DB.Save(&f).Error
}
