{-# LANGUAGE InstanceSigs #-}
import Control.Monad.Trans.State hiding (modify, get, put, exec, eval)
--  Chapter exercises
-- Write the following functions

-- 1. Construct a State where the state is also the value you return.
get :: State s s
get = state $ \x -> (x, x)

-- Expected output
--      Prelude> runState get "curryIsAmaze"
--      ("curryIsAmaze","curryIsAmaze")

-- 2. Construct a State where the resulting state is the argument provided and
-- the value is defaulted to unit.
put :: s -> State s ()
put s = state $ \x -> ((), s)
-- runState (put "blah") "woot"
-- ((),"blah")

-- 3. Run the State with s and get the state that results.
-- exec :: State s a -> s -> s
-- exec (State sa) s = snd (sa s)

-- exec (put "wilma") "daphne"
-- "wilma"
-- exec get "scooby papu"
-- "scooby papu"

-- 4. Run the State with s and get the value that results.
-- eval :: State s a -> s -> a
-- eval (State sa) s = fst (sa s)
-- eval get "bunnicula"
-- "bunnicula"
-- eval get "stake a bunny"
-- "stake a bunny"

-- 5. Write a function which applies a function to create a new State.
modify :: (s -> s) -> State s ()
modify f = state $ \s -> ((), f s)

-- Should behave like the following:
-- nrunState (modify (+1)) 0
-- ((),1)
-- runState (modify (+1) >> modify (+1)) 0
-- ((),2)

-- Note you don’t need to compose them, you can just throw away the result
-- because it returns unit for a anyway.
