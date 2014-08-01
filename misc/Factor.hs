factor :: Integral t => t -> [t]
factor x = [y | y <- [1..x-1], rem x y == 0 ]

isPrime :: Integral a => a -> Bool
isPrime x = if (length (factor x) == 1)
            then True
            else False

-- Compute 3^n - 1
ex2a :: (Integral b, Num a) => b -> a
ex2a n = 3^n - 1

-- Compute 3^n - 2^n
ex2b :: (Integral b, Num a) => b -> a
ex2b n = 3^n - 2^n

ex2 :: (Integral b, Num t) => b -> (t, t)
ex2 n = (ex2a n, ex2b n)

testData :: IO ()
testData = do
  let dummyData = [1..10]
      dat2 = map (\x -> (x, isPrime $ ex2a x, isPrime $ ex2b x)) dummyData
  mapM_ print dat2

isPerfectNumber :: Integral a => a -> Bool
isPerfectNumber x = sum (factor x) == x

allPerfectNumbers :: [Integer]
allPerfectNumbers = filter isPerfectNumber [1..]
