{-# LANGUAGE InstanceSigs #-}
import Test.QuickCheck hiding (Success)
import Test.QuickCheck.Checkers
import Test.QuickCheck.Classes

-- 1. Write liftA2 yourself. Think about it in terms of abstracting out the
-- difference between getDogR and getDogR' if that helps.
myLiftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
myLiftA2 f a b= f <$> a <*> b


-- 2. Write the following function. Again, it is simpler than it looks.
asks :: (r -> a) -> Reader r a
asks f = Reader f

-- 3. Implement the Applicative for Reader.

-- To write the Applicative instance for Reader, we’ll use a pragma called
-- InstanceSigs. It’s an extension we need in order to assert a type for the
-- typeclass methods. You ordinarily cannot assert type signatures in instances.
-- The compiler already knows the type of the functions, so it’s not usually
-- necessary to assert the types in instances anyway. We did this for the sake
-- of clarity, to make the Reader type explicit in our signatures.

-- Some instructions and hints.

-- a) When writing the pure function for Reader, remember that what you’re
-- trying to construct is a function that takes a value of type r, which you
-- know nothing about, and return a value of type a. Given that you’re not
-- really doing anything with r, there’s really only one thing you can do.

-- b) We got the definition of the apply function started for you, we’ll
-- describe what you need to do and you write the code. If you unpack the type
-- of Reader’s apply above, you get the following.

-- <*> :: (r -> a -> b) -> (r -> a) -> (r -> b)
-- contrast this with the type of fmap
-- fmap :: (a -> b) -> (r -> a) -> (r -> b)

-- So what’s the difference? The difference is that with apply, unlike fmap,
-- also takes an argument of type r.

-- Make it so.

newtype Reader r a = Reader { runReader :: r -> a }
  deriving (Show)

instance Functor (Reader r) where
  fmap f (Reader ra) = Reader (f . ra)

instance Applicative (Reader r) where
  pure :: a -> Reader r a
  pure a = Reader $ const a

  (<*>) :: Reader r (a -> b) -> Reader r a -> Reader r b
  (<*>) (Reader rab) (Reader ra) = Reader (\r -> rab r (ra r))

-- 4. Rewrite the above example that uses Dog and Person to use your Reader
-- datatype you just implemented the Applicative for. You’ll need to change the
-- types as well.

newtype HumanName = HumanName String deriving (Eq, Show)
newtype DogName = DogName String deriving (Eq, Show)
newtype Address = Address String deriving (Eq, Show)

data Person = Person { humanName :: HumanName
                     , dogName :: DogName
                     , address :: Address }
            deriving (Eq, Show)

data Dog = Dog { dogsName :: DogName
               , dogsAddress :: Address }
         deriving (Eq, Show)

getDogR :: Reader Person Dog
getDogR = Reader $ Dog <$> dogName <*> address
