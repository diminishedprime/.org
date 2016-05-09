import Data.Monoid

data Optional a =
  Nada
  | Only a
  deriving (Eq, Show)

instance Monoid a => Monoid (Optional a) where
  mempty = Nada
  (Only a) `mappend` (Only b) = Only (a `mappend` b)
  Nada `mappend` a = a
  a `mappend` Nada = a
