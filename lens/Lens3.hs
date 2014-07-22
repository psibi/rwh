
-- http://blog.jakubarnold.cz/2014/07/14/lens-tutorial-introduction-part-1.html
-- s is the object and a is the focus
data NaiveLens s a = NaiveLens
                     { view :: s -> a
                     , set :: a -> s -> s}

data User = User { name :: String, age :: Int } deriving Show
data Project = Project { owner :: User } deriving Show

nameLens :: NaiveLens User String
nameLens = NaiveLens name (\a s -> s{ name = a})

ageLens :: NaiveLens User Int
ageLens = NaiveLens age
                     (\a s -> s { age = a })


