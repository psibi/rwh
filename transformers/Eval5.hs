import Control.Monad.Identity
import Control.Monad.Error
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer
import qualified Data.Map as Map

type Eval5 a = ReaderT Env (ErrorT String
                           (WriterT [String] (StateT Integer Identity))) a

tick :: (Num s, MonadState s m) => m ()
tick = do st <- get
          put (st + 1)

runEval5 :: Env -> Integer -> Eval5 a -> ((Either String a, [String]), Integer)
runEval5 env st ev = runIdentity (runStateT (runWriterT (runErrorT (runReaderT ev env))) st)

type Name = String
data Exp = Lit Integer
         | Var Name
         | Plus Exp Exp
         | Abs Name Exp
         | App Exp Exp
         deriving (Show)

data Value = IntVal Integer
           | FunVal Env Name Exp
           deriving (Show)

type Env = Map.Map Name Value

eval5 :: Exp -> Eval5 Value
eval5 (Lit i) = do tick
                   return $ IntVal i
eval5 (Var n) = do tick
                   env <- ask
                   tell [n]
                   case Map.lookup n env of
                     Nothing -> throwError ("undefined variable: " ++ n)
                     Just x -> return x
eval5 (Plus e1 e2) = do tick
                        env <- ask
                        e1' <- eval5 e1
                        e2' <- eval5 e2
                        case (e1', e2') of
                          (IntVal i1, IntVal i2) ->
                              return $ IntVal (i1 + i2)
                          _ -> throwError "type error in addition"
eval5 (Abs n e) = do tick
                     env <- ask
                     return $ FunVal env n e 
eval5 (App e1 e2) = do tick
                       val1 <- eval5 e1
                       val2 <- eval5 e2
                       case val1 of
                         FunVal env' n body ->
                             local (const (Map.insert n val2 env'))
                                 (eval5 body)
                         _ -> throwError "type error in application"

