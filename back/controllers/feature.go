package controllers

import (
	"challenge/models"
	"strconv"

	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
)

func GetFeatures(c *gin.Context) {
	feature, err := models.FindAllFeature()
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, feature)
}

func GetFeature(c *gin.Context) {
	var feature models.Feature

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if err := feature.FindOneById(id); err != nil {
		c.JSON(404, gin.H{"error": "Feature not found"})
		return
	}

	c.JSON(200, feature)
}

func CreateFeature(c *gin.Context) {
	var feature models.Feature
	var data models.CreateFeatureDto

	if err := c.BindJSON(&data); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CoutFeatureByName(data.Name); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Feature already exists"})
		return
	}

	validate := validator.New()
	if err := validate.Struct(data); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	feature.Name = data.Name
	feature.Description = data.Description
	feature.Active = false

	if err := feature.Save(); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	c.JSON(201, feature)
}

func UpdateFeature(c *gin.Context) {
	var feature models.Feature
	var data models.UpdateFeatureDto

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if err := feature.FindOneById(id); err != nil {
		c.JSON(404, gin.H{"error": "Feature not found"})
		return
	}

	if err := c.BindJSON(&data); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CoutFeatureByName(data.Name); err != nil || count > 0 {
		c.JSON(400, gin.H{"error": "Feature already exists"})
		return
	}

	if data.Name != "" {
		feature.Name = data.Name
	}
	if data.Description != "" {
		feature.Description = data.Description
	}

	if err := feature.Save(); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, feature)
}

func DeleteFeature(c *gin.Context) {
	var feature models.Feature

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if err := feature.FindOneById(id); err != nil {
		c.JSON(404, gin.H{"error": "Feature not found"})
		return
	}

	if err := feature.Delete(); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	c.JSON(204, gin.H{})
}

func ToggleFeature(c *gin.Context) {
	var feature models.Feature

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	if err := feature.FindOneById(id); err != nil {
		c.JSON(404, gin.H{"error": "Feature not found"})
		return
	}

	feature.Toggle()

	if err := feature.Save(); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, feature)
}
