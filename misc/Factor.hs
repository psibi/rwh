factor :: Integral t => t -> [t]
factor x = [y | y <- [1..x-1], rem x y == 0 ]
