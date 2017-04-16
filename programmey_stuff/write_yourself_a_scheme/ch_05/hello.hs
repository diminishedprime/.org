module Main where
import Control.Monad
import Control.Applicative hiding ((<|>), many)
import Control.Monad.Error
import System.Environment
import Text.ParserCombinators.Parsec hiding (spaces)
import Numeric
import Data.Ratio
import Data.Complex
import Data.Function

data LispError = NumArgs Integer [LispVal]
               | TypeMismatch String LispVal
               | Parser ParseError
               | BadSpecialForm String LispVal
               | NotFunction String String
               | UnboundVar String String
               | Default String

showError :: LispError -> String
showError (UnboundVar message varname)  = message ++ ": " ++ varname
showError (BadSpecialForm message form) = message ++ ": " ++ show form
showError (NotFunction message func)    = message ++ ": " ++ show func
showError (NumArgs expected found)      = "Expected "
                                          ++ show expected
                                          ++ " args; found values "
                                          ++ unwordsList found
showError (TypeMismatch expected found) = "Invalid type: expected "
                                          ++ expected
                                          ++ ", found " ++ show found
showError (Parser parseErr)             = "Parse error at " ++ show parseErr
showError (Default message)             = message

instance Show LispError where show = showError

instance Error LispError where
     noMsg = Default "An error has occurred"
     strMsg = Default

type ThrowsError = Either LispError

trapError action = catchError action (return . show)

extractValue :: ThrowsError a -> a
extractValue (Right val) = val

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

apply :: String -> [LispVal] -> ThrowsError LispVal
apply func args = maybe (throwError $ NotFunction "Unrecognized primitive function args" func)
                        ($ args)
                        (lookup func primitives)

numericBinop :: (Integer -> Integer -> Integer) -> [LispVal] -> ThrowsError LispVal
numericBinop op           []  = throwError $ NumArgs 2 []
numericBinop op singleVal@[_] = throwError $ NumArgs 2 singleVal
numericBinop op params        = mapM unpackNum params >>= return . Number . foldl1 op

unpackNum :: LispVal -> ThrowsError Integer
unpackNum (Number n) = return n
unpackNum notNum     = throwError $ TypeMismatch "number" notNum

readExpr :: String -> ThrowsError LispVal
readExpr input = case parse parseExpr "lisp" input of
     Left err -> throwError $ Parser err
     Right val -> return val


main :: IO ()
main = do
     args <- getArgs
     evaled <- return $ liftM show $ readExpr (args !! 0) >>= eval
     putStrLn $ extractValue $ trapError evaled

-- Add primitives to perform the various type-testing functions of R5RS:
-- symbol?, string?, number?, etc.

unaryOp :: (LispVal -> LispVal) -> [LispVal] -> ThrowsError LispVal
unaryOp _ [] = throwError $ NumArgs 1 []
unaryOp f (a:[]) = return $ f a
unaryOp _ a = throwError $ NumArgs 1 a

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


primitives :: [(String, [LispVal] -> ThrowsError LispVal)]
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
             , ("=", numBoolBinop (==))
             , ("<", numBoolBinop (<))
             , (">", numBoolBinop (>))
             , ("/=", numBoolBinop (/=))
             , (">=", numBoolBinop (>=))
             , ("<=", numBoolBinop (<=))
             , ("&&", boolBoolBinop (&&))
             , ("||", boolBoolBinop (||))
             , ("string=?", strBoolBinop (==))
             , ("string<?", strBoolBinop (<))
             , ("string>?", strBoolBinop (>))
             , ("string<=?", strBoolBinop (<=))
             , ("string>=?", strBoolBinop (>=))
             , ("car", car)
             , ("cdr", cdr)
             , ("cons", cons)
             , ("eq?", eqv)
             , ("eqv?", eqv)
             ]

boolBinop :: (LispVal -> ThrowsError a)
          -> (a -> a -> Bool)
          -> [LispVal]
          -> ThrowsError LispVal
boolBinop unpacker op (l:r:[]) = Bool <$> liftA2 op (unpacker l) (unpacker r)
boolBinop _ _ args = throwError $ NumArgs 2 args

