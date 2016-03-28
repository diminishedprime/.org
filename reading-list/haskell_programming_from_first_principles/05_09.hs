-- Multiple choice

-- 1. A value of type [a] is
-- a) a list of alphabetic characters
-- b) a list of lists
-- c) a list whose elements are all of some type 𝑎 ***
-- d) a list whose elements are all of different types


-- 2. A function of type [[a]] -> [a] could
-- a) take a list of strings as an argument ***
-- b) transform a character into a string
-- c) transform a string in to a list of strings
-- d) take two arguments

-- 3. A function of type [a] -> Int -> a
-- a) takes one argument
-- b) returns one element of type 𝑎 from a list ***
-- c) must return an Int value
-- d) is completely fictional

-- 4. A function of type (a, b) -> a
-- a) takes a list argument and returns a Char value
-- b) has zero arguments
-- c) takes a tuple argument and returns the first value ***
-- d) requires that 𝑎 and 𝑏 be of different types Determine the type

-- For the following functions, determine the type of the specified value. Note:
-- you can type them into a file and load the contents of the file in GHCi. You
-- can then query the types a er you’ve loaded them.

-- 1. All function applications return a value. Determine the value returned by
-- these function applications and the type of that value.

-- a) (* 9) 6
-- 54
-- b) head [(0,"doge"),(1,"kitteh")]
--(0, "doge")
-- c) head [(0 :: Integer ,"doge"),(1,"kitteh")]
-- (0, "doge")
-- d) if False then True else False
-- False
-- e) length [1, 2, 3, 4, 5]
-- 5
-- f) (length [1, 2, 3, 4]) > (length "TACOCAT")
-- Bool

-- 2. Given
-- x=5 y=x+5 w = y * 10
-- What is the type of w?
-- Num

-- 3. Given
-- x=5 y=x+5
-- z y = y * 10
-- What is the type of z?
-- z :: (Num a) => a -> a

-- 4. Given
-- x=5 y=x+5 f=4/y
-- What is the type of f?
-- f :: (Fractional a) => a

-- 5. Given
-- x = "Julie"
-- y = " <3 "
-- z = "Haskell"
-- f = x ++ y ++ z

-- What is the type of f?
-- f :: String
-- Does it compile?
-- Yes???

-- For each set of expressions, figure out which expression, if any, causes the
-- compiler to squawk at you (n.b. we do not mean literal squawking) and why.
-- Fix it if you can.

-- 1.
-- bigNum = (^) 5
-- wahoo = bigNum $ 10
-- 2.
-- x' = print
-- y' = print "woohoo!"
-- z' = x' "hello world"
-- 3.
-- a' = (+)
-- b' = a'
-- c' = b' 10
-- d' = c' 200
-- 4.
-- a'' = 12 + b''
-- b'' = 10000 * c''
-- c'' = 3
-- Type variable or specific type constructor?

-- 1. You will be shown a type declaration, and you should categorize each type.
-- The choices are a fully polymorphic type variable, constrained polymorphic
-- type variable, or concrete type constructor.
-- f :: Num a => a -> b -> Int -> Int
-- [0] [1] [2] [3]
-- Here, the answer would be: constrained polymorphic (Num) ([0]), fully
-- polymorphic ([1]), and concrete ([2] and [3]).

-- 2. Categorize each component of the type signature as described in the previous example.
-- f :: zed -> Zed -> Blah

-- zed is fully polymorphic
-- Zed is concrete type constructor
-- Blah is concrete type constructor

-- 3. Categorize each component of the type signature
-- f :: Enum b => a -> b -> C

-- a is fully polymorphic type variable
-- b is constrained polymorphic type variable
-- C is a concrete type constructor.

-- 4. Categorize each component of the type signature
-- f :: f -> g -> C Write a type signature

-- f and g are fully polymorphic type variables
-- C is a concrete type constructor.

-- For the following expressions, please add a type signature. You should be
-- able to rely on GHCi type inference to check your work, although you might
-- not have precisely the same answer as GHCi gives (due to polymorphism, etc).

-- 1. While we haven’t fully explained this syntax yet, you’ve seen it in
-- Chapter 2 and as a solution to an exercise in Chapter 4. This syntax is a way
-- of destructuring a single element of a list.
functionH :: [x] -> x
functionH (x:_) = x

