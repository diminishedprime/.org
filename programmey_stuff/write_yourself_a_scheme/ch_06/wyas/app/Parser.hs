module Parser where

import Control.Monad
import Control.Monad.Error
import LispVal
import Text.ParserCombinators.Parsec hiding (spaces)
import Data.Ratio
import Data.Complex
import Data.Function
import Numeric

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

parseDecimal :: Parser LispVal
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

readExpr :: String -> ThrowsError LispVal
readExpr input = case parse parseExpr "lisp" input of
     Left err -> throwError $ Parser err
     Right val -> return val
