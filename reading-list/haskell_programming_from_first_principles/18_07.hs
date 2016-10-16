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
  pure _ = NopeDotJpg
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
  Identity a' >>= f = f a'

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

take' :: Int -> List a -> List a
take' 0 _ = Nil
take' _ Nil = Nil
take' n (Cons x xs) = Cons x (take' (n - 1) xs)

instance Monoid (List a) where
  mempty = Nil
  mappend a Nil = a
  mappend Nil a = a
  mappend (Cons x xs) ys = Cons x $ xs `mappend` ys

instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons a la) = Cons (f a) (fmap f la)

instance Applicative List where
  pure x = Cons x Nil
  Nil <*> _ = Nil
  _ <*> Nil = Nil
  (Cons f fs) <*> as = (f <$> as) <> (fs <*> as)

instance Monad List where
  return = pure
  Nil >>= _ = Nil
  (Cons x xs) >>= f = f x <> (xs >>= f)

instance Arbitrary a => Arbitrary (List a) where
  -- this breaks
  -- arbitrary = Cons <$> arbitrary <*> arbitrary
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    frequency [(1, return Nil),
               (10, return (Cons x y))]

instance Eq a => EqProp (List a) where
  xs =-= ys = xs' `eq` ys'
    where xs' = take' 3000 xs
          ys' = take' 3000 ys

main :: IO ()
main = do putStrLn "Testing Nope"
          quickBatch $ monad (undefined :: Nope (Int, Int, Int))
          putStrLn "Testing PhhhbbtttEither"
          quickBatch $ monad (undefined :: PhhhbbtttEither String (Int, Int, Int))
          putStrLn "Testing Identity"
          quickBatch $ monad (undefined :: Identity (Int, Int, Int))
          putStrLn "Testing List"
          quickBatch $ monad (undefined :: List (Int, String, Int))

-- Write the following functions using the methods provided by Monad and
-- Functor. Using stuff like identity and composition are fine, but it has to
-- typecheck with types provided.

-- 1.
j :: Monad m => m (m a) -> m a
j a = a >>= id

-- 2.
l1 :: Monad m => (a -> b) -> m a -> m b
l1 f m1 = f <$> m1

--3.
l2 :: Monad m => (a -> b -> c) -> m a -> m b -> m c
l2 f m1 m2 = do m1' <- m1
                m2' <- m2
                return $ f m1' m2'

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
