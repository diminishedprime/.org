-- Sum Types
data Shape = Triangle
           | Square
           | Pentagon
           | Hexagon

-- Function using a Sum type
shapeToString :: Shape -> String
shapeToString Triangle = "Triangle!"
shapeToString Square = "Square!"
shapeToString Pentagon = "Pentagon!"
-- shapeToString Hexagon = "Hexagon :("


-- Product Type
data MetadataShape = MetaShape Shape String

-- Function using a Product type
metaShapeToString (MetaShape shape str) = shapeToString shape ++ " " ++ str


-- Recursive Types
data List a = Cons a (List a) | Null

exList = Cons 3 (Cons 4 (Cons 5 (Cons 6 Null)))

-- mapping function for our recursive type
listMap ::  (a -> b) -> List a -> List b
listMap f Null = Null
listMap f (Cons a b) = Cons (f a) (listMap f b)

increment x = x + 1

exAnswer = listMap increment exList
