import Control.Monad
import Data.Char (toLower)
import System.Exit (exitSuccess)
import System.IO

-- 1. Ciphers: Open your Ciphers module and modify it so that the Caesar and
-- Vigenère ciphers work with user input.


-- nah

-- 2. Here is a very simple, short block of code. Notice it has a forever that
-- will make it keep running, over and over again. Load it into your REPL and
-- test it out. Then refer back to the chapter and modify it to exit
-- successfully after a False result.

palindrome :: IO ()
palindrome = forever $ do
  line1 <- getLine
  case (line1 == reverse line1) of
    True -> putStrLn "It's a palindrome!"
    False -> exitSuccess

-- 3. If you tried using palindrome on a sentence such as “Madam I’m Adam,” you
-- may have noticed that palindrome checker doesn’t work on that. Modifying the
-- above so that it works on sentences, too, involves several steps. You may
-- need to refer back to previ- ous examples in the chapter to get ideas for
-- proper ordering and nesting. You may wish to import Data.Char to use the
-- function toLower. Have fun.

palindrome' :: IO ()
palindrome' = forever $ do
  line1 <- getLine
  case (palindromeHelper line1) of
    True -> putStrLn "It's a palindrome!"
    False -> exitSuccess
  where palindromeHelper x = let allLower = map toLower x
                                 noPunct = filter (\x -> not $ elem x ".!,' ") allLower
                             in noPunct == reverse noPunct

-- 4.
type Name = String
type Age = Integer
data Person = Person Name Age
  deriving Show
data PersonInvalid = NameEmpty
                   | AgeTooLow
                   | PersonInvalidUnknown String
  deriving (Eq, Show)
mkPerson :: Name
         -> Age
         -> Either PersonInvalid Person
mkPerson name age
  | name /= "" && age > 0 = Right $ Person name age
  | name == "" = Left NameEmpty
  | not (age > 0) = Left AgeTooLow
  | otherwise = Left $ PersonInvalidUnknown $
                "Name was: " ++ show name ++
                " Age was: " ++ show age

-- Your job is to write the following function without modifying the code above.
gimmePerson :: IO ()
gimmePerson = do
  hSetBuffering stdout NoBuffering
  putStr "Please enter your name: "
  name <- getLine
  putStr "\nPlease enter your age: "
  age <- getLine
  let person = mkPerson name (read age)
  case person of
    (Left (PersonInvalidUnknown str)) -> putStr str
    (Left NameEmpty) -> putStr "You can't have an empty name"
    (Left AgeTooLow) -> putStr "The age was too low"
    _ -> putStr $ "Yay! Sucessfully got a person: " ++ show person

-- Since IO () is about the least informative type imaginable, we’ll tell what it should do.

-- a) It should prompt the user for a name and age input.

-- b) It should attempt to construct a Person value using the name and age the
-- user entered. You’ll need the read function for Age because it’s an Integer
-- rather than a String.

-- c) If it constructed a successful person, it should print ”Yay! Successfully
-- got a person:” followed by the Person value.

-- d) If it got an error value, report that an error occurred and print the
-- error.
