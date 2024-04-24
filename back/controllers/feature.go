package controllers

import (
	"challenge/models"
	_ "challenge/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
)

// GetUsers godoc
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
	var feature models.Feature

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := feature.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Feature not found"})
		return
	}

	c.JSON(http.StatusOK, feature)
}

// GetUsers godoc
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
	var data models.CreateFeatureDto

	if err := c.BindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CountFeatureByName(data.Name); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Feature already exists"})
		return
	}

	validate := validator.New()
	if err := validate.Struct(data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	feature.Name = data.Name
	feature.Description = data.Description
	feature.Active = false

	if err := feature.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, feature)
}

// GetUsers godoc
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
	var feature models.Feature
	var data models.UpdateFeatureDto

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := feature.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Feature not found"})
		return
	}

	if err := c.BindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if count, err := models.CountFeatureByName(data.Name); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Feature already exists"})
		return
	}

	if data.Name != "" {
		feature.Name = data.Name
	}
	if data.Description != "" {
		feature.Description = data.Description
	}

	if err := feature.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, feature)
}

// GetUsers godoc
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
	var feature models.Feature

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := feature.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Feature not found"})
		return
	}

	if err := feature.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, gin.H{})
}

// GetUsers godoc
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
	var feature models.Feature

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := feature.FindOneById(id); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Feature not found"})
		return
	}

	feature.Toggle()

	if err := feature.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, feature)
}
