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
	data := make([]bool, n)
	primes := []int{}
	data[0] = true
	data[1] = true
	for i := 0; i < n; i++ {
		if data[i] == false {
			primes = append(primes, i)
			for j := i + i; j < n; j += i {
				data[j] = true
			}
		}
	}
	return PrimeSieve{data, primes}
}

func main() {
	bigNum := 600851475143
	sieve := initSieve(int(math.Sqrt(float64(bigNum))))
	var prime int
	largest := 1
	for i := len(sieve.primes) - 1; i >= 0; i-- {
		prime = sieve.primes[i]
		if bigNum%prime == 0 {
			largest = prime
			break
		}
	}
	fmt.Println(largest)
}
