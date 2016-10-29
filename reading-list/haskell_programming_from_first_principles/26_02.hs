newtype MaybeT m a = MaybeT { runMaybeT :: m (Maybe a) }

instance Functor m => Functor (MaybeT m) where
  fmap f (MaybeT m) = MaybeT $ (fmap . fmap) f m

instance Applicative m => Applicative (MaybeT m) where
  pure = MaybeT . pure . pure
  (MaybeT fam) <*> (MaybeT fa) = MaybeT $ (<*>) <$> fam <*> fa

instance Monad m => Monad (MaybeT m) where
  return = pure
  (MaybeT m) >>= f = MaybeT $ do val <- m
                                 case val of
                                   Nothing -> return Nothing
                                   Just a -> runMaybeT $ f a
