----------------------------------------------------------------------
-- Chapter 2: Types and Functions

-- Exercise 1: Theorish!

-- Exercise 2

lastButOne :: [a] -> a
lastButOne [] = error "Empty List, Idiot!"
lastButOne (x:[]) = error "Only has single element!"
lastButOne (x:y:xs) = if null xs
                      then x
                      else lastButOne (y:xs)

-- Exercise 3

-- Just play out with Exercise 2
