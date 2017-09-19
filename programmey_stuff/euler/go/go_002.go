package main

import (
	"fmt"
)

func main() {
	a := 5
	b := 8
	sum := 2
	for b < 4000000 {
		// After 2, every 3 terms are even
		sum += b
		b, a = b+a, b
		b, a = b+a, b
		b, a = b+a, b
	}
	fmt.Println(sum)
}
