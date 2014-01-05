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
