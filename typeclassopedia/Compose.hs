-- Is the composition of two Functors is also a Functor ?

data Compose f g x = Compose (f (g x)) deriving (Show)

-- fmap :: (a -> b) -> Compose f g a -> Compose f g b

instance (Functor f, Functor g) => Functor (Compose f g) where
  fmap f (Compose x) = Compose $ fmap (fmap f) x

-- fmap f :: f a -> f b
-- fmap (fmap f) :: g (f a) -> g (f b)
