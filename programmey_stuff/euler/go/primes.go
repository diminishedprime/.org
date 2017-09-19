package main

import "fmt"

type Primes struct {
	sieve             []bool
	primes            []int
	primeFactorsCache map[int]map[int]int
}

func initSieve(n int) (sieve []bool, primes []int) {
	sieve = make([]bool, n+1)
	primes = []int{}
	sieve[0] = true
	sieve[1] = true
	for i := 0; i <= n; i++ {
		if sieve[i] == false {
			primes = append(primes, i)
			for j := i + i; j <= n; j += i {
				sieve[j] = true
			}
		}
	}
	return
}

func (p *Primes) isPrime(n int) bool {
	p.ensureSize(n)
	return !p.sieve[n]
}

func (p *Primes) ensureSize(n int) {
	if (len(p.sieve) - 1) < n {
		sieve, primes := initSieve(n)
		p.sieve = sieve
		p.primes = primes
	}
}

func (p *Primes) primeFactors(n int) map[int]int {
	if result, ok := p.primeFactorsCache[n]; ok {
		return result
	} else {
		p.ensureSize(n)

		otherFactors := map[int]int{}
		factor := 0
		for _, prime := range p.primes {
			if n%prime == 0 {
				otherFactors = p.primeFactors(n / prime)
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
		p.primeFactorsCache[n] = factors
		return factors
	}
}

var primes Primes = Primes{
	sieve:             []bool{},
	primes:            []int{},
	primeFactorsCache: map[int]map[int]int{},
}

func main() {
	currentFactors := primes.primeFactors(12345)
	currentFactors = primes.primeFactors(12345)
	fmt.Println(currentFactors)
}
