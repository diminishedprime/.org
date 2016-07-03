import System.Random

rollsToGetTwenty :: StdGen -> Int
rollsToGetTwenty g = go 0 0 g
  where go :: Int -> Int -> StdGen -> Int
        go sum count gen
          | sum >= 20 = count
          | otherwise = let (die, nextGen) = randomR (1, 6) gen
                        in go (sum + die) (count + 1) nextGen

-- 1. Refactor rollsToGetTwenty into having the limit be a function argument.

rollsToGetN :: Int -> StdGen -> Int
rollsToGetN n g = go 0 0 g
  where go :: Int -> Int -> StdGen -> Int
        go sum count gen
          | sum >= n = count
          | otherwise = let (die, nextGen) = randomR (1, 6) gen
                        in go (sum + die) (count + 1) nextGen

-- 2. Change rollsToGetN to recording the series of die that occurred in
-- addition to the count.
data Die =
  DieOne
  | DieTwo
  | DieThree
  | DieFour
  | DieFive
  | DieSix
  deriving (Eq, Show)

intToDie :: Int -> Die
intToDie n = case n of
               1 -> DieOne
               2 -> DieTwo
               3 -> DieThree
               4 -> DieFour
               5 -> DieFive
               6 -> DieSix
               -- Use this tactic _extremely_ sparingly.
               x -> error $ "intToDie got non 1-6 integer: " ++ show x

rollsCountLogged :: Int -> StdGen -> (Int, [Die])
rollsCountLogged n g = go 0 0 [] g
  where go :: Int -> Int -> [Die] -> StdGen -> (Int, [Die])
        go sum count dice gen
          | sum >= n = (count, dice)
          | otherwise = let (dieNum, nextGen) = randomR (1, 6) gen
                            die = (intToDie dieNum)
                        in go (sum + dieNum) (count + 1) (die:dice) nextGen
