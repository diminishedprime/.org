{-# LANGUAGE TemplateHaskell #-}
import Data.Char
import Data.List

-- Multiple choice
-- 1. Given the following datatype:
data Weekday = Monday
             | Tuesday
             | Wednesday
             | Thursday
             | Friday
-- we can say:
-- a) Weekday is a type with five data constructors
-- b) Weekday is a tree with five branches
-- c) Weekday is a product type
-- d) Weekday takes five arguments

-- a

-- 2. and with the same datatype definition in mind, what is the type of the
-- following function, f?
f Friday = "Miller Time"

-- a) f :: [Char]
-- b) f :: String -> String
-- c) f :: Weekday -> String
-- d) f :: Day -> Beer

-- c

-- 3. Types defined with the data keyword

-- a) must have at least one argument
-- b) must begin with a capital letter
-- c) must be polymorphic
-- d) cannot be imported from modules

-- b

-- 4. The function g xs = xs !! (length xs - 1)

-- a) is recursive and may not terminate
-- b) delivers the head of xs
-- c) delivers the final element of xs
-- d) has the same type as xs

-- c

-- Ciphers

-- In the Lists chapter, you wrote a Caesar cipher. Now, we want to expand on
-- that idea by writing a Vigenère cipher. A Vigenère cipher is another
-- substitution cipher, based on a Caesar cipher, but it uses a series of Caesar
-- ciphers for poly alphabetic substitution. The substitution for each letter in
-- the plain text is determined by a fixed keyword.

-- So, for example, if you want to encode the message “meet at dawn,” the first
-- step is to pick a keyword that will determine which Caesar cipher to use.
-- We’ll use the keyword “ALLY” here. You repeat the keyword for as many
-- characters as there are in your original message:

-- MEET AT DAWN
-- ALLY AL LYAL

-- Now the number of rightward shifts to make to encode each character is set by
-- the character of the keyword that lines up with it. The ’A’ means a shi of 0,
-- so the initial M will remain M. But the ’L’ for our second character sets a
-- rightward shi of 11, so ’E’ becomes ’P’. And so on, so “meet at dawn” encoded
-- with the keyword “ALLY” becomes

-- “MPPR AE OYWY.”

-- Like the Caesar cipher, you can find all kinds of resources to help you
-- understand the cipher and also many examples written in Haskell. Consider
-- using a combination of chr, ord, and mod again, possibly very similar to what
-- you used for writing the original Caesar cipher.



caeser :: Int -> [Char] -> [Char]
caeser n orig = map (flip shiftLetter n) orig

unCaeser :: Int -> [Char] -> [Char]
unCaeser n = caeser (26 - n)

shiftLetter :: Char -> Int -> Char
shiftLetter c n = head $ drop n $ letterCycleFrom c
            where letterCycleFrom char = enumFromTo char 'z' ++ cycle ['a'..'z']

offSet a = ord a - 65

vigenereCipher :: String -> String -> String
vigenereCipher kw message = foldl (++) [] $ map (\(a, b) -> a b)
                            (zip (map rollingCharCyphers rollingOffSets) (map (:[]) message))
  where rollingOffSets = take (length message) $ map offSet (cycle kw)
        rollingCharCyphers :: Int -> ([Char] -> [Char])
        rollingCharCyphers a = caeser a

subLetter :: Int -> Char -> Char
subLetter a c = chr $ ord c - a

-- As-patterns

-- “As-patterns” in Haskell are a nifty way to be able to pattern match on part
-- of something and still refer to the entire original value. Some

-- Use as-patterns in implementing the following functions:

-- 1. This should return True if (and only if) all the values in the first list
-- appear in the second list, though they need not be contiguous.

isIn :: (Eq a) => a -> [a] -> Bool
isIn a xs = any (== a) xs

isSubsequenceOf' :: (Eq a) => [a] -> [a] -> Bool
isSubsequenceOf' [] _ = True
isSubsequenceOf' (x:xs) y = isIn x y && isSubsequenceOf' xs y

-- 2. Split a sentence into words, then tuple each word with the capitalized
-- form of each.

capitalizeWords :: String -> [(String, String)]
capitalizeWords = map (\w -> (w, capFirst w)) . words
  where capFirst (x:xs) = toUpper x : xs

-- Language exercises

-- 1. Write a function that capitalizes a word.

capitalizeWord :: String -> String
capitalizeWord "" = ""
capitalizeWord (x:xs) = toUpper x : xs

-- 2. Write a function that capitalizes sentences in a paragraph. Recognize when
-- a new sentence has begun by checking for periods. Reuse the capitalizeWord
-- function.

--capitalizeParagraph :: String -> String
capitalizeParagraph xs = let almost = snd $ unzip $ map fixWords $ rollingGroup xs
                         in unwords $ (capitalizeWord $ head almost) : tail almost

fixWords x@(a, b) = if endsWithPeriod a
                    then (a, capitalizeWord b)
                    else x
  where endsWithPeriod [] = False
        endsWithPeriod x = (last x == '.')

rollingGroup xs = let wordz = words xs
                  in [("", head wordz)] ++ (zip wordz $ tail wordz) ++ [(last wordz, "")]

-- Phone exercise

