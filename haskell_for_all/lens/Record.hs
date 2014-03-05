data Point = Point { x :: Double,
                     y :: Double}
             deriving (Show)

data Circle = Circle { center :: Point,
                       radius :: Double}
              deriving (Show)

set42Radius :: Circle -> Circle
set42Radius c = c { radius = 42.0 }

goRight :: Circle -> Circle
goRight c = c { center = (\p -> p {x = x p + 10}) (center c)}
