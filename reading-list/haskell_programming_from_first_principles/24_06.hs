module AltParsing where
import Data.Ratio
import Control.Applicative
import Text.Trifecta

type NumberOrString = Either Integer String

a = "blah"
b = "123"
c = "123blah789"

parseNos :: Parser NumberOrString
parseNos = (Left <$> integer) <|> (Right <$> some letter)

main = do
  print $ parseString (some letter) mempty a
  print $ parseString integer mempty b
  print $ parseString parseNos mempty a
  print $ parseString parseNos mempty b
  print $ parseString (many parseNos) mempty c
  print $ parseString (some parseNos) mempty c

-- Exercise: Try Try

-- Make a parser, using the existing fraction parser plus a new decimal parser,
-- that can parse either decimals or fractions. You’ll want to use <|> from
-- Alternative to combine the...alternative parsers. If you find this too
-- difficult, write a parser that parses straightforward integers or fractions.
-- Make a datatype that contains either an integer or a rational and use that
-- datatype as the result of the parser. Or use Either. Run free, grasshopper.

-- Hint: we’ve not explained it yet, but you may want to try try.


parseFraction :: Parser Rational
parseFraction = do numerator <- decimal
                   char '/'
                   denomerator <- decimal
                   case denomerator of
                     0 -> fail "Denominator cannot be zero"
                     _ -> return (numerator % denomerator)

afterDot num = let scale = (fromIntegral . length . show) num
                   divisor = 10 ^ scale
               in num % divisor

parseDecimal :: Fractional a => Parser a
parseDecimal = do beforePeriod <- decimal
                  char '.'
                  afterPeriod <- decimal
                  return $ fromRational ((toRational beforePeriod) + (afterDot afterPeriod))

type NumberOrFraction = Either Double (Ratio Integer)

parseForD :: Parser NumberOrFraction
parseForD = (Left <$> try parseDecimal) <|>
            (Right <$> try parseFraction)

myMain :: IO ()
myMain = do print $ parseString parseForD mempty "123.12"
            print $ parseString parseForD mempty "123/12"
            print $ parseString parseForD mempty "12312"