numBoolBinop :: (Integer -> Integer -> Bool)
             -> [LispVal]
             -> ThrowsError LispVal
numBoolBinop  = boolBinop unpackNum

strBoolBinop :: (String -> String -> Bool)
             -> [LispVal]
             -> ThrowsError LispVal
strBoolBinop  = boolBinop unpackStr

boolBoolBinop :: (Bool -> Bool -> Bool)
              -> [LispVal]
              -> ThrowsError LispVal
boolBoolBinop = boolBinop unpackBool

unpackStr :: LispVal -> ThrowsError String
unpackStr (String s) = return s
unpackStr (Number s) = return $ show s
unpackStr (Bool s)   = return $ show s
unpackStr notString  = throwError $ TypeMismatch "string" notString

unpackBool :: LispVal -> ThrowsError Bool
unpackBool (Bool b) = return b
unpackBool notBool  = throwError $ TypeMismatch "boolean" notBool

truthy :: LispVal -> Bool
truthy (List []) = False
truthy (Bool False) = False
truthy _ = True

cond :: [LispVal] -> ThrowsError LispVal
cond ((List (Atom "else" : value : [])) : []) = eval value
cond ((List (condition : value : [])) : alts) = do
  result <- eval condition
  if truthy result
    then eval value
    else cond alts
cond ((List a) : _) = throwError $ NumArgs 2 a
cond (a : _) = throwError $ NumArgs 2 [a]
cond _ = throwError $ Default "Not viable alternative in cond"

-- Woo Evaluator
eval :: LispVal -> ThrowsError LispVal
eval val@(String _) = return val
eval val@(Number _) = return val
eval val@(Bool _) = return val
eval val@(Float _) = return val
eval val@(Complex _) = return val
eval val@(Ratio _ ) = return val
eval (List [Atom "quote", val]) = return val
eval (List [Atom "if", predicate, conseq, alt]) = eval predicate >>=
  \result -> case result of
               Bool False -> eval alt
               _ -> eval conseq
eval (List (Atom "cond" : pairs)) = cond pairs
eval (List (Atom func : args)) = mapM eval args >>= apply func
eval badForm = throwError $ BadSpecialForm "Unrecognized special form" badForm

car :: [LispVal] -> ThrowsError LispVal
car [List (x : xs)]       = return x
car [DottedList (x : xs) _] = return x
car [badArg]              = throwError $ TypeMismatch "pair" badArg
car badArgList            = throwError $ NumArgs 1 badArgList

cdr :: [LispVal] -> ThrowsError LispVal
cdr [List (x : xs)]         = return $ List xs
cdr [DottedList [_] x]      = return x
cdr [DottedList (_ : xs) x] = return $ DottedList xs x
cdr [badArg]                = throwError $ TypeMismatch "pair" badArg
cdr badArgList              = throwError $ NumArgs 1 badArgList

cons :: [LispVal] -> ThrowsError LispVal
cons [x1, List []]            = return $ List [x1]
cons [x, List xs]             = return $ List $ x : xs
cons [x, DottedList xs xlast] = return $ DottedList (x : xs) xlast
cons [x1, x2]                 = return $ DottedList [x1] x2
cons badArgList = throwError $ NumArgs 2 badArgList

eqv :: [LispVal] -> ThrowsError LispVal
eqv [(Bool arg1), (Bool arg2)]             = return $ Bool $ arg1 == arg2
eqv [(Number arg1), (Number arg2)]         = return $ Bool $ arg1 == arg2
eqv [(String arg1), (String arg2)]         = return $ Bool $ arg1 == arg2
eqv [(Atom arg1), (Atom arg2)]             = return $ Bool $ arg1 == arg2
eqv [(DottedList xs x), (DottedList ys y)] = eqv [List $ xs ++ [x], List $ ys ++ [y]]
eqv [(List arg1), (List arg2)]             = return $ Bool $ (length arg1 == length arg2) &&
                                                             (all eqvPair $ zip arg1 arg2)
     where eqvPair (x1, x2) = case eqv [x1, x2] of
                                Left err -> False
                                Right (Bool val) -> val
eqv [_, _]                                 = return $ Bool False
eqv badArgList                             = throwError $ NumArgs 2 badArgList
