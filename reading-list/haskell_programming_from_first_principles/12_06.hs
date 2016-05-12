import Data.Char
import Data.List
-- Determine the kinds
-- 1. Given
-- id :: a -> a
-- What is the kind of a?

-- *

-- 2. r :: a -> f a
-- What are the kinds of a and f?

-- f is a higher kind * -> *

-- String processing

-- Because this is the kind of thing linguist co-authors enjoy doing in their spare time.

-- 1. Write a recursive function that takes a text/string, breaks it into words
-- and replaces each instance of ”the” with ”a”. It’s intended only to replace
-- exactly the word “the”.

notThe :: String -> Maybe String
notThe x = case x of
             "the" -> Nothing
             _ -> Just x

-- >>> replaceThe "the cow loves us" -- "a cow loves us"
--replaceThe :: String -> String
replaceThe = unwords . map (\a -> case notThe a of
                               Nothing -> "a"
                               (Just a') -> a') . words

-- 2. Write a recursive function that takes a text/string, breaks it into words,
-- and counts the number of instances of ”the” followed by a vowel-initial word.

-- -- >>> countTheBeforeVowel "the cow"
-- -- 0
-- -- >>> countTheBeforeVowel "the evil cow" -- 1
--countTheBeforeVowel :: String -> Integer

isVowel x = any (\y -> y == (toLower $ x)) vowels

startsWithVowel = isVowel . head

countTheBeforeVowel x = let wordz = words x
                            wordz' = tail wordz
                            twos = zip wordz wordz'
                        in sum $ map (\(a, b) -> case notThe a of
                                                   Nothing -> if startsWithVowel b
                                                              then 1
                                                              else 0
                                                   _ -> 0) twos

-- 3. Return the number of letters that are vowels in a word.
countVowels :: String -> Int
countVowels = sum . map (\x -> case isVowel x of
                                 True -> 1
                                 False -> 0)

-- Validate the word

-- Use the Maybe type to write a function that counts the number of vowels in a
-- string and the number of consonants. If the number of vowels exceeds the
-- number of consonants, the function returns Nothing. In many human languages,
-- vowels rarely exceed the number of consonants so when they do, it indicates
-- the input isn’t a real word (that is, a valid input to your dataset):
newtype Word' =
  Word' String
  deriving (Eq, Show)

vowels = "aeiou"

--mkWord :: String -> Maybe Word'
mkWord x = let vowels = countVowels x
               consonance = (length x) - vowels
           in if vowels < consonance
              then Just $ Word' x
              else Nothing

-- It’s only Natural

-- You’ll be presented with a datatype to represent the natural numbers. The
-- only values representable with the naturals are whole numbers from zero to
-- infinity. Your task will be to implement functions to convert Naturals to
-- Integers and Integers to Naturals. The conversion from Naturals to Integers
-- won’t return Maybe because Integers are a strict superset of Naturals. Any
-- Natural can be represented by an Integer, but the same is not true of any
-- Integer. Negative numbers are not valid natural numbers.

-- As natural as any competitive bodybuilder
data Nat =
  Zero
  | Succ Nat
  deriving (Eq, Show)

natToInteger :: Nat -> Integer
natToInteger x = case x of
                   Zero -> 0
                   (Succ x) -> natToInteger x + 1

integerToNat :: Integer -> Maybe Nat
integerToNat x = if x < 0
                 then Nothing
                 else Just $ helper x
  where helper x = case x of
                     0 -> Zero
                     _ -> Succ $ helper (x - 1)

--Small library for Maybe

-- Write the following functions. This may take some time.

-- 1. Simple boolean checks for Maybe values.
isJust :: Maybe a -> Bool
isJust x = case x of
             Nothing -> False
             otherwise -> True

isNothing :: Maybe a -> Bool
isNothing = not . isJust

-- 2. The following is the Maybe catamorphism. You can turn a Maybe value into
-- anything else with this.
mayybee :: b -> (a -> b) -> Maybe a -> b
mayybee b f ma = case ma of
                   Nothing -> b
                   (Just a ) -> f a

-- 3. In case you just want to provide a fallback value.
fromMaybe :: a -> Maybe a -> a
fromMaybe a ma = mayybee a id ma
-- Try writing it in terms of the maybe catamorphism

--4. Converting between List and Maybe.
listToMaybe :: [a] -> Maybe a
listToMaybe a = case a of
                  [] -> Nothing
                  (x:_) -> Just x

maybeToList :: Maybe a -> [a]
maybeToList x = case x of
                  Nothing -> []
                  (Just a) -> [a]

--5. For when we just want to drop the Nothing values from our list.
catMaybes :: [Maybe a] -> [a]
catMaybes = concat . map maybeToList

--6. You’ll see this called “sequence” later.
flipMaybe :: [Maybe a] -> Maybe [a]
flipMaybe x = let nothings = filter (\x -> case x of
                                        Nothing -> True
                                        otherwise -> False) x
              in case nothings of
                   [] -> Just $ map (\x -> case x of
                                             Nothing -> undefined
                                             (Just a) -> a) x
                   otherwise -> Nothing

-- Small library for Either

-- Write each of the following functions. If more than one possible unique
-- function exists for the type, use common sense to determine what it should
-- do.

-- 1. Try to eventually arrive at a solution that uses foldr, even if earlier
-- versions don’t use foldr.
lefts' :: [Either a b] -> [a]
lefts' = foldr (\a b -> case a of
                   (Left a') -> a':b
                   _ -> b) []

-- 2. Same as the last one. Use foldr eventually.
rights' :: [Either a b] -> [b]
rights' = foldr (\a b -> case a of
                    (Right a') -> a':b
                    _ -> b) []

-- 3.
partitionEithers' :: [Either a b] -> ([a], [b])
partitionEithers' = foldr (\a (l, r) -> case a of
                                          (Left a') -> (a':l, r)
                                          (Right a') -> (l, a':r)) ([],[])

