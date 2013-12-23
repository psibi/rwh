import Data.Maybe
import qualified Data.Map as Map

type Name = String
data Exp = Lit Integer
         | Var Name
         | Plus Exp Exp
         | Abs Name Exp
         | App Exp Exp
         deriving (Show)

data Value = IntVal Integer
           | FunVal Env Name Exp

type Env = Map.Map Name Value

eval0 :: Env -> Exp -> Value
eval0 env (Lit i) = IntVal i
eval0 env (Var i) = fromJust $ Map.lookup i env


eval0 env (Plus e1 e2) = let IntVal i1 = eval0 env e1
                             IntVal i2 = eval0 env e2
                         in IntVal (i1 + i2)

eval0 env (Abs n e) = FunVal env n e
eval0 env (App e1 e2 ) = let val1 = eval0 env e1
                             val2 = eval0 env e2
                         in case val1 of
                           FunVal env' n body -> eval0 (Map.insert n val2 env') body

-- exampleExp = Lit 12 `Plus` (App (Abs "x" (Var "x")) (Lit 4 `Plus` Lit 2))
-- exampleExp = Lit 12 `Plus` (App (Abs "x" (Var "x")) IntVal 6
-- exampleExp = Lit 12 `Plus` (App FunVal env "x" (Var "x")) IntVal 6
                           



