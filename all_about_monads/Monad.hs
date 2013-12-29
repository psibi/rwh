class Monad m where
    (>>=) :: m a -> (a -> m b) -> m b
    return :: a -> m a

instance Monad Maybe where
    Nothing >>= _   = Nothing
    (Just x) >>= f  = f x
    return x        = Just x

