newtype Identity a =
  Identity {runIdentity :: a}
  deriving (Eq, Show)

newtype Compose f g a =
  Compose {getCompose :: f (g a)}
  deriving (Eq, Show)

-- Compose [Just 1, Nothing]
-- Compose [Just 1, Nothing]
-- :: Num a => Compose [] Maybe a
