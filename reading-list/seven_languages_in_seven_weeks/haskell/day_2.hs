mySort :: Ord a => [a] -> [a]
mySort (a:as) = let smallerOrEqual = [s | s <- as, s <= a]
                    bigger = [s | s <- as, s >= a]
                in mySort smallerOrEqual ++ [a] ++ mySort bigger
mySort [] = []


mySortComp :: Ord a => (a -> a -> Ordering) -> [a] -> [a]
mySortComp p (a:as) = let smallerOrEqual = [s | s <- as, case p a s of
                                                           LT -> True
                                                           EQ -> True
                                                           GT -> False]
                          bigger = [s | s <- as, case p a s of
                                                   LT -> False
                                                   EQ -> False
                                                   GT -> True]
                      in mySortComp p smallerOrEqual ++ [a] ++ mySortComp p bigger
mySortComp _ [] = []
