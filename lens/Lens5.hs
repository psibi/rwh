{-# LANGUAGE RankNTypes #-}

type Lens s a = Functor f => (a -> f a) -> s -> f s

newtype Identity a = Identity { runIdentity :: a }

instance Functor Identity where
  fmap f (Identity x) = Identity $ f x

over :: Lens s a -> (a -> a) -> s -> s
over ln f s = runIdentity $ ln (Identity . f) s

-- Identity . f :: (\a -> Identity (f a))  
-- ln (Identity . f) :: s -> f s

newtype Const a b = Const { getConst :: a }

instance Functor (Const a) where
  fmap _ (Const a) = Const a

view :: Lens s a -> s -> a
view ln s = getConst $ ln Const s

set :: Lens s a -> a -> s -> s
set ln x s = over ln (const x) s

_1 :: Functor f => (a -> f a) -> (a, b) -> f (a, b)
_1 f (x, y) = fmap (\a -> (a,y)) (f x)



