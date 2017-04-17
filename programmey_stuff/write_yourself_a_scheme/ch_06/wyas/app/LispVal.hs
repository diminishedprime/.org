module LispVal (
  LispVal(..)
  , LispError(..)
  , ThrowsError
  ) where

import Control.Monad.Error
import Data.Ratio
import Data.Complex
import Text.ParserCombinators.Parsec hiding (spaces)

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
