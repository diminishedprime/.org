package main

import "fmt"
import "math"

type PrimeSieve struct {
	data   []bool
	primes []int
}

func (p *PrimeSieve) isPrime(n int) bool {
	return !p.data[n]
}

func initSieve(n int) PrimeSieve {
	data := make([]bool, n+1)
	primes := []int{}
	data[0] = true
	data[1] = true
	for i := 0; i <= n; i++ {
		if data[i] == false {
			primes = append(primes, i)
			for j := i + i; j <= n; j += i {
				data[j] = true
			}
		}
	}
	return PrimeSieve{data, primes}
}

var sieve PrimeSieve = initSieve(20)

var cache map[int]map[int]int = map[int]map[int]int{
	1: make(map[int]int),
}

func primeFactors(n int) map[int]int {
	if res, ok := cache[n]; ok {
		return res
	}
	otherFactors := map[int]int{}
	factor := 0
	for _, prime := range sieve.primes {
		if n%prime == 0 {
			otherFactors = primeFactors(n / prime)
			factor = prime
			break
		}
	}
	factors := map[int]int{}
	if factor != 0 {
		for key, value := range otherFactors {
			factors[key] = value
		}
		factors[factor]++
	}
	cache[n] = factors
	return factors
}
func main() {
	currentFactors := map[int]int{}
	for i := 2; i <= 20; i++ {
		factors := primeFactors(i)
		for key, value := range factors {
			if currentFactors[key] < value {
				currentFactors[key] = value
			}
		}
	}
	fmt.Println(currentFactors)
	result := 1
	for key, value := range currentFactors {
		result *= int(math.Pow(float64(key), float64(value)))
	}
	fmt.Println(result)
}
