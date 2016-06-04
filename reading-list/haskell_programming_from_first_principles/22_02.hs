import Data.Char
import Control.Applicative

hurr = (*2)
durr = (+10)

m :: Integer -> Integer
m = hurr . durr

m' :: Integer -> Integer
m' = fmap hurr durr

m2 :: Integer -> Integer
m2 = (+) <$> hurr <*> durr

m3 :: Integer -> Integer
m3 = liftA2 (+) hurr durr

---

cap :: [Char] -> [Char]
cap xs = map toUpper xs

rev :: [Char] -> [Char]
rev xs = reverse xs

-- Two simple functions with the same type, taking the same type of input. We
-- could compose them, using (.) or fmap:
composed :: [Char] -> [Char]
composed = cap . rev

fmapped :: [Char] -> [Char]
fmapped = fmap cap rev

-- Prelude> composed "Julie"
-- "EILUJ"
-- Prelude> fmapped "Chris"
-- "SIRHC"

--Now we want to return the results of cap and rev both, as a tuple, like this:
-- Prelude> tupled "Julie"
--("JULIE","eiluJ")
---- or
-- Prelude> tupled' "Julie"
--("eiluJ","JULIE")

-- We will want to use an applicative here. The type will look like this:
tupled :: [Char] -> ([Char], [Char])
tupled = (,) <$> cap <*> rev
--tupled = liftA2 (,) cap rev

tupled' :: [Char] -> ([Char], [Char])
tupled' = do
  a <- cap
  b <- rev
  return (a, b)

-- There is no special reason such a function needs to be monadic, but let’s do
-- that, too, to get some practice. Do it one time using do syntax; then try
-- writing a new version using (>>=). The types will be the same as the type for
-- tupled.
