----------------------------------------------------------------------
--- Exercise 1 & 2

import Data.List(sortBy)

length' :: [a] -> Int
length' [] = 0
length' (x:xs) = 1 + (length' xs)

--- Exercise 3
mean :: Fractional a => [a] -> a
mean xs = if null xs
          then 0
          else (sum xs) / (fromIntegral (length xs))

--- Exercise 4
turnpalindrome :: [a] -> [a]
turnpalindrome [] = []
turnpalindrome xs = xs ++ (reverse xs)

-- Exercise 5
isPalindrome :: (Eq a) => [a] -> Bool
isPalindrome xs = xs == (reverse xs)

-- Exercise 6
sortsubList :: [[a]] -> [[a]]
sortsubList xs  = sortBy (\x y -> compare (length x) (length y)) xs

-- Exercise 7 & 8
-- intersperse :: a -> [[a]] -> [a]
-- intersperse x [] = []
-- intersperse x (y:ys) = if null ys
--                        then y
--                        else (y ++ x) ++ (intersperse x ys)


