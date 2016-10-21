import Data.Monoid
-- -- Write Foldable instances for the following datatypes.
-- 1.
data Constant a b = Constant a

instance Foldable (Constant a) where
  foldr f acc (Constant a) = acc

-- 2.
data Two a b = Two a b

instance Foldable (Two a) where
  foldr f acc (Two a b) = f b acc

-- 3.
data Three a b c = Three a b c

instance Foldable (Three a b) where
  foldr f acc (Three a b c) = f c acc

-- 4.
data Three' a b = Three' a b b

instance Foldable (Three' a) where
   foldMap f (Three' a b b') = f b <> f b'

-- 5.
data Four' a b = Four' a b b b

instance Foldable (Four' a) where
  foldMap f (Four' a b b' b'') = f b <> f b' <> f b''

-- Thinking cap time. Write a filter function for Foldable types using foldMap.
filterF :: (Applicative f, Foldable f, Monoid (f a)) =>
           (a -> Bool) -> f a -> f a
filterF f = foldMap (\x -> if f x -- (a -> Bool)
                           then pure x
                           else mempty)
