-- Defining the `Points` typeclass
class Points a where
  numPoints :: a -> Int

-- Defining the `Sides` typeclass
class (Points a) => Sides a where
  numSides :: a -> Int
  numSides a = numPoints a

-- Making Shape an instance of the Points typeclass
instance Points Shape where
  numPoints Triangle = 3
  numPoints Square = 4
  numPoints Pentagon = 5
  numPoints Hexagon = 6

-- Making Shape an instance of the Points typeclass
instance Sides Shape
