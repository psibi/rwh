class Monad m where
    (>>=) :: m a -> (a -> m b) -> m b
    return :: a -> m a

instance Monad Maybe where
    Nothing >>= _   = Nothing
    (Just x) >>= f  = f x
    return x        = Just x

instance Monad [] where
  m >>= f = concatMap f m
  return x = [x]
  fail s = []

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

--- Reverse binder function

(=<<) :: Monad m => (a -> m b) -> m a -> m b
f =<< x = x >>= f

--- foldM

foldM :: (Monad m) => (a -> b -> m a) -> a -> [b] -> m a
foldM f a [] = return a
foldM f a (x:xs) = f a x >>= \y -> foldM f y xs

-- when and unless function

when :: (Monad m) -> Bool -> m () -> m ()
when p s = if p then s else return ()

unless :: (Monad m) -> Bool -> m () -> m ()
unless p s = when (not p) s

-- ap and the lifting functions
liftM :: (Monad m) => (a -> b) -> (m a -> m b)
liftM f = \a -> do { a' <- a; return (f a')}

liftM2 :: (Monad m) => (a -> b -> c) -> (m a -> m b -> m c)
liftM2 f = \a b -> do { a' <- a; b' <- b; return (f a' b') }

ap :: (Monad m) => m (a -> b) -> m a -> m b
ap = liftM2 ($)
