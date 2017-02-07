import Control.Applicative

data Color = Red
           | Blue
           | Orange
           | Pink
           | GreenWhichIsNotACreativeColor
  deriving Show

data Person = Person String String Color deriving Show

myFunctionThatTalksToADatabase :: String -> String
myFunctionThatTalksToADatabase _ = undefined

getName personId = myFunctionThatTalksToADatabase "select name where this is obviously not a real query"
getDOB personId = myFunctionThatTalksToADatabase "dob"
getFavoriteColor personId = Red

printPersonDetails = Person (getName 3) (getDOB 3) (getFavoriteColor 3)

-- This compiles, but it's only because we used undefined
results = printPersonDetails


-- Proper Way
myDbFunction :: String -> Maybe String
myDbFunction "dob" = Just "03/27/1992"
myDbFunction "name" = Just "Matt!"
myDbFunction _ = Just "Hello there from the database"

getNameSafe 3 = myDbFunction "name"
getNameSafe _ = Nothing

getDOBSafe 3 = myDbFunction "dob"
getDOBSafe _ = Nothing

getFavoriteColorSafe 3 = Just Red
getFavoriteColorSafe _ = Nothing

printPerson = Person <$> (getNameSafe 3) <*> (getDOBSafe 3) <*> (getFavoriteColorSafe 3)

printPerson2 = Person <$> (getNameSafe 4) <*> (getDOBSafe 4) <*> (getFavoriteColorSafe 4)
