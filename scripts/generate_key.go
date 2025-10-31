package main

import (
	"fmt"

	"beacon-go-server/pkg/auth"
)

func main() {
	fmt.Println(auth.GenerateRandomKey())
}
