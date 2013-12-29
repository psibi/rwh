class (Monad m) => MonadPlus m where
    mzero :: m a
    mplus :: m a -> m a -> m a

instance MonadPlus Maybe where
    mzero = Nothing
    mplus Nothing x = x
    mplus x _ = x

