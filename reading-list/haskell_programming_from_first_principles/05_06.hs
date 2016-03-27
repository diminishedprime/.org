-- Intermission: Exercises

-- All you can really do with a parametrically polymorphic value is pass or not
-- pass it to some other expression. Prove that to yourself with these small
-- demonstrations.

-- 1. Given the type a -> a, which is the type for id - attempt to make it do
-- something other than returning the same value. This is impossible, but you
-- should try it anyway.

id' :: a -> a
id' a = a
-- id' a = undefined

-- 2. We can get a more comfortable appreciation of parametricity bylooking at a
-- -> a -> a. This hypothetical function a -> a -> a has two–and only
-- two–implementations. Write both possible versions of a -> a -> a, then try to
-- violate the constraints we’ve described.

name :: a -> a -> a
-- name a b = a
name a b = b
-- name a b = undefined

-- 3. Implement a -> b -> b. How many implementations can it have? Does the
-- behavior change when the types of a and b change?

name2 :: a -> b -> b
name2 a b = b
-- name2 a b = undefined
