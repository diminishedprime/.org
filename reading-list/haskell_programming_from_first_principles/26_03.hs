newtype EitherT e m a = EitherT { runEitherT :: m (Either e a) }

-- Exercises: EitherT

-- 1. Write the Functor instance for EitherT:
instance Functor m => Functor (EitherT e m) where
  fmap f (EitherT em) = EitherT $ (fmap . fmap) f em

-- 2. Write the Applicative instance for EitherT:
instance Applicative m => Applicative (EitherT e m) where
  pure = EitherT . pure . pure
  (EitherT fem) <*> (EitherT em) = EitherT $ (<*>) <$> fem <*> em

-- 3. Write the Monad instance for EitherT:
instance Monad m => Monad (EitherT e m) where
  return = pure
  (EitherT em) >>= f = EitherT $ do val <- em
                                    case val of
                                      (Left a) -> return $ Left a
                                      (Right a) -> runEitherT $ f a


-- 4. Write the swapEitherT helper function for EitherT.

-- transformer version of swapEither.
swapEither :: Either a b -> Either b a
swapEither (Left a) = (Right a)
swapEither (Right a) = (Left a)

swapEitherT :: (Functor m) => EitherT e m a -> EitherT a m e
swapEitherT (EitherT ema) = EitherT $ swapEither <$> ema

-- 5. Write the transformer variant of the either catamorphism.
eitherT :: Monad m => (a -> m c) -> (b -> m c) -> EitherT a m b -> m c
eitherT fa fb (EitherT amb) = do v <- amb
                                 case v of
                                   (Left a) -> fa a
                                   (Right b) -> fb b
