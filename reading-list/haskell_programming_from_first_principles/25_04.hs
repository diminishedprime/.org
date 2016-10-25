newtype Compose f g a =
  Compose {getCompose :: f (g a)}
  deriving (Eq, Show)

instance (Applicative f, Applicative g) =>
  Applicative (Compose f g) where
  pure = Compose $ f g
  (Compose f) <*> (Compose g) = undefined
