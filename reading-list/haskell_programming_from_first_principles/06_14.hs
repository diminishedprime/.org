-- 6.14 Chapter Exercises
-- Multiple choice

-- 1. The Eq class
-- a) includes all types in Haskell
-- b) is the same as the Ord class
-- c) makes equality tests possible ***
-- d) only includes numeric types

-- 2. The typeclass Ord
-- a) allows any two values to be compared
-- b) is a subclass of Eq ***
-- c) is a superclass of Eq
-- d) has no instance for Bool

-- 3. Suppose the typeclass Ord has an operator >. What is the type of >?
-- a) Ord a => a -> a -> Bool ***
-- b) Ord a => Int -> Bool
-- c) Ord a => a -> Char
-- d) Ord a => Char -> [Char]

-- 4. In x = divMod 16 12
-- a) the type of x is Integer
-- b) the value of x is undecidable
-- c) the type of x is a tuple ***
-- d) x is equal to 12 / 16

-- 5. The typeclass Integral includes
-- a) Int and Integer numbers ***
-- b) integral, real, and fractional numbers
-- c) Schrodinger’s cat
-- d) only positive numbers

-- Does it typecheck?
-- For this section of exercises, you’ll be practicing looking for type and
-- typeclass errors.

-- 1. Does the following code typecheck? If not, why not?

-- data Person = Person Bool

-- printPerson :: Person -> IO ()
-- printPerson person = putStrLn (show person)

-- This doesn't typecheck because it needs to derive show in order to call the
-- show function.

-- 2. Does the following typecheck? If not, why not?

-- data Mood = Blah | Woot deriving Show

-- settleDown x = if x == Woot
--               then Blah
--               else x

-- This doesn't typecheck because it needs to derive Eq in order to call the ==
-- function.

-- 3. If you were able to get settleDown to typecheck:

-- a) What values are acceptable inputs to that function?

-- Blah or Woot

-- b) What will happen if you try to run settleDown 9? Why?

-- It won't compile because 9 can't be asked for equality with something of
-- another type.

-- c) What will happen if you try to run Blah > Woot? Why?

-- It won't compile because Mood doesn't implement Ord.

-- 4. Does the following typecheck? If not, why not

type Subject = String
type Verb = String
type Object = String

data Sentence = Sentence Subject Verb Object deriving (Eq, Show)
s1 = Sentence "dogs" "drool"
s2 = Sentence "Julie" "loves" "dogs"

-- Yep, sure does.

-- Given a datatype declaration, what can we do? Given the following datatype definitions:
data Rocks = Rocks String deriving (Eq, Show)
data Yeah = Yeah Bool deriving (Eq, Show)
data Papu = Papu Rocks Yeah deriving (Eq, Show)

-- Which of the following will typecheck? For the ones that don’t type- check, why don’t they?

-- 1.
-- phew = Papu "chases" True

-- 2.
truth = Papu (Rocks "chomskydoz") (Yeah True)

-- 3.
equalityForall :: Papu -> Papu -> Bool
equalityForall p p' = p == p'

-- 4.
-- comparePapus :: Papu -> Papu -> Bool
-- comparePapus p p' = p > p'

-- Papu doesn't derive Ord.

-- 1 fails
-- 2 fails Num isn't fractional.
-- 3 fine
-- 4 fine
-- 5 fine
-- 6 fine
-- 7 fails a isn't an Int
-- 8 fine
-- 9 fine
-- 10 fine
-- 11 fine

-- 1
chk :: Eq b => (a -> b) -> a -> b -> Bool
chk f x x' = f x == x'

-- 2
arith :: Num b => (a -> b) -> Integer -> a -> b
arith f int x = f x
