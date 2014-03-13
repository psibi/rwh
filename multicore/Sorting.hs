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

-- This is the code which I will generally end up with. Wake up Dude!
sillySort :: (Ord a) => [a] -> [a]
sillySort (x:xs) = greater `par` (lesser `pseq`
                                  (lesser ++ x:greater))
  where lesser = sillySort [y | y <- xs, y < x]
        greater = sillySort [y | y <- xs, y >= x]
