function ends_in_3(num)
  return string.sub(string.reverse(num), 1, 1) == '3'
end
print(ends_in_3(13))
print(ends_in_3(31))

function is_prime(num)
  if num == 1 then return false end
  if num == 2 then return true end
  for i = 2, num - 1 do
    if num % i == 0 then return false
    else
      return true
    end
  end
end

print('Is 13 prime?')
print(is_prime(13))

print('Is 2 prime?')
print(is_prime(2))

print('Is 3 prime?')
print(is_prime(3))

print('Is 18 prime?')
print(is_prime(18))

function first_n_primes_ending_in_3(n)
  count = 0
  currentNumber = 3
  while count < n do
    if ends_in_3(currentNumber) and is_prime(currentNumber) then
      print(currentNumber)
      count = count + 1
    end
    currentNumber = currentNumber + 1
  end
end

print('First 10 primes ending in 3:')
first_n_primes_ending_in_3(10)


function for_loop(a, b, f)
  while a <= b do
    f(a)
    a = a + 1
  end
end

print()
print('For loop as a function')
for_loop(1, 3, function(num) print(num) end)


function reduce(max, init, f)
  acc = init
  for i = 1, max do
    acc = f(acc, i)
  end
  return acc
end

function add(previous, next)
  return previous + next
end

print()
print('Did reduce for great profit')
print(reduce(5, 0, add))

function factorial(n)
  return reduce(n, 1, function(acc, n) return acc * n end)
end

print()
print('Did factorial with reduce also for great profit')
print(factorial(10))
