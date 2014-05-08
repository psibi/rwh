-- http://blog.sigfpe.com/2007/04/trivial-monad.html

import Control.Monad

data W a = W a deriving Show

return :: a -> W a
return x = W x

fmap :: (a -> b) -> W a -> W b
fmap f (W x) = W $ f x

f :: Int -> W Int
f x = W (x + 1)

bind :: (a -> W b) -> (W a -> W b)
bind f (W x) = f x

-- Exercise:

-- My solution doesn't use the standard bind (>>=) and return function
-- but uses the stuff the higher order function that sigfpe has created.

-- Implement this: g x (W y) = W (x+y)
g :: Int -> W Int -> W Int
g x = bind (\a -> Main.return (a + x))

-- Implement this: h (W x) (W y) = W (x+y)
h :: W Int -> W Int -> W Int
h x y = bind (\a -> bind (\b -> Main.return $ a + b) y) x


