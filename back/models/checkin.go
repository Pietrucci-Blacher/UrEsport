package models

import (
	"fmt"
	"math/rand"
	"time"
)

func initRandomGenerator() *rand.Rand {
	return rand.New(rand.NewSource(time.Now().UnixNano()))
}

func generateCode() int {
	generator := initRandomGenerator()
	return generator.Intn(9000) + 1000
}

func main() {
	fmt.Println(generateCode())
}
