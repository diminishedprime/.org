import Control.Monad
import Data.Monoid
import Test.QuickCheck

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

firstMappend :: First' a -> First' a -> First' a
firstMappend = mappend

type FirstMappend = First' String -> First' String -> First' String -> Bool

main :: IO () main =
  do
    quickCheck (monoidAssoc :: FirstMappend)
    quickCheck (monoidLeftIdentity :: First' String -> Bool)
    quickCheck (monoidRightIdentity :: First' String -> Bool)
