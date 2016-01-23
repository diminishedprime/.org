module JoinList where
import Sized

data JoinList m a = Empty
                  | Single m a
                  | Append m (JoinList m a) (JoinList m a)
                  deriving (Eq, Show)

(+++) :: Monoid m => JoinList m a -> JoinList m a -> JoinList m a
l1 +++ Empty = l1
Empty +++ l2 = l2
l1 +++ l2 = Append (tag l1 `mappend` tag l2) l1 l2

tag :: Monoid m => JoinList m a -> m
tag Empty = mempty
tag (Single m _) = m
tag (Append m _ _) = m

indexJ :: (Sized b, Monoid b) => Int -> JoinList b a -> Maybe a
indexJ i _ | i < 0 = Nothing
indexJ _ Empty = Nothing
indexJ i node@(Single _ a)
  | i == (jlSize node - 1) = Just a
  | otherwise = Nothing
indexJ i node@(Append _ l r)
  | i >= jlSize node = Nothing
  | i < leftSize = indexJ i l
  | otherwise = indexJ (i - leftSize) r
  where leftSize = jlSize l

jlSize :: Sized m => JoinList m a -> Int
jlSize Empty = 0
jlSize (Single m _) = getSize $ size m
jlSize (Append m _ _) = getSize $ size m

jlToList :: JoinList m a -> [a]
jlToList Empty = []
jlToList (Single _ a) = [a]
jlToList (Append _ l1 l2) = jlToList l1 ++ jlToList l2

dropJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
dropJ n l | n <= 0 = l
dropJ _ Empty = Empty
dropJ n node@(Single _ _)
  | n >= jlSize node = Empty
  | otherwise = node
dropJ n node@(Append _ l r)
  | n >= jlSize node = Empty
  | n >= leftSize = dropJ (n - leftSize) r
  | otherwise = dropJ n l +++ r
  where leftSize = jlSize l


takeJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
takeJ n _ | n <= 0 = Empty
takeJ _ Empty = Empty
takeJ _ node@(Single _ _) = node
takeJ n node@(Append _ l r)
  | n >= jlSize node = node
  | n >= leftSize = l +++ takeJ (n - leftSize) r
  | otherwise = takeJ n l
  where leftSize = jlSize l
