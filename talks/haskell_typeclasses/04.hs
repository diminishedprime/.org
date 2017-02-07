import Control.Applicative

-- Recursive Types
data List a = Cons a (List a) | Null

exList = Cons 3 (Cons 4 (Cons 5 (Cons 6 Null)))

-- mapping function for our recursive type
listMap ::  (a -> b) -> List a -> List b
listMap f Null = Null
listMap f (Cons a b) = Cons (f a) (listMap f b)

increment x = x + 1

exAnswer = listMap increment exList


instance Functor List where
  fmap = listMap

exAnswer2 = fmap increment exList

exAnswer3 = increment <$> exList
