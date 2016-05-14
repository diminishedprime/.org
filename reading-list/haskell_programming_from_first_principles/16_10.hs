import Test.QuickCheck
import Test.QuickCheck.Function

functorIdentity :: (Functor f, Eq (f a)) =>
                   f a
                -> Bool
functorIdentity f = fmap id f == f

functorCompose :: (Eq (f c), Functor f) =>
                  (a -> b)
               -> (b -> c)
               -> f a
               -> Bool
functorCompose f g x = (fmap g (fmap f x)) == (fmap (g . f) x)

functorCompose' :: (Eq (f c), Functor f) =>
                   f a
                -> Fun a b
                -> Fun b c
                -> Bool
functorCompose' x (Fun _ f) (Fun _ g) =
  (fmap (g . f) x) == (fmap g . fmap f $ x)

-- Implement Functor instances for the following datatypes. Use the QuickCheck
-- properties we just showed you to validate them.

--1.
newtype Identity a = Identity a
  deriving (Eq)

instance Functor Identity where
  fmap f (Identity a) = Identity $ f a

-- 2.
data Pair a = Pair a a
  deriving (Eq)

instance Functor Pair where
  fmap f (Pair a b) = Pair (f a) (f b)

--3.
data Two a b = Two a b
  deriving (Eq)

instance Functor (Two a) where
  fmap f (Two a b) = Two a (f b)

--4.
data Three a b c = Three a b c
  deriving (Eq)

instance Functor (Three a b) where
  fmap f (Three a b c) = Three a b (f c)

-- 5.
data Three' a b = Three' a b b
  deriving (Eq)

instance Functor (Three' a) where
  fmap f (Three' a b b') = Three' a (f b) (f b')

-- 6.
data Four a b c d = Four a b c d
  deriving (Eq)

instance Functor (Four a b c) where
  fmap f (Four a b c d) = Four a b c (f d)

-- 7.
data Four' a b = Four' a a a b
  deriving (Eq)

instance Functor (Four' a) where
  fmap f (Four' a a' a'' b) = Four' a a' a'' (f b)

-- 8. Can you implement one for this type? Why? Why not?
data Trivial = Trivial
-- I can't because it's not kinded highly enough
