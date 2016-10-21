import Data.Monoid

-- Exercises>

-- Implement the functions in terms of foldMap or foldr from Foldable, then try
-- them out with multiple types that have Foldable instances.

-- 1. This and the next one are nicer with foldMap, but foldr is fine too.
sum :: (Foldable t, Num a) => t a -> a
sum = getSum . Main.foldMap Sum

-- 2.
product :: (Foldable t, Num a) => t a -> a
product = getProduct . Main.foldMap Product

-- 3.
elem :: (Foldable t, Eq a) => a -> t a -> Bool
elem a = getAny . Main.foldMap (Any . (==a))
-- 4.
newtype Min a = Min {getMin :: Maybe a}

instance Ord a => Monoid (Min a) where
  mempty = Min Nothing
  m `mappend` Min Nothing = m
  Min Nothing `mappend` n = n
  Min m@(Just x) `mappend` Min n@(Just y)
    | x <= y = Min m
    | otherwise = Min n

minimum :: (Foldable t, Ord a) => t a -> Maybe a
minimum = getMin . Main.foldMap (Min . Just)

-- 5.
newtype Max a = Max {getMax :: Maybe a}

instance Ord a => Monoid (Max a) where
  mempty = Max Nothing
  m `mappend` Max Nothing = m
  Max Nothing `mappend` n = n
  Max m@(Just x) `mappend` Max n@(Just y)
    | x >= y = Max m
    | otherwise = Max n

maximum :: (Foldable t, Ord a) => t a -> Maybe a
maximum = getMax . Main.foldMap (Max . Just)

-- 6.
newtype Id a = Id {getId :: a}

null :: (Foldable t) => t a -> Bool
null = (==0) . Main.length

-- 7.
length :: (Foldable t) => t a -> Int
length = foldr (\_ acc -> acc + 1) 0

-- 8. Some say this is all Foldable amounts to.
toList :: (Foldable t) => t a -> [a]
toList = foldr (\a acc -> a:acc) []

-- 9. Hint: use foldMap.
--      -- | Combine the elements of a structure using a monoid.
fold :: (Foldable t, Monoid m) => t m -> m
fold = Main.foldMap id

-- 10. Define foldMap in terms of foldr.
foldMap :: (Foldable t, Monoid m) => (a -> m) -> t a -> m
foldMap f = foldr (mappend . f) mempty
