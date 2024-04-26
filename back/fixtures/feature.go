package fixtures

import (
	"challenge/models"
	"fmt"
)

func LoadFeatures() error {
	for name, desc := range FEATURES {
		feature := models.Feature{
			Name:        name,
			Description: desc,
			Active:      true,
		}

		if err := feature.Save(); err != nil {
			return err
		}

		fmt.Printf("Feature %s created\n", feature.Name)
	}
	return nil
}
