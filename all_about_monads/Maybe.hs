data Maybe a = Nothing | Just a

instance Monad Maybe where
    return = Just
    fail = Nothing
    Nothing >>= _ = Nothing
    Just x >>= f = f x

instance MonadPlus Maybe where
    mzero               = Nothing
    (Nothing) `mplus` x = x
     x `mplus` _        = x
