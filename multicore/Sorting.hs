module Sorting where

import Control.Parallel (par, pseq)

sort :: (Ord a) => [a] -> [a]
sort (x:xs) = lesser ++ x:greater
  where lesser = sort [y | y <- xs, y < x]
        greater = sort [y | y <- xs, y >= x]
sort _ = []

parSort :: (Ord a) => [a] -> [a]
parSort (x:xs) = force greater `par` (force lesser `pseq`
                                      (lesser ++ x:greater))
  where lesser = parSort [y | y <- xs, y < x]
        greater = parSort [y | y <- xs, y >= x]

force :: [a] -> ()
force xs = go xs `pseq` ()
  where go (_:xs) = go xs
        go [] = 1
