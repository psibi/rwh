import Data.Maybe
import qualified Data.Map as Map
import Control.Monad.Identity

type Eval1 a = Identity a

runEval1 :: Eval1 a -> a
runEval1 = runIdentity 

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

eval1 :: Env -> Exp -> Eval1 Value
eval1 env (Lit i) = return $ IntVal i
eval1 env (Var i) = maybe (fail ("undefined variable: " ++ i)) return $ Map.lookup i env

eval1 env (Plus e1 e2) = do IntVal i1 <- eval1 env e1
                            IntVal i2 <- eval1 env e2
                            return $ IntVal (i1 + i2)

eval1 env (Abs n e) = return $ FunVal env n e
eval1 env (App e1 e2 ) = do val1 <- eval1 env e1
                            val2 <- eval1 env e2
                            case val1 of
                              FunVal env' n body ->
                                eval1 (Map.insert n val2 env') body
