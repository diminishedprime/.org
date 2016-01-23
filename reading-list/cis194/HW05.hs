
import Parser

data ExprT = Lit Integer
           | Add ExprT ExprT
           | Mul ExprT ExprT
           deriving (Show, Eq)

-- Exercise 1

eval :: ExprT -> Integer
eval (Lit a) = a
eval (Add a b) = (eval a) + (eval b)
eval (Mul a b) = (eval a) * (eval b)
--For example, eval (Mul (Add (Lit 2) (Lit 3)) (Lit 4)) == 20


-- Exercise 2
evalString :: String -> Maybe Integer
evalString str = let expr = parseExp Lit Add Mul str
                 in case expr of
                 Nothing -> Nothing
                 (Just expr) -> Just $ eval expr


-- Exercise 3
class Expr a where
  lit :: Integer -> a
  add, mul :: a -> a -> a

instance Expr ExprT where
  lit a = (Lit a)
  add a b = (Add a b)
  mul a b = (Mul a b)

-- Exercise 4
instance Expr Integer where
  lit a = a
  add a b = a + b
  mul a b = a * b

instance Expr Bool where
  lit a = a > 0
  add a b = a || b
  mul a b = a && b


newtype MinMax = MinMax Integer deriving (Eq, Show)

instance Expr MinMax where
  lit a = (MinMax a)
  add (MinMax a) (MinMax b) = MinMax $ max a b
  mul (MinMax a) (MinMax b) = MinMax $ min a b

newtype Mod7 = Mod7 Integer deriving (Eq, Show)

instance Expr Mod7 where
  lit a = Mod7 a
  add (Mod7 a) (Mod7 b) = Mod7 $ mod ((mod a 7) + (mod b 7)) 7
  mul (Mod7 a) (Mod7 b) = Mod7 $ mod ((mod a 7) * (mod b 7)) 7

testExp :: Expr a => Maybe a
testExp = parseExp lit add mul "(3 * -4) + 5"
  


  

-- • MinMax — “addition” is taken to be the max function, while
-- “multiplication” is the min function
-- • Mod7 — all values should be in the ranage 0 . . . 6, and
-- all arithmetic is done modulo 7; for example,
-- 5 + 3 = 1.
