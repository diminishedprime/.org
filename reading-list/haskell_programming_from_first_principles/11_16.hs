{-# LANGUAGE TemplateHaskell #-}
import Data.Char

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

-- “As-patterns” in Haskell are a ni y way to be able to pattern match on part
-- of something and still refer to the entire original value. Some
