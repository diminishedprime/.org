import Data.Semigroup
import Test.QuickCheck
-- Semigroup exercises

-- Given a datatype, implement the Semigroup instance. Add Semigroup constraints
-- to type variables where needed. Use the Semigroup class from the semigroups
-- library or write your own. When we use <>, we mean the infix mappend from the
-- Semigroup typeclass.

-- Note We’re not always going to derive every instance you may want or need in
-- the datatypes we provide for exercises. We expect you to know what you need
-- and to take care of it yourself by this point.

-- 1. Validate all of your instances with QuickCheck. Since Semigroup’s only law
-- is associativity, that’s the only property you need to reuse.

data Trivial = Trivial
  deriving (Eq, Show)

instance Semigroup Trivial where
  _ <> _ = Trivial

instance Arbitrary Trivial where
  arbitrary = return Trivial

semigroupAssoc :: (Eq m, Semigroup m) => m -> m -> m -> Bool
semigroupAssoc a b c = (a <> (b <> c)) == ((a <> b) <> c)

type TrivialAssoc = Trivial -> Trivial -> Trivial -> Bool

-- 2.
newtype Identity a = Identity a deriving (Show, Eq)

instance Semigroup a => Semigroup (Identity a) where
  (Identity x) <> (Identity y) = Identity (x <> y)

instance Arbitrary a => Arbitrary (Identity a) where
  arbitrary = fmap Identity arbitrary

type IdentityAssoc = Identity String -> Identity String -> Identity String -> Bool

-- 3.
data Two a b = Two a b deriving (Show, Eq)

instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where
  (Two a b) <> (Two a' b') = Two (a <> a') (b <> b')

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    return (Two a b)

type TwoAssoc = Two String String -> Two String String -> Two String String -> Bool

-- 4. data Three a b c = Three a b c
-- same pattern as Two

-- 5. data Four a b c d = Four a b c d
-- same pattern as Two

-- 6.
newtype BoolConj = BoolConj Bool deriving (Show, Eq)

instance Semigroup BoolConj where
  BoolConj a <> BoolConj a' = BoolConj (a && a')

instance Arbitrary BoolConj where
  arbitrary = frequency [ (1, return $ BoolConj True)
                        , (1, return $ BoolConj False)]

type BoolConjAssoc = BoolConj -> BoolConj -> BoolConj -> Bool

-- 7.
newtype BoolDisj = BoolDisj Bool deriving (Show, Eq)

instance Semigroup BoolDisj where
  BoolDisj a <> BoolDisj a' = BoolDisj (a || a')

instance Arbitrary BoolDisj where
  arbitrary = frequency [ (1, return $ BoolDisj True)
                        , (1, return $ BoolDisj False)]

type BoolDisjAssoc = BoolDisj -> BoolDisj -> BoolDisj -> Bool

-- 8.
data Or a b = Fst a
            | Snd b
  deriving (Show, Eq)

instance Semigroup (Or a b) where
  (Fst a) <> (Fst a') = Fst a'
  (Fst _) <> (Snd a) = Snd a
  (Snd a) <> _ = Snd a

instance (Arbitrary a, Arbitrary b) => Arbitrary (Or a b) where
  arbitrary = do a <- arbitrary
                 b <- arbitrary
                 elements [(Fst a), (Snd b)]

type OrAssoc = Or String Ordering -> Or String Ordering -> Or String Ordering -> Bool

-- 9.
newtype Combine a b =
  Combine { unCombine :: (a -> b) }

instance Semigroup b => Semigroup (Combine a b) where
  Combine {unCombine = f} <> Combine {unCombine = g} = Combine (f <> g)

-- What it should do:
--      Prelude> let f = Combine $ \n -> Sum (n + 1)
--      Prelude> let g = Combine $ \n -> Sum (n - 1)
--      Prelude> unCombine (f <> g) $ 0
--      Sum {getSum = 0}
--      Prelude> unCombine (f <> g) $ 1
--      Sum {getSum = 2}
--      Prelude> unCombine (f <> f) $ 1
--      Sum {getSum = 4}
--      Prelude> unCombine (g <> f) $ 1
--      Sum {getSum = 2}

-- 10.
newtype Comp a = Comp { unComp :: (a -> a) }

instance Semigroup (Comp a) where
  Comp {unComp = f} <> Comp {unComp = g} = Comp (f . g)

-- Hint: We can do something that seems a little more specific and natural to
-- functions now that the input and output types are the same.

-- 11. -- Look familiar?
data Validation a b = Failure' a
                    | Success' b
  deriving (Eq, Show)

instance Semigroup a => Semigroup (Validation a b) where
  Failure' a <> Failure' a' = Failure' (a <> a')
  Failure' a <> _ = Failure' a
  _ <> Failure' a = Failure' a
  a <> _ = a

instance (Arbitrary a, Arbitrary b) => Arbitrary (Validation a b) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    elements [(Success' a), (Failure' b)]

type ValidationAssoc = Validation String Ordering ->
                       Validation String Ordering ->
                       Validation String Ordering ->
                       Bool

-- 12. -- Validation with a Semigroup
--      -- that does something different
newtype AccumulateRight a b = AccumulateRight (Validation a b)
  deriving (Eq, Show)

instance Semigroup b => Semigroup (AccumulateRight a b) where
  AccumulateRight (Success' a) <> AccumulateRight (Success' a') =
    AccumulateRight $ Success' (a <> a')
  AccumulateRight (Failure' a) <> _ = AccumulateRight $ Failure' a
  _ <> AccumulateRight (Failure' a) = AccumulateRight $ Failure' a

instance (Arbitrary a, Arbitrary b) => Arbitrary (AccumulateRight a b) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    elements [(AccumulateRight (Success' a)), (AccumulateRight (Failure' b))]

type AccumulateRightAssoc = AccumulateRight String Ordering ->
                            AccumulateRight String Ordering ->
                            AccumulateRight String Ordering ->
                            Bool


-- 13. -- Validation with a Semigroup
     -- that does something more
newtype AccumulateBoth a b = AccumulateBoth (Validation a b)
  deriving (Eq, Show)

instance (Semigroup a, Semigroup b) => Semigroup (AccumulateBoth a b) where
  AccumulateBoth (Success' a) <> AccumulateBoth (Success' a') =
    AccumulateBoth $ Success' (a <> a')
  AccumulateBoth (Failure' a) <> AccumulateBoth (Failure' a') =
    AccumulateBoth $ Failure' (a <> a')
  _ <> AccumulateBoth (Failure' a) = AccumulateBoth $ Failure' a
  AccumulateBoth (Failure' a) <> _ = AccumulateBoth $ Failure' a

instance (Arbitrary a, Arbitrary b) => Arbitrary (AccumulateBoth a b) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    elements [(AccumulateBoth (Success' a)), (AccumulateBoth (Failure' b))]

type AccumulateBothAssoc = AccumulateBoth String Ordering ->
                           AccumulateBoth String Ordering ->
                           AccumulateBoth String Ordering ->
                           Bool

main :: IO ()
main = do
  quickCheck (semigroupAssoc :: TrivialAssoc)
  quickCheck (semigroupAssoc :: IdentityAssoc)
  quickCheck (semigroupAssoc :: TwoAssoc)
  quickCheck (semigroupAssoc :: BoolConjAssoc)
  quickCheck (semigroupAssoc :: OrAssoc)
  quickCheck (semigroupAssoc :: ValidationAssoc)
  quickCheck (semigroupAssoc :: AccumulateRightAssoc)
  quickCheck (semigroupAssoc :: AccumulateBothAssoc)
