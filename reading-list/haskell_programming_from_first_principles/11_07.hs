{-# LANGUAGE FlexibleInstances #-}
-- Intermission: Exercises

-- While we haven’t explicitly described the rules for calculating the
-- cardinality of datatypes yet, you might already have an idea of how to do it
-- for simple datatypes with nullary constructors. Try not to overthink these
-- exercises – you can probably intuitively grasp what the cardinality is based
-- just on what you know.

-- 1. data PugType = PugData

-- 1

-- 2. For this one, recall that Bool is also defined with the |:

data Airline =
  PapuAir
  | CatapultsR'Us
  | TakeYourChancesUnited

-- 3

-- 3. Given what we know about Int8, what’s the cardinality of Int16?

-- 65536

-- 4. Use the REPL and maxBound and minBound to examine Int and Integer. What
-- can you say about the cardinality of those types?

-- ???

-- 5. Extra credit (impress your friends!): What’s the connection between the 8
-- in Int8 and that type’s cardinality of 256?

-- it's 2^8


-- Intermission: Exercises

data Example = MakeExample deriving Show

-- 1. You can query the type of a value in GHCi with the :type commaand. What is
-- the type of data constructor MakeExample? What happens when you request the type of Example?

-- MakeExample :: Example
-- It gets mad because the data constructor Example isn't in scope.

-- 2. What if you try :info on Example in GHCi? Can you determine what typeclass
-- instances are defined for the Example type using :info in GHCi?

-- That does work. It shows what typeclass instances are defined as well.

-- 3. Try making a new datatype like Example but with a single type argument
-- added to MakeExample, such as Int. What has changed when you query
-- MakeExample with :type in GHCi?
data ExampleTwo = MakeTwo Int

-- MakeTwo 3 :: ExampleTwo

class TooMany a where
  tooMany :: a -> Bool

-- 1. Reusing the TooMany typeclass, write an instance of the typeclass for the
-- type (Int, String). This will require adding a language pragma named
-- FlexibleInstances4 if you do not use a newtype GHC will tell you what to do.

instance TooMany (Int, String) where
  tooMany (int, _) = int > 10

-- 2. Make another TooMany instance for (Int, Int). Sum the values together
-- under the assumption this is a count of goats from two fields.

instance TooMany (Int, Int) where
  tooMany (int, int2) = (int + int2) > 42

-- 3. Make another TooMany instance, this time for (Num a, TooMany a) => (a, a).
-- This can mean whatever you want, such as summing the two numbers together.

instance (Num a, TooMany a) => TooMany (a, a) where
  tooMany (a, a') = tooMany (a + a')
