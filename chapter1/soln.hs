----------------------------------------------------------------------
-- Chapter 1 Solution

-- Exercise 1: Enter them into your ghci

-- Exercise 2: Do them in ghci!

-- Exercise 3

main = interact wordCount
  where wordCount input = show (length (words input)) ++ "\n"

-- Exercise 4

main = interact wordCount
  where wordCount input = show (foldl (\acc x -> acc + length x) 0 (lines input)) ++ "\n"
