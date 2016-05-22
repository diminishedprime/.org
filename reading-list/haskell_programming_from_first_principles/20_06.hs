-- Write Foldable instances for the following datatypes.

-- 1.
data Constant a b =
  Constant a

instance Foldable (Constant a) where
  foldr f b (Constant a) = b

-- 2.
data Two a b =
  Two a b

instance Foldable (Two a) where
  foldr f b (Two a' b') = f b' b

--3.
data Three a b c =
  Three a b c

instance Foldable (Three a b) where
  foldr f b (Three a' b' c') = f c' b

--4.
data Three' a b =
  Three' a b b

instance Foldable (Three' a) where
  foldMap f (Three' a' b b') = mappend (f b') (f b')

--  5.
data Four' a b =
  Four' a b b b

instance Foldable (Four' a) where
  foldMap f (Four' a x y z) = f x `mappend` f y `mappend` f z

--Thinking cap time. Write a filter function for Foldable types using
--foldMap.
filterF :: (Applicative f, Foldable t, Monoid (f a)) =>
           (a -> Bool) -> t a -> f a
filterF f = foldMap (\a -> if f a then pure a else mempty)
