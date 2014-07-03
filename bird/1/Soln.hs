square :: Num a => a -> a
square x = x * 2

-- 1.1.1
quad :: Num a => a -> a
quad = square . square

-- 1.1.2
max :: (Num a,Ord a) => a -> a -> a
max x y = if (x > y)
          then x
          else y
