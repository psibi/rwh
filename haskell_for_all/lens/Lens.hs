type Lens a b = (a -> b, b -> a -> a)

getL :: Lens a b -> a -> b
getL (g, _) = g

setL :: Lens a b -> b -> a -> a
setL (_, s) = s

modL :: Lens a b -> (b -> b) -> a -> a
modL l f a = setL l (f (getL l a)) a

data Point = Point Double Double deriving (Show)

getX :: Point -> Double
getX (Point a _) = a

setX :: Double -> Point -> Point
setX x' (Point _ y) = Point x' y

x' :: Lens Point Double
x' = (getX, setX)

-- *Main> setL x' 10.0 (Point 3.0 4.0)
-- Point 10.0 4.0
-- *Main> getL x' (Point 3.0 4.0)
-- 3.0
