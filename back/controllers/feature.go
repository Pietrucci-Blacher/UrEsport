package controllers

import (
	"challenge/models"
	_ "challenge/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetUsers godoc
//
//	@Summary		get all features
//	@Description	get all features
//	@Tags			feature
//	@Accept			json
//	@Produce		json
//	@Success		200	{object}	[]models.Feature
//	@Failure		500	{object}	utils.HttpError
//	@Router			/features/ [get]
func GetFeatures(c *gin.Context) {
	feature, err := models.FindAllFeature()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, feature)
}

// GetUsers godoc
//
//	@Summary		get features by id
//	@Description	get features by id
//	@Tags			feature
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Feature ID"
//	@Success		200	{object}	models.Feature
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/features/{id} [get]
func GetFeature(c *gin.Context) {
	feature, _ := c.MustGet("feature").(models.Feature)
	c.JSON(http.StatusOK, feature)
}

// GetUsers godoc
//
//	@Summary		create features
//	@Description	create features
//	@Tags			feature
//	@Accept			json
//	@Produce		json
//	@Param			feature	body		models.CreateFeatureDto	true	"Feature"
//	@Success		201		{object}	models.Feature
//	@Failure		400		{object}	utils.HttpError
//	@Failure		401		{object}	utils.HttpError
//	@Failure		500		{object}	utils.HttpError
//	@Router			/features/ [post]
func CreateFeature(c *gin.Context) {
	var feature models.Feature

	body, _ := c.MustGet("body").(models.CreateFeatureDto)

	if count, err := models.CountFeatureByName(body.Name); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Feature already exists"})
		return
	}

	feature.Name = body.Name
	feature.Description = body.Description
	feature.Active = false

	if err := feature.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, feature)
}

// GetUsers godoc
//
//	@Summary		update features
//	@Description	update features
//	@Tags			feature
//	@Accept			json
//	@Produce		json
//	@Param			feature	body		models.UpdateFeatureDto	true	"Feature"
//	@Param			id		path		int						true	"Feature ID"
//	@Success		200		{object}	models.Feature
//	@Failure		400		{object}	utils.HttpError
//	@Failure		401		{object}	utils.HttpError
//	@Failure		404		{object}	utils.HttpError
//	@Failure		500		{object}	utils.HttpError
//	@Router			/features/{id} [patch]
func UpdateFeature(c *gin.Context) {
	body, _ := c.MustGet("body").(models.UpdateFeatureDto)
	feature, _ := c.MustGet("feature").(models.Feature)

	if count, err := models.CountFeatureByName(body.Name); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Feature already exists"})
		return
	}

	if body.Name != "" {
		feature.Name = body.Name
	}
	if body.Description != "" {
		feature.Description = body.Description
	}

	if err := feature.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, feature)
}

// GetUsers godoc
//
//	@Summary		delete features by id
//	@Description	delete features by id
//	@Tags			feature
//	@Accept			json
//	@Produce		json
//	@Param			id	path	int	true	"Feature ID"
//	@Success		204
//	@Failure		400	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/features/{id} [delete]
func DeleteFeature(c *gin.Context) {
	feature, _ := c.MustGet("feature").(models.Feature)

	if err := feature.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, gin.H{})
}

// GetUsers godoc
//
//	@Summary		toggle features by id
//	@Description	toggle features by id
//	@Tags			feature
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Feature ID"
//	@Success		200	{object}	models.Feature
//	@Failure		400	{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/features/{id}/toggle [get]
func ToggleFeature(c *gin.Context) {
	feature, _ := c.MustGet("feature").(models.Feature)

	feature.Toggle()

	if err := feature.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, feature)
}
