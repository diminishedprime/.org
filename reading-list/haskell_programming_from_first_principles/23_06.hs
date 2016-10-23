{-# LANGUAGE InstanceSigs #-}
newtype Moi s a = Moi { runMoi :: s -> (a, s) }

-- State Functor
-- Implement the Functor instance for State.

instance Functor (Moi s) where
  fmap :: (a -> b) -> Moi s a -> Moi s b
  fmap f (Moi g) = Moi $ \s -> let (a, s2) = g s
                               in (f a, s2)

-- Prelude> runMoi ((+1) <$> (Moi $ \s -> (0, s))) 0
-- (1,0)

-- State Applicative
-- Write the Applicative instance for State.
instance Applicative (Moi s) where
  pure :: a -> Moi s a
  pure a = Moi $ \s -> (a, s)
  (<*>) :: Moi s (a -> b) -> Moi s a -> Moi s b
  (Moi f) <*> (Moi g) = Moi $ \s -> let (fab, s2) = f s
                                        (a, _) = g s
                                    in (fab a, s2)

-- State Monad
-- Write the Monad instance for State.
instance Monad (Moi s) where
  return = pure
  (>>=) :: Moi s a -> (a -> Moi s b) -> Moi s b
  (Moi f) >>= g = Moi $ \s -> let (a, s2) = f s
                                  (Moi sb) = g a
                              in sb s
