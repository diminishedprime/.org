newtype Compose f g a = Compose {getCompose :: f (g a)} deriving (Eq, Show)

instance (Functor f, Functor g) => Functor (Compose f g) where
  fmap f (Compose fga) =
    Compose $ (fmap . fmap) f fga

instance (Foldable f, Foldable g) => Foldable (Compose f g) where
  foldMap f (Compose fga) = foldMap (\x -> foldMap f x) fga

-- Compose Traversable
-- Write the Traversable instance for Compose.

instance (Traversable f, Traversable g) => Traversable (Compose f g) where
  traverse f (Compose fga) = Compose <$> (traverse . traverse) f fga


-- And now for something completely different

-- This has nothing to do with anything else in this chapter.

class Bifunctor p where
  {-# MINIMAL bimap | first, second #-}
  bimap :: (a -> b) -> (c -> d) -> p a c -> p b d
  bimap f g = first f . second g
  first :: (a -> b) -> p a c -> p b c
  first f = bimap f id
  second :: (b -> c) -> p a b -> p a c
  second = bimap id

-- It’s a functor that can map over two type arguments instead of just one.
-- Write Bifunctor instances for the following types:

-- 1. The less you think, the easier it’ll be.
data Deux a b = Deux a b

instance Bifunctor Deux where
  bimap f g (Deux a b) = Deux (f a) (g b)

-- 2.
data Const a b = Const a

instance Bifunctor Const where
  bimap f _ (Const a) = Const $ f a

-- 3.
data Drei a b c = Drei a b c

instance Bifunctor (Drei a) where
  bimap f g (Drei a b c) = Drei a (f b) (g c)

-- 4.
data SuperDrei a b c = SuperDrei a b

instance Bifunctor (SuperDrei a) where
  bimap f _ (SuperDrei a b) = SuperDrei a (f b)

-- 5.
data SemiDrei a b c = SemiDrei a

instance Bifunctor (SemiDrei a) where
  bimap _ _ (SemiDrei a) = SemiDrei a

-- 6.
data Quadriceps a b c d = Quadzzz a b c d

instance Bifunctor (Quadriceps a b) where
  bimap f g (Quadzzz a b c d) = Quadzzz a b (f c) (g d)

-- 7.
data Either a b = Left a | Right b

instance Bifunctor Main.Either where
  bimap f _ (Main.Left a) = Main.Left (f a)
  bimap _ g (Main.Right b) = Main.Right (g b)
