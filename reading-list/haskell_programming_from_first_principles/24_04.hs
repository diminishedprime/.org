{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative
import Data.Ratio ((%))
import Text.Trifecta


badFraction = "1/0"
alsoBad = "10"
shouldWork = "1/2"
shouldAlsoWork = "2/1"

-- Then we’ll write our actual parser:
parseFraction :: Parser Rational
parseFraction = do
  numerator <- decimal
  char '/'
  denominator <- decimal
  return (numerator % denominator)

main :: IO ()
main = do
  print $ parseString parseFraction mempty shouldWork
  print $ parseString parseFraction mempty shouldAlsoWork
  print $ parseString parseFraction mempty alsoBad
  print $ parseString parseFraction mempty badFraction


virtuousFraction :: Parser Rational
virtuousFraction = do
  numerator <- decimal
  char '/'
  denominator <- decimal
  case denominator of
    0 -> fail "Denominator cannot be zero"
    _ -> return (numerator % denominator)

testVirtuous :: IO ()
testVirtuous = do
  print $ parseString virtuousFraction mempty badFraction
  print $ parseString virtuousFraction mempty alsoBad
  print $ parseString virtuousFraction mempty shouldWork
  print $ parseString virtuousFraction mempty shouldAlsoWork


parseAndReturn :: Parser Integer
parseAndReturn = do myNum <- integer
                    eof
                    return myNum

myMain = do print $ parseString parseAndReturn mempty "123"
            print $ parseString parseAndReturn mempty "123abc"
