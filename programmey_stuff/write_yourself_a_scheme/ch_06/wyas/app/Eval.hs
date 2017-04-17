module Eval where

import Control.Monad.Error
import Control.Monad
import Control.Applicative
import LispVal


trapError action = catchError action (return . show)

extractValue :: ThrowsError a -> a
extractValue (Right val) = val


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
