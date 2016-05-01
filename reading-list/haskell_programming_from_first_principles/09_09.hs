module Thing where
import Data.Bool

-- Intermission: Exercises

-- As always, we encourage you to try figuring out the answers before you enter
-- them into your REPL.

-- 1. Will the following expression return a value or be ⊥? take 1 $ map (+1)
-- [undefined, 2, 3]

-- ⊥

-- 2. Will the following expression return a value?
-- take 1 $ map (+1) [1, undefined, 3]

-- yes

-- 3. take 2 $ map (+1) [1, undefined, 3]

-- no

-- 4. What does the following mystery function do? What is its type? Describe it
-- (to yourself or a loved one) in standard English and then test it out in the
-- REPL to make sure you were correct.
itIsMystery :: [Char] -> [Bool]
itIsMystery xs = map (\x -> elem x "aeiou") xs

-- it returns a list of booleans where each boolean represents whether or not
-- that index in the original string was a vowel or not.

-- 5. What will be the result of the following functions:

-- a) map (^2) [1..10]

-- [1,4,9,16,25,36,49,64,81,100]

-- b) map minimum [[1..10], [10..20], [20..30]] -- n.b. `minimum` is not the
-- same function -- as the `min` that we used before

-- [1,10,20]

-- c) map sum [[1..5], [1..5], [1..5]]

-- [15,15,15]

-- 6. Back in the Functions chapter, you wrote a function called foldBool. That
-- function exists in a module known as Data.Bool and is called bool. Write a
-- function that does the same (or similar, if you wish) as the map
-- (if-then-else) function you saw above but uses bool instead of the
-- if-then-else syntax. Your first step should be bringing the bool function
-- into scope by typing import Data.Bool at your Prelude prompt.

myFun = map (\x -> if x == 3 then (-x) else (x)) [1..10]

myFun' = map (\x -> bool x (-x) $ x==3) [1..10]
