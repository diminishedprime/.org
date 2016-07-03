import Control.Applicative
import Data.Maybe

-- Chapter Exercises

-- A warm-up stretch

-- These exercises are designed to be a warm-up and get you using some of the
-- stuff we’ve learned in the last few chapters. While these exercises comprise
-- code fragments from “real” code, they are simplified in order to be discrete
-- exercises. That will allow us to highlight and practice some of the type
-- manipulation from Traversable and Reader, both of which are tricky.

-- The first simplified part is that we’re going to set up some toy data; in the
-- real programs these are taken from, the data is coming from somewhere else —
-- a database, for example. We just need some lists of numbers. We’re going to
-- use some functions from Control.Applicative and Data.Maybe, so we’ll import
-- those at the top of our practice file. We’ll call our lists of toy data by
-- common variable names for simplicity.

x = [1, 2, 3]
y = [4, 5, 6]
z = [7, 8, 9]

-- The next thing we want to do is write some functions that zip those lists
-- together and uses lookup to find the value associated with a specified key in
-- our zipped lists. For demonstration purposes, it’s nice to have the outputs
-- be predictable, so we recommend writing some that are concrete values, as
-- well as one that can be applied to a variable:

lookup :: Eq a => a -> [(a, b)] -> Maybe b
lookup _ [] = Nothing
lookup a ((a', b):xs) = case a' == a of
                          True -> Just b
                          False -> Main.lookup a xs
-- zip x and y using 3 as the lookup key

xs :: Maybe Integer
xs = Main.lookup 3 $ zip x y

-- zip y and z using 6 as the lookup key
ys :: Maybe Integer
ys = Main.lookup 6 $ zip y z

-- it's also nice to have one that will return Nothing, like this one zip x and
-- y using 4 as the lookup key
zs :: Maybe Integer
zs = Main.lookup 4 $ zip x y

-- now zip x and z using a variable lookup key
z' :: Integer -> Maybe Integer
z' n = Main.lookup n $ zip x z

-- Now we want to add the ability to make a Maybe (,) of values using
-- Applicative. Have x1 make a tuple of xs and ys, and x2 make a tuple of of ys
-- and zs. Also, write x3 which takes one input and makes a tuple of the results
-- of two applications of z' from above.

x1 :: Maybe (Integer, Integer)
x1 = (,) <$> xs <*> ys

x2 :: Maybe (Integer, Integer)
x2 = (,) <$> ys <*> zs

x3 :: Integer -> (Maybe Integer, Maybe Integer)
x3 a = (z' a, z' a)

-- Next, we’re going to make some helper functions. Let’s use uncurry to allow
-- us to add the two values that are inside a tuple:

uncurry :: (a -> b -> c) -> (a, b) -> c
uncurry f (a, b) = f a b

-- that first argument is a function

-- in this case, we want it to be addition -- summed is just uncurry with
-- addition as the first argument
summed :: Num c => (c, c) -> c
summed = Main.uncurry (+)

-- And now we’ll make a function similar to some we’ve seen before that lifts a
-- boolean function over two partially-applied functions:

bolt :: Integer -> Bool -- use &&, >3, <8
bolt = (&&) <$> (>3) <*> (<8)

-- Finally, we’ll be using fromMaybe in the main exercise, so let’s look at
-- that:

fromMaybe :: a -> Maybe a -> a
fromMaybe a Nothing = a
fromMaybe _ (Just a) = a

-- Now we’ll cobble together a main function, so that in one function call we
-- can execute several things at once.
main :: IO ()
main = do
  print $ sequenceA [Just 3, Just 2, Just 1]
  print $ sequenceA [x, y]
  print $ sequenceA [xs, ys]
  print $ summed <$> ((,) <$> xs <*> ys)
  print $ fmap summed ((,) <$> xs <*> zs)
  print $ bolt 7
  print $ fmap bolt z
  print $ sequenceA [(>3), (<8), even] 7

-- When you run this in GHCi, your results should look like this:
-- *ReaderPractice> main
-- Just [3,2,1]
-- [[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]
-- Just [6,9]
-- Just 15
-- Nothing
-- True
-- [True,False,False]

-- Next, we’re going to add one that combines sequenceA and Reader in a somewhat
-- surprising way (add this to your main function):

-- print $ sequenceA [(>3), (<8), even] 7

-- The type of sequenceA is
-- sequenceA :: (Applicative f, Traversable t) => t (f a) -> f (t a) -- so in this:

-- sequenceA [(>3), (<8), even] 7
-- f ~ (->) a and t ~ []

-- We have a Reader for the Applicative (functions) and a traversable for the
-- list. Pretty handy. We’re going to call that function sequA for the purposes
-- of the following exercises:

sequA :: Integral a => a -> [Bool]
sequA m = sequenceA [(>3), (<8), even] m
