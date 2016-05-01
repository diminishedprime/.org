-- Intermission: Exercises Will it blow up?

-- 1. Will the following expression return a value or be ⊥? [x^y | x <- [1..5],
-- y <- [2, undefined]]

-- blow up. When it tries to get the second y out, it throws and exception on the undefined.

-- 2. take 1 $ [x^y | x <- [1..5], y <- [2, undefined]] 3. Will the following
-- expression return a value? sum [1, undefined, 3]

-- no, this will blow up because sum has to evaluate all of its arguments

-- 4. length [1, 2, undefined]

-- this will be fine

-- 5. length $ [1, 2, 3] ++ undefined

-- this will blow up on the [1,2,3] ++ undefined part.

-- 6. take 1 $ filter even [1, 2, 3, undefined]

-- this won't blow up because it only needs to evaluate enough for one of the
-- values to get through the filter.

-- 7. take 1 $ filter even [1, 3, undefined]

-- this will blow up

-- 8. take 1 $ filter odd [1, 3,undefined]

-- this will be fine.

-- 9. take 2 $ filter odd [1, 3, undefined]

-- this will be fine

-- 10. take 3 $ filter odd [1, 3, undefined]

-- this will blow up.

-- Intermission: Is it in normal form?

-- For each expression below, determine whether it’s in: 1. normal form, which
-- implies weak head normal form; 2. weak head normal form only; or, 3. neither.

-- Remember that an expression cannot be in normal form or weak head normal form
-- if the outermost part of the expression isn’t a data constructor. It can’t be
-- in normal form if any part of the expression is unevaluated.

-- 1. [1, 2, 3, 4, 5]            1 & 2
-- 2. 1 : 2 : 3 : 4 : _          2
-- 3. enumFromTo 1 10            1
-- 4. length [1, 2, 3, 4, 5]     1
-- 5. sum (enumFromTo 1 10)      1 & 2
-- 6. ['a'..'m'] ++ ['n'..'z']   3
-- 7. (_, 'b')                   1
