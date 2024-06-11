package middlewares

import (
	"challenge/services"
	"challenge/utils"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"

	"github.com/gin-gonic/gin"
)

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
		return "", fmt.Errorf("File size is too large, maximum %s", utils.FormatSize(size))
	}

	if !utils.IsFileType(buf, availableType) {
		return "", fmt.Errorf("File type is not allowed, only %v are accepted", availableType)
	}

	return services.UploadFile(file)
}
