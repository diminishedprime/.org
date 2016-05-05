-- Warm-up and review

-- For the following set of exercises, you are not expected to use folds. These
-- are intended to review material from previous chapters. Feel free to use any
-- syntax or structure from previous chapters that seems appropriate.

-- 1. Given the following sets of consonants and vowels:
stops  = "pbtdkg"
vowels = "aeiou"

-- a) Write a function that takes inputs from stops and vowels and makes
-- 3-tuples of all possible stop-vowel-stop combinations. These will not all
-- correspond to real words in English, although the stop-vowel-stop pattern is
-- common enough that many of them will.
combos = [(a,b,c)
         | a <- stops,
           b <- vowels,
           c <- stops]

-- b) Modify that function so that it only returns the combinations that begin
-- with a p.
combos2 = [(a,b,c)
          | a <- stops,
            b <- vowels,
            c <- stops,
            a == 'p']

-- c) Now set up lists of nouns and verbs (instead of stops and vowels) and
-- modify the function to make tuples representing possible noun-verb-noun
-- sentences.
combos3 = [(a,b,c)
          | a <- nouns,
            b <- verbs,
            c <- nouns]
  where nouns = ["person", "place", "puppy"]
        verbs = ["run", "sleep", "punch"]

-- 2. What does the following mystery function do? What is its type? Try to get
-- a good sense of what it does before you test it in the REPL to verify it.
seekritFunc x = div (sum (map length (words x))) (length (words x))

-- this gives a crappy average of the length of each word that throws away the
-- remainer.

-- 3. We’d really like the answer to be more precise. Can you rewrite that using
-- fractional division?
seekritFuncDouble x = (/) (fromIntegral (sum (map length (words x)))) (fromIntegral (length (words x)))

-- Rewriting functions using folds

-- In the previous chapter, you wrote these functions using direct recur- sion
-- over lists. The goal now is to rewrite them using folds. Where possible, to
-- gain a deeper understanding of folding, try rewriting the fold version so
-- that it is point-free.

-- The goal here is to converge on the final version where possible. You don’t
-- need to write all variations for each example, but the more variations you
-- write, the deeper your understanding of these functions will become.

-- 1. myOr returns True if any Bool in the list is True.
myOr :: [Bool] -> Bool
myOr [] = False
myOr (x:xs) = x || myOr xs

myOrFold :: [Bool] -> Bool
myOrFold = foldr (||) False

-- 2. myAny returns True if a -> Bool applied to any of the values in the list
-- returns True.
myAny :: (a -> Bool) -> [a] -> Bool
myAny _ [] = False
myAny f (x:xs) = f x || myAny f xs

myAnyFold :: (a -> Bool) -> [a] -> Bool
myAnyFold f = foldr (\x y -> f x || y) False

-- 3. In addition to the recursive and fold based myElem, write a version that
-- uses any.
myElem :: Eq a => a -> [a] -> Bool
myElem _ [] = False
myElem a (x:xs) = x == a || myElem a xs

myElemFold :: Eq a => a -> [a] -> Bool
myElemFold a = foldr (\x y -> x == a || y) False

myElemAny :: Eq a => a -> [a] -> Bool
myElemAny a = myAnyFold (==a)

-- 4. ImplementmyReverse,don’t worry about trying to make it lazy.
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

myReverseFold :: [a] -> [a]
myReverseFold = foldr (\x y -> y ++ [x]) []

-- 5. Write myMap in terms of foldr. It should have the same behavior as the
-- built-in map.
myMap :: (a -> b) -> [a] -> [b]
myMap f = foldr (\x y -> f x : y) []

-- 6. Write myFilter in terms of foldr. It should have the same behavior as the
-- built-in filter.
myFilter :: (a -> Bool) -> [a] -> [a]
myFilter f = foldr (\x y -> case f x of
                                   True -> x : y
                                   False -> y) []

-- 7. squish flattens a list of lists into a list
squish :: [[a]] -> [a]
squish = foldr (++) []

-- 8. squishMap maps a function over a list and concatenates the results.
squishMap :: (a -> [b]) -> [a] -> [b]
squishMap f = foldr (\x y -> f x ++ y) []

-- 9. squishAgain flattens a list of lists into a list. This time re-use the
-- squishMap function.
squishAgain :: [[a]] -> [a]
squishAgain = squishMap id

-- 10. myMaximumBy takes a comparison function and a list and returns the
-- greatest element of the list based on the last value that the comparison
-- returned GT for.
myMaximumBy :: (a -> a -> Ordering) -> [a] -> a
myMaximumBy f (x:xs) = foldr (\x y -> case f x y of
                                        LT -> y
                                        _ -> x) x xs
-- 11. myMinimumBy takes a comparison function and a list and returns the least
-- element of the list based on the last value that the com- parison returned LT
-- for.
myMinimumBy :: (a -> a -> Ordering) -> [a] -> a
myMinimumBy f (x:xs) = foldr (\x y -> case f x y of
                                 LT -> x
                                 _ -> y) x xs
