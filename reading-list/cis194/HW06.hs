--Example 1
fib :: Integer -> Integer
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

fibs :: [Integer]
fibs = map fib [0..]

fib2 :: Integer -> Integer
fib2 n = helper n 1 1
  where helper 0 previous current = current
        helper n previous current = let next = previous + current
                                        current = current
                                    in helper (n - 1) current next
