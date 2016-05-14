-- Write a Functor instance for a datatype identical to Maybe. We’ll use our own
-- datatype because Maybe already has a Functor instance and we cannot make a
-- duplicate one.

data Possibly a = LolNope
                | Yeppers a deriving (Eq, Show)

instance Functor Possibly where
  fmap _ LolNope = LolNope
  fmap f (Yeppers a) = Yeppers $ f a

-- Short Exercise

-- 1. Write a Functor instance for a datatype identical to Either. We’ll use our
-- own datatype because Either also already has a Functor instance.
data Sum a b = First a
             | Second b
  deriving (Eq, Show)

instance Functor (Sum a) where
  fmap _ (First a) = First a
  fmap f (Second b) = Second $ f b

-- 2. Why is a Functor instance that applies the function only to First,
-- Either’s Left, impossible? We covered this earlier.

-- It's impossible because then we'd be changing the structure. (Sum a) is of
-- kind * so Sum is of kind * -> *
