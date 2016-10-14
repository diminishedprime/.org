module DayOne exposing (..)

productOfList : List number -> number
productOfList = List.foldl (*) 1


allXFields = List.map (\ {x} -> x)

multiply a b = a * b
