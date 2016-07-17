{-# LANGUAGE OverloadedStrings #-}

module Text.Fractions where

import Control.Applicative
import Data.Ratio ((%))
import Text.Trifecta

badFraction = "1/0"
alsoBad = "10"
shouldWork = "1/2"
shouldAlsoWork = "2/1"


parseFraction :: Parser Rational
parseFraction = do
  numerator <- decimal
  _ <- char '/'
  denominator <- decimal
  case denominator of
    0 -> fail "Denominator cannot be zero"
    _ -> return (numerator % denominator)
  return (numerator % denominator)

main :: IO ()
main = do
  print $ parseString parseFraction mempty badFraction
  print $ parseString parseFraction mempty alsoBad
  print $ parseString parseFraction mempty shouldWork
  print $ parseString parseFraction mempty shouldAlsoWork


yourFuncHere :: Parser Integer
yourFuncHere = do
  number <- integer
  _ <- eof
  return number

name = parseString (yourFuncHere) mempty "123"
