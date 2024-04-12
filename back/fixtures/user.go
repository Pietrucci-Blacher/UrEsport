package fixtures

import (
	"challenge/models"
	"github.com/bxcodec/faker/v3"
	"golang.org/x/crypto/bcrypt"
	"math/rand"
	"strings"
	"time"
)

func LoadUsers() error {
	if err := models.ClearUsers(); err != nil {
		return err
	}
	for i := 0; i < 20; i++ {
		firstname := faker.FirstName()
		lastname := faker.LastName()

		// Création du username à partir du nom et du prénom
		username := strings.ToLower(strings.ReplaceAll(firstname+"."+lastname, " ", ""))

		// Création de l'email à partir du nom et du prénom
		email := strings.ToLower(strings.ReplaceAll(firstname+"."+lastname+"@gmail.com", " ", ""))

		password := faker.Password()
		roles := []string{"user", "admin"} // Rôles possibles

		// Choix aléatoire du rôle
		role := roles[rand.Intn(len(roles))]

		user := models.User{
			Firstname: firstname,
			Lastname:  lastname,
			Username:  username,
			Email:     email,
			Password:  password,
			Roles:     []string{role},
			CreatedAt: time.Now(),
			UpdatedAt: time.Now(),
		}

		// Hachage du mot de passe
		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
		if err != nil {
			return err
		}
		user.Password = string(hashedPassword)

		if err := user.Save(); err != nil {
			return err
		}
	}
	return nil
}
