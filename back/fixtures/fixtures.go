package fixtures

func ImportFixtures() error {
	_, err := LoadUsers()
	if err != nil {
		return err
	}
	return nil
}
