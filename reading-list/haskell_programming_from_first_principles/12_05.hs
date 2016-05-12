-- Determine the kinds
-- 1. Given
id' :: a -> a
id' a = a
-- What is the kind of a?

-- *

-- 2. r :: a -> f a
-- What are the kinds of a and f?

-- * and *???

-- String processing

-- Because this is the kind of thing linguist co-authors enjoy doing in their spare time.

-- 1. Write a recursive function that takes a text/string, breaks it into words
-- and replaces each instance of ”the” with ”a”. It’s intended- only to replace
-- exactly the word “the”.

notThe :: String -> Maybe String
notThe x = case x of
             "the" -> Nothing
             otherwise -> Just x

replaceThe :: String -> String
replaceThe = unwords . map (\x -> case notThe x of
                                    Nothing -> "a"
                                    (Just x) -> x) . words

-- 2. Write a recursive function that takes a text/string, breaks it into words,
-- and counts the number of instances of ”the” followed by a vowel-initial word.

-- -- >>> countTheBeforeVowel "the cow"
-- -- 0
-- -- >>> countTheBeforeVowel "the evil cow" -- 1
countTheBeforeVowel :: String -> Integer
countTheBeforeVowel = undefined

-- 3. Return the number of letters that are vowels in a word.
-- Hint: it’s helpful to break this into steps. Add any helper func- tions necessary to achieve your objectives.
-- a) Test for vowelhood
-- b) Return the vowels of a string
-- c) Count the number of elements returned
-- -- >>> countVowels "the cow"
-- -- 2
-- -- >>> countVowels "Mikolajczak" -- 4
-- countVowels :: String -> Integer countVowels = undefined
-- Validate the word
-- Use the Maybe type to write a function that counts the number of vowels in a string and the number of consonants. If the number of vowels exceeds the number of consonants, the function returns Nothing. In many human languages, vowels rarely exceed the number of consonants so when they do, it indicates the input isn’t a real word (that is, a valid input to your dataset):
-- newtype Word' =
-- Word' String deriving (Eq, Show)
-- vowels = "aeiou"
-- mkWord :: String -> Maybe Word'
-- mkWord = undefined It’s only Natural
-- You’ll be presented with a datatype to represent the natural numbers. The only values representable with the naturals are whole numbers from zero to infinity. Your task will be to implement functions to convert Naturals to Integers and Integers to Naturals. The conversion from Naturals to Integers won’t return Maybe because Integers are a strict superset of Naturals. Any Natural can be represented by an Integer, but the same is not true of any Integer. Negative numbers are not valid natural numbers.
-- -- As natural as any competitive bodybuilder
-- data Nat =
--     Zero
-- | Succ Nat
-- deriving (Eq, Show)
-- -- >>> natToInteger Zero
-- -- 0
-- -- >>> natToInteger (Succ Zero)
-- -- 1
-- -- >>> natToInteger (Succ (Succ Zero)) -- 2
-- natToInteger :: Nat -> Integer natToInteger = undefined
-- -- >>> integerToNat 0
-- -- Just Zero
-- -- >>> integerToNat 1
-- -- Just (Succ Zero)
-- -- >>> integerToNat 2
-- -- Just (Succ (Succ Zero))
-- -- >>> integerToNat (-1)
-- -- Nothing
-- integerToNat :: Integer -> Maybe Nat integerToNat = undefined
-- Small library for Maybe
-- Write the following functions. This may take some time.
-- 1. Simple boolean checks for Maybe values. -- >>> isJust (Just 1)
-- -- True
-- -- >>> isJust Nothing
-- -- False
-- isJust :: Maybe a -> Bool
--      -- >>> isNothing (Just 1)
--      -- False
--      -- >>> isNothing Nothing
--      -- True
-- isNothing :: Maybe a -> Bool
-- 2. The following is the Maybe catamorphism. You can turn a Maybe
-- value into anything else with this.
--    -- >>> mayybee 0 (+1) Nothing
--    -- 0
--    -- >>> mayybee 0 (+1) (Just 1)
--    -- 2
-- mayybee :: b -> (a -> b) -> Maybe a -> b
-- 3. In case you just want to provide a fallback value.
--    -- >>> fromMaybe 0 Nothing
--    -- 0
--    -- >>> fromMaybe 0 (Just 1)
--    -- 1
-- fromMaybe :: a -> Maybe a -> a
-- -- Try writing it in terms of the maybe catamorphism
-- 4. Converting between List and Maybe. -- >>> listToMaybe [1, 2, 3]
-- -- Just 1
-- -- >>> listToMaybe []
-- -- Nothing
-- listToMaybe :: [a] -> Maybe a
--    -- >>> maybeToList (Just 1)
--    -- [1]
--    -- >>> maybeToList Nothing
--    -- []
-- maybeToList :: Maybe a -> [a]
-- 5. For when we just want to drop the Nothing values from our list. -- >>> catMaybes [Just 1, Nothing, Just 2]
-- -- [1, 2]
-- -- >>> catMaybes [Nothing, Nothing, Nothing]
-- -- []
-- catMaybes :: [Maybe a] -> [a]
-- 6. You’ll see this called “sequence” later.
--    -- >>> flipMaybe [Just 1, Just 2, Just 3]
--    -- Just [1, 2, 3]
--    -- >>> flipMaybe [Just 1, Nothing, Just 3]
--    -- Nothing
-- flipMaybe :: [Maybe a] -> Maybe [a]
-- Small library for Either
-- Write each of the following functions. If more than one possible unique function exists for the type, use common sense to determine what it should do.
-- 1. Trytoeventuallyarriveatasolutionthatusesfoldr,evenifearlier versions don’t use foldr.
-- lefts' :: [Either a b] -> [a]
-- 2. Same as the last one. Use foldr eventually.
-- rights' :: [Either a b] -> [b]
-- 3. partitionEithers' :: [Either a b] -> ([a], [b])
-- 4. eitherMaybe' :: (b -> c) -> Either a b -> Maybe c
-- 5. This is a general catamorphism for Either values. either' :: (a -> c) -> (b -> c) -> Either a b -> c
-- 6. Same as before, but use the either' function you just wrote. eitherMaybe'' :: (b -> c) -> Either a b -> Maybe c
-- Most of the functions you just saw are in the Prelude, Data.Maybe, or Data.Either but you should strive to write them yourself without looking at existing implementations. You will deprive yourself if you cheat.
-- Unfolds
-- While the idea of catamorphisms is still relatively fresh in our minds, let’s turn our attention to their dual: anamorphisms. If folds, or cata- morphisms, let us break data structures down then unfolds let us build them up. There are, just as with folds, a few different ways to unfold a data structure. We can use them to create finite and infinite data structures alike.
-- -- iterate is like a very limited
-- -- unfold that never ends
-- Prelude> :t iterate
-- iterate :: (a -> a) -> a -> [a]
-- -- because it never ends, we must use
-- -- take to get a finite list
-- Prelude> take 10 $ iterate (+1) 0
-- [0,1,2,3,4,5,6,7,8,9]
-- -- unfoldr is the full monty
-- Prelude> :t unfoldr
-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
-- -- Using unfoldr to do the same as thing as iterate
-- Prelude> take 10 $ unfoldr (\b -> Just (b, b+1)) 0
-- [0,1,2,3,4,5,6,7,8,9]
-- Why bother?
-- We bother with this for the same reason we abstracted direct recursion
-- into folds, such as with sum, product, and concat. import Data.List
-- mehSum :: Num a => [a] -> a mehSum xs = go 0 xs
-- where go :: Num a => a -> [a] -> a go n [] = n
-- go n (x:xs) = (go (n+x) xs) niceSum :: Num a => [a] -> a
-- niceSum = foldl' (+) 0
-- mehProduct :: Num a => [a] -> a mehProduct xs = go 1 xs
-- where go :: Num a => a -> [a] -> a go n [] = n
-- go n (x:xs) = (go (n*x) xs) niceProduct :: Num a => [a] -> a
-- niceProduct = foldl' (*) 1
-- Remember the redundant structure when we looked at folds?
-- mehConcat :: [[a]] -> [a] mehConcat xs = go [] xs
-- where go :: [a] -> [[a]] -> [a] go xs' [] = xs'
-- go xs' (x:xs) = (go (xs' ++ x) xs) niceConcat :: [[a]] -> [a]
-- niceConcat = foldr (++) []
-- Your eyes may be spouting gouts of blood, but you may also see that this same principle of abstracting out common patterns and giving them names applies as well to unfolds as it does to folds.
-- Write your own iterate and unfoldr
-- 1. Write the function myIterate using direct recursion. Compare the behavior with the built-in iterate to gauge correctness. Do not look at the source or any examples of iterate so that you are forced to do this yourself.
-- myIterate :: (a -> a) -> a -> [a] myIterate = undefined
-- 2. Write the function myUnfoldr using direct recursion. Compare with the built-in unfoldr to check your implementation. Again, don’t look at implementations of unfoldr so that you figure it out yourself.
-- myUnfoldr :: (b -> Maybe (a, b)) -> b -> [a] myUnfoldr = undefined
-- 3. Rewrite myIterate into betterIterate using myUnfoldr. A hint – we used unfoldr to produce the same results as iterate earlier. Do this with different functions and see if you can abstract the structure out.
--      -- It helps to have the types in front of you
--      -- myUnfoldr :: (b -> Maybe (a, b)) -> b -> [a]
-- betterIterate :: (a -> a) -> a -> [a]
-- betterIterate f x = myUnfoldr ...?
-- Remember, your betterIterate should have the same results as iterate.
--      Prelude> take 10 $ iterate (+1) 0
--      [0,1,2,3,4,5,6,7,8,9]
--      Prelude> take 10 $ betterIterate (+1) 0
-- [0,1,2,3,4,5,6,7,8,9]
-- Finally something other than a list!
-- Given the BinaryTree from last chapter, complete the following exer- cises. Here’s that datatype again:
-- data BinaryTree a = Leaf
-- | Node (BinaryTree a) a (BinaryTree a) deriving (Eq, Ord, Show)
-- 1. Write unfold for BinaryTree.
-- unfold :: (a -> Maybe (a,b,a)) -> a -> BinaryTree b unfold = undefined
-- 2. Make a tree builder.
-- Using the unfold function you’ve just made for BinaryTree, write the following function:
-- treeBuild :: Integer -> BinaryTree Integer
-- treeBuild n = undefined
-- You should be producing results that look like the following:
-- Prelude> treeBuild 0
-- Leaf
-- Prelude> treeBuild 1
-- Node Leaf 0 Leaf
-- Prelude> treeBuild 2
-- Node (Node Leaf 1 Leaf)
-- 0
--      (Node Leaf 1 Leaf)
-- Prelude> treeBuild 3
-- Node (Node (Node Leaf 2 Leaf)
--            1
--            (Node Leaf 2 Leaf))
--      0
--      (Node (Node Leaf 2 Leaf)
--            1
--            (Node Leaf 2 Leaf))
-- Or in a slightly different representation:
-- 0
-- 0 /\ 11
-- 0 /\
-- 11 /\ /\ 22 22
-- Good work.
--
