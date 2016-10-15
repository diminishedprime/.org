import Control.Monad
import Data.Monoid
import Test.QuickCheck

monoidAssoc :: (Eq m, Monoid m) => m -> m -> m -> Bool
monoidAssoc a b c = (a <> (b <> c)) == ((a <> b) <> c)

monoidLeftIdentity :: (Eq m, Monoid m) => m -> Bool
monoidLeftIdentity a = (mempty <> a) == a

monoidRightIdentity :: (Eq m, Monoid m) => m -> Bool
monoidRightIdentity a = (a <> mempty) == a

data Optional a =
  Nada
  |Only a
  deriving (Eq, Show)

newtype First' a =
  First' { getFirst' :: Optional a }
  deriving (Eq, Show)

instance Monoid (First' a) where
  mempty = First' Nada
  a@(First' (Only _)) `mappend` _ = a
  (First' Nada) `mappend` a@(First' (Only _)) = a
  a@(First' Nada) `mappend` (First' Nada) = a

instance Arbitrary a => Arbitrary (Optional a) where
  arbitrary = frequency [ (1, return Nada)
                        , (3, fmap Only arbitrary)]

instance Arbitrary a => Arbitrary (First' a) where
  arbitrary = fmap First' arbitrary

type FirstMappend = First' String -> First' String -> First' String -> Bool

main :: IO ()
main = do quickCheck (monoidAssoc :: FirstMappend)
          quickCheck (monoidLeftIdentity :: First' String -> Bool)
          quickCheck (monoidRightIdentity :: First' String -> Bool)
