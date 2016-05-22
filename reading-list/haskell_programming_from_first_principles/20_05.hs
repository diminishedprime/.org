import Data.Monoid

-- Exercises>

-- Implement the functions in terms of foldMap or foldr from Foldable, then try
-- them out with multiple types that have Foldable instances.

-- 1. This and the next one are nicer with foldMap, but foldr is fine too.
sum' :: (Foldable t, Num a) => t a -> a
sum' = getSum . foldMap Sum

-- 2. product :: (Foldable t, Num a) => t a -> a
product' :: (Foldable t, Num a) => t a -> a
product' = getProduct . foldMap Product

-- 3. elem :: (Foldable t, Eq a) => a -> t a -> Bool
elem' :: (Foldable t, Eq a) => a -> t a -> Bool
elem' a = foldr (\x acc -> x == a || acc) False

-- 4. minimum :: (Foldable t, Ord a) => t a -> Maybe a
minimum' :: (Foldable t, Ord a) => t a -> Maybe a
minimum' = foldr (\x acc -> Just $ case acc of
                                     Nothing -> x
                                     Just y -> if y < x
                                       then y
                                       else x) Nothing

-- 5. maximum :: (Foldable t, Ord a) => t a -> Maybe a
maximum' :: (Foldable t, Ord a) => t a -> Maybe a
maximum' = foldr (\x acc -> Just $ case acc of
                                     Nothing -> x
                                     Just y -> if y > x
                                               then y
                                               else x) Nothing

-- 6. null :: (Foldable t) => t a -> Bool
null' :: (Foldable t) => t a -> Bool
null' a = case a of
           mempty -> False
           otherwise -> True

-- 7. length :: (Foldable t) => t a -> Int

-- 8. Some say this is all Foldable amounts to.
--toList :: (Foldable t) => t a -> [a]

-- 9. Hint: use foldMap.
     -- | Combine the elements of a structure using a monoid.
--fold :: (Foldable t, Monoid m) => t m -> m
--10. Define foldMap in terms of foldr.
--foldMap :: (Foldable t, Monoid m) => (a -> m) -> t a -> m
