-- Intermission: Exercises
-- 1. foldr (*) 1 [1..5] will return the same result as which of the following:
-- a) flip (*) 1 [1..5]
-- b) foldl (flip (*)) 1 [1..5]
-- c) foldl (*) 1 [1..5]

-- c

-- 2. Write out the evaluation steps for foldl (flip (*)) 1 [1..3]

-- ???

-- 3. One difference between foldr and foldl is:
-- a) foldr, but not foldl, traverses the spine of a list from right to left
-- b) foldr, but not foldl, always forces the rest of the fold
-- c) foldr, but not foldl, associates to the right
-- d) foldr, but not foldl, is recursive

-- c

-- 4. Folds are catamorphisms, which means they are generally used to
-- a) reduce structure
-- b) expand structure
-- c) render you catatonic
-- d) generate infinite data structures

-- a

-- 5. The following are simple folds very similar to what you’ve already seen, but each has at least one error. Please fix them and test in your REPL:

-- a) foldr (++) ["woot", "WOOT", "woot"]
-- foldr (++) "" ["woot", "WOOT", "woot"]

-- b) foldr max [] "fear is the little death"
-- foldr max 'a' "fear is the little death"

-- c) foldr and True [False, True]
-- foldr (&&) True [False, True]

-- d) This one is more subtle than the previous. Can it ever return a different answer? foldr (||) True [False, True]
-- foldr (||) False [False, True]

-- e) foldl (++) "" $ map show [1..5]

-- f) foldr const 'a' [1..5]
-- foldr const 0 [1..5]

-- g) foldr const 0 "tacos"
-- foldr const '0' "tacos"

-- h) foldl (flip const) 0 "burritos"
-- foldl (flip const) '0' "burritos"

-- i) foldl (flip const) 'z' [1..5]
-- foldl (flip const) 0 [1..5]