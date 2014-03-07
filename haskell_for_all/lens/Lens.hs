import Control.Monad.State

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

(^.) :: a -> Lens a b -> b
a ^. p = getL p a

(^=) :: Lens a b -> b -> a -> a
(p ^= b) a = setL p b a

-- *Main> (Point 3.0 4.0) ^. x'
-- 3.0
-- *Main> (x' ^= 10.0 ) (Point 3.0 4.0)
-- Point 10.0 4.0

(^:=) :: Lens a b -> b -> State a ()
p ^:= b = do
  a <- get
  let a' = setL p b a
  put a'

access :: Lens a b -> State a b
access p = do
  a <- get
  let b = getL p a
  return b
