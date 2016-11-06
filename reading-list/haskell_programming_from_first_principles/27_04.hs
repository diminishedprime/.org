-- Exercises: Evaluate

-- Expand the expression in as much detail as possible. Then, work outside-in to
-- see what the expression evaluates to.

-- 1. const 1 undefined
-- 1

-- 2. const undefined 1
-- Exception

-- 3. flip const undefined 1
-- 1

-- 4. flip const 1 undefined
-- Exception

-- 5. const undefined undefined
-- Exception

-- 6. foldr const 'z' ['a'..'e']
-- 'a'

-- 7. foldr (flip const) 'z' ['a'..'e']
-- 'z'
