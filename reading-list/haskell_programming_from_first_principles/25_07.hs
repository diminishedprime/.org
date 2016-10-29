-- Good ole fashioned Identity
newtype Identity a = Identity { runIdentity :: a } deriving (Eq, Show)

instance Functor Identity where
  fmap f (Identity a) = Identity $ f a

instance Applicative Identity where
  pure = Identity
  (Identity fa) <*> (Identity a) = Identity $ fa a

instance Monad Identity where
  return = pure
  (Identity a) >>= f = f a


-- Identity T
newtype IdentityT f a = IdentityT { runIdentityT :: f a } deriving (Eq, Show)

instance Functor f => Functor (IdentityT f) where
  fmap f (IdentityT fa) = IdentityT $ f <$> fa

instance Applicative f => Applicative (IdentityT f) where
  pure = IdentityT . pure
  (IdentityT fa) <*> (IdentityT a) = IdentityT $ fa <*> a

instance Monad m => Monad (IdentityT m) where
  return = pure
  (IdentityT m) >>= f = IdentityT $ m >>= runIdentityT . f
