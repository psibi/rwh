instance Functor [] where
  fmap f [] = []
  fmap f (x:xs) = f x : fmap f xs

instance Functor Maybe where
  fmap f (Just x) = Just (f x)
  fmap _ Nothing = Nothing

instance Functor (Either e) where
  fmap f (Right a) = Right (f a)
  fmap f (Left x) = Left x

instance Functor ((->) e) where
  fmap = (.)

instance Functor ((,) e) where
  fmap f (a, b) = (a, f b)

data Pair a = Pair a a

instance Functor Pair where
  fmap f (Pair x y) = Pair (f x) (f y)

data ITree a = Leaf (Int -> a)
             | Node [ITree a]

instance Functor ITree where
  fmap f (Leaf g) = Leaf (f . g)
  fmap g (Node l) = Node $ fmap (fmap g) l

