newtype Identity a = Identity { runIdentity :: a }

instance Monad Identity where
    return a = Identity a
    (Identity x) >>= f = f x


