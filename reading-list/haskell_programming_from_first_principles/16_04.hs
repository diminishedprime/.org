-- Intermission: Exercises
-- Given a type signature, determine the kinds of each type variable:

--1. What’s the kind of a?
-- a -> a

-- *

-- 2. What are the kinds of b and T (The T is capitalized on purpose!)
-- a -> b a -> T (b a)

-- b is * -> *
-- T is * -> *

-- 3. What’s the kind of c?
-- c a b -> c b a

-- c is * -> * -> *
