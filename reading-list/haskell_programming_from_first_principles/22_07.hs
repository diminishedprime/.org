{-# LANGUAGE InstanceSigs #-}
import Control.Monad (join)

newtype Reader r a =
  Reader { runReader :: r -> a }

instance Functor (Reader r) where
  fmap f (Reader r) = Reader $ f . r

instance Applicative (Reader r) where
  pure :: a -> Reader r a
  pure a = Reader $ \r -> a

  (<*>) :: Reader r (a -> b)
        -> Reader r a
        -> Reader r b
  (Reader rab) <*> (Reader ra) = Reader $ \r -> rab r (ra r)

-- Exercise: Reader Monad
-- 1. Implement the Reader Monad. Don't forget instancesigs.
instance Monad (Reader r) where
  return = pure
  (>>=) :: Reader r a
        -> (a -> Reader r b)
        -> Reader r b
  (Reader ra) >>= aRb = join $ Reader $ \r -> aRb (ra r)

-- Hint: constrast the type with the Applicative instance and perform the most
-- obvious change you can imagine to make it work.

-- 2. Rewrite the monadic getDogRM to use your Reader datatype.

newtype HumanName = HumanName String deriving (Eq, Show)
newtype DogName = DogName String deriving (Eq, Show)
newtype Address = Address String deriving (Eq, Show)

data Person = Person { humanName :: HumanName , dogName :: DogName
                     , address :: Address
                     } deriving (Eq, Show)

data Dog = Dog { dogsName :: DogName
               , dogsAddress :: Address } deriving (Eq, Show)


getDogRm :: Person -> Dog
getDogRm = do
  name <- dogName
  addy <- address
  return $ Dog name addy
