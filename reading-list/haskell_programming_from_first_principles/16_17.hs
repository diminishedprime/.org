{-# LANGUAGE FlexibleInstances #-}

import GHC.Arr

-- 16.17 Chapter exercises

-- Determine if a valid Functor can be written for the datatype provided.
-- 1.
data Bool =
  False | True
-- Nope, wrong kind (*)

-- 2.
data BoolAndSomethingElse a =
  False' a | True' a

-- Yep, right kind.

-- 3.
data BoolAndMaybeSomethingElse a =
  Falsish | Truish a

-- Yep, right kind.

-- 4. Use the kinds to guide you on this one, don’t get too hung up on the details.
newtype Mu f = InF { outF :: f (Mu f) }

-- Yep, right kind (I think)

-- 5. Again, just follow the kinds and ignore the unfamiliar parts
data D = D (Array Word Word) Int Int

-- Nope, wrong kind

-- Rearrange the arguments to the type constructor of the datatype so the
-- Functor instance works.
-- 1.
data Sum a b = First a
             | Second b

instance Functor (Sum e) where
  fmap f (First a) = First a
  fmap f (Second b) = Second $ f b

-- 2.
data Company a b c = DeepBlue a c
                   | Something b

instance Functor (Company e e') where
  fmap _ (Something b) = Something b
  fmap f (DeepBlue a c) = DeepBlue a $ f c

-- 3.
data More b a = L a b a
              | R b a b
  deriving (Eq, Show)

instance Functor (More x) where
  fmap f (L a b a') = L (f a) b (f a')
  fmap f (R b a b') = R b (f a) b'

-- Write Functor instances for the following datatypes.
-- 1.
data Quant a b = Finance
               | Desk a
               | Bloor b

instance Functor (Quant a) where
  fmap _ Finance = Finance
  fmap _ (Desk a) = Desk a
  fmap f (Bloor b) = Bloor $ f b

-- 2. No, it’s not interesting by itself.
data K a b = K a

instance Functor (K a) where
  fmap _ (K a) = K a

-- 3.
newtype Flip f a b = Flip (f b a)
  deriving (Eq, Show)

newtype K' a b = K' a

instance Functor (Flip K' a) where
  fmap f (Flip (K' a)) = Flip $ K' (f a)

-- 4.
data EvilGoateeConst a b = GoatyConst b
  deriving (Show)

instance Functor (EvilGoateeConst a) where
  fmap f (GoatyConst b) = GoatyConst $ f b

-- 5. Do you need something extra to make the instance work?
data LiftItOut f a = LiftItOut (f a)
  deriving (Show)

instance Functor f => Functor (LiftItOut f) where
  fmap f (LiftItOut f') = LiftItOut $ fmap f f'

-- 6.
data Parappa f g a = DaWrappa (f a) (g a)

instance (Functor f, Functor g) => Functor (Parappa f g) where
  fmap f (DaWrappa f' g') = DaWrappa (fmap f f') (fmap f g')

-- 7. Don’t ask for more typeclass instances than you need. You can let GHC tell you what to do.
data IgnoreOne f g a b = IgnoringSomething (f a) (g b)

instance (Functor f, Functor g) => Functor (IgnoreOne f g a) where
  fmap f (IgnoringSomething f' g') = IgnoringSomething f' (fmap f g')

-- 8.
data Notorious g o a t = Notorious (g o) (g a) (g t)

instance (Functor g) => Functor (Notorious g o a) where
  fmap f (Notorious o' a' t') = Notorious o' a' (fmap f t')

-- 9. You’ll need to use recursion.
data List a = Nil
            | Cons a (List a)
  deriving Show

instance Functor List where
  fmap _ Nil = Nil
  fmap f (Cons a b) = Cons (f a) (fmap f b)

-- 10. A tree of goats forms a Goat-Lord, fearsome poly-creature.
data GoatLord a = NoGoat
                | OneGoat a
                | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)

instance Functor GoatLord where
  fmap _ NoGoat = NoGoat
  fmap f (OneGoat a) = OneGoat $ f a
  fmap f (MoreGoats a b c) = MoreGoats (fmap f a) (fmap f b) (fmap f c)

-- 11. You’ll use an extra functor for this one, although your solution might do
-- it monomorphically without using fmap
data TalkToMe a = Halt
                | Print String a
                | Read (String -> a)

instance Functor TalkToMe where
  fmap _ Halt = Halt
  fmap f (Print a a') = Print a (f a')
  fmap f (Read a) = Read (fmap f a)
