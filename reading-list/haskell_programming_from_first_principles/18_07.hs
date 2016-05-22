import Prelude hiding (Left, Right)
import Control.Applicative
import Control.Monad (join)
import Data.Monoid hiding (Sum, First)
import Test.QuickCheck hiding (Success)
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes

-- Write Monad instances for the following types. Use the QuickCheck properties
-- we showed you to validate your instances.

-- 1. Welcome to the Nope Monad, where nothing happens and nobody cares.

data Nope a = NopeDotJpg
  deriving (Eq, Show)

instance Functor Nope where
  fmap _ _ = NopeDotJpg

instance Applicative Nope where
  pure = \x -> NopeDotJpg
  _ <*> _ = NopeDotJpg

instance Monad Nope where
  return = pure
  _ >>= _ = NopeDotJpg

instance Arbitrary (Nope a) where
  arbitrary = elements [NopeDotJpg]

instance (Eq a) => EqProp (Nope a) where
  (=-=) = eq

-- 2.
data PhhhbbtttEither b a =
  Left a
  | Right b
  deriving (Eq, Show)

instance Functor (PhhhbbtttEither b) where
  fmap _ (Right b) = Right b
  fmap f (Left a) = Left $ f a

instance Applicative (PhhhbbtttEither b) where
  pure = Left
  Right f <*> _ = Right f
  Left f <*> fa = fmap f fa

instance Monad (PhhhbbtttEither b) where
  return = pure
  (Right a) >>= _ = Right a
  (Left a) >>= f = f a

instance (Arbitrary a, Arbitrary b) => Arbitrary (PhhhbbtttEither b a) where
  arbitrary = genPhEither
    where genPhEither = do
            a <- arbitrary
            b <- arbitrary
            elements [Left a, Right b]

instance (Eq a, Eq b) => EqProp (PhhhbbtttEither b a) where
  (=-=) = eq

-- 3. Write a Monad instance for Identity.
newtype Identity a = Identity a
  deriving (Eq, Ord, Show)

instance Functor Identity where
  fmap f (Identity a) = Identity $ f a

instance Applicative Identity where
  pure = Identity
  (<*>) (Identity f) a = fmap f a

instance Monad Identity where
  return = pure
  (>>=) (Identity a) f = f a

instance (Arbitrary a) => Arbitrary (Identity a) where
  arbitrary = genIdentity
    where genIdentity = do
            a <- arbitrary
            return $ Identity a

instance (Eq a) => EqProp (Identity a) where
  (=-=) = eq

-- 4. This one should be easier than the Applicative instance was. Remember to
-- use the Functor that Monad requires, then see where the chips fall.

data List a =
  Nil
  | Cons a (List a)
  deriving (Eq, Show)

instance Eq a => EqProp (List a) where
  xs =-= ys = takeList 10 xs `eq` takeList 10 ys

-- | Take a prefix of up to @n@ elements from a 'List'.
takeList :: Int -> List a -> List a
takeList _ Nil = Nil
takeList n (Cons a as)
    | n > 0 = Cons a (takeList (n-1) as)
    | otherwise = Nil

instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons a b) = Cons (f a) (fmap f b)

instance Applicative List where
  pure a = Cons a Nil
  Nil <*> _ = Nil
  _ <*> Nil = Nil
  a <*> a' = flatMap (\f -> fmap f a') a

append :: List a -> List a -> List a
append Nil ys = ys
append (Cons x xs) ys = Cons x $ xs `append` ys

fold :: (a -> b -> b) -> b -> List a -> b
fold _ b Nil = b
fold f b (Cons h t) = f h (fold f b t)

concat' :: List (List a) -> List a
concat' = fold append Nil
-- write this one in terms of concat' and fmap
flatMap :: (a -> List b) -> List a -> List b
flatMap f as = fold append Nil $ fmap f as

instance Arbitrary a => Arbitrary (List a) where
  arbitrary = genList

genList :: Arbitrary a => Gen (List a)
genList = do
  h <- arbitrary
  t <- genList
  frequency [(3, return $ Cons h t),
             (1, return Nil)]

instance Monad List where
  return = pure
  (>>=) ma f = flatMap f ma

-- Write the following functions using the methods provided by Monad and
-- Functor. Using stuff like identity and composition are fine, but it has to
-- typecheck with types provided.

-- 1.
j :: Monad m => m (m a) -> m a
j a = a >>= id

-- 2.
l1 :: Monad m => (a -> b) -> m a -> m b
l1 f m1 = m1 >>= (return . f)

--3.
l2 :: Monad m => (a -> b -> c) -> m a -> m b -> m c
l2 f m1 m2 = undefined

-- 4.
a :: Monad m => m a -> m (a -> b) -> m b
a = flip (<*>)

-- 5. You’ll need recursion for this one.
meh :: Monad m => [a] -> (a -> m b) -> m [b]
meh [] _ = return []
meh (x:xs) f = (++) <$> (fmap pure $ f x) <*> (meh xs f)

-- 6. Hint: reuse “meh”
flipType :: (Monad m) => [m a] -> m [a]
flipType a = meh a (join . pure)
