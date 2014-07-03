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

-- 1.1.3
area :: Fractional a => a -> a
area r = pi * (square r)
  where pi = 22 / 7

-- 1.2.1
-- Two forms: Call by need and call by value.

-- 1.2.2
-- Same as above

-- 1.2.3
-- ( succ (pred ( succ (pred (pred zero)))))
-- ( succ (pred (pred zero)))
-- ( pred zero)

-- Notes

-- A type variable can be instantiated to different types in different
-- variables. In id function, it takes type variable a and gives type
-- variable a.

-- 1.4.1
-- integral :: Num a -> a -> a

-- 1.4.2
-- (+)
-- (+) because of currying!
-- fmap :-)

-- 1.4.3
sign :: (Num a, Ord a) => a -> a
sign x = if x >=0
         then 1
         else 0

-- 1.4.4
-- one :: a -> Integer
-- apply :: (a -> b) -> a -> b
-- compose :: (a -> b) -> (c -> a) -> b
