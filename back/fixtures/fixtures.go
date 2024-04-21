package fixtures

func ImportFixtures() error {
	if err := LoadUsers(); err != nil {
		return err
	}
	return nil
}
