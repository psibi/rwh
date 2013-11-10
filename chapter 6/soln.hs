----------------------------------------------------------------------
-- WTF? Telling to explore Arrows without even knowing Monads!

--- Exercise 1
-- ghci > :t second
-- second :: Control.Arrow.Arrow a => a b c -> a (d, b) (d, c)

It takes a pair and calls the function on the second element of 
the pair and returns the new pair.

-- Exercise 2

ghci > :t (,)
(,) :: a -> b -> (a, b)
ghci > :t (,,)
(,,) :: a -> b -> c -> (a, b, c)

ghci > let a = (,) 9
ghci > a 8
(9,8)
