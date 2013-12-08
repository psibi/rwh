{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}

class Eq e => Collection c e where
  insert :: c -> e -> c
  member :: c -> e -> Bool

data Vector = Vector Int Int deriving (Eq, Show)
data Matrix = Matrix Vector Vector deriving (Eq, Show)

class Mult a b c | a b -> c where
  (*) :: a -> b -> c

