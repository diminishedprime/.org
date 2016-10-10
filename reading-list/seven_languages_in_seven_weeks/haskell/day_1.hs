myReverse :: [a] -> [a]
myReverse (a:[]) = [a]
myReverse (a:as) = myReverse as ++ [a]

myCombos = let colors = ["black", "white", "blue", "yellow", "red"]
           in [(a, b) | a <- colors, b <- colors, a < b]

multiples = let nums = [1..12]
            in [(x, y, x*y) | x <- nums, y <- nums, x <= y]
