{-# LANGUAGE QuasiQuotes       #-}
import Data.Word
import Text.Trifecta
import Control.Applicative ((<|>))
import Data.Monoid ((<>))
import Data.Char (digitToInt)
import Text.RawString.QQ

-- 1. Write a parser for semantic versions as defined by http://semver. org/. A
-- er making a working parser, write an Ord instance for the SemVer type that
-- obeys the specification outlined on the SemVer website.

-- Relevant to precedence/ordering, cannot sort numbers like strings.
data NumberOrString = NOSS String | NOSI Integer deriving Show

instance Eq NumberOrString where
  (NOSI i) == (NOSI i') = i == i'
  (NOSS s) == (NOSS s') = s == s'
  _ == _ = False

instance Ord NumberOrString where
  compare (NOSI i) (NOSI i') = compare i i'
  compare (NOSS s) (NOSS s') = compare s s'
  compare (NOSI _) _         = LT
  compare _        (NOSI _)  = GT

type Major = Integer
type Minor = Integer
type Patch = Integer
type Release = [NumberOrString]
type Metadata = [NumberOrString]

data SemVer = SemVer Major Minor Patch Release Metadata deriving Show

instance Eq SemVer where
  (SemVer ma mi pa re me) == (SemVer ma' mi' pa' re' me') =
    ma == ma' && mi == mi' && pa == pa' && re == re' && me == me'

instance Ord SemVer where
  compare (SemVer ma mi pa re _) (SemVer ma' mi' pa' re' _) =
    let c = (compare ma ma') <> (compare mi mi') <> (compare pa pa')
    in case c of
        EQ -> compare re re'
        _  -> c

nos :: Parser NumberOrString
nos = (NOSI <$> decimal) <|> (NOSS <$> some letter)

nosDot :: Parser NumberOrString
nosDot = do
  ns <- nos
  skipMany (oneOf ".")
  return ns

relP :: Parser [NumberOrString]
relP = do
  (char '-' >> many nosDot) <|> (return [])

metP :: Parser [NumberOrString]
metP = do
  (char '+' >> many nosDot) <|> (return [])

parseSemVer :: Parser SemVer
parseSemVer = do
  ma <- decimal
  char '.'
  mi <- decimal
  char '.'
  pa <- decimal
  rel <- try relP
  met <- try metP
  return $ SemVer ma mi pa rel met

-- Expected results:
-- Prelude> parseString parseSemVer mempty "2.1.1"
-- Success (SemVer 2 1 1 [] [])
-- Prelude> parseString parseSemVer mempty "1.0.0-x.7.z.92"
-- Success (SemVer 1 0 0 [NOSS "x", NOSI 7, NOSS "z", NOSI 92] [])
-- Prelude> SemVer 2 1 1 [] [] > SemVer 2 1 0 [] []
-- True



-- 2. Write a parser for positive integer values. Don’t reuse the pre- existing
-- digit or integer functions, but you can use them for inspiration if you get
-- stuck.

parseDigit :: Parser Char
parseDigit = oneOf "012345679"

makeNumber :: [Char] -> Integer
makeNumber = toInteger .
             foldr (+) 0 .
             fmap (\(power, number) -> number * 10 ^ power) .
             zip [0..] .
             reverse .
             fmap digitToInt

base10Integer :: Parser Integer
base10Integer = do digits <- some parseDigit
                   return $ makeNumber digits

-- Expected results:
-- Prelude> parseString parseDigit mempty "123"
-- Success '1'
-- Prelude> parseString parseDigit mempty "abc"
-- Failure (interactive):1:1: error: expected: parseDigit
-- abc<EOF>
-- ^
-- Prelude> parseString base10Integer mempty "123abc"
-- Success 123
-- Prelude> parseString base10Integer mempty "abc"
-- Failure (interactive):1:1: error: expected: integer
-- abc<EOF>
-- ^

-- Hint: Assume you’re parsing base-10 numbers. Use arithmetic as a cheap
-- “accumulator” for your final number as you parse each digit le -to-right.

-- 3. Extend the parser you wrote to handle negative and positive integers. Try
-- writing a new parser in terms of the one you already have to do this.
pOrNBase10Integer = do negativeSign <- many $ char '-'
                       number <- base10Integer
                       return $ number * case length negativeSign of
                                           0 -> 1
                                           _ -> (-1)

-- Prelude> parseString base10Integer' mempty "-123abc"
-- Success (-123)

-- 4. Write a parser for US/Canada phone numbers with varying formats.

type NumberingPlanArea = Integer -- aka area code
type Exchange = Integer
type LineNumber = Integer
data PhoneNumber = PhoneNumber NumberingPlanArea Exchange LineNumber deriving (Eq, Show)

phoneBullshit :: Parser String
phoneBullshit = many $ oneOf " -)("

parsePhone :: Parser PhoneNumber
parsePhone = do optional $ string "1-"
                phoneBullshit
                npa <- count 3 digit
                phoneBullshit
                ex <- count 3 digit
                phoneBullshit
                ln <- count 4 digit
                return $ PhoneNumber (makeNumber npa) (makeNumber ex) (makeNumber ln)

-- With the following behavior:
-- Prelude> parseString parsePhone mempty "123-456-7890"
-- Success (PhoneNumber 123 456 7890)
-- Prelude> parseString parsePhone mempty "1234567890"
-- Success (PhoneNumber 123 456 7890)
-- Prelude> parseString parsePhone mempty "(123) 456-7890"
-- Success (PhoneNumber 123 456 7890)
-- Prelude> parseString parsePhone mempty "1-123-456-7890"
-- Success (PhoneNumber 123 456 7890)

-- Cf. Wikipedia’s article on “National conventions for writing telephone
-- numbers”. You are encouraged to adapt the exercise to your locality’s
-- conventions if they are not part of the NNAP scheme.

-- 5. Write a parser for a log file format and sum the time spent in each
-- activity. Additionally, provide an alternative aggregation of the data that
-- provides average time spent per activity per day. The format supports the use
-- of comments which your parser will have to ignore. The # characters followed
-- by a date mark the beginning of a particular day.

data Timestamp = Timestamp Integer Integer deriving Show
type Description = String
data Activity = Activity Timestamp Description deriving Show

activity :: Parser Activity
activity = do hour <- makeNumber <$> count 2 digit
              char ':'
              minutes <- makeNumber <$> count 2 digit
              char ' '
              description <- many (letter <|> (oneOf " -&,?"))
              newline
              return $ Activity (Timestamp hour minutes) description

data Date = Date Integer Integer Integer deriving Show
data LogDay = LogDay Date [Activity] deriving Show

date :: Parser Date
date = do char '#' >> char ' '
          year <- makeNumber <$> count 4 digit
          char '-'
          month <- makeNumber <$> count 2 digit
          char '-'
          day <- makeNumber <$> count 2 digit
          try comment <|> many newline
          return $ Date year month day

comment :: Parser String
comment = optional space >> (string "--") >> (many $ noneOf "\n") >> many newline

logDay = do logDate <- date
            activities <- many activity
            return $ LogDay logDate activities

data Log = Log [LogDay] deriving Show

log = do days <- many $ (logDay <* (many newline))
         return $ Log days

logString :: String
logString = [r|# 2025-02-05
08:00 Breakfast
09:00 Sanitizing moisture collector
11:00 Exercising in high-grav gym
12:00 Lunch
13:00 Programming
17:00 Commuting home in rover
17:30 R&R
19:00 Dinner
21:00 Shower
21:15 Read
22:00 Sleep

# 2025-02-07 -- dates not nececessarily sequential
08:00 Breakfast -- should I try skippin bfast?
09:00 Bumped head, passed out
13:36 Wake up, headache
13:37 Go to medbay
13:40 Patch self up
13:45 Commute home for rest
14:15 Read
21:00 Dinner
21:15 Read
22:00 Sleep
|]
-- You are to derive a reasonable datatype for representing this data yourself.
-- For bonus points, make this bi-directional by making a Show representation
-- for the datatype which matches the format you are parsing. Then write a
-- generator for this data using QuickCheck’s Gen and see if you can break your
-- parser with QuickCheck.

-- 6. Write a parser for IPv4 addresses.

data IPAddress = IPAddress Word32 deriving (Eq, Ord, Show)

ipv4String :: Parser [Int]
ipv4String = do first <- many digit <* char '.'
                second <- many digit <* char '.'
                third <- many digit <* char '.'
                fourth <- many digit
                return $ read <$> [first, second, third, fourth]

-- A 32-bit word is a 32-bit unsigned int. Lowest value is 0 rather than being
-- capable of representing negative numbers, but the highest possible value in
-- the same number of bits is twice as high. Note:

-- Prelude> import Data.Int
-- Prelude> import Data.Word
-- Prelude> maxBound :: Int32
-- 2147483647
-- Prelude> maxBound :: Word32
-- 4294967295
-- Prelude> div 4294967295 2147483647
-- 2

-- Word32 is an appropriate and compact way to represent IPv4 addresses. You are
-- expected to figure out not only how to parse the typical IP address format,
-- but how IP addresses work numer- ically insofar as is required to write a
-- working parser. This will require using a search engine unless you have an
-- appropriate book on internet networking handy.

-- Example IPv4 addresses and their decimal representations:
-- 172.16.254.1 -> 2886794753
-- 204.120.0.15 -> 3430416399

-- I was a bit lazy, but I just didn't feel like figuring out that ipv4 is base
-- 8 or whatever.

-- 7. Same as before, but IPv6.
data IPAddress6 = IPAddress6 Word64 Word64 deriving (Eq, Ord, Show)

ipv6String :: Parser [String]
ipv6String = do first <- many hexDigit <* char ':'
                second <- many hexDigit <* char ':'
                third <- many hexDigit <* char ':'
                fourth <- many hexDigit <* char ':'
                fifth <- many hexDigit <* char ':'
                sixth <- many hexDigit <* char ':'
                seventh <- many hexDigit <* char ':'
                eighth <- many hexDigit
                return $ [first, second, third, fourth, fifth, sixth, seventh, eighth]

-- Example IPv6 addresses and their decimal representations:

-- 0:0:0:0:0:ffff:ac10:fe01 -> 281473568538113
-- 0:0:0:0:0:ffff:cc78:f    -> 281474112159759

-- FE80:0000:0000:0000:0202:B3FF:FE1E:8329 -> 338288524927261089654163772891438416681
-- 2001:DB8::8:800:200C:417A -> 42540766411282592856906245548098208122

-- One of the trickier parts about IPv6 will be full vs. collapsed addresses and
-- the abbrevations. See this Q&A thread14 about IPv6 abbreviations for more.

-- Ensure you can parse abbreviated variations of the earlier ex- amples like:
--FE80::0202:B3FF:FE1E:8329
--2001:DB8::8:800:200C:417A

-- also lazy on this one...

-- 8. Remove the derived Show instances from the IPAddress/IPAd- dress6 types,
-- write your own Show instance for each type that renders in the typical
-- textual format appropriate to each.

-- 9. Write a function that converts between IPAddress and IPAd- dress6.

-- 10. Write a parser for the DOT language15 Graphviz uses to express graphs in
-- plain-text.

-- We suggest you look at the AST datatype in Haphviz16 for ideas on how to
-- represent the graph in a Haskell datatype. If you’re feeling especially
-- robust, you can try using fgl17.
