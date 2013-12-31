class Monad m where
    (>>=) :: m a -> (a -> m b) -> m b
    return :: a -> m a

instance Monad Maybe where
    Nothing >>= _   = Nothing
    (Just x) >>= f  = f x
    return x        = Just x

--- Sequence Functions

sequence :: Monad m => [m a] -> m [a]
sequence = foldr mcons (return [])
  where mcons p q = p >>= \x -> q >>= \y -> return (x:y)

sequence_ :: Monad m => [m a] -> m ()
sequence_ = foldr (>>) (return ())


--- Mapping functions

mapM :: Monad m => (a -> m b) -> [a] -> m [b]
mapM f as = sequence $ map f as

mapM_ :: Monad m => (a -> m b) -> [a] -> m ()
mapM_ f as = sequence_ $ map f as 
