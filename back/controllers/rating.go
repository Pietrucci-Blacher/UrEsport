// rating_controller.go
package controllers

import (
	"challenge/models"
	"challenge/services"
	"errors"
	"log"
	"net/http"
	"strconv"

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
		models.ErrorLogf([]string{"rating", "GetRatings"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"rating", "GetRatings"}, "Fetched %d ratings", len(ratings))
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
//	@Router			/rating/ [get]
func GetRating(c *gin.Context) {
	tournamentIDStr := c.Query("tournament_id")
	userIDStr := c.Query("user_id")

	// Convert the string parameters to uint
	tournamentID, err := strconv.ParseUint(tournamentIDStr, 10, 32)
	if err != nil {
		models.ErrorLogf([]string{"rating", "GetRating"}, "Invalid tournament_id: %s", err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid tournament_id"})
		return
	}

	userID, err := strconv.ParseUint(userIDStr, 10, 32)
	if err != nil {
		models.ErrorLogf([]string{"rating", "GetRating"}, "Invalid user_id: %s", err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user_id"})
		return
	}

	// Find rating by tournamentId and userId
	var rating models.Rating
	if err := models.FindRatingByTournamentAndUser(uint(tournamentID), uint(userID), &rating); err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			models.ErrorLogf([]string{"rating", "GetRating"}, "Rating not found")
			c.JSON(http.StatusNotFound, gin.H{"error": "Rating not found"})
			return
		}

		models.ErrorLogf([]string{"rating", "GetRating"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"rating", "GetRating"}, "Fetched rating for tournament %d and user %d", tournamentID, userID)
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
			models.ErrorLogf([]string{"rating", "GetRatingById"}, "Rating not found")
			c.JSON(http.StatusNotFound, gin.H{"error": "Rating not found"})
			return
		}
		models.ErrorLogf([]string{"rating", "GetRatingById"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"rating", "GetRatingById"}, "Fetched rating %d", rating.ID)
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
		models.ErrorLogf([]string{"rating", "CreateRating"}, "Rating already exists for this user and tournament")
		c.JSON(http.StatusBadRequest, gin.H{"error": "Rating already exists for this user and tournament"})
		return
	}

	rating = models.Rating{
		TournamentID: body.TournamentID,
		UserID:       body.UserID,
		Rating:       body.Rating,
	}

	if err := rating.Save(); err != nil {
		models.ErrorLogf([]string{"rating", "CreateRating"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"rating", "CreateRating"}, "Rating created")
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
		models.ErrorLogf([]string{"rating", "UpdateRating"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"rating", "UpdateRating"}, "Rating %d updated", rating.ID)
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
		models.ErrorLogf([]string{"rating", "DeleteRating"}, "%s", err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	models.PrintLogf([]string{"rating", "DeleteRating"}, "Rating %d deleted", rating.ID)
	c.Status(http.StatusNoContent)
}
