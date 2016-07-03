{-# LANGUAGE RankNTypes #-}
module LearnParsers where
import Text.Trifecta

stop :: Parser a
stop = unexpected "stop"

one = char '1'

one' = one >> stop

-- read two characters, '1', and '2'
oneTwo = char '1' >> char '2'

-- read two characters, '1' and '2', then die
oneTwo' = oneTwo >> stop

testParse :: Parser Char -> IO ()
testParse p = print $ parseString p mempty "123"

pNL s = putStrLn ('\n' : s)
main = do
  pNL "stop:"
  testParse stop
  pNL "one:"
  testParse one
  pNL "one':"
  testParse one'
  pNL "oneTwo:"
  testParse oneTwo
  pNL "oneTwo':"
  testParse oneTwo'


-- Exercises: Parsing Practice

-- 1. There’s a combinator that’ll let us mark that we expect an input stream to
-- be “finished” at a particular point in our parser. In the parsers library
-- this is simply called eof (end-of-file) and is in the Text.Parser.Combinators
-- module. See if you can make the one and oneTwo parsers fail because they
-- didn’t exhaust the input stream!
testEOF :: Parser () -> IO ()
testEOF p = print $ parseString p mempty "123"

-- 2. Use string to make a Parser that parses “1”,“12”, and “123” out of the
-- example input respectively. Try combining it with stop too. That is, a single
-- parser should be able to parse all three of those strings.
testParseString :: Parser String -> IO ()
testParseString p = print $ parseString p mempty "123"

type S = forall m. CharParsing m => m String

oneS :: S
oneS = string "1"

oneTwoS :: S
oneTwoS = string "12"

-- 3. Try writing a Parser that does what string does, but using char.
-- ???????????????????
