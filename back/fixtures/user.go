package fixtures

import (
	"challenge/models"
	"math/rand"
	"strings"

	faker "github.com/jaswdr/faker/v2"
)

var fake = faker.New()

func LoadUsers() error {
	if err := models.ClearUsers(); err != nil {
		return err
	}
	for i := 0; i < 20; i++ { // Création d'une instance de faker
		firstname := fake.Person().FirstName()
		lastname := fake.Person().LastName()

		// Création du username à partir du nom et du prénom
		username := strings.ToLower(strings.ReplaceAll(firstname+"."+lastname, " ", ""))

		// Création de l'email à partir du nom et du prénom // Création d'une instance de Internet
		email := fake.Internet().Email() // Utilisation de l'instance pour générer un email

		password := fake.Internet().Password()
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
		}

		// Hachage du mot de passe
		if err := user.HashPassword(); err != nil {
			return err
		}

		if err := user.Save(); err != nil {
			return err
		}
	}
	return nil
}
