-- What will :sprint output?

-- We show you a definition or multiple definitions, you determine what :sprint
-- will output when passed the bindings listed in your head before testing it.

-- 1. let x = 1
-- x = _

-- 2. let x = ['1']
-- x = "1"

-- 3. let x = [1]
-- x = _

-- 4. let x = 1 :: Int
-- x = 1

-- 5. let f = \x -> x let x = f 1
-- x = _

-- 6. let f :: Int -> Int; f = \x -> x let x = f 1
-- x = _

-- Will printing this expression result in bottom?

-- 1. snd (undefined, 1)
-- no

-- 2. let x = undefined
-- let y = x `seq` 1 in snd (x, y)
-- yes

-- 3. length $ [1..5] ++ undefined
-- yes

-- 4. length $ [1..5] ++ [undefined]
-- no

-- 5. const 1 undefined
-- no

-- 6. const 1 (undefined `seq` 1)
-- no

-- 7. const undefined 1
-- yes

-- Make the expression bottom

-- Using only bang patterns or seq, make the code bottom out when executed.
-- 1.
x = undefined
y = "blah"

main :: IO ()
main = do print (snd (x, x `seq`y))
