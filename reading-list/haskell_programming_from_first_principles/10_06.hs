-- Write the following functions for processing this data.
import Data.Time
data DatabaseItem = DbString String
  | DbNumber Integer
  | DbDate   UTCTime
  deriving (Eq, Ord, Show)

theDatabase :: [DatabaseItem]
theDatabase = [DbDate (UTCTime (fromGregorian 1911 5 1) (secondsToDiffTime 34123)),
               DbNumber 9001,
               DbString "Hello, world!",
               DbDate (UTCTime (fromGregorian 1921 5 1) (secondsToDiffTime 34123))]

-- 1. Write a function that filters for DbDate values and returns a list of the UTCTime values inside them.
filterDbDate :: [DatabaseItem] -> [UTCTime]
filterDbDate = foldr keepPred []
  where keepPred x acc = case x of
          (DbDate utcTime) -> utcTime : acc
          _ -> acc

-- 2. Write a function that filters for DbNumber values and returns a list of the Integer values inside them.
filterDbNumber :: [DatabaseItem] -> [Integer]
filterDbNumber = foldr keepPred []
  where keepPred x acc = case x of
          (DbNumber dbNumber) -> dbNumber : acc
          _ -> acc

-- 3. Write a function that gets the most recent date.
mostRecent :: [DatabaseItem] -> UTCTime
mostRecent = foldr maxDate (UTCTime (fromGregorian 1900 5 1) (secondsToDiffTime 34123)) . filterDbDate
  where maxDate curr last = case compare curr last of
          LT -> last
          _ -> curr

-- 4. Write a function that sums all of the DbNumber values.
sumDb :: [DatabaseItem] -> Integer
sumDb = sum . filterDbNumber

-- 5. Write a function that gets the average of the DbNumber values.
avgDb :: [DatabaseItem] -> Double
avgDb = avg . filterDbNumber
  where avg xs = let totalSum = fromIntegral $ sum xs
                     totalCount = fromIntegral $ length xs in
                 totalSum / totalCount
