-- Exercise 1
toDigits :: Integer -> [Integer]
toDigits 0 = []
toDigits n = toDigits (n `div` 10) ++ [n `mod` 10]

toDigitsRev :: Integer -> [Integer]
toDigitsRev 0 = []
toDigitsRev n = [n `mod` 10] ++ toDigitsRev (n `div` 10) 

--Exercise 2
doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther 

reverse' :: [Integer] -> [Integer]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]
