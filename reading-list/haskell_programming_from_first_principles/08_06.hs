module WordNumber where
import Data.List (intersperse)

-- Review of types

-- 1. What is the type of [[True, False], [True, True], [False, True]]?
--a) Bool
-- b) mostly True
-- c) [a]
-- d) [[Bool]]

-- d

-- 2. Which of the following has the same type as [[True, False], [True, True], [False, True]]?
-- a) [(True, False), (True, True), (False, True)]
-- b) [[3 == 3], [6 > 5], [3 < 4]]
-- c) [3 == 3, 6 > 5, 3 < 4]
-- d) ["Bool", "more Bool", "Booly Bool!"]

-- b

-- 3. For the following function
func :: [a] -> [a] -> [a]
func x y = x ++ y
-- which of the following is true?
-- a) x and y must be of the same type
-- b) x and y must both be lists
-- c) if x is a String then y must be a String
-- d) all of the above

-- d

-- 4. For the func code above, which is a valid application of func to both of its arguments?
-- a) func "Hello World"
-- b) func "Hello" "World"
-- c) func [1, 2, 3] "a, b, c"
-- d) func ["Hello", "World"]

-- b


-- Reviewing currying

--Given the following definitions, tell us what value results from further
--applications.
cattyConny :: String -> String -> String
cattyConny x y = x ++ " mrow " ++ y


-- fill in the types
flippy :: String -> String -> String
flippy = flip cattyConny

appedCatty :: String -> String
appedCatty = cattyConny "woops"

frappe :: String -> String
frappe = flippy "haha"

-- 1. What is the value of appedCatty "woohoo!" ? Try to determine the answer
-- for yourself, then test in the REPL.

-- "woops mrow woohoo!"

-- 2. frappe "1"

-- "1 mrow haha"

-- 3. frappe (appedCatty "2")

-- "woops mrow 2 mrow haha"

-- 4. appedCatty (frappe "blue")

-- "woops mrow blue mrow haha"

-- 5. cattyConny (frappe "pink") (cattyConny "green" (appedCatty "blue"))

-- "pink mrow haha mrow green mrow woops mrow blue"

-- 6. cattyConny (flippy "Pugs" "are") "awesome"

-- "are mrow Pugs mrow awesome"

-- Recursion

-- 1. Write out the steps for reducing dividedBy 15 2 to its final answer
-- according to the Haskell code.

-- nah

-- 2. Write a function that recursively sums all numbers from 1 to n, n being
-- the argument. So that if n was 5, you'd add 1+2+3+4+5 to get 15.
-- The type should be (Eq a, Num a) => a -> a.

triangleNum :: (Eq a, Num a) => a -> a
triangleNum n = go n 0
  where go iterations acc
          | iterations == 0 = acc
          | otherwise = go (iterations - 1) (acc + iterations)


-- 3. Write a function that multiplies two integral numbers using recursive
-- summation. The type should be (Integral a) => a -> a -> a.

multi :: (Integral a) => a -> a -> a
multi x y = go x 0
  where go iterations acc
          | iterations == 0 = acc
          | otherwise = go (iterations -1) (acc + y)

-- Fixing dividedBy

-- Our dividedBy function wasn’t quite ideal. For one thing. It was a partial
-- function and doesn’t return a result (bottom) when given a divisor that is 0
-- or less.

-- Using the pre-existing div function we can see how negative numbers should be
-- handled:

-- Prelude> div 10 2
-- 5
-- Prelude> div 10 (-2)
-- -5
-- Prelude> div (-10) (-2)
-- 5
-- Prelude> div (-10) (2)
-- -5

-- The next issue is how to handle zero. Zero is undefined for division in math,
-- so really we ought to use a datatype that lets us say there was no sensible
-- result when the user divides by zero. If you need inspiration, consider using
-- the following datatype to handle this.

data DividedResult = Result Integer |  DividedByZero deriving Show

dividedBy :: Integral a => a -> a -> DividedResult
dividedBy num denom = go (abs num) (abs denom) 0
  where go n d count
          | denom == 0 = DividedByZero
          | n < d = Result $ fixSign num denom $ count
          | otherwise = go (n - d) d (count + 1)
        fixSign a b
          | (a < 0) && (b < 0) ||
            (a > 0) && (b > 0) = id
          | otherwise = negate

-- McCarthy 91 function

-- We’re going to describe a function in English, then in math notation, then
-- show you what your function should return for some test inputs. Your task is
-- to write the function in Haskell.

-- The McCarthy 91 function yields 𝑥 − 10 when 𝑥 > 100 and 91 otherwise. The
-- function is recursive. 𝑀𝐶(𝑛) =  ⎧𝑛 − 10 if 𝑛 > 100
--                                 ⎨
--                                  ⎩𝑀𝐶(𝑀𝐶(𝑛 + 11)) if 𝑛 ≤ 100

mc91 n
  | n > 100 = n - 10
  | otherwise = mc91 $ mc91 $ n + 11


-- You haven’t seen map yet, but all you need to know right now is that it
-- applies a function to each member of a list and returns the resulting list.
-- It’ll be explained in more detail in the next chapter.

-- Prelude> map mc91 [95..110]
-- [91,91,91,91,91,91,91,92,93,94,95,96,97,98,99,100]

-- Numbers into words


digitToWord :: Int -> String
digitToWord n = case n of
                  0 -> "zero"
                  1 -> "one"
                  2 -> "two"
                  3 -> "three"
                  4 -> "four"
                  5 -> "five"
                  6 -> "six"
                  7 -> "seven"
                  8 -> "eight"
                  9 -> "nine"
                  _ -> error "You goofed"

digits :: Int -> [Int]
digits = map read . map pure . show

wordNumber :: Int -> String
wordNumber n = concat $ intersperse "-" $ map digitToWord $ digits n

-- Here undefined is a placeholder to show you where you need to fill in the
-- functions. The n to the right of the function names is the argument which
-- will be an integer.

-- Fill in the implementations of the functions above so that wordNumber returns
-- the English word version of the Int value. You will first write a function
-- that turns integers from 1-9 into their corresponding English words, ”one,”
-- ”two,” and so on. Then you will write a function that takes the integer,
-- separates the digits, and returns it as a list of integers. Finally you will
-- need to apply the first function to the list produced by the second function
-- and turn it into a single string with interspersed hyphens.

-- We’ve laid out multiple functions for you to consider as you tackle the
-- problem. You may not need all of them, depending on how you solve it–these
-- are just suggestions. Play with them and look up their documentation to
-- understand them in deeper detail.

-- You will probably find this difficult.
