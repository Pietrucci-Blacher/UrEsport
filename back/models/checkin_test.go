package models

import (
	"testing"
)

func TestInitRandomGenerator(t *testing.T) {
	generator := initRandomGenerator()
	if generator == nil {
		t.Errorf("Failed to initialize random generator")
	}
}

func TestGenerateCode(t *testing.T) {
	code := generateCode()
	if code < 1000 || code > 9999 {
		t.Errorf("Generated code is out of range: got %v", code)
	} else {
		t.Logf("Generated code is within range: got %v", code)
	}
}