-- 4.
eitherMaybe' :: (b -> c) -> Either a b -> Maybe c
eitherMaybe' f e = case e of
                     (Right a') -> Just $ f a'
                     _ -> Nothing

-- 5. This is a general catamorphism for Either values.
either' :: (a -> c) -> (b -> c) -> Either a b -> c
either' f g e = case e of
                  (Left a') -> f a'
                  (Right a') -> g a'

-- 6. Same as before, but use the either' function you just wrote.
eitherMaybe'' :: (b -> c) -> Either a b -> Maybe c
eitherMaybe'' f e = either' (\x -> Nothing) (Just . f) e

-- Most of the functions you just saw are in the Prelude, Data.Maybe, or
-- Data.Either but you should strive to write them yourself without looking at
-- existing implementations. You will deprive yourself if you cheat.


-- Unfolds

-- Why bother?

-- We bother with this for the same reason we abstracted direct recursion into folds, such as with sum, product, and concat.

mehSum :: Num a => [a] -> a
mehSum xs = go 0 xs
  where go :: Num a => a -> [a] -> a
        go n [] = n
        go n (x:xs) = (go (n+x) xs)

niceSum :: Num a => [a] -> a
niceSum = foldl' (+) 0

mehProduct :: Num a => [a] -> a
mehProduct xs = go 1 xs
  where go :: Num a => a -> [a] -> a
        go n [] = n
        go n (x:xs) = (go (n*x) xs)

niceProduct :: Num a => [a] -> a
niceProduct = foldl' (*) 1

-- Remember the redundant structure when we looked at folds?

mehConcat :: [[a]] -> [a]
mehConcat xs = go [] xs
  where go :: [a] -> [[a]] -> [a]
        go xs' [] = xs'
        go xs' (x:xs) = (go (xs' ++ x) xs)

niceConcat :: [[a]] -> [a]
niceConcat = foldr (++) []

-- Your eyes may be spouting gouts of blood, but you may also see that this same
-- principle of abstracting out common patterns and giving them names applies as
-- well to unfolds as it does to folds.

-- Write your own iterate and unfoldr

-- 1. Write the function myIterate using direct recursion. Compare the behavior
-- with the built-in iterate to gauge correctness. Do not look at the source or
-- any examples of iterate so that you are forced to do this yourself.
myIterate :: (a -> a) -> a -> [a]
myIterate f a = f a : myIterate f (f a)

--2. Write the function myUnfoldr using direct recursion. Compare with the
--built-in unfoldr to check your implementation. Again, don’t look at
--implementations of unfoldr so that you figure it out yourself.

myUnfoldr :: (b -> Maybe (a, b)) -> b -> [a]
myUnfoldr f b = case f b of
                  (Just (a', b')) -> a': myUnfoldr f b'
                  Nothing -> undefined

-- 3. Rewrite myIterate into betterIterate using myUnfoldr. A hint – we used
-- unfoldr to produce the same results as iterate earlier. Do this with
-- different functions and see if you can abstract the structure out. It helps
-- to have the types in front of you

--myUnfoldr :: (b -> Maybe (a, b)) -> b -> [a]
betterIterate :: (a -> a) -> a -> [a]
betterIterate f x = myUnfoldr (\a -> Just $ (a, f a)) x
--Remember, your betterIterate should have the same results as iterate.
--     Prelude> take 10 $ iterate (+1) 0
--     [0,1,2,3,4,5,6,7,8,9]
--     Prelude> take 10 $ betterIterate (+1) 0

-- Finally something other than a list!

-- Given the BinaryTree from last chapter, complete the following exer- cises.
-- Here’s that datatype again:
data BinaryTree a = Leaf
                  | Node (BinaryTree a) a (BinaryTree a)
  deriving (Eq, Ord, Show)

-- 1. Write unfold for BinaryTree.
-- unfold :: (a -> Maybe (a,b,a)) -> a -> BinaryTree b
unfold f a = case f a of
               (Just (a', b', a'')) -> Node a' b' a''
               Nothing -> undefined

-- 2. Make a tree builder. Using the unfold function you’ve just made for
-- BinaryTree, write the following function:
treeBuild :: Integer -> BinaryTree Integer
treeBuild n = undefined

-- You should be producing results that look like the following:
-- Prelude> treeBuild 0
-- Leaf
