-- Intermission: Exercises

-- Determine how many unique inhabitants each type has.

-- Suggestion: just do the arithmetic unless you want to verify. Writing them
-- out gets tedious quickly.

-- 1.
data Quad = One
          | Two
          | Three
          | Four
  deriving (Eq, Show)

quadOptions = [ One
              , Two
              , Three
              , Four]

eitherDataConstructors = [ Left
                         , Right]
-- how many different forms can this take?
eQuad :: Either Quad Quad
eQuad = undefined

-- mathematically this is 2 * 4 = 8
-- Let's do it pragmatically
eQuads = length [constructors quadOption |
                 constructors <- eitherDataConstructors,
                 quadOption <- quadOptions]

-- 2.
prodQuad :: (Quad, Quad)
prodQuad = undefined

-- 16
prodQuads = length [(a, b) |
                    a <- quadOptions,
                    b <- quadOptions]

-- 3.
funcQuad :: Quad -> Quad
funcQuad = undefined

funcQuads = length [(a, b, c, d) |
                    a <- quadOptions,
                    b <- quadOptions,
                    c <- quadOptions,
                    d <- quadOptions]

-- 4.
prodTBool :: (Bool, Bool, Bool)
prodTBool = undefined

prodTBools = length [(a, b, c) |
                     a <- [True, False],
                     b <- [True, False],
                     c <- [True, False]]

-- 5.
gTwo :: Bool -> Bool -> Bool
gTwo = undefined

-- 2 ^ 2 ^ 2 16

-- 6. Hint: 5 digit number
fTwo :: Bool -> Quad -> Quad
fTwo = undefined

-- ???
