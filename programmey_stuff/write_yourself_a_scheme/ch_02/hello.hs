module Main where
import Control.Monad
import System.Environment
import Text.ParserCombinators.Parsec hiding (spaces)
import Numeric
import Data.Ratio
import Data.Complex
import Data.Function

data LispVal = Atom String
             | List [LispVal]
             | DottedList [LispVal] LispVal
             | Number Integer
             | Complex (Complex Double)
             | Float Double
             | String String
             | Ratio Rational
             | Bool Bool
             | Character Char
  deriving Show

spaces :: Parser ()
spaces = skipMany1 space

parseExpr :: Parser LispVal
parseExpr = parseAtom
         <|> parseString
         <|> try parseRatio
         <|> try parseFloat
         <|> try parseComplex
         <|> try parseNumber
         <|> try parseBool
         <|> try parseCharacter
         <|> parseQuasiQuoted
         <|> parseUnQuote
         <|> parseQuoted
         <|> char '(' *> (try parseList <|> parseDottedList) <* char ')'

readExpr :: String -> String
readExpr input = case parse parseExpr "lisp" input of
    Left err -> "No match: " ++ show err
    Right val -> "Found value: " ++ show val

main :: IO ()
main = do
         (expr:_) <- getArgs
         putStrLn (readExpr expr)

---- Exercises
-- Rewrite parseNumber, without liftM, using do-notation
parseNumber' :: Parser LispVal
parseNumber' = do numberStr <- many1 digit
                  let number = (Number . read) numberStr
                  return number

-- explicit sequencing with the >>= operator
parseNumber'' :: Parser LispVal
parseNumber'' = (many1 digit) >>= (return . Number . read)

-- Our strings aren't quite R5RS compliant, because they don't support escaping
-- of internal quotes within the string. Change parseString so that \" gives a
-- literal quote character instead of terminating the string. You may want to
-- replace noneOf "\"" with a new parser action that accepts either a non-quote
-- character or a backslash followed by a quote mark.

-- Modify the previous exercise to support \n, \r, \t, \\, and any other desired escape characters

noDoubleQuote :: Parser Char
noDoubleQuote = (noneOf ['"'])

escapedChars = [
  -- Double Quote
  '"'
  -- New Line
  , 'n'
  -- Whatever \r is ??
  , 'r'
  -- Tab
  , 't'
  -- Backslash
  ,'\\'
  ]

escapedChar :: Parser Char
escapedChar = char '\\' >> oneOf escapedChars >>=
  \parsedChar -> return $ case parsedChar of
                            'n' -> '\n'
                            'r' -> '\r'
                            't' -> '\t'
                            _ -> parsedChar

stringContents :: Parser String
stringContents = many (escapedChar <|> noDoubleQuote)

dq :: Parser Char
dq = char '"'

parseString :: Parser LispVal
parseString = String <$> (dq *> stringContents <* dq)


-- Change parseNumber to support the Scheme standard for different bases. You
-- may find the readOct and readHex functions useful.

-- symbol needs to be changed as to not allow hashes
symbol :: Parser Char
symbol = oneOf "!$%&|*+-/:<=>?@^_~"

parseAtom :: Parser LispVal
parseAtom = Atom <$> liftM2
            (:)
            (letter <|> symbol)
            (many (letter <|> digit <|> symbol))

parseBool :: Parser LispVal
parseBool = char '#' >> oneOf ['t', 'f'] >>=
            \c -> (return . Bool) $ 't' == c

parseNumber :: Parser LispVal
parseNumber = parseDecimal <|> parseHex <|> parseOct <|> parseBin

parseDecimal = parseDecimal1 <|> parseDecimal2

parseDecimal1 :: Parser LispVal
parseDecimal1 = Number . read <$> many1 digit

parseDecimal2 :: Parser LispVal
parseDecimal2 = try $ string "#d" >>
                Number . read <$> many1 digit

parseHex :: Parser LispVal
parseHex = try $ string "#x" >>
           Number . hex2dig <$> many1 hexDigit
  where hex2dig x = fst $ readHex x !! 0


parseOct :: Parser LispVal
parseOct = try $ string "#o" >>
           Number . oct2dig <$> many1 octDigit
  where oct2dig x = fst $ readOct x !! 0

parseBin :: Parser LispVal
parseBin = try $ string "#b" >>
           Number . bin2dig <$> many1 (oneOf ['0', '1'])
  where bin2dig  = bin2dig' 0
        bin2dig' digint "" = digint
        bin2dig' digint (x:xs) = let old = 2 * digint + (if x == '0' then 0 else 1) in
                                   bin2dig' old xs

-- Add a Character constructor to LispVal, and create a parser for character
-- literals as described in R5RS.

parseCharacter :: Parser LispVal
parseCharacter = try $ string "#\\" >>
                  Character . fixChar <$> (newLineOrSpace <|> aloneChar)
  where newLineOrSpace = try $ string "newline" <|> string "space"
        aloneChar = pure <$> anyChar <* notFollowedBy alphaNum
        fixChar "space" = ' '
        fixChar "newline" = '\n'
        fixChar (x:_) = x

-- Add a Float constructor to LispVal, and support R5RS syntax for decimals. The
-- Haskell function readFloat may be useful.

parseFloat :: Parser LispVal
parseFloat = (Float . fst . head . readFloat) <$> liftM2
             (\x y -> x ++ "." ++ y)
             (many1 digit <* char '.')
             (many1 digit)

parseRatio :: Parser LispVal
parseRatio = Ratio <$> liftM2
             (on (%) read)
             (many1 digit <* char '/')
             (many1 digit)

floatOrDecimal :: Parser LispVal
floatOrDecimal = try parseFloat <|> parseDecimal

parseComplex :: Parser LispVal
parseComplex = Complex <$> liftM2
               (on (:+) toDouble)
               (floatOrDecimal <* char '+')
               (floatOrDecimal <* char 'i')
  where toDouble(Float f) = realToFrac f
        toDouble(Number n) = fromIntegral n

--  (a -> b) (b -> b -> c) -> a -> a -> c


parseList :: Parser LispVal
parseList = List <$> sepBy parseExpr spaces

parseDottedList :: Parser LispVal
parseDottedList = liftM2
                  DottedList
                  (endBy parseExpr spaces)
                  (char '.' >> spaces >> parseExpr)

-- These could probably be refactored out into one function that takes "quote"
-- and character needed as arguments.
parseQuoted :: Parser LispVal
parseQuoted = (\e -> List [Atom "quote", e]) <$> (char '\'' >> parseExpr)

parseQuasiQuoted :: Parser LispVal
parseQuasiQuoted = (\e -> List [Atom "quasiquote", e]) <$> (char '`' >> parseExpr)

parseUnQuote :: Parser LispVal
parseUnQuote = (\e -> List [Atom "unquote", e]) <$> (char ',' >> parseExpr)
