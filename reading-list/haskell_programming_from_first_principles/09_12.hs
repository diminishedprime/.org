import Data.Char

-- 9.12 Chapter Exercises

-- The first set of exercises here will mostly be review but will also introduce you to some new things. The second set is more conceptually challenging but does not use any syntax or concepts we haven’t already studied. If you get stuck, it may help to flip back to a relevant section and review.

-- Data.Char

-- These first few exercises are straightforward but will introduce you to some new library functions and review some of what we’ve learned so far. Some of the functions we will use here are not standard in Prelude and so have to be imported from a module called Data.Char. You may do so in a source file (recommended) or at the Prelude prompt with the same phrase: import Data.Char (write that at the top of your source file). This brings into scope a bunch of new standard functions we can play with that operate on Char and String types.

-- 1. Query the types of isUpper and toUpper.
-- 2. Given the following behaviors, which would we use to write a function that filters all the uppercase letters out of a String? Write that function such that, given the input “HbEfLrLxO,” your function will return “HELLO.”
onlyUppercase :: [Char] -> [Char]
onlyUppercase = filter isUpper

-- . Write a function that will capitalize the first letter of a String and return the entire String. For example, if given the argument julie,” it will return “Julie.”

capFirst :: [Char] -> [Char]
capFirst [] = []
capFirst (x:xs) = toUpper x : xs

-- . Now make a new version of that function that is recursive such that if you give it the input “woot” it will holler back at you “WOOT.” The type signature won’t change, but you will want to dd a base case.

capAll :: [Char] -> [Char]
capAll [] = []
capAll (x:xs) = toUpper x : capAll xs

-- . To do the final exercise in this section, we’ll need another standard function for lists called head. Query the type of head and experiment with it to see what it does. Now write a function that will capitalize the first letter of a String and return only that letter as the result.

firstAsCap :: [Char] -> Char
firstAsCap xs = toUpper $ head xs

-- . Cool. Good work. Now rewrite it as a composed function. Then, for fun, rewrite it pointfree.

firstAsCapComp :: [Char] -> Char
firstAsCapComp xs = (toUpper . head) xs

firstAsCapPF :: [Char] -> Char
firstAsCapPF = toUpper . head

-- Ciphers

-- See Cipher.hs in pwd

-- Writing your own standard functions
-- Below are the outlines of some standard functions. The goal here is to write your own versions of these to gain a deeper understanding of recursion over lists and how to make functions flexible enough to accept a variety of inputs. You could figure out how to look up the answers, but you won’t do that because you know you’d only be cheating yourself out of the knowledge. Right?

-- Let’s look at an example of what we’re after here. The and function can take a list of Bool values and returns True if and only if no values in the list are False. Here’s how you might write your own version of it:

-- direct recursion, not using (&&)
myAnd :: [Bool] -> Bool
myAnd [] = True
myAnd (x:xs) = if x == False
               then False
               else myAnd xs

-- direct recursion, using (&&)
myAnd' :: [Bool] -> Bool
myAnd' [] = True
myAnd' (x:xs) = x && myAnd' xs

-- And now the fun begins:

-- 1. myOr returns True if any Bool in the list is True.
myOr :: [Bool] -> Bool
myOr [] = False
myOr (x:xs) = x || myOr xs

-- 2. myAny returns True if a -> Bool applied to any of the values in the list returns True.
myAny :: (a -> Bool) -> [a] -> Bool
myAny _ [] = False
myAny f (x:xs) = f x || myAny f xs

-- 3. After you write the recursive myElem, write another version that uses any.
-- myElem :: Eq a => a -> [a] -> Bool
myElem :: Eq a => a -> [a] -> Bool
myElem _ [] = False
myElem a (x:xs) = a == x || myElem a xs

myElemAny :: Eq a => a -> [a] -> Bool
myElemAny a xs = any (== a) xs

-- 4. Implement myReverse.
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

-- 5. squish flattens a list of lists into a list
squish :: [[a]] -> [a]
squish [] = []
squish (x:xs) = x ++ squish xs

-- 6. squishMap maps a function over a list and concatenates the results.
squishMap :: (a -> [b]) -> [a] -> [b]
squishMap _ [] = []
squishMap f (a:as) = f a ++ squishMap f as

-- 7. squishAgain flattens a list of lists into a list. This time re-use the squishMap function.
squishAgain :: [[a]] -> [a]
squishAgain = squishMap id

-- 8. myMaximumBy takes a comparison function and a list and returns the greatest element of the list based on the last value that the comparison returned GT for.
-- - If you import maximumBy from Data.List,
--   -- you'll see the type is
--   -- Foldable t => (a -> a -> Ordering) -> t a -> a
--   -- rather than
--   -- (a -> a -> Ordering) -> [a] -> a
--   -- if you have GHC 7.10 or newer. Seeing a pattern?

myMaximumBy :: (a -> a -> Ordering) -> [a] -> a
myMaximumBy f (x:xs) = go x xs
            where go current [] = current
                  go current (next:xs) = go (case (f next current) of
                                             GT -> next
                                             _ -> current) xs

-- 9. myMinimumBy takes a comparison function and a list and returns the least element of the list based on the last value that the com- parison returned LT for.
-- - blah blah GHC 7.10 different type
--     -- that uses Foldable.
myMinimumBy :: (a -> a -> Ordering) -> [a] -> a
myMinimumBy f (x:xs) = go x xs
            where go current [] = current
                  go current (next:xs) = go (case (f next current) of
                                             LT -> next
                                             _ -> current) xs

-- using the myMinimumBy and myMaximumBy functions, write your own versions of maximum and minimum. If you have GHC 7.10 or newer, you’ll see a type constructor that wants a Foldable instance in- stead of a list as has been the case for many functions so far.
myMaximum :: (Ord a) => [a] -> a
myMaximum = myMaximumBy compare
myMinimum :: (Ord a) => [a] -> a
myMinimum = myMinimumBy compare