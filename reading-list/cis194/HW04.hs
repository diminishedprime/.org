-- Exercise 1
fun1 :: [Integer] -> Integer
fun1 [] = 1
fun1 (x:xs)
  | even x = (x - 2) * fun1 xs
  | otherwise = fun1 xs

fun1' :: [Integer] -> Integer
fun1' = product . map (subtract 2) . filter even

fun2 :: Integer -> Integer
fun2 1 = 0
fun2 n
  | even n = n + fun2 (n `div` 2)
  | otherwise = fun2 (3 * n + 1)

fun2' :: Integer -> Integer
fun2' n = sum $ filter even $ takeWhile (/= 1) $ iterate step n

step :: Integer -> Integer
step n
  | even n = (div n 2)
  | otherwise =  (3 * n + 1)

-- Exercise 2
data Tree a = Leaf
            | Node Integer (Tree a) a (Tree a)
              deriving (Show, Eq)

-- I found this solution online, but it doesn't seem to actually work
-- correctly.

foldTree :: [a] -> Tree a
foldTree = foldr insertTree Leaf

insertTree :: a -> Tree a -> Tree a
insertTree elem Leaf = (Node 0 Leaf elem Leaf)
insertTree insertElem (Node depth l elem r)
  | hl < hr = Node hl (insertTree insertElem l) elem r
  | hl > hr = Node hr l elem r
  | otherwise = Node (hr2 + 1) l elem r2
  where
    hl = heightTree l
    hr = heightTree r
    r2 = insertTree insertElem r
    hr2 = heightTree r2

heightTree :: Tree a -> Integer
heightTree Leaf = 0
heightTree (Node depth _ _ _) = depth
              

-- Exercise 3

-- 1
xor :: [Bool] -> Bool
xor [True, False] = True
xor [False, True] = True
xor [_,_] = False
xor xs = foldr (\x y -> xor [x, y]) False xs
-- I personally like this solution without a fold much better, but
-- this isn't the point of the exercise

--xor = odd . length . filter (==True)

-- 2
map' :: (a -> b) -> [a] -> [b]
map' f = foldr (\x acc -> f x : acc) []

-- 3
-- Maybe do later.
