import Control.Applicative
import Data.Monoid hiding (Sum, First)
import Test.QuickCheck hiding (Success)
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes

-- 17.9 Chapter Exercises

-- Given a type that has an instance of Applicative, specialize the types of the
-- methods. Test your specialization in the REPL.

-- 1. Type
-- []

-- Methods
--pure :: a -> [] a
--(<*>) :: [] (a -> b) -> [] a -> [] b

-- 2. Type
-- IO
-- Methods
-- pure ::a -> IO a
-- (<*>) :: IO (a -> b) -> IO a -> IO b

-- 3. Type
-- (,) a
-- Methods
--pure :: a -> (a,a)
--(<*>) :: (a,(a -> b)) -> (a,a) -> (a,b)

-- 4. Type
-- (->) e
-- Methods
-- pure :: a -> (a ->) a
-- (<*>) :: (a ->) (a -> b) -> (a ->) a -> (a ->) b

-- Write applicative instances for the following datatypes. Confused? Write out
-- what the type should be. Use the checkers library to validate the instances.

-- 1.
newtype Identity a = Identity a
  deriving (Show, Eq)

instance Functor Identity where
  fmap f (Identity a) = Identity $ f a

instance Applicative Identity where
  pure = Identity
  (Identity f) <*> (Identity a) = Identity $ f a

instance Eq a => EqProp (Identity a) where
  (=-=) = eq

instance Arbitrary a => Arbitrary (Identity a) where
  arbitrary = genId
    where genId :: Arbitrary a => Gen (Identity a)
          genId = do
            a <- arbitrary
            return $ Identity a

-- 2.
data Pair a = Pair a a
  deriving (Show, Eq)

instance Functor Pair where
  fmap f (Pair a a') = Pair (f a) (f a')

instance Applicative Pair where
  pure a = Pair a a
  (Pair f f') <*> (Pair a a') = Pair (f a) (f' a')

instance Eq a => EqProp (Pair a) where
  (=-=) = eq

instance Arbitrary a => Arbitrary (Pair a) where
  arbitrary = genPair
    where genPair :: Arbitrary a => Gen (Pair a)
          genPair = do
            a <- arbitrary
            a' <- arbitrary
            return $ Pair a a'

-- 3. This should look familiar.
data Two a b = Two a b
  deriving (Show, Eq)

instance Functor (Two a) where
  fmap f (Two a b) = Two a $ f b

instance Monoid a => Applicative (Two a) where
  pure = Two mempty
  (Two m f) <*> (Two m' a) = Two (m <> m') (f a)

instance (Eq a, Eq b) => EqProp (Two a b) where
  (=-=) = eq

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = genTwo
    where genTwo :: (Arbitrary a, Arbitrary b) => Gen (Two a b)
          genTwo = do
            a <- arbitrary
            b <- arbitrary
            return $ Two a b

-- 4.
data Three a b c = Three a b c
  deriving (Show, Eq)

instance Functor (Three a b) where
  fmap f (Three a b c) = Three a b $ f c

instance (Monoid a, Monoid b) => Applicative (Three a b) where
  pure = Three mempty mempty
  (Three m m2 f) <*> (Three m' m2' a) = Three (m <> m') (m2 <> m2') (f a)

instance (Eq a, Eq b, Eq c) => EqProp (Three a b c) where
  (=-=) = eq

instance (Arbitrary a, Arbitrary b, Arbitrary c) => Arbitrary (Three a b c) where
  arbitrary = genThree
    where genThree = do
            a <- arbitrary
            b <- arbitrary
            c <- arbitrary
            return $ Three a b c

-- 5.
data Three' a b = Three' a b b
  deriving (Eq, Show)

instance Functor (Three' a) where
  fmap f (Three' a b b') = Three' a (f b) (f b')

instance (Monoid a) => Applicative (Three' a) where
  pure a = Three' mempty a a
  (Three' m f f') <*> (Three' m' a a') = Three' (m <> m') (f a) (f' a')

instance (Eq a, Eq b) => EqProp (Three' a b) where
  (=-=) = eq

instance (Arbitrary a, Arbitrary b) => Arbitrary (Three' a b) where
  arbitrary = genThree'
    where genThree' = do
            a <- arbitrary
            b <- arbitrary
            c <- arbitrary
            return $ Three' a b c

-- 6.
data Four a b c d = Four a b c d
  deriving (Eq, Show)

instance Functor (Four a b c) where
  fmap f (Four a b c d) = Four a b c $ f d

instance (Monoid a, Monoid b, Monoid c) => Applicative (Four a b c) where
  pure = Four mempty mempty mempty
  (Four m m2 m3 f) <*> (Four m' m2' m3' a) = Four (m <> m') (m2 <> m2') (m3 <> m3') (f a)

instance (Eq a, Eq b, Eq c, Eq d) => EqProp (Four a b c d) where
  (=-=) = eq

instance (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) => Arbitrary (Four a b c d) where
  arbitrary = genFour
    where genFour = do
            a <- arbitrary
            b <- arbitrary
            c <- arbitrary
            d <- arbitrary
            return $ Four a b c d

-- 7. data Four' a b = Four' a a

data Four' a b = Four' a a a b
  deriving (Eq, Show)

instance Functor (Four' a) where
  fmap f (Four' a b c d) = Four' a b c (f d)

instance Monoid a => Applicative (Four' a) where
  pure = Four' mempty mempty mempty
  (Four' ma mb mc f) <*> (Four' ma' mb' mc' x) = Four' (ma <> ma') (mb <> mb') (mc <> mc') (f x)

instance (Eq a, Eq b) => EqProp (Four' a b) where
  (=-=) = eq

instance (Arbitrary a, Arbitrary b) => Arbitrary (Four' a b) where
  arbitrary = genFour'
    where genFour' = do
            a <- arbitrary
            b <- arbitrary
            c <- arbitrary
            d <- arbitrary
            return $ Four' a b c d

main :: IO ()
main = do quickBatch (applicative (undefined :: Identity (Int, Int, Int)))
          quickBatch (applicative (undefined :: Pair (Int, Int, Int)))
          quickBatch (applicative (undefined :: Two String (Int, Int, Int)))
          quickBatch (applicative (undefined :: Three String String (Int, Int, Int)))
          quickBatch (applicative (undefined :: Three' String (Int, Int, Int)))
          quickBatch (applicative (undefined :: Four String String [Int] (Int, Int, Int)))
          quickBatch (applicative (undefined :: Four' [Int] (Int, Int, Int)))

-- Combinations

-- Remember the vowels and stops exercise in folds? Reimplement the combos
-- function using liftA3 from Control.Applicative.

stops, vowels :: String
stops = "pbtdkg"
vowels = "aeiou"

combos :: [a] -> [b] -> [c] -> [(a, b, c)]
combos = liftA3 (, ,)
