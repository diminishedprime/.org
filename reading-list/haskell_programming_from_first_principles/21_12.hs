-- import Data.Traversable
-- import Data.Foldable
-- import Control.Applicative
import Data.Monoid
import Test.QuickCheck hiding (Success)
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes


-- Traversable instances

-- Write a Traversable instance for the datatype provided, filling in any
-- required superclasses. Use QuickCheck to validate your instances.

-- Identity
-- Write a Traversable instance for Identity.
newtype Identity a = Identity a
  deriving (Eq, Ord, Show)

instance Functor Identity where
  f `fmap` (Identity a) = Identity $ f a

instance Foldable Identity where
  foldMap f (Identity a) = f a

instance Traversable Identity where
  traverse f (Identity a) = Identity <$> f a

instance (Arbitrary a) => Arbitrary (Identity a) where
  arbitrary = do a <- arbitrary
                 return $ Identity a

instance (Eq a) => EqProp (Identity a) where
  (=-=) = eq

-- Constant
newtype Constant a b = Constant { getConstant :: a }
  deriving (Eq, Ord, Show)

instance Functor (Constant a) where
  fmap f (Constant a) = Constant a

instance Foldable (Constant a) where
  foldMap _ (Constant _) = mempty

instance Traversable (Constant a) where
  traverse _ (Constant a) = pure $ Constant a

instance (Arbitrary a) => Arbitrary (Constant a b) where
  arbitrary = do b <- arbitrary
                 return $ Constant b

instance (Eq a) => EqProp (Constant a b) where
  (=-=) = eq

-- Maybe
data Optional a = Nada | Yep a
  deriving (Eq, Ord, Show)

instance Functor Optional where
  f `fmap` Yep a = Yep $ f a
  _ `fmap` Nada = Nada

instance Foldable Optional where
  foldMap f (Yep a) = f a
  foldMap _ Nada = mempty

instance Traversable Optional where
  traverse f (Yep a) = Yep <$> f a
  traverse _ Nada = pure Nada

instance (Arbitrary a) => Arbitrary (Optional a) where
  arbitrary = frequency [ (2, genYep)
                        , (1, return Nada)]
    where genYep = do a <- arbitrary
                      return $ Yep a

instance (Eq a) => EqProp (Optional a) where
  (=-=) = eq

-- List
data List a = Nil | Cons a (List a)
  deriving (Eq, Show, Ord)

instance Functor List where
  f `fmap` (Cons a b) = Cons (f a) (f <$> b)
  _ `fmap` Nil = Nil

instance Foldable List where
  foldMap f (Cons a b) = f a <> foldMap f b
  foldMap _ Nil = mempty

instance Traversable List where
  traverse _ Nil = pure Nil
  traverse f (Cons a b) = Cons <$> f a <*> traverse f b

instance Arbitrary a => Arbitrary (List a) where
  arbitrary = do h <- arbitrary
                 t <- arbitrary
                 frequency [ (3, return $ Cons h t)
                           , (1, return Nil)]
takeList :: Int -> List a -> List a
takeList _ Nil = Nil
takeList n (Cons a as)
            | n > 0 = Cons a (takeList (n-1) as)
            | otherwise = Nil

instance Eq a => EqProp (List a) where
  xs =-= ys = takeList 10 xs `eq` takeList 10 ys

-- Three
data Three a b c = Three a b c
  deriving (Eq, Show, Ord)

instance Functor (Three a b) where
  f `fmap` (Three a b c) = Three a b $ f c

instance Foldable (Three a b) where
  foldMap f (Three _ _ c) = f c

instance Traversable (Three a b) where
  traverse f (Three a b c) = Three a b <$> f c

instance (Arbitrary a, Arbitrary b, Arbitrary c) => Arbitrary (Three a b c) where
  arbitrary = do a <- arbitrary
                 b <- arbitrary
                 c <- arbitrary
                 return $ Three a b c

instance (Eq a, Eq b, Eq c) => EqProp (Three a b c) where
  (=-=) = eq

-- Three’
data Three' a b = Three' a b b
  deriving (Show, Eq)

instance Functor (Three' a) where
  f `fmap` (Three' a b b') = Three' a (f b) (f b')

instance Foldable (Three' a) where
  foldMap f (Three' _ b b') = f b <> f b'

instance Traversable (Three' a) where
  traverse f (Three' a b b') = Three' a <$> f b <*> f b'

instance (Arbitrary a, Arbitrary b) => Arbitrary (Three' a b) where
  arbitrary = do a <- arbitrary
                 b <- arbitrary
                 b' <- arbitrary
                 return $ Three' a b b'

instance (Eq a, Eq b) => EqProp (Three' a b) where
  (=-=) = eq

-- S
-- This’ll suck.
data S n a = S (n a) a deriving (Eq, Show)
-- -- to make it easier, we'll give you the constraints.

instance Functor n => Functor (S n) where
  f `fmap` (S as a) = S (f <$> as) (f a)

instance Foldable n => Foldable (S n) where
  foldMap f (S as a) = foldMap f as <> f a

instance Traversable n => Traversable (S n) where
  traverse f (S as a) = S <$> traverse f as <*> f a

instance (Arbitrary a, Arbitrary (n a)) => Arbitrary (S n a) where
  arbitrary = do n <- arbitrary
                 a <- arbitrary
                 return $ S n a

instance (Eq a, Eq (n a)) => EqProp (S n a) where
  (=-=) = eq


-- Instances for Tree
-- This might be hard. Write the following instances for Tree.
data Tree a = Empty
            | Leaf a
            | Node (Tree a) a (Tree a)
  deriving (Eq, Show)

instance Functor Tree where
  _ `fmap` Empty = Empty
  f `fmap` Leaf a = Leaf $ f a
  f `fmap` Node l a r = Node (f <$> l) (f a) (f <$> r)

instance Foldable Tree where
  foldMap _ Empty = mempty
  foldMap f (Leaf a) = f a
  foldMap f (Node l a r) = foldMap f l <> f a <> foldMap f r

instance Traversable Tree where
  traverse _ Empty = pure Empty
  traverse f (Leaf a) = Leaf <$> f a
  traverse f (Node l a r) = Node <$> traverse f l <*> f a <*> traverse f r

instance (Arbitrary a) => Arbitrary (Tree a) where
  arbitrary = frequency [ (4, return Empty)
                        , (2, genLeaf)
                        , (1, genNode)]
              where genLeaf = do a <- arbitrary
                                 return $ Leaf a
                    genNode = do l <- arbitrary
                                 a <- arbitrary
                                 r <- arbitrary
                                 return $ Node l a r

instance (Eq a) => EqProp (Tree a) where
  (=-=) = eq

main :: IO ()
main = do putStr "Traversable for Identity"
          quickBatch (traversable (undefined :: Identity (Int, Int, [Int])))
          putStr "Traversable for Constant"
          quickBatch (traversable (undefined :: Constant String (Int, Int, [Int])))
          putStr "Traversable for Optional"
          quickBatch (traversable (undefined :: Optional (Int, Int, [Int])))
          putStr "Traversable for List"
          quickBatch (traversable (undefined :: List (Int, Int, [Int])))
          putStr "Traversable for Three"
          quickBatch (traversable (undefined :: Three String String (Int, Int, [Int])))
          putStr "Traversable for Three'"
          quickBatch (traversable (undefined :: Three' String (Int, Int, [Int])))
          putStr "Traversable for S"
          quickBatch (traversable (undefined :: S [] (Int, Int, [Int])))
          putStr "Traversable for Tree"
          quickBatch (traversable (undefined :: Tree (Int, Int, [Int])))
