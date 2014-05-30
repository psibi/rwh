-- Basic statistics functions

-- mean :: [a] -> Double
mean :: Fractional a => [a] -> a
mean xs = sum xs / fromIntegral (length xs)

variance :: Floating a => [a] -> a
variance xs =  s / fromIntegral (length xs)
  where mew = mean xs
        s = sum (map (\x -> (x - mew) ** 2) xs)

-- standard deviation
sd :: Floating a => [a] -> a
sd xs = variance xs  ** 0.5       
