-- 1. let x = 5 in x
-- 2. let x = 5 in x * x
-- 3. let x = 5; y = 6 in x * y
-- 4. let x = 3; y = 1000 in x + 3

mult1 = x * y
  where x = 5
        y = 6

-- (\x -> x) 0
-- (\x -> x) 1
-- (\x -> x) "blah"

-- let id = \x -> x
-- id 0
-- id 1

-- let id x = x
-- id 0
-- id 1

-- let a = b in c
-- (\a -> c) b

-- let x = 10 in x + 9091
-- (\x -> x + 9091) 10

-- c where a = b
-- (\a -> c) b

-- x + 9091 where x = 10
-- (\x -> x + 9091) 10

-- 1. let x = 3; y = 1000 in x * 3 + y


-- 2. let y = 10; x = 10 * 5 + y in x * 5


-- 3. let x = 7; y = negate x; z = y * 10 in z / x + y
