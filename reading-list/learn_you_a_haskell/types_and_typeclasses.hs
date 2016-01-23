main :: IO()
main = print "hello"

removeNonUppercase :: [Char] -> [Char]
removeNonUppercase st = [ c | c <- st, c `elem` ['A'..'Z']]

addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

addTwo x y = x + y

factorial :: Integer -> Integer
factorial n = product [1..n]
