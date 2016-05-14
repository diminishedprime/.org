-- Intermission: Li ing Exercises

-- Add fmap, parentheses, and function composition to the expression as needed
-- for the expression to typecheck and produce the expected result. It may not
-- always need to go in the same place, so don’t get complacent.

-- 1.

a = fmap (+1) $ read "[1]" :: [Int]

--Expected result
-- Prelude> a => [2]

-- 2.
b = (fmap . fmap) (++ "lol") (Just ["Hi,", "Hello"])

-- Prelude> b
-- Just ["Hi,lol","Hellolol"]

-- 3.
c = fmap (* 2) (\x -> x - 2)

-- 4.
d = fmap ((return '1' ++) . show) (\x -> [x, 1..3])

-- 5.
e :: IO Integer
e = let ioi = readIO "1" :: IO Integer
        changed = fmap read $ fmap ("123"++) $ fmap show ioi :: IO Integer
    in fmap (*3) changed
