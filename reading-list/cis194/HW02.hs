{-# OPTIONS_GHC -Wall #-}
module LogAnalysis where
import Log

parseMessage :: String -> LogMessage
parseMessage m = parseHelper (words m)

parseHelper :: [String] -> LogMessage
parseHelper ("E":s:t:xs) = LogMessage (Error (read s)) (read t) (unwords xs)
parseHelper ("I":t:xs) = LogMessage (Info) (read t) (unwords xs)
parseHelper ("W":t:xs) = LogMessage (Warning) (read t) (unwords xs)
parseHelper x = Unknown (unwords x)

parse :: String -> [LogMessage]
parse x = map parseMessage (lines x)

-- Exercise 2

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _) tree = tree
insert msg Leaf = Node Leaf msg Leaf
insert msg tree =
  let (LogMessage _ ts _) = msg
      (Node left otherMessage right) = tree
      (LogMessage _ otherTs _) = otherMessage
  in if ts < otherTs
        then (Node (insert msg left) otherMessage right)
     else (Node left otherMessage (insert msg right))

-- Exercise 3
build :: [LogMessage] -> MessageTree
build = foldr insert Leaf

-- Exercise 4
inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node left msg right) = (inOrder left) ++ [msg] ++ (inOrder right)

-- Exercise 5
whatWentWrong :: [LogMessage] -> [String]
whatWentWrong = map (\(LogMessage _ _ msg) -> msg) . filter p . inOrder . build
     where p :: LogMessage -> Bool
           p (LogMessage (Error sev) _ _) = sev >= 50
           p _ = False
