package middlewares

import (
	"challenge/models"
	"challenge/services"
	"challenge/utils"
	"errors"
	"io"
	"mime/multipart"
	"net/http"
	"reflect"
	"strconv"

	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
)

func Validate[T any]() gin.HandlerFunc {
	return func(c *gin.Context) {
		var body T

		if err := c.BindJSON(&body); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		validate := validator.New()
		if err := validate.Struct(body); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		c.Set("body", body)
	}
}

func Get[T models.Model](name string) gin.HandlerFunc {
	return func(c *gin.Context) {
		var model T
		var err error

		id, err := strconv.Atoi(c.Param(name))
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Bad Request"})
			c.Abort()
			return
		}

		instance := reflect.New(reflect.TypeOf(model).Elem()).Interface().(models.Model)
		if instance.FindOneById(id) != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Not Found"})
			c.Abort()
			return
		}

		c.Set(name, instance)
		c.Next()
	}
}

func FileUploader(availableType []string, size int) gin.HandlerFunc {
	return func(c *gin.Context) {
		var fileUrls []string

		form, err := c.MultipartForm()
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		files := form.File["upload[]"]

		// TODO: improve by using goroutine
		for _, file := range files {
			url, err := uploadFile(file, availableType, size)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				c.Abort()
				return
			}

			fileUrls = append(fileUrls, url)
		}

		if len(fileUrls) == 0 {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to upload file"})
			c.Abort()
			return
		}

		c.Set("files", fileUrls)
	}
}

func uploadFile(file *multipart.FileHeader, availableType []string, size int) (string, error) {
	src, err := file.Open()
	if err != nil {
		return "", err
	}
	defer src.Close()

	buf, err := io.ReadAll(src)
	if err != nil {
		return "", err
	}

	if len(buf) > size {
		return "", errors.New("File size is too large")
	}

	if !utils.IsFileType(buf, availableType) {
		return "", errors.New("Invalid file type")
	}

	return services.UploadFile(file)
}
