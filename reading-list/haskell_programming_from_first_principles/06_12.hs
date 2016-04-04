-- 1. It’s not a typo, we’re just being cute with the name.
data TisAnInteger = TisAn Integer
instance Eq TisAnInteger where
  (==) (TisAn a) (TisAn b) = a == b
--2.
data TwoIntegers = Two Integer Integer
instance Eq TwoIntegers where
  (==) (Two a b) (Two a' b') =
    a == a' && b == b'
-- 3.
data StringOrInt = TisAnInt Int | TisAString String
instance Eq StringOrInt where
  (==) (TisAnInt _) (TisAString _) = False
  (==) (TisAnInt a) (TisAnInt a') = a == a'
  (==) (TisAString a) (TisAString a') = a == a'
-- 4.
data Pair a = Pair a a
instance (Eq a) => Eq (Pair a) where
  (==) (Pair a b) (Pair a' b') = a == a' && b == b'
-- 5.
data Tuple a b = Tuple a b
instance (Eq a, Eq b) => Eq (Tuple a b) where
  (==) (Tuple a b) (Tuple a' b') = a == a' && b == b'
-- 6.
data Which a = ThisOne a | ThatOne a
instance Eq a => Eq (Which a) where
  (==) (ThisOne a) (ThatOne a') = a == a'
  (==) (ThisOne a) (ThisOne a') = a == a'
  (==) (ThatOne a) (ThatOne a') = a == a'
-- 7.
data EitherOr a b = Hello a | Goodbye b
instance (Eq a, Eq b) => Eq (EitherOr a b) where
  (==) (Hello _) (Goodbye _) = False
  (==) (Hello a) (Hello a') = a == a'
  (==) (Goodbye a) (Goodbye a') = a == a'
