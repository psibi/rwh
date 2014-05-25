data Toy b next =
    Output b next
  | Bell next
  | Done
    deriving (Show)

data Cheat f = Cheat1 (f (Cheat f))

data Dummy f = Dummy (Maybe f) deriving (Show)

-- λ> let a = Cheat1 (Output 'a' (Cheat1 Done))
-- λ> :t a
-- a :: Cheat (Toy Char)

 

