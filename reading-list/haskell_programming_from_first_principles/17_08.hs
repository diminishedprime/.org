import Control.Applicative
import Data.Monoid hiding (Sum, First)
import Test.QuickCheck hiding (Success)
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes

-- List Applicative Exercise

-- Implement the List Applicative. Writing a minimally complete Applicative
-- instance calls for writing the definitions of both pure and <*>. We’re going
-- to provide a hint as well. Use the checkers library to validate your
-- Applicative instance.

-- | Test lists for equality (fallibly) by comparing finite prefixes
--  of them.  I've arbitrarily chosen a depth of 1,000. There may be
-- better ideas than that.
instance Eq a => EqProp (List a) where
  xs =-= ys = takeList 10 xs `eq` takeList 10 ys

-- | Take a prefix of up to @n@ elements from a 'List'.
takeList :: Int -> List a -> List a
takeList _ Nil = Nil
takeList n (Cons a as)
    | n > 0 = Cons a (takeList (n-1) as)
    | otherwise = Nil


data List a = Nil
            | Cons a (List a)
  deriving (Eq, Show)

-- Remember what you wrote for the List Functor:
instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons a b) = Cons (f a) (fmap f b)

instance Applicative List where
  pure a = Cons a Nil
  Nil <*> _ = Nil
  _ <*> Nil = Nil
  a <*> a' = flatMap (\f -> fmap f a') a

-- Expected result:
-- Prelude> let functions = Cons (+1) (Cons (*2) Nil)
-- Prelude> let values = Cons 1 (Cons 2 Nil)
-- Prelude> functions <*> values
-- Cons 2 (Cons 3 (Cons 2 (Cons 4 Nil)))

-- In case you get stuck, use the following functions and hints.
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

-- Use the above and try using flatMap and fmap without explicitly
-- pattern-matching on Cons cells. You’ll still need to handle the Nil cases.

-- Applicative instances, unlike Functors, are not guaranteed to have a unique
-- implementation for a given datatype.

take' :: Int -> List a -> List a
take' _ Nil = Nil
take' n (Cons a b) = Cons a $ take' (n - 1) b

newtype ZipList' a = ZipList' (List a)
  deriving (Eq, Show)

instance Eq a => EqProp (ZipList' a) where
  xs =-= ys = xs' `eq` ys'
    where xs' = let (ZipList' l) = xs
                in take' 3000 l
          ys' = let (ZipList' l) = ys
                in take' 3000 l

instance Functor ZipList' where
  fmap f (ZipList' xs) = ZipList' $ fmap f xs

instance Applicative ZipList' where
  pure a = ZipList' $ Cons a Nil
  (ZipList' Nil) <*> _ = ZipList' Nil
  _ <*> (ZipList' Nil) = ZipList' Nil
  ZipList' (Cons f Nil) <*> ZipList' (Cons x xs) = ZipList' $ Cons (f x) (pure f <*> xs)
  ZipList' (Cons f fs) <*> ZipList' (Cons x Nil) = ZipList' $ Cons (f x) (fs <*> pure x)
  ZipList' (Cons f fs) <*> ZipList' (Cons x xs) = ZipList' $ Cons (f x) (fs <*> xs)

instance Arbitrary a => Arbitrary (List a) where
  arbitrary = genList

instance Arbitrary a => Arbitrary (ZipList' a) where
  arbitrary = genZipList

genList :: Arbitrary a => Gen (List a)
genList = do
  h <- arbitrary
  t <- genList
  frequency [(3, return $ Cons h t),
             (1, return Nil)]

genZipList :: Arbitrary a => Gen (ZipList' a)
genZipList = do
  l <- arbitrary
  return $ ZipList' l

------

data Sum' a b = First' a
              | Second' b
  deriving (Eq, Show)

data Validation e a = Error e
                    | Success a
  deriving (Eq, Show)

instance Functor (Sum' a) where
  fmap f (Second' b) = Second' $ f b
  fmap _ (First' a) = First' a

instance Applicative (Sum' a) where
  pure = Second'
  (First' a) <*> _ = First' a
  (Second' _) <*> (First' a) = First' a
  (Second' f) <*> (Second' a) = Second' $ f a

instance (Arbitrary a, Arbitrary b) => Arbitrary (Sum' a b) where
  arbitrary = genSum

genSum :: (Arbitrary a, Arbitrary b) => Gen (Sum' a b)
genSum = do
  a <- arbitrary
  b <- arbitrary
  elements [First' a, Second' b]

-- same as Sum/Either
instance Functor (Validation e) where
  fmap f (Success b) = Success $ f b
  fmap _ (Error a) = Error a

-- This is different
instance Monoid e => Applicative (Validation e) where
  pure = Success
  (Error e) <*> (Error e') = Error $ e <> e'
  (Error e) <*> (Success _) = Error e
  (Success _) <*> (Error e') = Error e'
  (Success f) <*> (Success a) = Success $ f a

-- Your hint for this one is that you’re writing the following functions:
applyIfBothSecond :: (Sum' e) (a -> b)
                  -> (Sum' e) a
                  -> (Sum' e) b
applyIfBothSecond = undefined

applyMappendError :: Monoid e =>
                     (Validation e) (a -> b)
                  -> (Validation e) a
                  -> (Validation e) b
applyMappendError = undefined


instance (Eq e, Eq a) => EqProp (Validation e a) where
    (=-=) = eq

instance (Eq a, Eq b) => EqProp (Sum' a b) where
    (=-=) = eq

instance (Arbitrary e, Arbitrary a) => Arbitrary (Validation e a) where
  arbitrary = genValidation

genValidation :: (Arbitrary e, Arbitrary a) => Gen (Validation e a)
genValidation = do
  e <- arbitrary
  a <- arbitrary
  elements [Error e, Success a]

main :: IO ()
main = let sum' = undefined :: Sum' String (String, String, String)
           validation = undefined :: Validation String (String, String, String)
           ziplist = undefined :: ZipList' (String, String, String)
       in do putStrLn "Testing applicative for sum"
             quickBatch (applicative sum')
             putStrLn "Testing applicative for validation"
             quickBatch (applicative validation)
             putStrLn "Testing applicative for ZipList"
             quickBatch (applicative ziplist)
