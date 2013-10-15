----------------------------------------------------------------------
--- Chapter 4: Functional Programming

--- Exercise 1

safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x

safeTail :: [a] -> Maybe [a]
safeTail []     = Nothing
safeTail (_:xs) = Just xs

safeLast :: [a] -> Maybe a
safeLast []     = Nothing
safeLast (x:xs) = if null xs
                  then Just x
                  else safeLast xs

safeInit :: [a] -> Maybe [a]
safeInit []     = Nothing
safeInit (_:xs) = Just xs

-- Exercise 2
splitWith :: (a -> Bool) -> [a] -> [[a]]
splitWith _ [] = []
splitWith f xs = first : splitWith f (sTail rest)
  where (first, rest) = break f xs
        sTail [] = []
        sTail (_:ys) = ys

