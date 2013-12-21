class Monad m where
  return :: a -> m a
  (>>=) :: m a -> (a -> m b) -> m b
  (>>) :: m a -> m b -> m b
  m >> n = m >>= \_ -> n

  fail :: String -> m a

instance Monad Maybe where
  return = Just
  (Just x) >>= f = f x
  Nothing >>= _ = Nothing

instance Monad [] where
  return x = [x]
  xs >>= f = concat $ map f xs

instance Monad ((->) r) where
  f >>= k = \r -> k (f r) r

data Free f a = Var a
              | Node (f (Free f a))

-- Kind of f: (* -> *)
-- Type of f: Free f a -> b

instance Functor f => Functor (Free f) where
  fmap f (Var a) = Var (f a)
  fmap f (Node x) = Node (fmap (fmap f) x)

-- Type of fmap f: f a -> f b
-- Type of fmap (fmap f) x: f b

instance Functor f => Monad (Free f) where
  return = Var
  Var x >>= g = g x
  Node x >>= g = Node (fmap (>>= g) x)
