module Main where
import System.Environment

main :: IO ()
main = do putStrLn "Please Enter a number"
          first <- getLine
          putStrLn "Please Enter a second number"
          second <- getLine
          putStrLn $ "The sum of the numbers is "
            ++ show (read first + read second)
