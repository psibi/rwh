import Control.Lens

data Game = Game
            { _score :: Int
            , _units :: [Unit]
            , _boss :: Unit
            } deriving (Show)

data Unit = Unit
            { _health :: Int
            , _position :: Point
            } deriving (Show)

data Point = Point
             {
               _x :: Double
             , _y :: Double
             } deriving (Show)

score :: Lens' Game Int
score = lens _score (\game v -> game { _score = v})
