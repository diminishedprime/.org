{-# LANGUAGE InstanceSigs #-}
import Control.Monad (join, liftM2)
-- Exercise: Reader Monad

-- 1. Implement the Reader Monad.
--      -- Don't forget instancesigs.
newtype Reader r a = Reader { runReader :: r -> a }

instance Functor (Reader r) where
  fmap f (Reader ra) = Reader (f . ra)

instance Applicative (Reader r) where
  pure a = Reader $ const a
  (Reader rab) <*> (Reader ra) = Reader $ \r -> (rab r) (ra r)

instance Monad (Reader r) where
  return = pure
  (>>=) :: Reader r a -> (a -> Reader r b) -> Reader r b
  (Reader ra) >>= aRb = Reader $ \r -> (runReader $ aRb (ra r)) r

-- Hint: constrast the type with the Applicative instance and perform the most
-- obvious change you can imagine to make it work.

 -- 2. Rewrite the monadic getDogRM to use your Reader datatype.
newtype HumanName = HumanName String deriving (Eq, Show)

newtype DogName = DogName String deriving (Eq, Show)

newtype Address = Address String deriving (Eq, Show)

data Person = Person { humanName :: HumanName
                     , dogName :: DogName
                     , address :: Address} deriving (Eq, Show)

data Dog = Dog { dogsName :: DogName
               , dogsAddress :: Address} deriving (Eq, Show)

getDogRM :: Reader Person Dog
getDogRM = do name <- dogName
              addy <- address
              return $ Dog name addy