-- 2.
functionC :: (Ord x) => x -> x -> Bool
functionC x y = if (x > y) then True else False
-- 3.
functionS :: (a, b) -> b
functionS (x, y) = y

-- Given a type, write the function

-- You will be shown a type and a function that needs to be written. Use the
-- information the type provides to determine what the function should do. We’ll
-- also tell you how many ways there are to write the function. (Syntactically
-- different but semantically equivalent implementations are not counted as
-- being different).

-- 1. There is only one implementation that typechecks.
i :: a -> a
i a = a

-- 2. There is only one version that works.
c :: a -> b -> a
c a b = a

-- 3. Given alpha equivalence are c” and c (see above) the same thing?
c'' :: b -> a -> b
c'' a b = a

-- 4. Only one version that works.

c' :: a -> b -> b
c' a b = b

-- 5. There are multiple possibilities, at least two of which you’ve seen in
-- previous chapters.

r :: [a] -> [a]
r a = a

-- 6. Only one version that will typecheck.
--co :: (b -> c) -> (a -> b) -> (a -> c)

-- Having trouble with this one, I know it has to be the composition of the
-- second function with the first, but I can't get it to work???

-- 7. One version will typecheck.
a :: (a -> c) -> a -> a
a x y = y

-- 8. One version will typecheck.
a' :: (a -> b) -> a -> b
a' x y = x y

-- Fix it

-- Won’t someone take pity on this poor broken code and fix it up? Be sure to
-- check carefully for things like capitalization, parentheses, and indentation.

-- 1. module sing where
fstString :: [Char] -> [Char]
fstString x = x ++ " in the rain"

sndString :: [Char] -> [Char]
sndString x = x ++ " over the rainbow"

sing = if (x > y)
       then fstString x
       else sndString y
  where x = "Singing"
        y = "Somewhere"

-- 2. Now that it’s fixed, make a minor change and make it sing the other song.
-- If you’re lucky, you’ll end up with both songs stuck in your head!

-- The change would just be to swap the values of x and y.

-- 3. -- arith3broken.hs
-- module Arith3Broken where
main :: IO ()
main = do
  print (1 + 2)
  putStrLn "10"
  print (negate (-1))
  print ((+) 0 blah)
    where blah = negate 1

-- Type-Kwon-Do
-- The name is courtesy Phillip Wright3, thank you for the idea!

-- The focus here is on manipulating terms in order to get the types to fit.
-- This sort of exercise is something you’ll encounter in writing real Haskell
-- code, so the practice will make it easier to deal with when you get there.
-- Practicing this will make you better at writing ordinary code as well.

-- We provide the types and bottomed out (declared as “undefined”) terms. Bottom
-- and undefined will be explained in more detail later. The contents of the
-- terms are irrelevant here. You’ll use only the declarations provided and what
-- the Prelude provides by default unless otherwise specified. Your goal is to
-- make the ???’d declaration pass the typechecker by modifying it alone.

-- Here’s a worked example for how we present these exercises and how you are
-- expected to solve them. Given the following:

data Woot
data Blah
f :: Woot -> Blah
f = undefined
g :: (Blah, Woot) -> (Blah, Blah)
g (b, w) = (b, b)

-- Here it’s 𝑔 that you’re supposed to implement; however, you can’t evaluate
-- anything. You’re to only use type-checking and type-inference to validate
-- your answers. Also note that we’re using a trick for defining datatypes which
-- can be named in a type signature, but have no values. Here’s an example of a
-- valid solution:

-- g :: (Blah, Woot) -> (Blah, Blah) g (b, w) = (b, f w)
-- The idea is to only fill in what we’ve marked with ???.
-- Not all terms will always be used in the intended solution for a problem.

-- 1.
f' :: Int -> String
f' = undefined
g' :: String -> Char
g' = undefined
h :: Int -> Char
h x = g' $ f' x

-- 2.
data A
data B
data C

q :: A -> B
q = undefined

w :: B -> C
w = undefined

e :: A -> C
e x = w $ q x

-- 3.
data X
data Y
data Z

xz :: X -> Z
xz = undefined

yz :: Y -> Z
yz = undefined

xform :: (X, Y) -> (Z, Z)
xform (a, b) = ((xz a), (yz b))

-- 4.
munge :: (x -> y) -> (y -> (w, z)) -> x -> w
munge a b c = fst $ b $ a c
