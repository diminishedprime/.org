newtype StateT s m a = StateT { runStateT :: s -> m (a,s) }

-- Exercises: StateT

-- If you’re familiar with the distinction, you’ll be implementing the strict
-- variant of StateT here. To make the strict variant, you don’t have to do
-- anything special. Just write the most obvious thing that could work. The lazy
-- (lazier, anyway) variant is the one that involves adding a bit extra. We’ll
-- explain the difference in the chapter on nonstrictness.

-- 1. You’ll have to do the Functor and Applicative instances first, because
-- there aren’t Functor and Applicative instances ready to go for the type

-- Monad m => s -> m (a, s)

instance (Functor m) => Functor (StateT s m) where
  fmap f (StateT smas) = StateT $ \s ->
                                    (\(a, s') -> (f a, s')) <$> (smas s)


-- 2. As with Functor, you can’t cheat and re-use an underlying Applicative
-- instance, so you’ll have to do the work with the s -> m (a, s) type yourself.

instance (Monad m) => Applicative (StateT s m) where
  pure a = StateT $ \s -> return (a, s)
  (StateT fab) <*> (StateT fa) = StateT $ \s -> do (f, s') <- fab s
                                                   (a, s'') <- fa s'
                                                   return (f a, s'')


-- Also note that the constraint on m is not Applicative as you expect, but
-- rather Monad. This is because you can’t express the order-dependent
-- computation you’d expect the StateT Applicative to have without having a
-- Monad for m. In essence, the issue is that without Monad, you’re just feeding
-- the initial state to each computation in StateT rather than threading it
-- through as you go. This is a general pattern contrasting Applicative and
-- Monad and is worth contemplating.

-- 3. The Monad instance should look fairly similar to the Monad instance you
-- wrote for ReaderT.

instance (Monad m) => Monad (StateT s m) where
  return = pure
  (StateT ma) >>= f = StateT $ \s -> do (a, s') <- ma s
                                        (runStateT (f a)) s
