module Print1 where

main1 :: IO ()
main1 = putStrLn "hello, world"

main2 :: IO ()
main2 = do
  putStrLn "Count to four for me:"
  putStr "one, two"
  putStr ", three, and"
  putStrLn " four!"

myGreeting :: String
-- The above line reads as: "myGreeting has the type String"
myGreeting = "hello" ++ " world!"
-- Could also be: "hello" ++ " " ++ "world!"
-- to obtain the same result.
hello :: String
hello = "hello"

world :: String
world = "world!"

main3 :: IO ()
main3 = do
putStrLn myGreeting
putStrLn secondGreeting
  where secondGreeting = concat [hello, " ", world]

topLevelFunction :: Integer -> Integer
topLevelFunction x = x + woot + topLevelValue
  where woot :: Integer
        woot = 10

topLevelValue :: Integer
topLevelValue = 5

-- Intermission: Exercises
-- 1. These lines of code are from a REPL session. Is 𝑦 in scope for 𝑧?
--     Prelude> let x = 5
--     Prelude> let y = 7
--     Prelude> let z = x * y

-- Yes, y is in scope for z.

-- 2. These lines of code are from a REPL session. Is h in scope for function 𝑔?
--     Prelude> let f = 3
--     Prelude> let g = 6 * f + h

-- No, h is not in scope for g.

-- 3. This code sample is from a source file. Is everything we need to
-- execute area in scope?
-- area d = pi * (r * r)
-- r=d/2

-- No, the r and d that are in this code aren't referring to each other.

-- 4. This code is also from a source file. Now are 𝑟 and 𝑑 in scope for
-- area?
-- area d = pi * (r * r)
-- where r = d / 2

-- Now these are scoped correctly together.
