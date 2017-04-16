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

-- woo showing things""
showVal :: LispVal -> String
showVal (String contents) = "\"" ++ contents ++ "\""
showVal (Atom name) = name
showVal (Number contents) = show contents
showVal (Float a) = show a
showVal (Character a) = "#\\"
                        ++ [a]
showVal (Ratio a) = show (numerator a)
                    ++ "/"
                    ++ show (denominator a)
showVal (Complex (a :+ b)) = show a
                             ++ "+"
                             ++ show b
                             ++ "i"
showVal (Bool True) = "#t"
showVal (Bool False) = "#f"
showVal (List contents) = "("
                          ++ unwordsList contents
                          ++ ")"
showVal (DottedList h t) = "("
                           ++ unwordsList h
                           ++ " . "
                           ++ showVal t
                           ++ ")"

unwordsList :: [LispVal] -> String
unwordsList = unwords . map showVal

instance Show LispVal where show = showVal

-- Woo Evaluator
eval :: LispVal -> LispVal
eval val@(String _) = val
eval val@(Number _) = val
eval val@(Float _) = val
eval val@(Complex _) = val
eval val@(Ratio _ ) = val
eval val@(Bool _) = val
eval (List [Atom "quote", val]) = val
eval (List (Atom func : args)) = apply func $ map eval args

apply :: String -> [LispVal] -> LispVal
apply func args = maybe (String "did not work") ($ args) $ lookup func primitives

primitives :: [(String, [LispVal] -> LispVal)]
primitives = [ ("+", numericBinop (+))
             , ("-", numericBinop (-))
             , ("*", numericBinop (*))
             , ("/", numericBinop div)
             , ("mod", numericBinop mod)
             , ("quotient", numericBinop quot)
             , ("remainder", numericBinop rem)
             , ("symbol?", unaryOp isSymbol)
             , ("number?", unaryOp isNumber)
             , ("string?", unaryOp isString)
             , ("symbol->string", unaryOp symbolToString)
             , ("string->symbol", unaryOp stringToSymbol)
             ]

numericBinop :: (Integer -> Integer -> Integer) -> [LispVal] -> LispVal
numericBinop op params = Number $ foldl1 op $ map unpackNum params

unpackNum :: LispVal -> Integer
unpackNum (Number n) = n

readExpr :: String -> LispVal
readExpr input = case parse parseExpr "lisp" input of
    Left err -> String $ "No match: " ++ show err
    Right val -> val

main :: IO ()
main = getArgs >>= print . eval . readExpr . head


-- Add primitives to perform the various type-testing functions of R5RS:
-- symbol?, string?, number?, etc.

unaryOp :: (LispVal -> LispVal) -> [LispVal] -> LispVal
unaryOp f [v] = f v

isSymbol :: LispVal -> LispVal
isSymbol (Atom _) = Bool True
isSymbol _ = Bool False

isString :: LispVal -> LispVal
isString (String _) = Bool True
isString _ = Bool False

isNumber :: LispVal -> LispVal
isNumber a = Bool $ case a of
                      (Number _) -> True
                      (Complex _) -> True
                      (Float _) -> True
                      (Ratio _ ) -> True
                      _ -> False
-- Add the symbol-handling functions from R5RS. A symbol is what we've been
-- calling an Atom in our data constructors

symbolToString :: LispVal -> LispVal
symbolToString (Atom str) = String str

stringToSymbol :: LispVal -> LispVal
stringToSymbol (String str) = Atom str
