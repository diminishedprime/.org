-- Parenthesization

---- (2^) $ (+2) $ 3*2

---- (2^) $ 2 + 2 $ (*30)
---- (2^) $ 2 + 2 $ (*30)
----        2 + 2 $ (*30)
----       (2 + 2) (*30)
----             4 (* 30)

---- (2^) $ (*30) $ 2 + 2
---- (2^) $ (*30) $ 2 + 2
---- (2^) $ (*30) 4
---- (2^) $ 120
---- (2^) 120
---- 1329227995784915872903807060280344576


---- 1. 2 + 2 * 3 - 1
----    2 + (2 * 3) - 1
---- 2. (^) 10 $ 1 + 1
----    (^) 10 (1 + 1)
---- 3. 2 ^ 2 * 4 ^ 5 + 1
----    (2 ^ 2) * (4 ^ 5) + 1

-- Equivalent expressions

-- 1. 1 + 1
--    2
-- 2. 10 ^ 2
--    10 + 9 * 10
-- 3. 400 - 37
--    (-) 37 400
-- 4. 100 `div` 3
--    100 / 3
-- 5. 2 * 5 + 18
--    2 * (5 + 18)

-- 1. Same
-- 2. Same
-- 3. Different
-- 4. Different
-- 5. Different