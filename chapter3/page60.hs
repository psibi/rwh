----------------------------------------------------------------------
-- Chapter 3: Defining Types, Streamlining Functions

data List a = Cons a (List a)
            | Nil


-- Problem 1

toList :: List a -> [a]
toList Nil = []
toList (Cons x xs) = x:(toList xs)

-- Problem 2

data Tree a = Node a (Maybe (Tree a)) (Maybe (Tree a))
            deriving (Show)

-- Example: 
-- Node 9 (Just (Node 8 Nothing Nothing)) (Just (Node 8 Nothing Nothing))
