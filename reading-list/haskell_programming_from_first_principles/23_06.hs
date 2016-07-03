{-# LANGUAGE InstanceSigs #-}
newtype Moi s a = Moi { runMoi :: s -> (a, s) }

-- State Functor
-- Implement the Functor instance for State.

instance Functor (Moi s) where
  -- The Moi g here is of type s -> (a, s)
  --                           a -> b
  fmap :: (a -> b) -> Moi s a -> Moi s b
  fmap f (Moi g) = Moi

-- Prelude> runMoi ((+1) <$> (Moi $ \s -> (0, s))) 0 (1,0)
