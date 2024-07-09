// rating_controller.go
package controllers

import (
	"challenge/models"
	"challenge/services"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// GetRatings godoc
//
//	@Summary		get all ratings
//	@Description	get all ratings
//	@Tags			rating
//	@Accept			json
//	@Produce		json
//	@Success		200	{object}	[]models.Rating
//	@Failure		500	{object}	utils.HttpError
//	@Router			/ratings/ [get]
func GetRatings(c *gin.Context) {
	query, _ := c.MustGet("query").(services.QueryFilter)

	ratings, err := models.FindAllRatings(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, ratings)
}

// GetRating godoc
//
//	@Summary		get rating by tournament ID and user ID
//	@Description	get rating by tournament ID and user ID
//	@Tags			rating
//	@Accept			json
//	@Produce		json
//	@Param			rating	body		models.CreateRatingDto	true	"Rating object"
//	@Success		200		{object}	models.Rating
//	@Failure		400		{object}	utils.HttpError	"Bad request"
//	@Failure		404		{object}	utils.HttpError	"Not found"
//	@Failure		500		{object}	utils.HttpError	"Internal server error"
//	@Router			/rating/ [post]
func GetRating(c *gin.Context) {
	input, _ := c.MustGet("body").(models.CreateRatingDto)

	// Find rating by tournamentId and userId
	var rating models.Rating
	if err := models.FindRatingByTournamentAndUser(input.TournamentID, input.UserID, &rating); err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Rating not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, rating)
}

// GetRatingById godoc
//
//	@Summary		get ranking by id
//	@Description	get ranking by id
//	@Tags			rating
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Ranking ID"
//	@Success		200	{object}	models.Rating
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/ratings/{id} [get]
func GetRatingById(c *gin.Context) { // Correction du nom de la fonction
	id := c.Param("rating") // Correction ici pour utiliser le bon paramètre de route
	log.Printf("Rating ID from function: %s", id)
	var rating models.Rating
	if err := models.FindRatingById(id, &rating); err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Rating not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, rating)
}

// CreateRating godoc
//
//	@Summary		create a rating
//	@Description	create a rating
//	@Tags			rating
//	@Accept			json
//	@Produce		json
//	@Param			rating	body		models.CreateRatingDto	true	"Rating object"
//	@Success		201		{object}	models.Rating
//	@Failure		400		{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/ratings/ [post]
func CreateRating(c *gin.Context) {
	var rating models.Rating
	body, _ := c.MustGet("body").(models.CreateRatingDto)

	if count, err := models.CountRatingByUserAndTournament(body.UserID, body.TournamentID); err != nil || count > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Rating already exists for this user and tournament"})
		return
	}

	rating = models.Rating{
		TournamentID: body.TournamentID,
		UserID:       body.UserID,
		Rating:       body.Rating,
	}

	if err := rating.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, rating)
}

// UpdateRating godoc
//
//	@Summary		update a rating
//	@Description	update a rating
//	@Tags			rating
//	@Accept			json
//	@Produce		json
//	@Param			id		path		int						true	"Rating ID"
//	@Param			rating	body		models.UpdateRatingDto	true	"Rating object"
//	@Success		200		{object}	models.Rating
//	@Failure		400		{object}	utils.HttpError
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/ratings/{id} [patch]
func UpdateRating(c *gin.Context) {
	body, _ := c.MustGet("body").(models.UpdateRatingDto)
	rating, _ := c.MustGet("rating").(*models.Rating)

	rating.Rating = body.Rating

	if err := rating.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, rating)
}

// DeleteRating godoc
//
//	@Summary		delete a rating
//	@Description	delete a rating
//	@Tags			rating
//	@Accept			json
//	@Produce		json
//	@Param			id	path		int	true	"Rating ID"
//	@Success		204
//	@Failure		404	{object}	utils.HttpError
//	@Failure		500	{object}	utils.HttpError
//	@Router			/ratings/{id} [delete]
func DeleteRating(c *gin.Context) {
	rating, _ := c.MustGet("rating").(*models.Rating)

	if err := rating.Delete(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.Status(http.StatusNoContent)
}
