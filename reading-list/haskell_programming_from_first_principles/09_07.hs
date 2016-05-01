mySqr = [x^2 | x <- [1..5]]
myCube = [y^3 | y <- [1..5]]
-- 1. First write an expression that will make tuples of the outputs of mySqr
-- and myCube.

myTuples = [(x, y) | x <- mySqr, y <- myCube]

-- 2. Now alter that function so that it only uses the x and y values that are
-- less than 50.

myTuples2 = [(x, y) | x <- mySqr, y <- myCube, x < 50, y < 50]

-- 3. Now apply another function to that list comprehension to deter- mine how
-- many tuples inhabit your output list.

nMyTuples2 = flip take $ myTuples2
