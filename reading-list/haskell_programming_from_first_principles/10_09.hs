-- Scans Exercises
-- 1. Modify your fibs function to only return the first 20 Fibonacci numbers.
fibsFirst20 = take 20 fibsHelper
     where fibsHelper = 1 : scanl (+) 1 fibsHelper

-- 2. Modify fibs to return the Fibonacci numbers that are less than 100.
fibsLT100 = takeWhile (<100) fibsHelper
     where fibsHelper = 1 : scanl (+) 1 fibsHelper

-- 3. Try to write the factorial function from Recursion as a scan. You’ll want scanl again, and your start value will be 1. Warning: this will also generate an infinite list, so you may want to pass it through a take function or similar.
facts = take 10 $ scanl (*) 1 [2..]