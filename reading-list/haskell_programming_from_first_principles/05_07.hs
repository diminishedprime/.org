module TypeInference1 where

f :: Num a => a -> a -> a
f x y = x + y + 3

g x y = x + y + 3

-- Intermission: Exercises

-- Look at these pairs of functions. One function is unapplied, so the compiler
-- will infer maximally polymorphic type. The second func- tion has been applied
-- to a value, so the inferred type signature may have become concrete, or at
-- least less polymorphic. Figure out how the type would change and why, make a
-- note of what you think the new inferred type would be and then check your
-- work in GHCi.

-- 1. -- Type signature of general function (++) :: [a] -> [a] -> [a] How might
-- that change when we apply it to the following value?
myConcat x = x ++ " yo"
myConcat :: [Char] -> [Char]

-- 2. -- General function
-- (*) :: Num a => a -> a -> a
--     Applied to a value
myMult x = (x / 3) * 5
myMult :: (Fractional a) => a -> a

-- 3. take :: Int -> [a] -> [a]
myTake x = take x "hey you"
myTake ::

-- 4. (>) :: Ord a => a -> a -> Bool
myCom x = x > (length [1..10])
-- 5. (<) :: Ord a => a -> a -> Bool
myAlph x = x < 'z'
