-- 1. Given the type

type Gardener = String

-- What is the normal form of Garden?

data Garden =
  Gardenia Gardener
  | Daisy Gardener
  | Rose Gardener
  | Lilac Gardener
  deriving Show
