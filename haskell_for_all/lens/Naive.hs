data Point = Point Double Double

data Circle = Circle Point Double

-- Lame code (Typical Java workflow ?)

getX :: Point -> Double
getX (Point a _) = a

setX :: Double -> Point -> Point
setX x' (Point _ y) = Point x' y

getY :: Point -> Double
getY (Point _ a) = a

setY :: Double -> Point -> Point
setY y' (Point x _) = Point x y'

getCenter :: Circle -> Point
getCenter (Circle c _) = c

setCenter :: Point -> Circle -> Circle
setCenter p (Circle _ r) = Circle p r

getRadius :: Circle -> Double
getRadius (Circle _ r) = r

setRadius :: Double -> Circle -> Circle
setRadius r' (Circle p _) = Circle p r'
