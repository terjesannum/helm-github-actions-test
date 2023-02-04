package main

import "fmt"

var (
	version string
)

func main() {
	if version == "" {
		version = "n/a"
	}
	fmt.Printf("Hello %s\n", version)
}
