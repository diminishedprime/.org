-- Intermission: Exercises

-- n1. Given the following declarations
k (x, y) = x

k1 = k ((4-1), 10)

k2 = k ("three", (1 + 2))

k3 = k (3, True)

-- a) What is the type of k?

-- a

-- b) What is the type of k2? Is it the same type as k1 or k3?

-- [Char], no, it is different.

-- c) Of k1, k2, k3, which will return the number3 as the result?

-- k1 and k3

-- 2. Fill in the definition of the following function:
    -- Remember: Tuples have the same syntax for their
    -- type constructors and their data constructors.

f :: (a, b, c) -> (d, e, f) -> ((a, d), (c, f))
f (a, b, c) (d, e, f) = ((a, d), (c, f))