-- Remember old-fashioned phone inputs for writing text where you had to press a
-- button multiple times to get different letters to come up? You may still have
-- to do this when you try to search for a movie to watch using your television
-- remote control. You’re going to write code to translate sequences of button
-- presses into strings and vice versa.

-- So! Here is the layout of the phone:

-- ----------------
-- |1    |2 ABC|3 DEF|
-- -------------------
-- |4 GHI|5 JKL|6 MNO|
-- -------------------
-- |7PQRS|8 TUV|9WXYZ|
-- -------------------
-- | *^  | 0+_ | #., |
-- -------------------

-- Where star (*) gives you capitalization of the letter you’re writing to your
-- friends, and 0 is your space bar. To represent the digit itself, you press
-- that digit once more than the letters it represents. If you press a button
-- one more than than is required to type the digit, it wraps around to the
-- first letter. For example,

-- 2     -> 'A'
-- 22    -> 'B'
-- 222   -> 'C'
-- 2222  -> '2'
-- 22222 -> 'A'
-- So on and so forth. We’re going to kick this around.

-- 1. Create a data structure that captures the phone layout above. The data
-- structure should be able to express enough of how the layout works that you
-- can use it to dictate the behavior of the functions in the following
-- exercises.


type Digit = Char
type Presses = Int
data Button = Button Digit String
  deriving (Show, Eq, Ord)
data DaPhone = DaPhone [Button]
  deriving (Show)

phoneLayout = DaPhone [ Button '2' "ABC2", Button '3' "DEF3", Button '4' "GHI4",
                        Button '5' "JKL5", Button '6' "MNO6", Button '7' "PQRS7",
                        Button '8' "TUV8", Button '9' "WXYZ9", Button '#' ".,",
                        Button '0' " 0"]

defaultButton = Button '&' "&&&"

-- 2. Convert the following conversations into the key presses required to
-- express them. We’re going to suggest types and functions to fill in order to
-- accomplish the goal, but they’re not obligatory. If you want to do it
-- differently...you do you.

convo :: [String]
convo = ["Wanna play 20 questions",
         "Ya",
         "U 1st haha",
         "Lol ok. Have u ever tasted alcohol lol",
         "Lol ya",
         "Wow ur cool haha. Ur turn",
         "Ok. Do u think I am pretty Lol",
         "Lol ya",
         "Haha thanks just making sure rofl ur turn"]

getButton :: DaPhone -> Char -> Button
getButton (DaPhone btns) c = foldl (\a b -> case matchOnFirst a of
                                           (Button '&' "&&&") -> b
                                           _ -> a) defaultButton btns
  where matchOnFirst b@(Button ch str) = if any (== toUpper c) str
                                         then b
                                         else defaultButton

presses :: Button -> Char -> [(Digit, Presses)]
presses (Button ch str) c = let presses = case elemIndex (toUpper c) str of
                                           Nothing -> undefined
                                           (Just i) -> [(ch , (i + 1) :: Presses)]
                                capital = if isUpper c
                                          then [('*', 1)]
                                          else []
                           in capital ++ presses

reverseTaps :: DaPhone -> Char -> [(Digit, Presses)]
reverseTaps phone c = let button = getButton phone c
                      in presses button c

cellPhonesDead :: DaPhone -> String -> [(Digit, Presses)]
cellPhonesDead phone message = concat $ map (reverseTaps phone) message

-- 3. How many times do digits need to be pressed for each message?
--fingerTaps :: [(Digit, Presses)] -> Presses
fingerTaps = foldl (\a b -> a + b) (0 :: Presses) . map snd

-- 4. What was the most popular letter for each message? What was its cost?
-- You’ll want to combine reverseTaps and fingerTaps to figure out what it cost
-- in taps. reverseTaps is a list because you need to press a different button
-- in order to get capitals.

mostPopularLetter :: String -> Char
mostPopularLetter = head . foldl longestLength "" . groupBy (==) . sort

-- 5. What was the most popular letter overall? What was the most popular word?

--coolestLtr :: [String] -> Char
coolestLtr messages = mostPopularLetter $ concat $ messages

longestLength a b = case length a `compare` length b of
                      GT -> a
                      _ -> b


-- coolestWord :: [String] -> String
coolestWord  = head . foldl longestLength [""] .
               groupBy (==) . sort . words . concat . intersperse " "

-- Hutton’s Razor

-- Hutton’s Razor is a very simple expression language that expresses integer
-- literals and addition of values in that expression language. The “trick” to
-- it is that it’s recursive and the two expressions you’re summing together
-- could be literals or themselves further addition operations. This sort of
-- datatype is stereotypical of expression languages used to motivate ideas in
-- research papers and functional pearls. Evaluating or folding a datatype is
-- also in some sense what you’re doing most of the time while programming
-- anyway.

-- 1. Your first task is to write the “eval” function which reduces an
-- expression to a final sum.

data Expr = Lit Integer
          | Add Expr Expr

eval :: Expr -> Integer
eval (Lit a) = a
eval (Add a b) = eval a + eval b

-- 2. Write a printer for the expressions.
printExpr :: Expr -> String
printExpr (Lit a) = show a
printExpr (Add a b) = printExpr a ++ " + " ++ printExpr b
