package main

import "fmt"
import "strconv"

func isPalindrome(n int) bool {
	str := strconv.Itoa(n)
	strlen := len(str)
	middle := strlen / 2
	for i := 0; i <= middle; i++ {
		if str[i] != str[strlen-i-1] {
			return false
		}
	}
	return true
}

func main() {
	var largest int
outer:
	for i := 999; i >= 100; i-- {
		for j := i; j <= i; j-- {
			product := i * j
			if product > largest {
				if isPalindrome(product) {
					largest = product
				}
			} else {
				continue outer
			}
		}
	}
	fmt.Println(largest)
}
