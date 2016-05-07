module Jammin where
import Data.List

-- Intermission: Jammin Exercises

-- Here we’ve started working on datatypes to keep track of Julie’s home- made
-- jam output, with an Int value to represent how many jars she’s canned:
data Fruit =
  Peach
  | Plum
  | Apple
  | Blackberry
  deriving (Eq, Show, Ord)

data JamJars =
  Jam Fruit Int deriving (Eq, Show)

-- 1. Let’s make a module for this. Name your module at the top of the file:

-- 2. Rewrite JamJars with record syntax.

data JamJars2 =
  JamJars2 {fruit :: Fruit
           , numberOfJars :: Int}
  deriving (Eq, Show)

-- 3. What is the cardinality of JamJars?

-- 4 * cardinality of Int

-- 4. Add Ord instances to your deriving clauses.

instance Ord JamJars2 where
  (JamJars2 _ a) `compare` (JamJars2 _ b) = compare a b

-- 5. You can use the record field accessors in other functions as well. To
-- demonstrate this, work up some sample data that has a count of the types and
-- numbers of jars of jam in the rows in our pantry (you can define more data
-- than this if you like):
row1 = JamJars2 Peach 10
row2 = JamJars2 Plum 11
row3 = JamJars2 Apple 3
row4 = JamJars2 Blackberry 8
row5 = JamJars2 Plum 3
row6 = JamJars2 Apple 8
allJam = [row1, row2, row3, row4, row5, row6]

-- Now over that list of data, we can map the field accessor for the Int value
-- and see a list of the numbers for each row.

-- 6. Write a function that will return the total number of jars of jam.

totalJarsOfJam = sum . map numberOfJars

-- 7. Write a function that will tell you which row has the most jars of jam in
-- it. It should return a result like this, though the fruit and number will
-- vary depending on how you defined your data:

mostRow :: [JamJars2] -> JamJars2
mostRow (x:xs) = foldl (\a b -> case compare a b of
                           GT -> a
                           _ -> b) x xs

-- 8. Under your module name, import the module called Data.List. It includes
-- some standard functions called sortBy and groupBy that will allow us to
-- organize our list of jams. Look at their type signatures because there are
-- some important differences between them.

-- okay

-- 9. You’ll want to sort the list allJam by the first field in each record. You
-- may (or may not) want to use the following helper function as part of that:

sortJam = sortBy compareKind

compareKind (JamJars2 k _) (JamJars2 k' _) = compare k k'

-- 10. Now take the sorting function and use groupBy to group the jams by the
-- type of fruit they are made from. You’ll later want the ability to sum the
-- sublists separately, so you’re looking for a result that is a list of lists
-- (again, the actual data in your list will depend on how you defined it):

groupJam = groupBy sameJam . sortJam
  where sameJam a b = EQ == compareKind a b
