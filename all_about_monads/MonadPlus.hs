class (Monad m) => MonadPlus m where
    mzero :: m a
    mplus :: m a -> m a -> m a

instance MonadPlus Maybe where
    mzero = Nothing
    mplus Nothing x = x
    mplus x _ = x

instance MonadPlus [] where
  mzero = []
  mplus = (++)

msum :: MonadPlus m => [m a] -> m a
msum xs = foldr mplus mzero xs

guard :: MonadPlus m => Bool -> m ()
guard p = if p then return () else mzero

-- Some Examples

type Variable = String
type Value = String
type EnvironmentStack = [[(Variable, Value)]]

lookupVar1 :: Variable -> EnvironmentStack -> Maybe Value
lookupVar1 var [] = Nothing
lookupVar1 var (x:xs) = let val = lookup var x
                        in maybe (lookupVar1 var xs) Just val

-- Using 
lookupVar2 :: Variable -> EnvironmentStack -> Maybe Value
lookupVar2 var stack = msum $ map (lookup var) stack
