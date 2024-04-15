package models

type Tournament struct {
	ID           int    `json:"id" gorm:"primaryKey"`
	Name         string `json:"name" gorm:"type:varchar(100)"`
	Description  string `json:"description" gorm:"type:varchar(255)"`
	StartDate    string `json:"start_date"`
	EndDate      string `json:"end_date"`
	Location     string `json:"location" gorm:"type:varchar(100)"`
	OrganizerID  int    `json:"organizer" gorm:"foreignKey:ID"`
	Participants []User `json:"participants" gorm:"many2many:tournament_participants;"`
	Image        string `json:"image" gorm:"type:varchar(255)"`
	CreatedAt    string `json:"created_at"`
	UpdatedAt    string `json:"updated_at"`
}

func FindAllTournaments() ([]Tournament, error) {
	var tournaments []Tournament
	err := DB.Model(&Tournament{}).Preload("Participants").Find(&tournaments).Error
	return tournaments, err
}

func (t *Tournament) Save() error {
	return DB.Save(t).Error
}

func (t *Tournament) FindOneById(id int) error {
	return DB.Model(&Tournament{}).Preload("Participants").First(t, id).Error
}

func (t *Tournament) FindOne(key string, value any) error {
	return DB.Model(&Tournament{}).Preload("Participants").Where(key, value).First(t).Error
}

func (t *Tournament) Delete() error {
	return DB.Delete(t).Error
}
