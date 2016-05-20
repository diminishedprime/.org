import Control.Applicative
import Data.Monoid hiding (Sum, First)
import Test.QuickCheck hiding (Success)
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes
-- Exercise

-- Implement the Either Monad.

instance (Arbitrary a, Arbitrary b) => Arbitrary (Sum a b) where
  arbitrary = genSum

genSum :: (Arbitrary a, Arbitrary b) => Gen (Sum a b)
genSum = do
  a <- arbitrary
  b <- arbitrary
  elements [First a, Second b]

instance (Eq a, Eq b) => EqProp (Sum a b) where
  (=-=) = eq

data Sum a b = First a
             | Second b
  deriving (Eq, Show)

instance Functor (Sum a) where
  fmap _ (First a) = First a
  fmap f (Second a) = Second $ f a

instance Applicative (Sum a) where
  pure = Second
  Second f <*> a = fmap f a
  First a <*> _ = First a

instance Monad (Sum a) where
  return = pure
  First m >>= _ = First m
  Second m >>= f = f m

-- quickBatch (applicative (undefined :: Sum String (Int, Int, Int)))
