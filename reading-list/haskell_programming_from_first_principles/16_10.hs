import Test.QuickCheck
import Test.QuickCheck.Function

functorIdentity :: (Functor f, Eq (f a)) =>
                   f a
                -> Bool
functorIdentity f = fmap id f == f

functorCompose :: (Eq (f c), Functor f) =>
                  f a ->
                  Fun a b ->
                  Fun b c ->
                  Bool
functorCompose x (Fun _ f) (Fun _ g) = (fmap (g . f) x) == (fmap g . fmap f $ x)

-- Implement Functor instances for the following datatypes. Use the QuickCheck
-- properties we just showed you to validate them.

--1.
newtype Identity a = Identity a
  deriving (Eq, Show)

instance Functor Identity where
  fmap f (Identity a) = Identity $ f a

instance Arbitrary a => Arbitrary (Identity a) where
  arbitrary = fmap Identity arbitrary

-- 2.
data Pair a = Pair a a
  deriving (Eq, Show)

instance Functor Pair where
  fmap f (Pair a b) = Pair (f a) (f b)

instance Arbitrary a => Arbitrary (Pair a) where
  arbitrary = do a <- arbitrary
                 a' <- arbitrary
                 return $ Pair a a'

--3.
data Two a b = Two a b
  deriving (Eq, Show)

instance Functor (Two a) where
  fmap f (Two a b) = Two a (f b)

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = do a <- arbitrary
                 b <- arbitrary
                 return $ Two a b

--4.
data Three a b c = Three a b c
  deriving (Eq, Show)

instance Functor (Three a b) where
  fmap f (Three a b c) = Three a b (f c)

instance (Arbitrary a, Arbitrary b, Arbitrary c) => Arbitrary (Three a b c) where
  arbitrary = do a <- arbitrary
                 b <- arbitrary
                 c <- arbitrary
                 return $ Three a b c
-- 5.
data Three' a b = Three' a b b
  deriving (Eq, Show)

instance Functor (Three' a) where
  fmap f (Three' a b b') = Three' a (f b) (f b')

instance (Arbitrary a, Arbitrary b) => Arbitrary (Three' a b) where
  arbitrary = do a <- arbitrary
                 b <- arbitrary
                 b' <- arbitrary
                 return $ Three' a b b'

-- 6.
data Four a b c d = Four a b c d
  deriving (Eq, Show)

instance Functor (Four a b c) where
  fmap f (Four a b c d) = Four a b c (f d)

instance (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) =>
  Arbitrary (Four a b c d) where
  arbitrary = do a <- arbitrary
                 b <- arbitrary
                 c <- arbitrary
                 d <- arbitrary
                 return $ Four a b c d

-- 7.
data Four' a b = Four' a a a b
  deriving (Eq, Show)

instance Functor (Four' a) where
  fmap f (Four' a a' a'' b) = Four' a a' a'' (f b)

instance (Arbitrary a, Arbitrary b) => Arbitrary (Four' a b) where
  arbitrary = do a <- arbitrary
                 a' <- arbitrary
                 a'' <- arbitrary
                 b <- arbitrary
                 return $ Four' a a' a'' b

-- 8. Can you implement one for this type? Why? Why not?
data Trivial = Trivial
-- I can't because it's not kinded highly enough

main :: IO ()
main = do
  putStrLn "Checking Identity Functor"
  quickCheck (functorIdentity :: Identity String -> Bool)
  quickCheck (functorCompose :: Identity String ->
                                Fun String Int ->
                                Fun Int String ->
                                Bool)

  putStrLn "Checking Pair Functor"
  quickCheck (functorIdentity :: Pair String -> Bool)
  quickCheck (functorCompose :: Pair String ->
                                Fun String Int ->
                                Fun Int String ->
                                Bool)

  putStrLn "Checking Two Functor"
  quickCheck (functorIdentity :: Two Int String -> Bool)
  quickCheck (functorCompose :: Two Int String ->
                                Fun String Int ->
                                Fun Int String ->
                                Bool)

  putStrLn "Checking Three Functor"
  quickCheck (functorIdentity :: Three Double Int String -> Bool)
  quickCheck (functorCompose :: Three Double Int String ->
                                Fun String Int ->
                                Fun Int String ->
                                Bool)

  putStrLn "Checking Three' Functor"
  quickCheck (functorIdentity :: Three' Int String -> Bool)
  quickCheck (functorCompose :: Three' Int String ->
                                Fun String Int ->
                                Fun Int String ->
                                Bool)

  putStrLn "Checking Four Functor"
  quickCheck (functorIdentity :: Four Int Int Int String -> Bool)
  quickCheck (functorCompose :: Four Int Int Int String ->
                                Fun String Int ->
                                Fun Int String ->
                                Bool)

  putStrLn "Checking Four' Functor"
  quickCheck (functorIdentity :: Four' Int String -> Bool)
  quickCheck (functorCompose :: Four' Int String ->
                                Fun String Int ->
                                Fun Int String ->
                                Bool)
