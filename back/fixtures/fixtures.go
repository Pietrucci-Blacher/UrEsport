package fixtures

func ImportFixtures() error {
	err := LoadUsers()
	if err != nil {
		return err
	}
	return nil
}
