package models

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func createSampleFeatureData() Feature {
	feature := Feature{
		ID:          1,
		Name:        fake.Lorem().Word(),
		Description: fake.Lorem().Sentence(5),
		Active:      true,
	}

	DB.Create(&feature)

	return feature
}

func TestFindAllFeature(t *testing.T) {
	setup()
	defer close()
	_ = createSampleFeatureData()

	features, err := FindAllFeature()

	assert.Nil(t, err)
	assert.Equal(t, 1, len(features))
}

func TestCountFeatureByName(t *testing.T) {
	setup()
	defer close()
	feature := createSampleFeatureData()

	count, err := CountFeatureByName(feature.Name)

	assert.Nil(t, err)
	assert.Equal(t, int64(1), count)
}

func TestToggleFeature(t *testing.T) {
	setup()
	defer close()
	feature := createSampleFeatureData()

	feature.Toggle()

	assert.False(t, feature.Active)
}

func TestFindOneFeatureByID(t *testing.T) {
	setup()
	defer close()
	feature := createSampleFeatureData()

	var foundFeature Feature
	err := foundFeature.FindOneById(feature.ID)

	assert.Nil(t, err)
	assert.Equal(t, feature.ID, foundFeature.ID)
}

func TestFindOneFeature(t *testing.T) {
	setup()
	defer close()
	feature := createSampleFeatureData()

	var foundFeature Feature
	err := foundFeature.FindOne("name", feature.Name)

	assert.Nil(t, err)
	assert.Equal(t, feature.Name, foundFeature.Name)
}

func TestSaveFeature(t *testing.T) {
	setup()
	defer close()
	feature := createSampleFeatureData()
	feature.Name = "Updated Feature"

	err := feature.Save()

	assert.Nil(t, err)
	assert.Equal(t, "Updated Feature", feature.Name)
}

func TestDeleteFeature(t *testing.T) {
	setup()
	defer close()
	feature := createSampleFeatureData()

	err := feature.Delete()

	assert.Nil(t, err)
	var count int64
	DB.Model(&Feature{}).Count(&count)
	assert.Equal(t, int64(0), count)
}

func TestClearFeature(t *testing.T) {
	setup()
	defer close()
	_ = createSampleFeatureData()

	err := ClearFeature()

	assert.Nil(t, err)
	var count int64
	DB.Model(&Feature{}).Count(&count)
	assert.Equal(t, int64(0), count)
}
